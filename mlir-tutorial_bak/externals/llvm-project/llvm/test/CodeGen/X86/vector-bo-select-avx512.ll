; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512f          | FileCheck %s --check-prefixes=AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512f,avx512vl | FileCheck %s --check-prefixes=AVX512,AVX512VL

define dso_local <8 x i64> @select_sub(<8 x i64> %src, <8 x i64> %a, <8 x i64> %b, ptr %ptr) {
; AVX512-LABEL: select_sub:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovdqa64 64(%rdi), %zmm3
; AVX512-NEXT:    vptestnmq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm3, %k1
; AVX512-NEXT:    vpsubq %zmm2, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i64>, ptr %ptr, i64 1
  %0 = load <8 x i64>, ptr %arrayidx, align 64
  %and1 = and <8 x i64> %0, <i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248>
  %not = icmp ne <8 x i64> %and1, zeroinitializer
  %sub = sub <8 x i64> %a, %b
  %1 = select <8 x i1> %not, <8 x i64> %src, <8 x i64> %sub
  ret <8 x i64> %1
}

define dso_local <8 x i64> @select_add(<8 x i64> %src, <8 x i64> %a, <8 x i64> %b, ptr %ptr) {
; AVX512-LABEL: select_add:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovdqa64 64(%rdi), %zmm3
; AVX512-NEXT:    vptestnmq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm3, %k1
; AVX512-NEXT:    vpaddq %zmm2, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i64>, ptr %ptr, i64 1
  %0 = load <8 x i64>, ptr %arrayidx, align 64
  %and1 = and <8 x i64> %0, <i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248>
  %not = icmp ne <8 x i64> %and1, zeroinitializer
  %add = add <8 x i64> %a, %b
  %1 = select <8 x i1> %not, <8 x i64> %src, <8 x i64> %add
  ret <8 x i64> %1
}

define dso_local <8 x i64> @select_and(<8 x i64> %src, <8 x i64> %a, <8 x i64> %b, ptr %ptr) {
; AVX512-LABEL: select_and:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovdqa64 64(%rdi), %zmm3
; AVX512-NEXT:    vptestnmq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm3, %k1
; AVX512-NEXT:    vpandq %zmm2, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i64>, ptr %ptr, i64 1
  %0 = load <8 x i64>, ptr %arrayidx, align 64
  %and1 = and <8 x i64> %0, <i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248>
  %not = icmp ne <8 x i64> %and1, zeroinitializer
  %and = and <8 x i64> %a, %b
  %1 = select <8 x i1> %not, <8 x i64> %src, <8 x i64> %and
  ret <8 x i64> %1
}

define dso_local <8 x i64> @select_xor(<8 x i64> %src, <8 x i64> %a, <8 x i64> %b, ptr %ptr) {
; AVX512-LABEL: select_xor:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovdqa64 64(%rdi), %zmm3
; AVX512-NEXT:    vptestnmq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm3, %k1
; AVX512-NEXT:    vpxorq %zmm2, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i64>, ptr %ptr, i64 1
  %0 = load <8 x i64>, ptr %arrayidx, align 64
  %and1 = and <8 x i64> %0, <i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248>
  %not = icmp ne <8 x i64> %and1, zeroinitializer
  %xor = xor <8 x i64> %a, %b
  %1 = select <8 x i1> %not, <8 x i64> %src, <8 x i64> %xor
  ret <8 x i64> %1
}

define dso_local <8 x i64> @select_shl(<8 x i64> %src, <8 x i64> %a, <8 x i64> %b, ptr %ptr) {
; AVX512-LABEL: select_shl:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovdqa64 64(%rdi), %zmm3
; AVX512-NEXT:    vptestnmq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm3, %k1
; AVX512-NEXT:    vpsllvq %zmm2, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i64>, ptr %ptr, i64 1
  %0 = load <8 x i64>, ptr %arrayidx, align 64
  %and1 = and <8 x i64> %0, <i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248>
  %not = icmp ne <8 x i64> %and1, zeroinitializer
  %shl = shl <8 x i64> %a, %b
  %1 = select <8 x i1> %not, <8 x i64> %src, <8 x i64> %shl
  ret <8 x i64> %1
}

define dso_local <8 x i64> @select_srl(<8 x i64> %src, <8 x i64> %a, <8 x i64> %b, ptr %ptr) {
; AVX512-LABEL: select_srl:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovdqa64 64(%rdi), %zmm3
; AVX512-NEXT:    vptestnmq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm3, %k1
; AVX512-NEXT:    vpsrlvq %zmm2, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i64>, ptr %ptr, i64 1
  %0 = load <8 x i64>, ptr %arrayidx, align 64
  %and1 = and <8 x i64> %0, <i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248>
  %not = icmp ne <8 x i64> %and1, zeroinitializer
  %srl = lshr <8 x i64> %a, %b
  %1 = select <8 x i1> %not, <8 x i64> %src, <8 x i64> %srl
  ret <8 x i64> %1
}

define dso_local <8 x i64> @select_sra(<8 x i64> %src, <8 x i64> %a, <8 x i64> %b, ptr %ptr) {
; AVX512-LABEL: select_sra:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovdqa64 64(%rdi), %zmm3
; AVX512-NEXT:    vptestnmq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm3, %k1
; AVX512-NEXT:    vpsravq %zmm2, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i64>, ptr %ptr, i64 1
  %0 = load <8 x i64>, ptr %arrayidx, align 64
  %and1 = and <8 x i64> %0, <i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248, i64 2251799813685248>
  %not = icmp ne <8 x i64> %and1, zeroinitializer
  %sra = ashr <8 x i64> %a, %b
  %1 = select <8 x i1> %not, <8 x i64> %src, <8 x i64> %sra
  ret <8 x i64> %1
}

define dso_local <8 x i32> @select_mul(<8 x i32> %src, <8 x i32> %a, <8 x i32> %b, ptr %ptr) {
; AVX512F-LABEL: select_mul:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512F-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm3, %k1
; AVX512F-NEXT:    vpmulld %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vmovdqa32 %zmm1, %zmm0 {%k1}
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: select_mul:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512VL-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %ymm3, %k1
; AVX512VL-NEXT:    vpmulld %ymm2, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i32>, ptr %ptr, i32 1
  %0 = load <8 x i32>, ptr %arrayidx, align 64
  %and1 = and <8 x i32> %0, <i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517>
  %not = icmp ne <8 x i32> %and1, zeroinitializer
  %mul = mul <8 x i32> %a, %b
  %1 = select <8 x i1> %not, <8 x i32> %src, <8 x i32> %mul
  ret <8 x i32> %1
}

define dso_local <8 x i32> @select_smax(<8 x i32> %src, <8 x i32> %a, <8 x i32> %b, ptr %ptr) {
; AVX512F-LABEL: select_smax:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512F-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm3, %k1
; AVX512F-NEXT:    vpmaxsd %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vmovdqa32 %zmm1, %zmm0 {%k1}
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: select_smax:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512VL-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %ymm3, %k1
; AVX512VL-NEXT:    vpmaxsd %ymm2, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i32>, ptr %ptr, i32 1
  %0 = load <8 x i32>, ptr %arrayidx, align 64
  %and1 = and <8 x i32> %0, <i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517>
  %not = icmp ne <8 x i32> %and1, zeroinitializer
  %smax = call <8 x i32> @llvm.smax.v4i32(<8 x i32> %a, <8 x i32> %b)
  %1 = select <8 x i1> %not, <8 x i32> %src, <8 x i32> %smax
  ret <8 x i32> %1
}
declare <8 x i32> @llvm.smax.v4i32(<8 x i32> %a, <8 x i32> %b)

define dso_local <8 x i32> @select_smin(<8 x i32> %src, <8 x i32> %a, <8 x i32> %b, ptr %ptr) {
; AVX512F-LABEL: select_smin:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512F-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm3, %k1
; AVX512F-NEXT:    vpminsd %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vmovdqa32 %zmm1, %zmm0 {%k1}
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: select_smin:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512VL-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %ymm3, %k1
; AVX512VL-NEXT:    vpminsd %ymm2, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i32>, ptr %ptr, i32 1
  %0 = load <8 x i32>, ptr %arrayidx, align 64
  %and1 = and <8 x i32> %0, <i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517>
  %not = icmp ne <8 x i32> %and1, zeroinitializer
  %smin = call <8 x i32> @llvm.smin.v4i32(<8 x i32> %a, <8 x i32> %b)
  %1 = select <8 x i1> %not, <8 x i32> %src, <8 x i32> %smin
  ret <8 x i32> %1
}
declare <8 x i32> @llvm.smin.v4i32(<8 x i32> %a, <8 x i32> %b)

define dso_local <8 x i32> @select_umax(<8 x i32> %src, <8 x i32> %a, <8 x i32> %b, ptr %ptr) {
; AVX512F-LABEL: select_umax:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512F-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm3, %k1
; AVX512F-NEXT:    vpmaxud %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vmovdqa32 %zmm1, %zmm0 {%k1}
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: select_umax:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512VL-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %ymm3, %k1
; AVX512VL-NEXT:    vpmaxud %ymm2, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i32>, ptr %ptr, i32 1
  %0 = load <8 x i32>, ptr %arrayidx, align 64
  %and1 = and <8 x i32> %0, <i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517>
  %not = icmp ne <8 x i32> %and1, zeroinitializer
  %umax = call <8 x i32> @llvm.umax.v4i32(<8 x i32> %a, <8 x i32> %b)
  %1 = select <8 x i1> %not, <8 x i32> %src, <8 x i32> %umax
  ret <8 x i32> %1
}
declare <8 x i32> @llvm.umax.v4i32(<8 x i32> %a, <8 x i32> %b)

define dso_local <8 x i32> @select_umin(<8 x i32> %src, <8 x i32> %a, <8 x i32> %b, ptr %ptr) {
; AVX512F-LABEL: select_umin:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512F-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm3, %k1
; AVX512F-NEXT:    vpminud %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vmovdqa32 %zmm1, %zmm0 {%k1}
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: select_umin:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %ymm3
; AVX512VL-NEXT:    vptestnmd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %ymm3, %k1
; AVX512VL-NEXT:    vpminud %ymm2, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
entry:
  %arrayidx = getelementptr inbounds <8 x i32>, ptr %ptr, i32 1
  %0 = load <8 x i32>, ptr %arrayidx, align 64
  %and1 = and <8 x i32> %0, <i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517, i32 22517>
  %not = icmp ne <8 x i32> %and1, zeroinitializer
  %umin = call <8 x i32> @llvm.umin.v4i32(<8 x i32> %a, <8 x i32> %b)
  %1 = select <8 x i1> %not, <8 x i32> %src, <8 x i32> %umin
  ret <8 x i32> %1
}
declare <8 x i32> @llvm.umin.v4i32(<8 x i32> %a, <8 x i32> %b)