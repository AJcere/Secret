; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt < %s -passes=slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu -mattr=+avx  | FileCheck %s --check-prefixes=CHECK,AVX
; RUN: opt < %s -passes=slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX

define void @powof2mul_uniform(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, ptr noalias nocapture readonly %c){
; CHECK-LABEL: @powof2mul_uniform(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr [[B:%.*]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, ptr [[C:%.*]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <4 x i32> [[TMP3]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = mul <4 x i32> [[TMP4]], <i32 2, i32 2, i32 2, i32 2>
; CHECK-NEXT:    store <4 x i32> [[TMP5]], ptr [[A:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, ptr %b, align 4
  %1 = load i32, ptr %c, align 4
  %add = add nsw i32 %1, %0
  %mul = mul i32 %add, 2
  store i32 %mul, ptr %a, align 4
  %arrayidx3 = getelementptr inbounds i32, ptr %b, i64 1
  %2 = load i32, ptr %arrayidx3, align 4
  %arrayidx4 = getelementptr inbounds i32, ptr %c, i64 1
  %3 = load i32, ptr %arrayidx4, align 4
  %add5 = add nsw i32 %3, %2
  %mul6 = mul i32 %add5, 2
  %arrayidx7 = getelementptr inbounds i32, ptr %a, i64 1
  store i32 %mul6, ptr %arrayidx7, align 4
  %arrayidx8 = getelementptr inbounds i32, ptr %b, i64 2
  %4 = load i32, ptr %arrayidx8, align 4
  %arrayidx9 = getelementptr inbounds i32, ptr %c, i64 2
  %5 = load i32, ptr %arrayidx9, align 4
  %add10 = add nsw i32 %5, %4
  %mul11 = mul i32 %add10, 2
  %arrayidx12 = getelementptr inbounds i32, ptr %a, i64 2
  store i32 %mul11, ptr %arrayidx12, align 4
  %arrayidx13 = getelementptr inbounds i32, ptr %b, i64 3
  %6 = load i32, ptr %arrayidx13, align 4
  %arrayidx14 = getelementptr inbounds i32, ptr %c, i64 3
  %7 = load i32, ptr %arrayidx14, align 4
  %add15 = add nsw i32 %7, %6
  %mul16 = mul i32 %add15, 2
  %arrayidx17 = getelementptr inbounds i32, ptr %a, i64 3
  store i32 %mul16, ptr %arrayidx17, align 4
  ret void
}

define void @negpowof2mul_uniform(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, ptr noalias nocapture readonly %c){
; CHECK-LABEL: @negpowof2mul_uniform(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr [[B:%.*]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, ptr [[C:%.*]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <4 x i32> [[TMP3]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = mul <4 x i32> [[TMP4]], <i32 -2, i32 -2, i32 -2, i32 -2>
; CHECK-NEXT:    store <4 x i32> [[TMP5]], ptr [[A:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, ptr %b, align 4
  %1 = load i32, ptr %c, align 4
  %add = add nsw i32 %1, %0
  %mul = mul i32 %add, -2
  store i32 %mul, ptr %a, align 4
  %arrayidx3 = getelementptr inbounds i32, ptr %b, i64 1
  %2 = load i32, ptr %arrayidx3, align 4
  %arrayidx4 = getelementptr inbounds i32, ptr %c, i64 1
  %3 = load i32, ptr %arrayidx4, align 4
  %add5 = add nsw i32 %3, %2
  %mul6 = mul i32 %add5, -2
  %arrayidx7 = getelementptr inbounds i32, ptr %a, i64 1
  store i32 %mul6, ptr %arrayidx7, align 4
  %arrayidx8 = getelementptr inbounds i32, ptr %b, i64 2
  %4 = load i32, ptr %arrayidx8, align 4
  %arrayidx9 = getelementptr inbounds i32, ptr %c, i64 2
  %5 = load i32, ptr %arrayidx9, align 4
  %add10 = add nsw i32 %5, %4
  %mul11 = mul i32 %add10, -2
  %arrayidx12 = getelementptr inbounds i32, ptr %a, i64 2
  store i32 %mul11, ptr %arrayidx12, align 4
  %arrayidx13 = getelementptr inbounds i32, ptr %b, i64 3
  %6 = load i32, ptr %arrayidx13, align 4
  %arrayidx14 = getelementptr inbounds i32, ptr %c, i64 3
  %7 = load i32, ptr %arrayidx14, align 4
  %add15 = add nsw i32 %7, %6
  %mul16 = mul i32 %add15, -2
  %arrayidx17 = getelementptr inbounds i32, ptr %a, i64 3
  store i32 %mul16, ptr %arrayidx17, align 4
  ret void
}

define void @powof2mul_nonuniform(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, ptr noalias nocapture readonly %c){
; CHECK-LABEL: @powof2mul_nonuniform(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr [[B:%.*]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, ptr [[C:%.*]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <4 x i32> [[TMP3]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = mul <4 x i32> [[TMP4]], <i32 2, i32 4, i32 8, i32 16>
; CHECK-NEXT:    store <4 x i32> [[TMP5]], ptr [[A:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, ptr %b, align 4
  %1 = load i32, ptr %c, align 4
  %add = add nsw i32 %1, %0
  %mul = mul i32 %add, 2
  store i32 %mul, ptr %a, align 4
  %arrayidx3 = getelementptr inbounds i32, ptr %b, i64 1
  %2 = load i32, ptr %arrayidx3, align 4
  %arrayidx4 = getelementptr inbounds i32, ptr %c, i64 1
  %3 = load i32, ptr %arrayidx4, align 4
  %add5 = add nsw i32 %3, %2
  %mul6 = mul i32 %add5, 4
  %arrayidx7 = getelementptr inbounds i32, ptr %a, i64 1
  store i32 %mul6, ptr %arrayidx7, align 4
  %arrayidx8 = getelementptr inbounds i32, ptr %b, i64 2
  %4 = load i32, ptr %arrayidx8, align 4
  %arrayidx9 = getelementptr inbounds i32, ptr %c, i64 2
  %5 = load i32, ptr %arrayidx9, align 4
  %add10 = add nsw i32 %5, %4
  %mul11 = mul i32 %add10, 8
  %arrayidx12 = getelementptr inbounds i32, ptr %a, i64 2
  store i32 %mul11, ptr %arrayidx12, align 4
  %arrayidx13 = getelementptr inbounds i32, ptr %b, i64 3
  %6 = load i32, ptr %arrayidx13, align 4
  %arrayidx14 = getelementptr inbounds i32, ptr %c, i64 3
  %7 = load i32, ptr %arrayidx14, align 4
  %add15 = add nsw i32 %7, %6
  %mul16 = mul i32 %add15, 16
  %arrayidx17 = getelementptr inbounds i32, ptr %a, i64 3
  store i32 %mul16, ptr %arrayidx17, align 4
  ret void
}

define void @negpowof2mul_nonuniform(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, ptr noalias nocapture readonly %c){
; CHECK-LABEL: @negpowof2mul_nonuniform(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr [[B:%.*]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, ptr [[C:%.*]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <4 x i32> [[TMP3]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = mul <4 x i32> [[TMP4]], <i32 -2, i32 -4, i32 -8, i32 -16>
; CHECK-NEXT:    store <4 x i32> [[TMP5]], ptr [[A:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, ptr %b, align 4
  %1 = load i32, ptr %c, align 4
  %add = add nsw i32 %1, %0
  %mul = mul i32 %add, -2
  store i32 %mul, ptr %a, align 4
  %arrayidx3 = getelementptr inbounds i32, ptr %b, i64 1
  %2 = load i32, ptr %arrayidx3, align 4
  %arrayidx4 = getelementptr inbounds i32, ptr %c, i64 1
  %3 = load i32, ptr %arrayidx4, align 4
  %add5 = add nsw i32 %3, %2
  %mul6 = mul i32 %add5, -4
  %arrayidx7 = getelementptr inbounds i32, ptr %a, i64 1
  store i32 %mul6, ptr %arrayidx7, align 4
  %arrayidx8 = getelementptr inbounds i32, ptr %b, i64 2
  %4 = load i32, ptr %arrayidx8, align 4
  %arrayidx9 = getelementptr inbounds i32, ptr %c, i64 2
  %5 = load i32, ptr %arrayidx9, align 4
  %add10 = add nsw i32 %5, %4
  %mul11 = mul i32 %add10, -8
  %arrayidx12 = getelementptr inbounds i32, ptr %a, i64 2
  store i32 %mul11, ptr %arrayidx12, align 4
  %arrayidx13 = getelementptr inbounds i32, ptr %b, i64 3
  %6 = load i32, ptr %arrayidx13, align 4
  %arrayidx14 = getelementptr inbounds i32, ptr %c, i64 3
  %7 = load i32, ptr %arrayidx14, align 4
  %add15 = add nsw i32 %7, %6
  %mul16 = mul i32 %add15, -16
  %arrayidx17 = getelementptr inbounds i32, ptr %a, i64 3
  store i32 %mul16, ptr %arrayidx17, align 4
  ret void
}

define void @PR51436(ptr nocapture %a) {
; SSE-LABEL: @PR51436(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[GEP2:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 2
; SSE-NEXT:    [[GEP4:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 4
; SSE-NEXT:    [[GEP6:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 6
; SSE-NEXT:    [[TMP1:%.*]] = load <2 x i64>, ptr [[A]], align 8
; SSE-NEXT:    [[TMP2:%.*]] = mul <2 x i64> [[TMP1]], <i64 -17592186044416, i64 -17592186044416>
; SSE-NEXT:    [[TMP3:%.*]] = add <2 x i64> [[TMP2]], <i64 -17592186044416, i64 -17592186044416>
; SSE-NEXT:    store <2 x i64> [[TMP3]], ptr [[A]], align 8
; SSE-NEXT:    [[TMP6:%.*]] = load <2 x i64>, ptr [[GEP2]], align 8
; SSE-NEXT:    [[TMP7:%.*]] = mul <2 x i64> [[TMP6]], <i64 -17592186044416, i64 -17592186044416>
; SSE-NEXT:    [[TMP8:%.*]] = add <2 x i64> [[TMP7]], <i64 -17592186044416, i64 -17592186044416>
; SSE-NEXT:    store <2 x i64> [[TMP8]], ptr [[GEP2]], align 8
; SSE-NEXT:    [[TMP11:%.*]] = load <2 x i64>, ptr [[GEP4]], align 8
; SSE-NEXT:    [[TMP12:%.*]] = mul <2 x i64> [[TMP11]], <i64 -17592186044416, i64 -17592186044416>
; SSE-NEXT:    [[TMP13:%.*]] = add <2 x i64> [[TMP12]], <i64 -17592186044416, i64 -17592186044416>
; SSE-NEXT:    store <2 x i64> [[TMP13]], ptr [[GEP4]], align 8
; SSE-NEXT:    [[TMP16:%.*]] = load <2 x i64>, ptr [[GEP6]], align 8
; SSE-NEXT:    [[TMP17:%.*]] = mul <2 x i64> [[TMP16]], <i64 -17592186044416, i64 -17592186044416>
; SSE-NEXT:    [[TMP18:%.*]] = add <2 x i64> [[TMP17]], <i64 -17592186044416, i64 -17592186044416>
; SSE-NEXT:    store <2 x i64> [[TMP18]], ptr [[GEP6]], align 8
; SSE-NEXT:    ret void
;
; AVX-LABEL: @PR51436(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[GEP4:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 4
; AVX-NEXT:    [[TMP1:%.*]] = load <4 x i64>, ptr [[A]], align 8
; AVX-NEXT:    [[TMP2:%.*]] = mul <4 x i64> [[TMP1]], <i64 -17592186044416, i64 -17592186044416, i64 -17592186044416, i64 -17592186044416>
; AVX-NEXT:    [[TMP3:%.*]] = add <4 x i64> [[TMP2]], <i64 -17592186044416, i64 -17592186044416, i64 -17592186044416, i64 -17592186044416>
; AVX-NEXT:    store <4 x i64> [[TMP3]], ptr [[A]], align 8
; AVX-NEXT:    [[TMP6:%.*]] = load <4 x i64>, ptr [[GEP4]], align 8
; AVX-NEXT:    [[TMP7:%.*]] = mul <4 x i64> [[TMP6]], <i64 -17592186044416, i64 -17592186044416, i64 -17592186044416, i64 -17592186044416>
; AVX-NEXT:    [[TMP8:%.*]] = add <4 x i64> [[TMP7]], <i64 -17592186044416, i64 -17592186044416, i64 -17592186044416, i64 -17592186044416>
; AVX-NEXT:    store <4 x i64> [[TMP8]], ptr [[GEP4]], align 8
; AVX-NEXT:    ret void
;
entry:
  %gep1 = getelementptr inbounds i64, ptr %a, i64 1
  %gep2 = getelementptr inbounds i64, ptr %a, i64 2
  %gep3 = getelementptr inbounds i64, ptr %a, i64 3
  %gep4 = getelementptr inbounds i64, ptr %a, i64 4
  %gep5 = getelementptr inbounds i64, ptr %a, i64 5
  %gep6 = getelementptr inbounds i64, ptr %a, i64 6
  %gep7 = getelementptr inbounds i64, ptr %a, i64 7
  %load0 = load i64, ptr %a, align 8
  %load1 = load i64, ptr %gep1, align 8
  %load2 = load i64, ptr %gep2, align 8
  %load3 = load i64, ptr %gep3, align 8
  %load4 = load i64, ptr %gep4, align 8
  %load5 = load i64, ptr %gep5, align 8
  %load6 = load i64, ptr %gep6, align 8
  %load7 = load i64, ptr %gep7, align 8
  %mul0 = mul i64 %load0, -17592186044416
  %mul1 = mul i64 %load1, -17592186044416
  %mul2 = mul i64 %load2, -17592186044416
  %mul3 = mul i64 %load3, -17592186044416
  %mul4 = mul i64 %load4, -17592186044416
  %mul5 = mul i64 %load5, -17592186044416
  %mul6 = mul i64 %load6, -17592186044416
  %mul7 = mul i64 %load7, -17592186044416
  %add0 = add i64 %mul0, -17592186044416
  %add1 = add i64 %mul1, -17592186044416
  %add2 = add i64 %mul2, -17592186044416
  %add3 = add i64 %mul3, -17592186044416
  %add4 = add i64 %mul4, -17592186044416
  %add5 = add i64 %mul5, -17592186044416
  %add6 = add i64 %mul6, -17592186044416
  %add7 = add i64 %mul7, -17592186044416
  store i64 %add0, ptr %a, align 8
  store i64 %add1, ptr %gep1, align 8
  store i64 %add2, ptr %gep2, align 8
  store i64 %add3, ptr %gep3, align 8
  store i64 %add4, ptr %gep4, align 8
  store i64 %add5, ptr %gep5, align 8
  store i64 %add6, ptr %gep6, align 8
  store i64 %add7, ptr %gep7, align 8
  ret void
}