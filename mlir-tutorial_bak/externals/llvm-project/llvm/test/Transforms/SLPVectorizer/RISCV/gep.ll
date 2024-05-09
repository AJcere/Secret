; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer -mtriple=riscv64 -mattr=+v \
; RUN: -riscv-v-slp-max-vf=0 -S | FileCheck %s

; This should not be vectorized, as the cost of computing the offsets nullifies
; the benefits of vectorizing:
;
; copy_with_offset_v2i8:
;         addi    a0, a0, 8
;         vsetivli        zero, 2, e8, mf8, ta, ma
;         vle8.v  v8, (a0)
;         addi    a1, a1, 16
;         vse8.v  v8, (a1)
;         ret
;
; Compared to the scalar version where the offsets can be folded into the
; addressing mode:
;
; copy_with_offset_v2i8:
;         lbu     a2, 8(a0)
;         lbu     a0, 9(a0)
;         sb      a2, 16(a1)
;         sb      a0, 17(a1)
;	  ret

define void @copy_with_offset_v2i8(ptr noalias %p, ptr noalias %q) {
; CHECK-LABEL: @copy_with_offset_v2i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P1:%.*]] = getelementptr i8, ptr [[P:%.*]], i32 8
; CHECK-NEXT:    [[X1:%.*]] = load i8, ptr [[P1]], align 1
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i8, ptr [[Q:%.*]], i32 16
; CHECK-NEXT:    store i8 [[X1]], ptr [[Q1]], align 1
; CHECK-NEXT:    [[P2:%.*]] = getelementptr i8, ptr [[P]], i32 9
; CHECK-NEXT:    [[X2:%.*]] = load i8, ptr [[P2]], align 1
; CHECK-NEXT:    [[Q2:%.*]] = getelementptr i8, ptr [[Q]], i32 17
; CHECK-NEXT:    store i8 [[X2]], ptr [[Q2]], align 1
; CHECK-NEXT:    ret void
;
entry:
  %p1 = getelementptr i8, ptr %p, i32 8
  %x1 = load i8, ptr %p1
  %q1 = getelementptr i8, ptr %q, i32 16
  store i8 %x1, ptr %q1

  %p2 = getelementptr i8, ptr %p, i32 9
  %x2 = load i8, ptr %p2
  %q2 = getelementptr i8, ptr %q, i32 17
  store i8 %x2, ptr %q2

  ret void
}

; This on the other hand, should be vectorized as the vector savings outweigh
; the GEP costs.
define void @copy_with_offset_v4i8(ptr noalias %p, ptr noalias %q) {
; CHECK-LABEL: @copy_with_offset_v4i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P1:%.*]] = getelementptr i8, ptr [[P:%.*]], i32 8
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i8, ptr [[Q:%.*]], i32 16
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x i8>, ptr [[P1]], align 1
; CHECK-NEXT:    store <4 x i8> [[TMP0]], ptr [[Q1]], align 1
; CHECK-NEXT:    ret void
;
entry:
  %p1 = getelementptr i8, ptr %p, i32 8
  %x1 = load i8, ptr %p1
  %q1 = getelementptr i8, ptr %q, i32 16
  store i8 %x1, ptr %q1

  %p2 = getelementptr i8, ptr %p, i32 9
  %x2 = load i8, ptr %p2
  %q2 = getelementptr i8, ptr %q, i32 17
  store i8 %x2, ptr %q2

  %p3 = getelementptr i8, ptr %p, i32 10
  %x3 = load i8, ptr %p3
  %q3 = getelementptr i8, ptr %q, i32 18
  store i8 %x3, ptr %q3

  %p4 = getelementptr i8, ptr %p, i32 11
  %x4 = load i8, ptr %p4
  %q4 = getelementptr i8, ptr %q, i32 19
  store i8 %x4, ptr %q4

  ret void
}