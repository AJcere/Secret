; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -passes=slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=corei7-avx -passes=slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX256
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=bdver1 -passes=slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX256
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=core-avx2 -passes=slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX256
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skylake-avx512 -mattr=-prefer-256-bit -passes=slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX512
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skylake-avx512 -mattr=+prefer-256-bit -passes=slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX256

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@srcA64 = common global [8 x double] zeroinitializer, align 64
@srcB64 = common global [8 x double] zeroinitializer, align 64
@srcC64 = common global [8 x double] zeroinitializer, align 64
@srcA32 = common global [16 x float] zeroinitializer, align 64
@srcB32 = common global [16 x float] zeroinitializer, align 64
@srcC32 = common global [16 x float] zeroinitializer, align 64
@dst64 = common global [8 x double] zeroinitializer, align 64
@dst32 = common global [16 x float] zeroinitializer, align 64

declare float @llvm.copysign.f32(float, float)
declare double @llvm.copysign.f64(double, double)

;
; CHECK
;

define void @fcopysign_2f64() #0 {
; CHECK-LABEL: @fcopysign_2f64(
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x double>, ptr @srcA64, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x double>, ptr @srcB64, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = call <2 x double> @llvm.copysign.v2f64(<2 x double> [[TMP1]], <2 x double> [[TMP2]])
; CHECK-NEXT:    store <2 x double> [[TMP3]], ptr @dst64, align 8
; CHECK-NEXT:    ret void
;
  %a0 = load double, ptr @srcA64, align 8
  %a1 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 1), align 8
  %b0 = load double, ptr @srcB64, align 8
  %b1 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 1), align 8
  %fcopysign0 = call double @llvm.copysign.f64(double %a0, double %b0)
  %fcopysign1 = call double @llvm.copysign.f64(double %a1, double %b1)
  store double %fcopysign0, ptr @dst64, align 8
  store double %fcopysign1, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 1), align 8
  ret void
}

define void @fcopysign_4f64() #0 {
; SSE-LABEL: @fcopysign_4f64(
; SSE-NEXT:    [[TMP1:%.*]] = load <2 x double>, ptr @srcA64, align 8
; SSE-NEXT:    [[TMP2:%.*]] = load <2 x double>, ptr @srcB64, align 8
; SSE-NEXT:    [[TMP3:%.*]] = call <2 x double> @llvm.copysign.v2f64(<2 x double> [[TMP1]], <2 x double> [[TMP2]])
; SSE-NEXT:    store <2 x double> [[TMP3]], ptr @dst64, align 8
; SSE-NEXT:    [[TMP4:%.*]] = load <2 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 2), align 8
; SSE-NEXT:    [[TMP5:%.*]] = load <2 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 2), align 8
; SSE-NEXT:    [[TMP6:%.*]] = call <2 x double> @llvm.copysign.v2f64(<2 x double> [[TMP4]], <2 x double> [[TMP5]])
; SSE-NEXT:    store <2 x double> [[TMP6]], ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 2), align 8
; SSE-NEXT:    ret void
;
; AVX-LABEL: @fcopysign_4f64(
; AVX-NEXT:    [[TMP1:%.*]] = load <4 x double>, ptr @srcA64, align 8
; AVX-NEXT:    [[TMP2:%.*]] = load <4 x double>, ptr @srcB64, align 8
; AVX-NEXT:    [[TMP3:%.*]] = call <4 x double> @llvm.copysign.v4f64(<4 x double> [[TMP1]], <4 x double> [[TMP2]])
; AVX-NEXT:    store <4 x double> [[TMP3]], ptr @dst64, align 8
; AVX-NEXT:    ret void
;
  %a0 = load double, ptr @srcA64, align 8
  %a1 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 1), align 8
  %a2 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 2), align 8
  %a3 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 3), align 8
  %b0 = load double, ptr @srcB64, align 8
  %b1 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 1), align 8
  %b2 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 2), align 8
  %b3 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 3), align 8
  %fcopysign0 = call double @llvm.copysign.f64(double %a0, double %b0)
  %fcopysign1 = call double @llvm.copysign.f64(double %a1, double %b1)
  %fcopysign2 = call double @llvm.copysign.f64(double %a2, double %b2)
  %fcopysign3 = call double @llvm.copysign.f64(double %a3, double %b3)
  store double %fcopysign0, ptr @dst64, align 8
  store double %fcopysign1, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 1), align 8
  store double %fcopysign2, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 2), align 8
  store double %fcopysign3, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 3), align 8
  ret void
}

define void @fcopysign_8f64() #0 {
; SSE-LABEL: @fcopysign_8f64(
; SSE-NEXT:    [[TMP1:%.*]] = load <2 x double>, ptr @srcA64, align 4
; SSE-NEXT:    [[TMP2:%.*]] = load <2 x double>, ptr @srcB64, align 4
; SSE-NEXT:    [[TMP3:%.*]] = call <2 x double> @llvm.copysign.v2f64(<2 x double> [[TMP1]], <2 x double> [[TMP2]])
; SSE-NEXT:    store <2 x double> [[TMP3]], ptr @dst64, align 4
; SSE-NEXT:    [[TMP4:%.*]] = load <2 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 2), align 4
; SSE-NEXT:    [[TMP5:%.*]] = load <2 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 2), align 4
; SSE-NEXT:    [[TMP6:%.*]] = call <2 x double> @llvm.copysign.v2f64(<2 x double> [[TMP4]], <2 x double> [[TMP5]])
; SSE-NEXT:    store <2 x double> [[TMP6]], ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 2), align 4
; SSE-NEXT:    [[TMP7:%.*]] = load <2 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 4), align 4
; SSE-NEXT:    [[TMP8:%.*]] = load <2 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 4), align 4
; SSE-NEXT:    [[TMP9:%.*]] = call <2 x double> @llvm.copysign.v2f64(<2 x double> [[TMP7]], <2 x double> [[TMP8]])
; SSE-NEXT:    store <2 x double> [[TMP9]], ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 4), align 4
; SSE-NEXT:    [[TMP10:%.*]] = load <2 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 6), align 4
; SSE-NEXT:    [[TMP11:%.*]] = load <2 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 6), align 4
; SSE-NEXT:    [[TMP12:%.*]] = call <2 x double> @llvm.copysign.v2f64(<2 x double> [[TMP10]], <2 x double> [[TMP11]])
; SSE-NEXT:    store <2 x double> [[TMP12]], ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 6), align 4
; SSE-NEXT:    ret void
;
; AVX256-LABEL: @fcopysign_8f64(
; AVX256-NEXT:    [[TMP1:%.*]] = load <4 x double>, ptr @srcA64, align 4
; AVX256-NEXT:    [[TMP2:%.*]] = load <4 x double>, ptr @srcB64, align 4
; AVX256-NEXT:    [[TMP3:%.*]] = call <4 x double> @llvm.copysign.v4f64(<4 x double> [[TMP1]], <4 x double> [[TMP2]])
; AVX256-NEXT:    store <4 x double> [[TMP3]], ptr @dst64, align 4
; AVX256-NEXT:    [[TMP4:%.*]] = load <4 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 4), align 4
; AVX256-NEXT:    [[TMP5:%.*]] = load <4 x double>, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 4), align 4
; AVX256-NEXT:    [[TMP6:%.*]] = call <4 x double> @llvm.copysign.v4f64(<4 x double> [[TMP4]], <4 x double> [[TMP5]])
; AVX256-NEXT:    store <4 x double> [[TMP6]], ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 4), align 4
; AVX256-NEXT:    ret void
;
; AVX512-LABEL: @fcopysign_8f64(
; AVX512-NEXT:    [[TMP1:%.*]] = load <8 x double>, ptr @srcA64, align 4
; AVX512-NEXT:    [[TMP2:%.*]] = load <8 x double>, ptr @srcB64, align 4
; AVX512-NEXT:    [[TMP3:%.*]] = call <8 x double> @llvm.copysign.v8f64(<8 x double> [[TMP1]], <8 x double> [[TMP2]])
; AVX512-NEXT:    store <8 x double> [[TMP3]], ptr @dst64, align 4
; AVX512-NEXT:    ret void
;
  %a0 = load double, ptr @srcA64, align 4
  %a1 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 1), align 4
  %a2 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 2), align 4
  %a3 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 3), align 4
  %a4 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 4), align 4
  %a5 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 5), align 4
  %a6 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 6), align 4
  %a7 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcA64, i32 0, i64 7), align 4
  %b0 = load double, ptr @srcB64, align 4
  %b1 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 1), align 4
  %b2 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 2), align 4
  %b3 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 3), align 4
  %b4 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 4), align 4
  %b5 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 5), align 4
  %b6 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 6), align 4
  %b7 = load double, ptr getelementptr inbounds ([8 x double], ptr @srcB64, i32 0, i64 7), align 4
  %fcopysign0 = call double @llvm.copysign.f64(double %a0, double %b0)
  %fcopysign1 = call double @llvm.copysign.f64(double %a1, double %b1)
  %fcopysign2 = call double @llvm.copysign.f64(double %a2, double %b2)
  %fcopysign3 = call double @llvm.copysign.f64(double %a3, double %b3)
  %fcopysign4 = call double @llvm.copysign.f64(double %a4, double %b4)
  %fcopysign5 = call double @llvm.copysign.f64(double %a5, double %b5)
  %fcopysign6 = call double @llvm.copysign.f64(double %a6, double %b6)
  %fcopysign7 = call double @llvm.copysign.f64(double %a7, double %b7)
  store double %fcopysign0, ptr @dst64, align 4
  store double %fcopysign1, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 1), align 4
  store double %fcopysign2, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 2), align 4
  store double %fcopysign3, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 3), align 4
  store double %fcopysign4, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 4), align 4
  store double %fcopysign5, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 5), align 4
  store double %fcopysign6, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 6), align 4
  store double %fcopysign7, ptr getelementptr inbounds ([8 x double], ptr @dst64, i32 0, i64 7), align 4
  ret void
}

define void @fcopysign_4f32() #0 {
; CHECK-LABEL: @fcopysign_4f32(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, ptr @srcA32, align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, ptr @srcB32, align 4
; CHECK-NEXT:    [[TMP3:%.*]] = call <4 x float> @llvm.copysign.v4f32(<4 x float> [[TMP1]], <4 x float> [[TMP2]])
; CHECK-NEXT:    store <4 x float> [[TMP3]], ptr @dst32, align 4
; CHECK-NEXT:    ret void
;
  %a0 = load float, ptr @srcA32, align 4
  %a1 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 1), align 4
  %a2 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 2), align 4
  %a3 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 3), align 4
  %b0 = load float, ptr @srcB32, align 4
  %b1 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 1), align 4
  %b2 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 2), align 4
  %b3 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 3), align 4
  %fcopysign0 = call float @llvm.copysign.f32(float %a0, float %b0)
  %fcopysign1 = call float @llvm.copysign.f32(float %a1, float %b1)
  %fcopysign2 = call float @llvm.copysign.f32(float %a2, float %b2)
  %fcopysign3 = call float @llvm.copysign.f32(float %a3, float %b3)
  store float %fcopysign0, ptr @dst32, align 4
  store float %fcopysign1, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 1), align 4
  store float %fcopysign2, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 2), align 4
  store float %fcopysign3, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 3), align 4
  ret void
}

define void @fcopysign_8f32() #0 {
; SSE-LABEL: @fcopysign_8f32(
; SSE-NEXT:    [[TMP1:%.*]] = load <4 x float>, ptr @srcA32, align 4
; SSE-NEXT:    [[TMP2:%.*]] = load <4 x float>, ptr @srcB32, align 4
; SSE-NEXT:    [[TMP3:%.*]] = call <4 x float> @llvm.copysign.v4f32(<4 x float> [[TMP1]], <4 x float> [[TMP2]])
; SSE-NEXT:    store <4 x float> [[TMP3]], ptr @dst32, align 4
; SSE-NEXT:    [[TMP4:%.*]] = load <4 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 4), align 4
; SSE-NEXT:    [[TMP5:%.*]] = load <4 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 4), align 4
; SSE-NEXT:    [[TMP6:%.*]] = call <4 x float> @llvm.copysign.v4f32(<4 x float> [[TMP4]], <4 x float> [[TMP5]])
; SSE-NEXT:    store <4 x float> [[TMP6]], ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 4), align 4
; SSE-NEXT:    ret void
;
; AVX-LABEL: @fcopysign_8f32(
; AVX-NEXT:    [[TMP1:%.*]] = load <8 x float>, ptr @srcA32, align 4
; AVX-NEXT:    [[TMP2:%.*]] = load <8 x float>, ptr @srcB32, align 4
; AVX-NEXT:    [[TMP3:%.*]] = call <8 x float> @llvm.copysign.v8f32(<8 x float> [[TMP1]], <8 x float> [[TMP2]])
; AVX-NEXT:    store <8 x float> [[TMP3]], ptr @dst32, align 4
; AVX-NEXT:    ret void
;
  %a0 = load float, ptr @srcA32, align 4
  %a1 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 1), align 4
  %a2 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 2), align 4
  %a3 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 3), align 4
  %a4 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 4), align 4
  %a5 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 5), align 4
  %a6 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 6), align 4
  %a7 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 7), align 4
  %b0 = load float, ptr @srcB32, align 4
  %b1 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 1), align 4
  %b2 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 2), align 4
  %b3 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 3), align 4
  %b4 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 4), align 4
  %b5 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 5), align 4
  %b6 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 6), align 4
  %b7 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 7), align 4
  %fcopysign0 = call float @llvm.copysign.f32(float %a0, float %b0)
  %fcopysign1 = call float @llvm.copysign.f32(float %a1, float %b1)
  %fcopysign2 = call float @llvm.copysign.f32(float %a2, float %b2)
  %fcopysign3 = call float @llvm.copysign.f32(float %a3, float %b3)
  %fcopysign4 = call float @llvm.copysign.f32(float %a4, float %b4)
  %fcopysign5 = call float @llvm.copysign.f32(float %a5, float %b5)
  %fcopysign6 = call float @llvm.copysign.f32(float %a6, float %b6)
  %fcopysign7 = call float @llvm.copysign.f32(float %a7, float %b7)
  store float %fcopysign0, ptr @dst32, align 4
  store float %fcopysign1, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 1), align 4
  store float %fcopysign2, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 2), align 4
  store float %fcopysign3, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 3), align 4
  store float %fcopysign4, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 4), align 4
  store float %fcopysign5, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 5), align 4
  store float %fcopysign6, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 6), align 4
  store float %fcopysign7, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 7), align 4
  ret void
}

define void @fcopysign_16f32() #0 {
; SSE-LABEL: @fcopysign_16f32(
; SSE-NEXT:    [[TMP1:%.*]] = load <4 x float>, ptr @srcA32, align 4
; SSE-NEXT:    [[TMP2:%.*]] = load <4 x float>, ptr @srcB32, align 4
; SSE-NEXT:    [[TMP3:%.*]] = call <4 x float> @llvm.copysign.v4f32(<4 x float> [[TMP1]], <4 x float> [[TMP2]])
; SSE-NEXT:    store <4 x float> [[TMP3]], ptr @dst32, align 4
; SSE-NEXT:    [[TMP4:%.*]] = load <4 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 4), align 4
; SSE-NEXT:    [[TMP5:%.*]] = load <4 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 4), align 4
; SSE-NEXT:    [[TMP6:%.*]] = call <4 x float> @llvm.copysign.v4f32(<4 x float> [[TMP4]], <4 x float> [[TMP5]])
; SSE-NEXT:    store <4 x float> [[TMP6]], ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 4), align 4
; SSE-NEXT:    [[TMP7:%.*]] = load <4 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 8), align 4
; SSE-NEXT:    [[TMP8:%.*]] = load <4 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 8), align 4
; SSE-NEXT:    [[TMP9:%.*]] = call <4 x float> @llvm.copysign.v4f32(<4 x float> [[TMP7]], <4 x float> [[TMP8]])
; SSE-NEXT:    store <4 x float> [[TMP9]], ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 8), align 4
; SSE-NEXT:    [[TMP10:%.*]] = load <4 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 12), align 4
; SSE-NEXT:    [[TMP11:%.*]] = load <4 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 12), align 4
; SSE-NEXT:    [[TMP12:%.*]] = call <4 x float> @llvm.copysign.v4f32(<4 x float> [[TMP10]], <4 x float> [[TMP11]])
; SSE-NEXT:    store <4 x float> [[TMP12]], ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 12), align 4
; SSE-NEXT:    ret void
;
; AVX256-LABEL: @fcopysign_16f32(
; AVX256-NEXT:    [[TMP1:%.*]] = load <8 x float>, ptr @srcA32, align 4
; AVX256-NEXT:    [[TMP2:%.*]] = load <8 x float>, ptr @srcB32, align 4
; AVX256-NEXT:    [[TMP3:%.*]] = call <8 x float> @llvm.copysign.v8f32(<8 x float> [[TMP1]], <8 x float> [[TMP2]])
; AVX256-NEXT:    store <8 x float> [[TMP3]], ptr @dst32, align 4
; AVX256-NEXT:    [[TMP4:%.*]] = load <8 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 8), align 4
; AVX256-NEXT:    [[TMP5:%.*]] = load <8 x float>, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 8), align 4
; AVX256-NEXT:    [[TMP6:%.*]] = call <8 x float> @llvm.copysign.v8f32(<8 x float> [[TMP4]], <8 x float> [[TMP5]])
; AVX256-NEXT:    store <8 x float> [[TMP6]], ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 8), align 4
; AVX256-NEXT:    ret void
;
; AVX512-LABEL: @fcopysign_16f32(
; AVX512-NEXT:    [[TMP1:%.*]] = load <16 x float>, ptr @srcA32, align 4
; AVX512-NEXT:    [[TMP2:%.*]] = load <16 x float>, ptr @srcB32, align 4
; AVX512-NEXT:    [[TMP3:%.*]] = call <16 x float> @llvm.copysign.v16f32(<16 x float> [[TMP1]], <16 x float> [[TMP2]])
; AVX512-NEXT:    store <16 x float> [[TMP3]], ptr @dst32, align 4
; AVX512-NEXT:    ret void
;
  %a0  = load float, ptr @srcA32, align 4
  %a1  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  1), align 4
  %a2  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  2), align 4
  %a3  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  3), align 4
  %a4  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  4), align 4
  %a5  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  5), align 4
  %a6  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  6), align 4
  %a7  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  7), align 4
  %a8  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  8), align 4
  %a9  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64  9), align 4
  %a10 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 10), align 4
  %a11 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 11), align 4
  %a12 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 12), align 4
  %a13 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 13), align 4
  %a14 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 14), align 4
  %a15 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcA32, i32 0, i64 15), align 4
  %b0  = load float, ptr @srcB32, align 4
  %b1  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  1), align 4
  %b2  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  2), align 4
  %b3  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  3), align 4
  %b4  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  4), align 4
  %b5  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  5), align 4
  %b6  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  6), align 4
  %b7  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  7), align 4
  %b8  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  8), align 4
  %b9  = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64  9), align 4
  %b10 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 10), align 4
  %b11 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 11), align 4
  %b12 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 12), align 4
  %b13 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 13), align 4
  %b14 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 14), align 4
  %b15 = load float, ptr getelementptr inbounds ([16 x float], ptr @srcB32, i32 0, i64 15), align 4
  %fcopysign0  = call float @llvm.copysign.f32(float %a0 , float %b0 )
  %fcopysign1  = call float @llvm.copysign.f32(float %a1 , float %b1 )
  %fcopysign2  = call float @llvm.copysign.f32(float %a2 , float %b2 )
  %fcopysign3  = call float @llvm.copysign.f32(float %a3 , float %b3 )
  %fcopysign4  = call float @llvm.copysign.f32(float %a4 , float %b4 )
  %fcopysign5  = call float @llvm.copysign.f32(float %a5 , float %b5 )
  %fcopysign6  = call float @llvm.copysign.f32(float %a6 , float %b6 )
  %fcopysign7  = call float @llvm.copysign.f32(float %a7 , float %b7 )
  %fcopysign8  = call float @llvm.copysign.f32(float %a8 , float %b8 )
  %fcopysign9  = call float @llvm.copysign.f32(float %a9 , float %b9 )
  %fcopysign10 = call float @llvm.copysign.f32(float %a10, float %b10)
  %fcopysign11 = call float @llvm.copysign.f32(float %a11, float %b11)
  %fcopysign12 = call float @llvm.copysign.f32(float %a12, float %b12)
  %fcopysign13 = call float @llvm.copysign.f32(float %a13, float %b13)
  %fcopysign14 = call float @llvm.copysign.f32(float %a14, float %b14)
  %fcopysign15 = call float @llvm.copysign.f32(float %a15, float %b15)
  store float %fcopysign0 , ptr @dst32, align 4
  store float %fcopysign1 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  1), align 4
  store float %fcopysign2 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  2), align 4
  store float %fcopysign3 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  3), align 4
  store float %fcopysign4 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  4), align 4
  store float %fcopysign5 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  5), align 4
  store float %fcopysign6 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  6), align 4
  store float %fcopysign7 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  7), align 4
  store float %fcopysign8 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  8), align 4
  store float %fcopysign9 , ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64  9), align 4
  store float %fcopysign10, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 10), align 4
  store float %fcopysign11, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 11), align 4
  store float %fcopysign12, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 12), align 4
  store float %fcopysign13, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 13), align 4
  store float %fcopysign14, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 14), align 4
  store float %fcopysign15, ptr getelementptr inbounds ([16 x float], ptr @dst32, i32 0, i64 15), align 4
  ret void
}

attributes #0 = { nounwind }