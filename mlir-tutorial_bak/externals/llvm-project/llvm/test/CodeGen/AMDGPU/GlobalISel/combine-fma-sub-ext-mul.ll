; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 --denormal-fp-math=preserve-sign < %s | FileCheck -check-prefix=GFX9-DENORM %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 --denormal-fp-math=preserve-sign < %s | FileCheck -check-prefix=GFX10-DENORM %s

; fold (fsub (fpext (fmul x, y)), z) -> (fma (fpext x), (fpext y), (fneg z))
define amdgpu_vs float @test_f16_to_f32_sub_ext_mul(half %x, half %y, float %z) {
; GFX9-DENORM-LABEL: test_f16_to_f32_sub_ext_mul:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_mad_mix_f32 v0, v0, v1, -v2 op_sel_hi:[1,1,0]
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_f16_to_f32_sub_ext_mul:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v0, v0, v1, -v2 op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast half %x, %y
  %b = fpext half %a to float
  %c = fsub fast float %b, %z
  ret float %c
}

; fold (fsub x, (fpext (fmul y, z))) -> (fma (fneg (fpext y)), (fpext z), x)
define amdgpu_vs float @test_f16_to_f32_sub_ext_mul_rhs(float %x, half %y, half %z) {
; GFX9-DENORM-LABEL: test_f16_to_f32_sub_ext_mul_rhs:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    v_mad_mix_f32 v0, -v1, v2, v0 op_sel_hi:[1,1,0]
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_f16_to_f32_sub_ext_mul_rhs:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v0, -v1, v2, v0 op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    ; return to shader part epilog
.entry:
  %a = fmul fast half %y, %z
  %b = fpext half %a to float
  %c = fsub fast float %x, %b
  ret float %c
}

; fold (fsub (fpext (fmul x, y)), z) -> (fma (fpext x), (fpext y), (fneg z))
define amdgpu_vs <4 x float> @test_v4f16_to_v4f32_sub_ext_mul(<4 x half> %x, <4 x half> %y, <4 x float> %z) {
; GFX9-DENORM-LABEL: test_v4f16_to_v4f32_sub_ext_mul:
; GFX9-DENORM:       ; %bb.0: ; %entry
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v2, v0
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v3, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v8, v1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v9, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v0, v2, v4
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v1, v3, v5
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v2, v8, v6
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v3, v9, v7
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_v4f16_to_v4f32_sub_ext_mul:
; GFX10-DENORM:       ; %bb.0: ; %entry
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v4, v0, v2, -v4 op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v5, v0, v2, -v5 op_sel:[1,1,0] op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v2, v1, v3, -v6 op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v3, v1, v3, -v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    v_mov_b32_e32 v0, v4
; GFX10-DENORM-NEXT:    v_mov_b32_e32 v1, v5
; GFX10-DENORM-NEXT:    ; return to shader part epilog
entry:
  %a = fmul fast <4 x half> %x, %y
  %b = fpext <4 x half> %a to <4 x float>
  %c = fsub fast <4 x float> %b, %z
  ret <4 x float> %c
}

; fold (fsub x, (fpext (fmul y, z))) -> (fma (fneg (fpext y)), (fpext z), x)
define amdgpu_vs <4 x float> @test_v4f16_to_v4f32_sub_ext_mul_rhs(<4 x float> %x, <4 x half> %y, <4 x half> %z) {
; GFX9-DENORM-LABEL: test_v4f16_to_v4f32_sub_ext_mul_rhs:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v4, v4, v6
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v5, v5, v7
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v6, v4
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v4, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_e32 v7, v5
; GFX9-DENORM-NEXT:    v_cvt_f32_f16_sdwa v5, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v0, v0, v6
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v1, v1, v4
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v2, v2, v7
; GFX9-DENORM-NEXT:    v_sub_f32_e32 v3, v3, v5
; GFX9-DENORM-NEXT:    ; return to shader part epilog
;
; GFX10-DENORM-LABEL: test_v4f16_to_v4f32_sub_ext_mul_rhs:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v0, -v4, v6, v0 op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v1, -v4, v6, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v2, -v5, v7, v2 op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    v_fma_mix_f32 v3, -v5, v7, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0]
; GFX10-DENORM-NEXT:    ; return to shader part epilog
.entry:
  %a = fmul fast <4 x half> %y, %z
  %b = fpext <4 x half> %a to <4 x float>
  %c = fsub fast <4 x float> %x, %b
  ret <4 x float> %c
}