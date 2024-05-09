; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx900 -sgpr-regalloc=fast -vgpr-regalloc=fast -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

; Make sure there's no verifier error from improperly updated
; SlotIndexes if regalloc fast is manually used.

declare void @foo()

define amdgpu_kernel void @kernel() {
; GCN-LABEL: kernel:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s36, SCRATCH_RSRC_DWORD0
; GCN-NEXT:    s_mov_b32 s37, SCRATCH_RSRC_DWORD1
; GCN-NEXT:    s_mov_b32 s38, -1
; GCN-NEXT:    s_mov_b32 s39, 0xe00000
; GCN-NEXT:    ; implicit-def: $vgpr3 : SGPR spill to VGPR lane
; GCN-NEXT:    s_add_u32 s36, s36, s11
; GCN-NEXT:    v_writelane_b32 v3, s4, 0
; GCN-NEXT:    s_movk_i32 s32, 0x400
; GCN-NEXT:    s_addc_u32 s37, s37, 0
; GCN-NEXT:    s_mov_b32 s14, s10
; GCN-NEXT:    s_mov_b32 s13, s9
; GCN-NEXT:    s_mov_b32 s12, s8
; GCN-NEXT:    s_mov_b64 s[10:11], s[6:7]
; GCN-NEXT:    v_writelane_b32 v3, s5, 1
; GCN-NEXT:    s_or_saveexec_b64 s[34:35], -1
; GCN-NEXT:    buffer_store_dword v3, off, s[36:39], 0 offset:4 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[34:35]
; GCN-NEXT:    s_mov_b64 s[4:5], s[0:1]
; GCN-NEXT:    v_readlane_b32 s0, v3, 0
; GCN-NEXT:    v_readlane_b32 s1, v3, 1
; GCN-NEXT:    s_add_u32 s8, s0, 36
; GCN-NEXT:    s_addc_u32 s9, s1, 0
; GCN-NEXT:    s_getpc_b64 s[0:1]
; GCN-NEXT:    s_add_u32 s0, s0, foo@gotpcrel32@lo+4
; GCN-NEXT:    s_addc_u32 s1, s1, foo@gotpcrel32@hi+12
; GCN-NEXT:    s_load_dwordx2 s[16:17], s[0:1], 0x0
; GCN-NEXT:    s_mov_b64 s[6:7], s[2:3]
; GCN-NEXT:    v_lshlrev_b32_e32 v2, 20, v2
; GCN-NEXT:    v_lshlrev_b32_e32 v1, 10, v1
; GCN-NEXT:    s_mov_b64 s[0:1], s[36:37]
; GCN-NEXT:    v_or3_b32 v31, v0, v1, v2
; GCN-NEXT:    s_mov_b64 s[2:3], s[38:39]
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_swappc_b64 s[30:31], s[16:17]
; GCN-NEXT:    s_or_saveexec_b64 s[34:35], -1
; GCN-NEXT:    buffer_load_dword v0, off, s[36:39], 0 offset:4 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[34:35]
; GCN-NEXT:    ; kill: killed $vgpr0
; GCN-NEXT:    s_endpgm
  call void @foo()
  ret void
}