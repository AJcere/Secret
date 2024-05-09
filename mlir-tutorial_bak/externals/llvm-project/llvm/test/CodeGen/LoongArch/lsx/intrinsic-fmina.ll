; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lsx < %s | FileCheck %s

declare <4 x float> @llvm.loongarch.lsx.vfmina.s(<4 x float>, <4 x float>)

define <4 x float> @lsx_vfmina_s(<4 x float> %va, <4 x float> %vb) nounwind {
; CHECK-LABEL: lsx_vfmina_s:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmina.s $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x float> @llvm.loongarch.lsx.vfmina.s(<4 x float> %va, <4 x float> %vb)
  ret <4 x float> %res
}

declare <2 x double> @llvm.loongarch.lsx.vfmina.d(<2 x double>, <2 x double>)

define <2 x double> @lsx_vfmina_d(<2 x double> %va, <2 x double> %vb) nounwind {
; CHECK-LABEL: lsx_vfmina_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmina.d $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <2 x double> @llvm.loongarch.lsx.vfmina.d(<2 x double> %va, <2 x double> %vb)
  ret <2 x double> %res
}