; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; We used to generate a mul+mflo sequence instead of shifting by 2/3 to get the jump table address
; RUN: llc %s -O2 -mtriple=mips64-unknown-freebsd -target-abi n64 -relocation-model=pic -o - | FileCheck %s

define i64 @test(i64 %arg) {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui $1, %hi(%neg(%gp_rel(test)))
; CHECK-NEXT:    daddu $2, $1, $25
; CHECK-NEXT:    sltiu $1, $4, 11
; CHECK-NEXT:    beqz $1, .LBB0_4
; CHECK-NEXT:    nop
; CHECK-NEXT:  .LBB0_1: # %entry
; CHECK-NEXT:    daddiu $1, $2, %lo(%neg(%gp_rel(test)))
; CHECK-NEXT:    dsll $2, $4, 3
; CHECK-NEXT:    ld $3, %got_page(.LJTI0_0)($1)
; CHECK-NEXT:    daddu $2, $2, $3
; CHECK-NEXT:    ld $2, %got_ofst(.LJTI0_0)($2)
; CHECK-NEXT:    daddu $1, $2, $1
; CHECK-NEXT:    jr $1
; CHECK-NEXT:    nop
; CHECK-NEXT:  .LBB0_2: # %sw.bb
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    daddiu $2, $zero, 1
; CHECK-NEXT:  .LBB0_3: # %sw.bb1
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    daddiu $2, $zero, 0
; CHECK-NEXT:  .LBB0_4: # %default
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    daddiu $2, $zero, 1234
; Previously this dsll was the following sequence:
;	daddiu	$2, $zero, 8
;	dmult	$4, $2
;	mflo	$2
entry:
  switch i64 %arg, label %default [
    i64 0, label %sw.bb
    i64 3, label %sw.bb
    i64 5, label %sw.bb
    i64 10, label %sw.bb1
  ]

default:
  ret i64 1234

sw.bb:
  ret i64 1

sw.bb1:
  ret i64 0
}

; CHECK-LABEL: 	.section	.rodata,"a",@progbits
; CHECK-NEXT: 	.p2align	3
; CHECK-LABEL: .LJTI0_0:
; CHECK-NEXT: 	.gpdword	.LBB0_2
; CHECK-NEXT: 	.gpdword	.LBB0_4
; CHECK-NEXT: 	.gpdword	.LBB0_4
; CHECK-NEXT: 	.gpdword	.LBB0_2
; CHECK-NEXT: 	.gpdword	.LBB0_4
; CHECK-NEXT: 	.gpdword	.LBB0_2
; CHECK-NEXT: 	.gpdword	.LBB0_4
; CHECK-NEXT: 	.gpdword	.LBB0_4
; CHECK-NEXT: 	.gpdword	.LBB0_4
; CHECK-NEXT: 	.gpdword	.LBB0_4
; CHECK-NEXT: 	.gpdword	.LBB0_3