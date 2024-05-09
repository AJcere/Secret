; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn -mcpu=gfx1100 -verify-machineinstrs %s -o - | FileCheck %s -check-prefix=GFX11

declare i32 @llvm.amdgcn.workitem.id.x()

define void @f0() {
; GFX11-LABEL: f0:
; GFX11:       ; %bb.0: ; %bb
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s2, s33
; GFX11-NEXT:    s_mov_b32 s33, s32
; GFX11-NEXT:    s_xor_saveexec_b32 s0, -1
; GFX11-NEXT:    scratch_store_b32 off, v4, s33 ; 4-byte Folded Spill
; GFX11-NEXT:    s_mov_b32 exec_lo, s0
; GFX11-NEXT:    s_add_i32 s32, s32, 16
; GFX11-NEXT:    s_getpc_b64 s[0:1]
; GFX11-NEXT:    s_add_u32 s0, s0, f1@gotpcrel32@lo+4
; GFX11-NEXT:    s_addc_u32 s1, s1, f1@gotpcrel32@hi+12
; GFX11-NEXT:    v_writelane_b32 v4, s30, 0
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x0
; GFX11-NEXT:    v_writelane_b32 v4, s31, 1
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-NEXT:    v_readlane_b32 s31, v4, 1
; GFX11-NEXT:    v_readlane_b32 s30, v4, 0
; GFX11-NEXT:    s_xor_saveexec_b32 s0, -1
; GFX11-NEXT:    scratch_load_b32 v4, off, s33 ; 4-byte Folded Reload
; GFX11-NEXT:    s_mov_b32 exec_lo, s0
; GFX11-NEXT:    s_add_i32 s32, s32, -16
; GFX11-NEXT:    s_mov_b32 s33, s2
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_setpc_b64 s[30:31]
bb:
  %i = call <2 x i64> @f1()
  ret void
}

define <2 x i64> @f1() #0 {
; GFX11-LABEL: f1:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    v_mov_b32_e32 v1, 0
; GFX11-NEXT:    v_mov_b32_e32 v2, 0
; GFX11-NEXT:    v_mov_b32_e32 v3, 0
; GFX11-NEXT:    s_setpc_b64 s[30:31]
  ret <2 x i64> zeroinitializer
}

; FIXME: This generates "instid1(/* invalid instid value */)".
define amdgpu_kernel void @f2(i32 %arg, i32 %arg1, i32 %arg2, i1 %arg3, i32 %arg4, i1 %arg5, ptr %arg6, i32 %arg7, i32 %arg8, i32 %arg9, i32 %arg10, i1 %arg11) {
; GFX11-LABEL: f2:
; GFX11:       ; %bb.0: ; %bb
; GFX11-NEXT:    s_mov_b64 s[16:17], s[4:5]
; GFX11-NEXT:    v_mov_b32_e32 v31, v0
; GFX11-NEXT:    s_load_b32 s24, s[16:17], 0x24
; GFX11-NEXT:    s_mov_b32 s12, s13
; GFX11-NEXT:    s_mov_b64 s[10:11], s[6:7]
; GFX11-NEXT:    s_mov_b64 s[6:7], s[2:3]
; GFX11-NEXT:    v_and_b32_e32 v0, 0x3ff, v31
; GFX11-NEXT:    s_mov_b64 s[4:5], s[0:1]
; GFX11-NEXT:    s_mov_b32 s3, 0
; GFX11-NEXT:    s_mov_b32 s0, -1
; GFX11-NEXT:    s_mov_b32 s18, exec_lo
; GFX11-NEXT:    s_mov_b32 s32, 0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    v_mul_lo_u32 v0, s24, v0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-NEXT:    v_cmpx_eq_u32_e32 0, v0
; GFX11-NEXT:    s_cbranch_execz .LBB2_13
; GFX11-NEXT:  ; %bb.1: ; %bb14
; GFX11-NEXT:    s_load_b128 s[20:23], s[16:17], 0x2c
; GFX11-NEXT:    s_mov_b32 s19, 0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_bitcmp1_b32 s21, 0
; GFX11-NEXT:    s_cselect_b32 s25, -1, 0
; GFX11-NEXT:    s_bitcmp0_b32 s21, 0
; GFX11-NEXT:    s_cbranch_scc0 .LBB2_3
; GFX11-NEXT:  ; %bb.2: ; %bb15
; GFX11-NEXT:    s_add_u32 s8, s16, 0x58
; GFX11-NEXT:    s_addc_u32 s9, s17, 0
; GFX11-NEXT:    s_getpc_b64 s[0:1]
; GFX11-NEXT:    s_add_u32 s0, s0, f0@gotpcrel32@lo+4
; GFX11-NEXT:    s_addc_u32 s1, s1, f0@gotpcrel32@hi+12
; GFX11-NEXT:    s_mov_b32 s13, s14
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x0
; GFX11-NEXT:    s_mov_b32 s3, s14
; GFX11-NEXT:    s_mov_b32 s14, s15
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; GFX11-NEXT:    s_mov_b32 s14, s3
; GFX11-NEXT:    s_mov_b32 s1, -1
; GFX11-NEXT:    s_cbranch_execz .LBB2_4
; GFX11-NEXT:    s_branch .LBB2_12
; GFX11-NEXT:  .LBB2_3:
; GFX11-NEXT:    s_mov_b32 s1, 0
; GFX11-NEXT:    s_and_not1_b32 vcc_lo, exec_lo, s0
; GFX11-NEXT:    s_cbranch_vccnz .LBB2_12
; GFX11-NEXT:  .LBB2_4: ; %bb16
; GFX11-NEXT:    s_load_b32 s2, s[16:17], 0x54
; GFX11-NEXT:    s_bitcmp1_b32 s23, 0
; GFX11-NEXT:    s_cselect_b32 s0, -1, 0
; GFX11-NEXT:    s_and_b32 s3, s23, 1
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_bitcmp1_b32 s2, 0
; GFX11-NEXT:    s_mov_b32 s2, -1
; GFX11-NEXT:    s_cselect_b32 s8, -1, 0
; GFX11-NEXT:    s_cmp_eq_u32 s3, 0
; GFX11-NEXT:    s_cbranch_scc0 .LBB2_8
; GFX11-NEXT:  ; %bb.5: ; %bb18.preheader
; GFX11-NEXT:    s_load_b128 s[28:31], s[16:17], 0x44
; GFX11-NEXT:    v_mov_b32_e32 v2, 0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mul_hi_u32 s2, s29, s28
; GFX11-NEXT:    s_mul_i32 s3, s29, s28
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_alignbit_b32 v0, s2, s3, 1
; GFX11-NEXT:    s_mov_b32 s3, 0
; GFX11-NEXT:    v_readfirstlane_b32 s2, v0
; GFX11-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s25
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(SALU_CYCLE_1)
; GFX11-NEXT:    s_or_b32 s2, s2, 1
; GFX11-NEXT:    s_lshr_b32 s2, s2, s30
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
; GFX11-NEXT:    s_mul_i32 s2, s2, s22
; GFX11-NEXT:    s_mul_i32 s2, s2, s20
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
; GFX11-NEXT:    s_or_b32 s2, s24, s2
; GFX11-NEXT:    s_lshl_b64 s[20:21], s[2:3], 1
; GFX11-NEXT:    global_load_u16 v1, v2, s[20:21]
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_cmp_eq_u16_e32 vcc_lo, 0, v1
; GFX11-NEXT:    v_cndmask_b32_e64 v1, 0, 1, vcc_lo
; GFX11-NEXT:    .p2align 6
; GFX11-NEXT:  .LBB2_6: ; %bb18
; GFX11-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX11-NEXT:    v_cmp_ne_u16_e64 s2, s3, 0
; GFX11-NEXT:    v_cmp_ne_u16_e32 vcc_lo, 0, v2
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_2)
; GFX11-NEXT:    v_cndmask_b32_e64 v3, 0, 1, s2
; GFX11-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc_lo
; GFX11-NEXT:    s_and_b32 vcc_lo, s8, vcc_lo
; GFX11-NEXT:    v_cndmask_b32_e64 v3, v1, v3, s0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
; GFX11-NEXT:    v_cndmask_b32_e32 v2, v0, v2, vcc_lo
; GFX11-NEXT:    s_mov_b32 vcc_lo, 0
; GFX11-NEXT:    v_readfirstlane_b32 s2, v3
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
; GFX11-NEXT:    v_and_b32_e32 v2, 1, v2
; GFX11-NEXT:    s_bitcmp1_b32 s2, 0
; GFX11-NEXT:    s_cselect_b32 s2, 0x100, 0
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX11-NEXT:    s_or_b32 s3, s2, s3
; GFX11-NEXT:    s_cbranch_vccz .LBB2_6
; GFX11-NEXT:  ; %bb.7: ; %Flow
; GFX11-NEXT:    s_mov_b32 s2, 0
; GFX11-NEXT:  .LBB2_8: ; %Flow12
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX11-NEXT:    s_and_b32 vcc_lo, exec_lo, s2
; GFX11-NEXT:    s_cbranch_vccz .LBB2_12
; GFX11-NEXT:  ; %bb.9:
; GFX11-NEXT:    s_xor_b32 s0, s8, -1
; GFX11-NEXT:  .LBB2_10: ; %bb17
; GFX11-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX11-NEXT:    s_and_b32 vcc_lo, exec_lo, s0
; GFX11-NEXT:    s_cbranch_vccz .LBB2_10
; GFX11-NEXT:  ; %bb.11: ; %Flow6
; GFX11-NEXT:    s_mov_b32 s19, -1
; GFX11-NEXT:  .LBB2_12: ; %Flow11
; GFX11-NEXT:    s_and_b32 s3, s1, exec_lo
; GFX11-NEXT:    s_or_not1_b32 s0, s19, exec_lo
; GFX11-NEXT:  .LBB2_13: ; %Flow9
; GFX11-NEXT:    s_or_b32 exec_lo, exec_lo, s18
; GFX11-NEXT:    s_and_saveexec_b32 s18, s0
; GFX11-NEXT:    s_cbranch_execz .LBB2_15
; GFX11-NEXT:  ; %bb.14: ; %bb43
; GFX11-NEXT:    s_add_u32 s8, s16, 0x58
; GFX11-NEXT:    s_addc_u32 s9, s17, 0
; GFX11-NEXT:    s_getpc_b64 s[0:1]
; GFX11-NEXT:    s_add_u32 s0, s0, f0@gotpcrel32@lo+4
; GFX11-NEXT:    s_addc_u32 s1, s1, f0@gotpcrel32@hi+12
; GFX11-NEXT:    s_mov_b32 s13, s14
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x0
; GFX11-NEXT:    s_mov_b32 s14, s15
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; GFX11-NEXT:    s_or_b32 s3, s3, exec_lo
; GFX11-NEXT:  .LBB2_15: ; %Flow14
; GFX11-NEXT:    s_or_b32 exec_lo, exec_lo, s18
; GFX11-NEXT:    s_and_saveexec_b32 s0, s3
; GFX11-NEXT:  ; %bb.16: ; %UnifiedUnreachableBlock
; GFX11-NEXT:    ; divergent unreachable
; GFX11-NEXT:  ; %bb.17: ; %UnifiedReturnBlock
; GFX11-NEXT:    s_endpgm
bb:
  %i = tail call i32 @llvm.amdgcn.workitem.id.x()
  %i12 = mul i32 %arg, %i
  %i13 = icmp ult i32 %i12, 1
  br i1 %i13, label %bb14, label %bb43

bb14:
  br i1 %arg3, label %bb16, label %bb15

bb15:
  call void @f0()
  unreachable

bb16:
  br i1 %arg5, label %bb17, label %bb18

bb17:
  br i1 %arg11, label %bb17, label %bb43

bb18:
  %i19 = phi i16 [ %i38, %bb18 ], [ 0, %bb16 ]
  %i20 = phi i16 [ %i42, %bb18 ], [ 0, %bb16 ]
  %i21 = zext i32 %arg7 to i64
  %i22 = zext i32 %arg8 to i64
  %i23 = mul i64 %i22, %i21
  %i24 = lshr i64 %i23, 1
  %i25 = trunc i64 %i24 to i32
  %i26 = or i32 1, %i25
  %i27 = lshr i32 %i26, %arg9
  %i28 = mul i32 %i27, %arg4
  %i29 = mul i32 %i28, %arg2
  %i30 = or i32 %arg, %i29
  %i31 = zext i32 %i30 to i64
  %i32 = getelementptr { [2 x i8] }, ptr addrspace(1) null, i64 %i31
  %i33 = load i16, ptr addrspace(1) %i32, align 2
  %i34 = icmp ult i16 %i33, 1
  %i35 = icmp ne i16 %i19, 0
  %i36 = select i1 %arg11, i1 %i35, i1 false
  %i37 = select i1 %i36, i1 %i35, i1 %arg3
  %i38 = select i1 %i37, i16 1, i16 0
  %i39 = icmp ne i16 %i20, 0
  %i40 = select i1 %arg5, i1 %i39, i1 %i34
  %i41 = select i1 %i40, i16 256, i16 0
  %i42 = or i16 %i41, %i20
  br label %bb18

bb43:
  call void @f0()
  unreachable
}

attributes #0 = { noinline optnone }