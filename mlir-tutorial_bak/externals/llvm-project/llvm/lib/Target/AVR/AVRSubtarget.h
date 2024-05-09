//===-- AVRSubtarget.h - Define Subtarget for the AVR -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the AVR specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_AVR_SUBTARGET_H
#define LLVM_AVR_SUBTARGET_H

#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Target/TargetMachine.h"

#include "AVRFrameLowering.h"
#include "AVRISelLowering.h"
#include "AVRInstrInfo.h"
#include "AVRSelectionDAGInfo.h"
#include "MCTargetDesc/AVRMCTargetDesc.h"

#define GET_SUBTARGETINFO_HEADER
#include "AVRGenSubtargetInfo.inc"

namespace llvm {

/// A specific AVR target MCU.
class AVRSubtarget : public AVRGenSubtargetInfo {
public:
  //! Creates an AVR subtarget.
  //! \param TT  The target triple.
  //! \param CPU The CPU to target.
  //! \param FS  The feature string.
  //! \param TM  The target machine.
  AVRSubtarget(const Triple &TT, const std::string &CPU, const std::string &FS,
               const AVRTargetMachine &TM);

  const AVRInstrInfo *getInstrInfo() const override { return &InstrInfo; }
  const TargetFrameLowering *getFrameLowering() const override {
    return &FrameLowering;
  }
  const AVRTargetLowering *getTargetLowering() const override {
    return &TLInfo;
  }
  const AVRSelectionDAGInfo *getSelectionDAGInfo() const override {
    return &TSInfo;
  }
  const AVRRegisterInfo *getRegisterInfo() const override {
    return &InstrInfo.getRegisterInfo();
  }

  /// Parses a subtarget feature string, setting appropriate options.
  /// \note Definition of function is auto generated by `tblgen`.
  void ParseSubtargetFeatures(StringRef CPU, StringRef TuneCPU, StringRef FS);

  AVRSubtarget &initializeSubtargetDependencies(StringRef CPU, StringRef FS,
                                                const TargetMachine &TM);

  // Subtarget feature getters.
#define GET_SUBTARGETINFO_MACRO(ATTRIBUTE, DEFAULT, GETTER)                    \
  bool GETTER() const { return ATTRIBUTE; }
#include "AVRGenSubtargetInfo.inc"

  uint8_t getIORegisterOffset() const { return hasMemMappedGPR() ? 0x20 : 0x0; }

  bool enableSubRegLiveness() const override { return true; }

  /// Gets the ELF architecture for the e_flags field
  /// of an ELF object file.
  unsigned getELFArch() const {
    assert(ELFArch != 0 &&
           "every device must have an associate ELF architecture");
    return ELFArch;
  }

  /// Get I/O register addresses.
  int getIORegRAMPZ() const { return hasELPM() ? 0x3b : -1; }
  int getIORegEIND() const { return hasEIJMPCALL() ? 0x3c : -1; }
  int getIORegSPL() const { return 0x3d; }
  int getIORegSPH() const { return hasSmallStack() ? -1 : 0x3e; }
  int getIORegSREG() const { return 0x3f; }

  /// Get GPR aliases.
  int getRegTmpIndex() const { return hasTinyEncoding() ? 16 : 0; }
  int getRegZeroIndex() const { return hasTinyEncoding() ? 17 : 1; }

  Register getTmpRegister() const {
    return hasTinyEncoding() ? AVR::R16 : AVR::R0;
  }
  Register getZeroRegister() const {
    return hasTinyEncoding() ? AVR::R17 : AVR::R1;
  }

private:
  /// The ELF e_flags architecture.
  unsigned ELFArch = 0;

  // Subtarget feature settings
#define GET_SUBTARGETINFO_MACRO(ATTRIBUTE, DEFAULT, GETTER)                    \
  bool ATTRIBUTE = DEFAULT;
#include "AVRGenSubtargetInfo.inc"

  AVRInstrInfo InstrInfo;
  AVRFrameLowering FrameLowering;
  AVRTargetLowering TLInfo;
  AVRSelectionDAGInfo TSInfo;
};

} // end namespace llvm

#endif // LLVM_AVR_SUBTARGET_H