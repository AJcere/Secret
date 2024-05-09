; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

; This is a specialization of generic folds for min/max values targeted to the
; 'null' ptr constant.
; Related tests for non-pointer types should be included in another file.

; There are 6 basic patterns (or 3 with DeMorganized equivalent) with
;    2 (commute logic op) *
;    2 (swap compare operands) *
; variations for a total of 24 tests.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X == null) && (X > Y) --> false
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ugt_and_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_and_min(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ugt ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_and_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_and_min_commute(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ugt ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ugt_swap_and_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_swap_and_min(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ult ptr %y, %x
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_swap_and_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_swap_and_min_commute(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ult ptr %y, %x
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sgt_and_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @sgt_and_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq ptr [[X]], null
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sgt ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X != null) || (X <= Y) --> true
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ule_or_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_or_not_min(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ule ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_or_not_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_or_not_min_commute(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ule ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ule_swap_or_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_swap_or_not_min(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp uge ptr %y, %x
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_swap_or_not_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_swap_or_not_min_commute(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp uge ptr %y, %x
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sle_or_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @sle_or_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne ptr [[X]], null
; CHECK-NEXT:    [[R:%.*]] = or i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sle ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X == null) && (X <= Y) --> X == null
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ule_and_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_and_min(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq ptr [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ule ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_and_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_and_min_commute(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq ptr [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ule ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ule_swap_and_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_swap_and_min(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq ptr [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp uge ptr %y, %x
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_swap_and_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_swap_and_min_commute(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq ptr [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp uge ptr %y, %x
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sle_and_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @sle_and_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq ptr [[X]], null
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sle ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X == null) || (X <= Y) --> X <= Y
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ule_or_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_or_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ule ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_or_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_or_min_commute(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ule ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ule_swap_or_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_swap_or_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge ptr [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp uge ptr %y, %x
  %cmpeq = icmp eq ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_swap_or_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ule_swap_or_min_commute(
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge ptr [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp uge ptr %y, %x
  %cmpeq = icmp eq ptr %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sle_or_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @sle_or_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq ptr [[X]], null
; CHECK-NEXT:    [[R:%.*]] = or i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sle ptr %x, %y
  %cmpeq = icmp eq ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X != null) && (X > Y) --> X > Y
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ugt_and_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_and_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ugt ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_and_not_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_and_not_min_commute(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ugt ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ugt_swap_and_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_swap_and_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult ptr [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ult ptr %y, %x
  %cmpeq = icmp ne ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_swap_and_not_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_swap_and_not_min_commute(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult ptr [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ult ptr %y, %x
  %cmpeq = icmp ne ptr %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sgt_and_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @sgt_and_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne ptr [[X]], null
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sgt ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X != null) || (X > Y) --> X != null
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ugt_or_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_or_not_min(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne ptr [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ugt ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_or_not_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_or_not_min_commute(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne ptr [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ugt ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ugt_swap_or_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_swap_or_not_min(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne ptr [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ult ptr %y, %x
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_swap_or_not_min_commute(ptr %x, ptr %y)  {
; CHECK-LABEL: @ugt_swap_or_not_min_commute(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne ptr [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ult ptr %y, %x
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sgt_or_not_min(ptr %x, ptr %y)  {
; CHECK-LABEL: @sgt_or_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne ptr [[X]], null
; CHECK-NEXT:    [[R:%.*]] = or i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sgt ptr %x, %y
  %cmpeq = icmp ne ptr %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}