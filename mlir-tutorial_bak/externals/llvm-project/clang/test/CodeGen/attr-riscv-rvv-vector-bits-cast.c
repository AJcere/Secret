// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple riscv64-none-linux-gnu -target-feature +f -target-feature +d -target-feature +zve64d -mvscale-min=4 -mvscale-max=4 -S -O1 -emit-llvm -o - %s | FileCheck %s

// REQUIRES: riscv-registered-target

#include <stdint.h>

typedef __rvv_int8m1_t vint8m1_t;
typedef __rvv_uint8m1_t vuint8m1_t;
typedef __rvv_int16m1_t vint16m1_t;
typedef __rvv_uint16m1_t vuint16m1_t;
typedef __rvv_int32m1_t vint32m1_t;
typedef __rvv_uint32m1_t vuint32m1_t;
typedef __rvv_int64m1_t vint64m1_t;
typedef __rvv_uint64m1_t vuint64m1_t;
typedef __rvv_float32m1_t vfloat32m1_t;
typedef __rvv_float64m1_t vfloat64m1_t;

typedef vint64m1_t fixed_int64m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vfloat64m1_t fixed_float64m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));

typedef vint32m1_t fixed_int32m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef vfloat64m1_t fixed_float64m1_t __attribute__((riscv_rvv_vector_bits(__riscv_v_fixed_vlen)));
typedef int32_t gnu_int32m1_t __attribute__((vector_size(__riscv_v_fixed_vlen / 8)));

// CHECK-LABEL: @to_vint32m1_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    ret <vscale x 2 x i32> [[TYPE_COERCE:%.*]]
//
vint32m1_t to_vint32m1_t(fixed_int32m1_t type) {
  return type;
}

// CHECK-LABEL: @from_vint32m1_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    ret <vscale x 2 x i32> [[TYPE:%.*]]
//
fixed_int32m1_t from_vint32m1_t(vint32m1_t type) {
  return type;
}

// CHECK-LABEL: @to_vfloat64m1_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    ret <vscale x 1 x double> [[TYPE_COERCE:%.*]]
//
vfloat64m1_t to_vfloat64m1_t(fixed_float64m1_t type) {
  return type;
}

// CHECK-LABEL: @from_vfloat64m1_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    ret <vscale x 1 x double> [[TYPE:%.*]]
//
fixed_float64m1_t from_vfloat64m1_t(vfloat64m1_t type) {
  return type;
}

// CHECK-LABEL: @to_vint32m1_t__from_gnu_int32m1_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE:%.*]] = load <8 x i32>, ptr [[TMP0:%.*]], align 32, !tbaa [[TBAA4:![0-9]+]]
// CHECK-NEXT:    [[CAST_SCALABLE:%.*]] = tail call <vscale x 2 x i32> @llvm.vector.insert.nxv2i32.v8i32(<vscale x 2 x i32> undef, <8 x i32> [[TYPE]], i64 0)
// CHECK-NEXT:    ret <vscale x 2 x i32> [[CAST_SCALABLE]]
//
vint32m1_t to_vint32m1_t__from_gnu_int32m1_t(gnu_int32m1_t type) {
  return type;
}

// CHECK-LABEL: @from_vint32m1_t__to_gnu_int32m1_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[CAST_FIXED:%.*]] = tail call <8 x i32> @llvm.vector.extract.v8i32.nxv2i32(<vscale x 2 x i32> [[TYPE:%.*]], i64 0)
// CHECK-NEXT:    store <8 x i32> [[CAST_FIXED]], ptr [[AGG_RESULT:%.*]], align 32, !tbaa [[TBAA4]]
// CHECK-NEXT:    ret void
//
gnu_int32m1_t from_vint32m1_t__to_gnu_int32m1_t(vint32m1_t type) {
  return type;
}

// CHECK-LABEL: @to_fixed_int32m1_t__from_gnu_int32m1_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE:%.*]] = load <8 x i32>, ptr [[TMP0:%.*]], align 32, !tbaa [[TBAA4]]
// CHECK-NEXT:    [[CAST_SCALABLE:%.*]] = tail call <vscale x 2 x i32> @llvm.vector.insert.nxv2i32.v8i32(<vscale x 2 x i32> undef, <8 x i32> [[TYPE]], i64 0)
// CHECK-NEXT:    ret <vscale x 2 x i32> [[CAST_SCALABLE]]
//
fixed_int32m1_t to_fixed_int32m1_t__from_gnu_int32m1_t(gnu_int32m1_t type) {
  return type;
}

// CHECK-LABEL: @from_fixed_int32m1_t__to_gnu_int32m1_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE:%.*]] = tail call <8 x i32> @llvm.vector.extract.v8i32.nxv2i32(<vscale x 2 x i32> [[TYPE_COERCE:%.*]], i64 0)
// CHECK-NEXT:    store <8 x i32> [[TYPE]], ptr [[AGG_RESULT:%.*]], align 32, !tbaa [[TBAA4]]
// CHECK-NEXT:    ret void
//
gnu_int32m1_t from_fixed_int32m1_t__to_gnu_int32m1_t(fixed_int32m1_t type) {
  return type;
}