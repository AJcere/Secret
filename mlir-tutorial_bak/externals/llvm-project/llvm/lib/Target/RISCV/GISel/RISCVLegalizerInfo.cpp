//===-- RISCVLegalizerInfo.cpp ----------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for RISC-V.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "RISCVLegalizerInfo.h"
#include "RISCVSubtarget.h"
#include "llvm/CodeGen/GlobalISel/LegalizerHelper.h"
#include "llvm/CodeGen/GlobalISel/MachineIRBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"

using namespace llvm;
using namespace LegalityPredicates;

// Is this type supported by scalar FP arithmetic operations given the current
// subtarget.
static LegalityPredicate typeIsScalarFPArith(unsigned TypeIdx,
                                             const RISCVSubtarget &ST) {
  return [=, &ST](const LegalityQuery &Query) {
    return Query.Types[TypeIdx].isScalar() &&
           ((ST.hasStdExtF() && Query.Types[TypeIdx].getSizeInBits() == 32) ||
            (ST.hasStdExtD() && Query.Types[TypeIdx].getSizeInBits() == 64));
  };
}

RISCVLegalizerInfo::RISCVLegalizerInfo(const RISCVSubtarget &ST) {
  const unsigned XLen = ST.getXLen();
  const LLT sXLen = LLT::scalar(XLen);
  const LLT sDoubleXLen = LLT::scalar(2 * XLen);
  const LLT p0 = LLT::pointer(0, XLen);
  const LLT s8 = LLT::scalar(8);
  const LLT s16 = LLT::scalar(16);
  const LLT s32 = LLT::scalar(32);
  const LLT s64 = LLT::scalar(64);

  using namespace TargetOpcode;

  getActionDefinitionsBuilder({G_ADD, G_SUB, G_AND, G_OR, G_XOR})
      .legalFor({s32, sXLen})
      .widenScalarToNextPow2(0)
      .clampScalar(0, s32, sXLen);

  getActionDefinitionsBuilder(
      {G_UADDE, G_UADDO, G_USUBE, G_USUBO}).lower();

  getActionDefinitionsBuilder({G_SADDO, G_SSUBO}).minScalar(0, sXLen).lower();

  getActionDefinitionsBuilder({G_ASHR, G_LSHR, G_SHL})
      .customIf([=, &ST](const LegalityQuery &Query) {
        return ST.is64Bit() && typeIs(0, s32)(Query) && typeIs(1, s32)(Query);
      })
      .legalFor({{s32, s32}, {s32, sXLen}, {sXLen, sXLen}})
      .widenScalarToNextPow2(0)
      .clampScalar(1, s32, sXLen)
      .clampScalar(0, s32, sXLen)
      .minScalarSameAs(1, 0);

  if (ST.is64Bit()) {
    getActionDefinitionsBuilder({G_ZEXT, G_SEXT, G_ANYEXT})
        .legalFor({{sXLen, s32}})
        .maxScalar(0, sXLen);

    getActionDefinitionsBuilder(G_SEXT_INREG)
        .customFor({sXLen})
        .maxScalar(0, sXLen)
        .lower();
  } else {
    getActionDefinitionsBuilder({G_ZEXT, G_SEXT, G_ANYEXT}).maxScalar(0, sXLen);

    getActionDefinitionsBuilder(G_SEXT_INREG).maxScalar(0, sXLen).lower();
  }

  // Merge/Unmerge
  for (unsigned Op : {G_MERGE_VALUES, G_UNMERGE_VALUES}) {
    unsigned BigTyIdx = Op == G_MERGE_VALUES ? 0 : 1;
    unsigned LitTyIdx = Op == G_MERGE_VALUES ? 1 : 0;
    getActionDefinitionsBuilder(Op)
        .widenScalarToNextPow2(LitTyIdx, XLen)
        .widenScalarToNextPow2(BigTyIdx, XLen)
        .clampScalar(LitTyIdx, sXLen, sXLen)
        .clampScalar(BigTyIdx, sXLen, sXLen);
  }

  getActionDefinitionsBuilder({G_FSHL, G_FSHR}).lower();

  getActionDefinitionsBuilder({G_ROTL, G_ROTR}).lower();

  getActionDefinitionsBuilder({G_BSWAP, G_BITREVERSE})
      .maxScalar(0, sXLen)
      .lower();

  getActionDefinitionsBuilder(
      {G_CTPOP, G_CTLZ, G_CTLZ_ZERO_UNDEF, G_CTTZ, G_CTTZ_ZERO_UNDEF})
      .maxScalar(0, sXLen)
      .scalarSameSizeAs(1, 0)
      .lower();

  getActionDefinitionsBuilder({G_CONSTANT, G_IMPLICIT_DEF})
      .legalFor({s32, sXLen, p0})
      .widenScalarToNextPow2(0)
      .clampScalar(0, s32, sXLen);

  getActionDefinitionsBuilder(G_ICMP)
      .legalFor({{sXLen, sXLen}, {sXLen, p0}})
      .widenScalarToNextPow2(1)
      .clampScalar(1, sXLen, sXLen)
      .clampScalar(0, sXLen, sXLen);

  getActionDefinitionsBuilder(G_SELECT)
      .legalFor({{sXLen, sXLen}, {p0, sXLen}})
      .widenScalarToNextPow2(0)
      .clampScalar(0, sXLen, sXLen)
      .clampScalar(1, sXLen, sXLen);

  auto &LoadStoreActions =
      getActionDefinitionsBuilder({G_LOAD, G_STORE})
          .legalForTypesWithMemDesc({{s32, p0, s8, 8},
                                     {s32, p0, s16, 16},
                                     {s32, p0, s32, 32},
                                     {p0, p0, sXLen, XLen}});
  auto &ExtLoadActions =
      getActionDefinitionsBuilder({G_SEXTLOAD, G_ZEXTLOAD})
          .legalForTypesWithMemDesc({{s32, p0, s8, 8}, {s32, p0, s16, 16}});
  if (XLen == 64) {
    LoadStoreActions.legalForTypesWithMemDesc({{s64, p0, s8, 8},
                                               {s64, p0, s16, 16},
                                               {s64, p0, s32, 32},
                                               {s64, p0, s64, 64}});
    ExtLoadActions.legalForTypesWithMemDesc(
        {{s64, p0, s8, 8}, {s64, p0, s16, 16}, {s64, p0, s32, 32}});
  } else if (ST.hasStdExtD()) {
    LoadStoreActions.legalForTypesWithMemDesc({{s64, p0, s64, 64}});
  }
  LoadStoreActions.clampScalar(0, s32, sXLen).lower();
  ExtLoadActions.widenScalarToNextPow2(0).clampScalar(0, s32, sXLen).lower();

  getActionDefinitionsBuilder(G_PTR_ADD).legalFor({{p0, sXLen}});

  getActionDefinitionsBuilder(G_PTRTOINT)
      .legalFor({{sXLen, p0}})
      .clampScalar(0, sXLen, sXLen);

  getActionDefinitionsBuilder(G_INTTOPTR)
      .legalFor({{p0, sXLen}})
      .clampScalar(1, sXLen, sXLen);

  getActionDefinitionsBuilder(G_BRCOND).legalFor({sXLen}).minScalar(0, sXLen);

  getActionDefinitionsBuilder(G_BRJT).legalFor({{p0, sXLen}});

  getActionDefinitionsBuilder(G_PHI)
      .legalFor({p0, sXLen})
      .widenScalarToNextPow2(0)
      .clampScalar(0, sXLen, sXLen);

  getActionDefinitionsBuilder({G_GLOBAL_VALUE, G_JUMP_TABLE}).legalFor({p0});

  if (ST.hasStdExtM() || ST.hasStdExtZmmul()) {
    getActionDefinitionsBuilder(G_MUL)
        .legalFor({s32, sXLen})
        .widenScalarToNextPow2(0)
        .clampScalar(0, s32, sXLen);

    // clang-format off
    getActionDefinitionsBuilder({G_SMULH, G_UMULH})
        .legalFor({sXLen})
        .lower();
    // clang-format on

    getActionDefinitionsBuilder({G_SMULO, G_UMULO}).minScalar(0, sXLen).lower();
  } else {
    getActionDefinitionsBuilder(G_MUL)
        .libcallFor({sXLen, sDoubleXLen})
        .widenScalarToNextPow2(0)
        .clampScalar(0, sXLen, sDoubleXLen);

    getActionDefinitionsBuilder({G_SMULH, G_UMULH}).lowerFor({sXLen});

    getActionDefinitionsBuilder({G_SMULO, G_UMULO})
        .minScalar(0, sXLen)
        // Widen sXLen to sDoubleXLen so we can use a single libcall to get
        // the low bits for the mul result and high bits to do the overflow
        // check.
        .widenScalarIf(typeIs(0, sXLen),
                       LegalizeMutations::changeTo(0, sDoubleXLen))
        .lower();
  }

  if (ST.hasStdExtM()) {
    getActionDefinitionsBuilder({G_UDIV, G_SDIV, G_UREM, G_SREM})
        .legalFor({s32, sXLen})
        .libcallFor({sDoubleXLen})
        .clampScalar(0, s32, sDoubleXLen)
        .widenScalarToNextPow2(0);
  } else {
    getActionDefinitionsBuilder({G_UDIV, G_SDIV, G_UREM, G_SREM})
        .libcallFor({sXLen, sDoubleXLen})
        .clampScalar(0, sXLen, sDoubleXLen)
        .widenScalarToNextPow2(0);
  }

  getActionDefinitionsBuilder(G_ABS).lower();
  getActionDefinitionsBuilder({G_UMAX, G_UMIN, G_SMAX, G_SMIN}).lower();

  getActionDefinitionsBuilder(G_FRAME_INDEX).legalFor({p0});

  getActionDefinitionsBuilder({G_MEMCPY, G_MEMMOVE, G_MEMSET}).libcall();

  getActionDefinitionsBuilder(G_DYN_STACKALLOC).lower();

  // FP Operations

  getActionDefinitionsBuilder({G_FADD, G_FSUB, G_FMUL, G_FDIV, G_FMA, G_FNEG,
                               G_FABS, G_FSQRT, G_FMAXNUM, G_FMINNUM})
      .legalIf(typeIsScalarFPArith(0, ST));

  getActionDefinitionsBuilder(G_FPTRUNC).legalIf(
      [=, &ST](const LegalityQuery &Query) -> bool {
        return (ST.hasStdExtD() && typeIs(0, s32)(Query) &&
                typeIs(1, s64)(Query));
      });
  getActionDefinitionsBuilder(G_FPEXT).legalIf(
      [=, &ST](const LegalityQuery &Query) -> bool {
        return (ST.hasStdExtD() && typeIs(0, s64)(Query) &&
                typeIs(1, s32)(Query));
      });

  getActionDefinitionsBuilder(G_FCMP)
      .legalIf(all(typeIs(0, sXLen), typeIsScalarFPArith(1, ST)))
      .clampScalar(0, sXLen, sXLen);

  getActionDefinitionsBuilder(G_FCONSTANT).legalIf(typeIsScalarFPArith(0, ST));

  getActionDefinitionsBuilder({G_FPTOSI, G_FPTOUI})
      .legalIf(all(typeInSet(0, {s32, sXLen}), typeIsScalarFPArith(1, ST)))
      .widenScalarToNextPow2(0)
      .clampScalar(0, s32, sXLen);

  getActionDefinitionsBuilder({G_SITOFP, G_UITOFP})
      .legalIf(all(typeIsScalarFPArith(0, ST), typeInSet(1, {s32, sXLen})))
      .widenScalarToNextPow2(1)
      .clampScalar(1, s32, sXLen);

  // FIXME: We can do custom inline expansion like SelectionDAG.
  // FIXME: Legal with Zfa.
  getActionDefinitionsBuilder({G_FCEIL, G_FFLOOR})
      .libcallFor({s32, s64});

  getLegacyLegalizerInfo().computeTables();
}

bool RISCVLegalizerInfo::legalizeShlAshrLshr(
    MachineInstr &MI, MachineIRBuilder &MIRBuilder,
    GISelChangeObserver &Observer) const {
  assert(MI.getOpcode() == TargetOpcode::G_ASHR ||
         MI.getOpcode() == TargetOpcode::G_LSHR ||
         MI.getOpcode() == TargetOpcode::G_SHL);
  MachineRegisterInfo &MRI = *MIRBuilder.getMRI();
  // If the shift amount is a G_CONSTANT, promote it to a 64 bit type so the
  // imported patterns can select it later. Either way, it will be legal.
  Register AmtReg = MI.getOperand(2).getReg();
  auto VRegAndVal = getIConstantVRegValWithLookThrough(AmtReg, MRI);
  if (!VRegAndVal)
    return true;
  // Check the shift amount is in range for an immediate form.
  uint64_t Amount = VRegAndVal->Value.getZExtValue();
  if (Amount > 31)
    return true; // This will have to remain a register variant.
  auto ExtCst = MIRBuilder.buildConstant(LLT::scalar(64), Amount);
  Observer.changingInstr(MI);
  MI.getOperand(2).setReg(ExtCst.getReg(0));
  Observer.changedInstr(MI);
  return true;
}

bool RISCVLegalizerInfo::legalizeCustom(LegalizerHelper &Helper,
                                        MachineInstr &MI) const {
  MachineIRBuilder &MIRBuilder = Helper.MIRBuilder;
  GISelChangeObserver &Observer = Helper.Observer;
  switch (MI.getOpcode()) {
  default:
    // No idea what to do.
    return false;
  case TargetOpcode::G_SHL:
  case TargetOpcode::G_ASHR:
  case TargetOpcode::G_LSHR:
    return legalizeShlAshrLshr(MI, MIRBuilder, Observer);
  case TargetOpcode::G_SEXT_INREG: {
    // Source size of 32 is sext.w.
    int64_t SizeInBits = MI.getOperand(2).getImm();
    if (SizeInBits == 32)
      return true;

    return Helper.lower(MI, 0, /* Unused hint type */ LLT()) ==
           LegalizerHelper::Legalized;
  }
  }

  llvm_unreachable("expected switch to return");
}