// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 %s -emit-llvm -o - -triple x86_64-unknown-unknown | FileCheck %s

#include <stdarg.h>

struct S { float a[3]; };
struct S a[5];

// CHECK-LABEL: @check(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[RETVAL:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[Z_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[ARG:%.*]] = alloca [[STRUCT_S:%.*]], align 4
// CHECK-NEXT:    [[P:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[AP:%.*]] = alloca [1 x %struct.__va_list_tag], align 16
// CHECK-NEXT:    [[J:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[K:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[TMP:%.*]] = alloca [[STRUCT_S]], align 4
// CHECK-NEXT:    store i32 [[Z:%.*]], ptr [[Z_ADDR]], align 4
// CHECK-NEXT:    store i32 0, ptr [[J]], align 4
// CHECK-NEXT:    store i32 0, ptr [[K]], align 4
// CHECK-NEXT:    [[ARRAYDECAY:%.*]] = getelementptr inbounds [1 x %struct.__va_list_tag], ptr [[AP]], i64 0, i64 0
// CHECK-NEXT:    call void @llvm.va_start.p0(ptr [[ARRAYDECAY]])
// CHECK-NEXT:    store ptr getelementptr inbounds ([5 x %struct.S], ptr @a, i64 0, i64 2), ptr [[P]], align 8
// CHECK-NEXT:    [[ARRAYDECAY1:%.*]] = getelementptr inbounds [1 x %struct.__va_list_tag], ptr [[AP]], i64 0, i64 0
// CHECK-NEXT:    [[FP_OFFSET_P:%.*]] = getelementptr inbounds nuw [[STRUCT___VA_LIST_TAG:%.*]], ptr [[ARRAYDECAY1]], i32 0, i32 1
// CHECK-NEXT:    [[FP_OFFSET:%.*]] = load i32, ptr [[FP_OFFSET_P]], align 4
// CHECK-NEXT:    [[FITS_IN_FP:%.*]] = icmp ule i32 [[FP_OFFSET]], 144
// CHECK-NEXT:    br i1 [[FITS_IN_FP]], label [[VAARG_IN_REG:%.*]], label [[VAARG_IN_MEM:%.*]]
// CHECK:       vaarg.in_reg:
// CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds nuw [[STRUCT___VA_LIST_TAG]], ptr [[ARRAYDECAY1]], i32 0, i32 3
// CHECK-NEXT:    [[REG_SAVE_AREA:%.*]] = load ptr, ptr [[TMP0]], align 16
// CHECK-NEXT:    [[TMP1:%.*]] = getelementptr i8, ptr [[REG_SAVE_AREA]], i32 [[FP_OFFSET]]
// CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[TMP1]], i64 16
// CHECK-NEXT:    [[TMP3:%.*]] = load <2 x float>, ptr [[TMP1]], align 16
// CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds nuw { <2 x float>, float }, ptr [[TMP]], i32 0, i32 0
// CHECK-NEXT:    store <2 x float> [[TMP3]], ptr [[TMP4]], align 4
// CHECK-NEXT:    [[TMP5:%.*]] = load float, ptr [[TMP2]], align 16
// CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds nuw { <2 x float>, float }, ptr [[TMP]], i32 0, i32 1
// CHECK-NEXT:    store float [[TMP5]], ptr [[TMP6]], align 4
// CHECK-NEXT:    [[TMP7:%.*]] = add i32 [[FP_OFFSET]], 32
// CHECK-NEXT:    store i32 [[TMP7]], ptr [[FP_OFFSET_P]], align 4
// CHECK-NEXT:    br label [[VAARG_END:%.*]]
// CHECK:       vaarg.in_mem:
// CHECK-NEXT:    [[OVERFLOW_ARG_AREA_P:%.*]] = getelementptr inbounds nuw [[STRUCT___VA_LIST_TAG]], ptr [[ARRAYDECAY1]], i32 0, i32 2
// CHECK-NEXT:    [[OVERFLOW_ARG_AREA:%.*]] = load ptr, ptr [[OVERFLOW_ARG_AREA_P]], align 8
// CHECK-NEXT:    [[OVERFLOW_ARG_AREA_NEXT:%.*]] = getelementptr i8, ptr [[OVERFLOW_ARG_AREA]], i32 16
// CHECK-NEXT:    store ptr [[OVERFLOW_ARG_AREA_NEXT]], ptr [[OVERFLOW_ARG_AREA_P]], align 8
// CHECK-NEXT:    br label [[VAARG_END]]
// CHECK:       vaarg.end:
// CHECK-NEXT:    [[VAARG_ADDR:%.*]] = phi ptr [ [[TMP]], [[VAARG_IN_REG]] ], [ [[OVERFLOW_ARG_AREA]], [[VAARG_IN_MEM]] ]
// CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 4 [[ARG]], ptr align 4 [[VAARG_ADDR]], i64 12, i1 false)
// CHECK-NEXT:    [[ARRAYDECAY2:%.*]] = getelementptr inbounds [1 x %struct.__va_list_tag], ptr [[AP]], i64 0, i64 0
// CHECK-NEXT:    call void @llvm.va_end.p0(ptr [[ARRAYDECAY2]])
// CHECK-NEXT:    [[TMP8:%.*]] = load ptr, ptr [[P]], align 8
// CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne ptr [[TMP8]], null
// CHECK-NEXT:    br i1 [[TOBOOL]], label [[LAND_LHS_TRUE:%.*]], label [[IF_END:%.*]]
// CHECK:       land.lhs.true:
// CHECK-NEXT:    [[TMP9:%.*]] = load ptr, ptr [[P]], align 8
// CHECK-NEXT:    [[A:%.*]] = getelementptr inbounds nuw [[STRUCT_S]], ptr [[TMP9]], i32 0, i32 0
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [3 x float], ptr [[A]], i64 0, i64 2
// CHECK-NEXT:    [[TMP10:%.*]] = load float, ptr [[ARRAYIDX]], align 4
// CHECK-NEXT:    [[A3:%.*]] = getelementptr inbounds nuw [[STRUCT_S]], ptr [[ARG]], i32 0, i32 0
// CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds [3 x float], ptr [[A3]], i64 0, i64 2
// CHECK-NEXT:    [[TMP11:%.*]] = load float, ptr [[ARRAYIDX4]], align 4
// CHECK-NEXT:    [[CMP:%.*]] = fcmp une float [[TMP10]], [[TMP11]]
// CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END]]
// CHECK:       if.then:
// CHECK-NEXT:    store i32 0, ptr [[RETVAL]], align 4
// CHECK-NEXT:    br label [[RETURN:%.*]]
// CHECK:       if.end:
// CHECK-NEXT:    store i32 1, ptr [[RETVAL]], align 4
// CHECK-NEXT:    br label [[RETURN]]
// CHECK:       return:
// CHECK-NEXT:    [[TMP12:%.*]] = load i32, ptr [[RETVAL]], align 4
// CHECK-NEXT:    ret i32 [[TMP12]]
//
int check (int z, ...)
{
  struct S arg, *p;
  va_list ap;
  int j = 0, k = 0;
  int i;
  va_start (ap, z);
  p = &a[2];
  arg = va_arg (ap, struct S);
  va_end (ap);
  if (p && p->a[2] != arg.a[2])
    return 0;
  return 1;
}
