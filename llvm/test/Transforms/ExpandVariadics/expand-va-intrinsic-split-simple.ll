; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: -p --function-signature
; RUN: opt -mtriple=wasm32-unknown-unknown -S --passes=expand-variadics --expand-variadics-override=optimize < %s | FileCheck %s --check-prefixes=OPT
; RUN: opt -mtriple=wasm32-unknown-unknown -S --passes=expand-variadics --expand-variadics-override=lowering < %s | FileCheck %s --check-prefixes=ABI
; REQUIRES: webassembly-registered-target

; Examples are variadic functions that return the first or the second of an int and a double
; Split the functions into an internal equivalent that takes a va_list and a ABI preserving wrapper

define i32 @variadic_int_double_get_firstz(...) {
; OPT-LABEL: define {{[^@]+}}@variadic_int_double_get_firstz(...) {
; OPT-NEXT:  entry:
; OPT-NEXT:    %va_start = alloca ptr, align 4
; OPT-NEXT:    call void @llvm.lifetime.start.p0(i64 4, ptr %va_start)
; OPT-NEXT:    call void @llvm.va_start.p0(ptr %va_start)
; OPT-NEXT:    %0 = load ptr, ptr %va_start, align 4
; OPT-NEXT:    %1 = call i32 @variadic_int_double_get_firstz.valist(ptr %0)
; OPT-NEXT:    call void @llvm.lifetime.end.p0(i64 4, ptr %va_start)
; OPT-NEXT:    ret i32 %1
;
; ABI-LABEL: define {{[^@]+}}@variadic_int_double_get_firstz(ptr %varargs) {
; ABI-NEXT:  entry:
; ABI-NEXT:    %va = alloca ptr, align 4
; ABI-NEXT:    store ptr %varargs, ptr %va, align 4
; ABI-NEXT:    %argp.cur = load ptr, ptr %va, align 4
; ABI-NEXT:    %argp.next = getelementptr inbounds i8, ptr %argp.cur, i32 4
; ABI-NEXT:    store ptr %argp.next, ptr %va, align 4
; ABI-NEXT:    %0 = load i32, ptr %argp.cur, align 4
; ABI-NEXT:    ret i32 %0
;
entry:
  %va = alloca ptr, align 4
  call void @llvm.va_start.p0(ptr nonnull %va)
  %argp.cur = load ptr, ptr %va, align 4
  %argp.next = getelementptr inbounds i8, ptr %argp.cur, i32 4
  store ptr %argp.next, ptr %va, align 4
  %0 = load i32, ptr %argp.cur, align 4
  call void @llvm.va_end.p0(ptr %va)
  ret i32 %0
}

; CHECK-LABEL: define i32 @variadic_int_double_get_firstz(...) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %va_list = alloca ptr, align 4
; CHECK-NEXT:    call void @llvm.va_start.p0(ptr %va_list)
; CHECK-NEXT:    %0 = tail call i32 @variadic_int_double_get_firstz.valist(ptr %va_list)
; CHECK-NEXT:    ret i32 %0
; CHECK-NEXT:  }

; CHECK-LABEL: define internal i32 @variadic_int_double_get_firstz.valist(ptr noalias %varargs) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:   %va = alloca ptr, align 4
; CHECK-NEXT:   store ptr %varargs, ptr %va, align 4
; CHECK-NEXT:   %argp.cur = load ptr, ptr %va, align 4
; CHECK-NEXT:   %argp.next = getelementptr inbounds i8, ptr %argp.cur, i32 4
; CHECK-NEXT:   store ptr %argp.next, ptr %va, align 4
; CHECK-NEXT:   %0 = load i32, ptr %argp.cur, align 4
; CHECK-NEXT:   ret i32 %0
; CHECK-NEXT:  }

define double @variadic_int_double_get_secondz(...) {
; OPT-LABEL: define {{[^@]+}}@variadic_int_double_get_secondz(...) {
; OPT-NEXT:  entry:
; OPT-NEXT:    %va_start = alloca ptr, align 4
; OPT-NEXT:    call void @llvm.lifetime.start.p0(i64 4, ptr %va_start)
; OPT-NEXT:    call void @llvm.va_start.p0(ptr %va_start)
; OPT-NEXT:    %0 = load ptr, ptr %va_start, align 4
; OPT-NEXT:    %1 = call double @variadic_int_double_get_secondz.valist(ptr %0)
; OPT-NEXT:    call void @llvm.lifetime.end.p0(i64 4, ptr %va_start)
; OPT-NEXT:    ret double %1
;
; ABI-LABEL: define {{[^@]+}}@variadic_int_double_get_secondz(ptr %varargs) {
; ABI-NEXT:  entry:
; ABI-NEXT:    %va = alloca ptr, align 4
; ABI-NEXT:    store ptr %varargs, ptr %va, align 4
; ABI-NEXT:    %argp.cur = load ptr, ptr %va, align 4
; ABI-NEXT:    %argp.next = getelementptr inbounds i8, ptr %argp.cur, i32 4
; ABI-NEXT:    %argp.next2 = getelementptr inbounds i8, ptr %argp.cur, i32 12
; ABI-NEXT:    store ptr %argp.next2, ptr %va, align 4
; ABI-NEXT:    %0 = load double, ptr %argp.next, align 4
; ABI-NEXT:    ret double %0
;
entry:
  %va = alloca ptr, align 4
  call void @llvm.va_start.p0(ptr nonnull %va)
  %argp.cur = load ptr, ptr %va, align 4
  %argp.next = getelementptr inbounds i8, ptr %argp.cur, i32 4
  %argp.next2 = getelementptr inbounds i8, ptr %argp.cur, i32 12
  store ptr %argp.next2, ptr %va, align 4
  %0 = load double, ptr %argp.next, align 4
  call void @llvm.va_end.p0(ptr %va)
  ret double %0
}

; CHECK-LABEL: define double @variadic_int_double_get_secondz(...) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %va_list = alloca ptr, align 4
; CHECK-NEXT:    call void @llvm.va_start.p0(ptr %va_list)
; CHECK-NEXT:    %0 = tail call double @variadic_int_double_get_secondz.valist(ptr %va_list)
; CHECK-NEXT:    ret double %0
; CHECK-NEXT:  }

; CHECK-LABEL: define internal double @variadic_int_double_get_secondz.valist(ptr noalias %varargs) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %va = alloca ptr, align 4
; CHECK-NEXT:    store ptr %varargs, ptr %va, align 4
; CHECK-NEXT:    %argp.cur = load ptr, ptr %va, align 4
; CHECK-NEXT:    %argp.next = getelementptr inbounds i8, ptr %argp.cur, i32 4
; CHECK-NEXT:    %argp.next2 = getelementptr inbounds i8, ptr %argp.cur, i32 12
; CHECK-NEXT:    store ptr %argp.next2, ptr %va, align 4
; CHECK-NEXT:    %0 = load double, ptr %argp.next, align 4
; CHECK-NEXT:    ret double %0
; CHECK-NEXT:  }


; CHECK-LABEL: @variadic_can_get_firstIidEEbT_T0_(i32 %x, double %y) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %vararg_buffer = alloca %variadic_can_get_firstIidEEbT_T0_.vararg, align 16
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 12, ptr %vararg_buffer)
; CHECK-NEXT:    %0 = getelementptr inbounds %variadic_can_get_firstIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 0
; CHECK-NEXT:    store i32 %x, ptr %0, align 4
; CHECK-NEXT:    %1 = getelementptr inbounds %variadic_can_get_firstIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 1
; CHECK-NEXT:    store double %y, ptr %1, align 4
; CHECK-NEXT:    %call = call i32 @variadic_int_double_get_firstz.valist(ptr %vararg_buffer)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 12, ptr %vararg_buffer)
; CHECK-NEXT:    %cmp.i = icmp eq i32 %call, %x
; CHECK-NEXT:    ret i1 %cmp.i
; CHECK-NEXT:  }

define zeroext i1 @variadic_can_get_firstIidEEbT_T0_(i32 %x, double %y) {
; OPT-LABEL: define {{[^@]+}}@variadic_can_get_firstIidEEbT_T0_(i32 %x, double %y) {
; OPT-NEXT:  entry:
; OPT-NEXT:    %vararg_buffer = alloca %variadic_can_get_firstIidEEbT_T0_.vararg, align 16
; OPT-NEXT:    call void @llvm.lifetime.start.p0(i64 16, ptr %vararg_buffer)
; OPT-NEXT:    %0 = getelementptr inbounds nuw %variadic_can_get_firstIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 0
; OPT-NEXT:    store i32 %x, ptr %0, align 4
; OPT-NEXT:    %1 = getelementptr inbounds nuw %variadic_can_get_firstIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 2
; OPT-NEXT:    store double %y, ptr %1, align 8
; OPT-NEXT:    %call = call i32 @variadic_int_double_get_firstz.valist(ptr %vararg_buffer)
; OPT-NEXT:    call void @llvm.lifetime.end.p0(i64 16, ptr %vararg_buffer)
; OPT-NEXT:    %cmp.i = icmp eq i32 %call, %x
; OPT-NEXT:    ret i1 %cmp.i
;
; ABI-LABEL: define {{[^@]+}}@variadic_can_get_firstIidEEbT_T0_(i32 %x, double %y) {
; ABI-NEXT:  entry:
; ABI-NEXT:    %vararg_buffer = alloca %variadic_can_get_firstIidEEbT_T0_.vararg, align 16
; ABI-NEXT:    call void @llvm.lifetime.start.p0(i64 16, ptr %vararg_buffer)
; ABI-NEXT:    %0 = getelementptr inbounds nuw %variadic_can_get_firstIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 0
; ABI-NEXT:    store i32 %x, ptr %0, align 4
; ABI-NEXT:    %1 = getelementptr inbounds nuw %variadic_can_get_firstIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 2
; ABI-NEXT:    store double %y, ptr %1, align 8
; ABI-NEXT:    %call = call i32 @variadic_int_double_get_firstz(ptr %vararg_buffer)
; ABI-NEXT:    call void @llvm.lifetime.end.p0(i64 16, ptr %vararg_buffer)
; ABI-NEXT:    %cmp.i = icmp eq i32 %call, %x
; ABI-NEXT:    ret i1 %cmp.i
;
entry:
  %call = call i32 (...) @variadic_int_double_get_firstz(i32 %x, double %y)
  %cmp.i = icmp eq i32 %call, %x
  ret i1 %cmp.i
}

; CHECK-LABEL: @variadic_can_get_secondIidEEbT_T0_(i32 %x, double %y) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %vararg_buffer = alloca %variadic_can_get_secondIidEEbT_T0_.vararg, align 16
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 12, ptr %vararg_buffer)
; CHECK-NEXT:    %0 = getelementptr inbounds %variadic_can_get_secondIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 0
; CHECK-NEXT:    store i32 %x, ptr %0, align 4
; CHECK-NEXT:    %1 = getelementptr inbounds %variadic_can_get_secondIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 1
; CHECK-NEXT:    store double %y, ptr %1, align 4
; CHECK-NEXT:    %call = call double @variadic_int_double_get_secondz.valist(ptr %vararg_buffer)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 12, ptr %vararg_buffer)
; CHECK-NEXT:    %cmp.i = fcmp oeq double %call, %y
; CHECK-NEXT:    ret i1 %cmp.i
; CHECK-NEXT:  }

define zeroext i1 @variadic_can_get_secondIidEEbT_T0_(i32 %x, double %y) {
; OPT-LABEL: define {{[^@]+}}@variadic_can_get_secondIidEEbT_T0_(i32 %x, double %y) {
; OPT-NEXT:  entry:
; OPT-NEXT:    %vararg_buffer = alloca %variadic_can_get_secondIidEEbT_T0_.vararg, align 16
; OPT-NEXT:    call void @llvm.lifetime.start.p0(i64 16, ptr %vararg_buffer)
; OPT-NEXT:    %0 = getelementptr inbounds nuw %variadic_can_get_secondIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 0
; OPT-NEXT:    store i32 %x, ptr %0, align 4
; OPT-NEXT:    %1 = getelementptr inbounds nuw %variadic_can_get_secondIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 2
; OPT-NEXT:    store double %y, ptr %1, align 8
; OPT-NEXT:    %call = call double @variadic_int_double_get_secondz.valist(ptr %vararg_buffer)
; OPT-NEXT:    call void @llvm.lifetime.end.p0(i64 16, ptr %vararg_buffer)
; OPT-NEXT:    %cmp.i = fcmp oeq double %call, %y
; OPT-NEXT:    ret i1 %cmp.i
;
; ABI-LABEL: define {{[^@]+}}@variadic_can_get_secondIidEEbT_T0_(i32 %x, double %y) {
; ABI-NEXT:  entry:
; ABI-NEXT:    %vararg_buffer = alloca %variadic_can_get_secondIidEEbT_T0_.vararg, align 16
; ABI-NEXT:    call void @llvm.lifetime.start.p0(i64 16, ptr %vararg_buffer)
; ABI-NEXT:    %0 = getelementptr inbounds nuw %variadic_can_get_secondIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 0
; ABI-NEXT:    store i32 %x, ptr %0, align 4
; ABI-NEXT:    %1 = getelementptr inbounds nuw %variadic_can_get_secondIidEEbT_T0_.vararg, ptr %vararg_buffer, i32 0, i32 2
; ABI-NEXT:    store double %y, ptr %1, align 8
; ABI-NEXT:    %call = call double @variadic_int_double_get_secondz(ptr %vararg_buffer)
; ABI-NEXT:    call void @llvm.lifetime.end.p0(i64 16, ptr %vararg_buffer)
; ABI-NEXT:    %cmp.i = fcmp oeq double %call, %y
; ABI-NEXT:    ret i1 %cmp.i
;
entry:
  %call = call double (...) @variadic_int_double_get_secondz(i32 %x, double %y)
  %cmp.i = fcmp oeq double %call, %y
  ret i1 %cmp.i
}

; Declaration unchanged
; CHECK: declare void @variadic_without_callers(...)
declare void @variadic_without_callers(...)

declare void @llvm.va_start.p0(ptr)
declare void @llvm.va_end.p0(ptr)
