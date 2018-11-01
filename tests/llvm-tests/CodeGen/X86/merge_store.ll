; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

define void @merge_store(i32* nocapture %a) {
; CHECK-LABEL: merge_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movabsq $4294967297, %rcx # imm = 0x100000001
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rcx, (%rdi,%rax,4)
; CHECK-NEXT:    movq %rcx, 8(%rdi,%rax,4)
; CHECK-NEXT:    addq $4, %rax
; CHECK-NEXT:    cmpl $1000, %eax # imm = 0x3E8
; CHECK-NEXT:    jl .LBB0_1
; CHECK-NEXT:  # %bb.2: # %for.end
; CHECK-NEXT:    retq
entry:
  br label %for.body

  for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  store i32 1, i32* %arrayidx, align 4
  %0 = or i64 %indvars.iv, 1
  %arrayidx2 = getelementptr inbounds i32, i32* %a, i64 %0
  store i32 1, i32* %arrayidx2, align 4
  %1 = or i64 %indvars.iv, 2
  %arrayidx5 = getelementptr inbounds i32, i32* %a, i64 %1
  store i32 1, i32* %arrayidx5, align 4
  %2 = or i64 %indvars.iv, 3
  %arrayidx8 = getelementptr inbounds i32, i32* %a, i64 %2
  store i32 1, i32* %arrayidx8, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 4
  %3 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp slt i32 %3, 1000
  br i1 %cmp, label %for.body, label %for.end

  for.end:
  ret void
}

define void @indexed_store_merge(i64 %p, i8* %v) {
; CHECK-LABEL: indexed_store_merge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $0, 2(%rsi,%rdi)
; CHECK-NEXT:    movb $0, (%rsi)
; CHECK-NEXT:    retq
entry:
  %p2 = add nsw i64 %p, 2
  %v2 = getelementptr i8, i8* %v, i64 %p2
  store i8 0, i8* %v2, align 2
  %p3 = add nsw i64 %p, 3
  %v3 = getelementptr i8, i8* %v, i64 %p3
  store i8 0, i8* %v3, align 1
  %p4 = add nsw i64 %p, 4
  %v4 = getelementptr i8, i8* %v, i64 %p4
  store i8 0, i8* %v4, align 2
  %p5 = add nsw i64 %p, 5
  %v5 = getelementptr i8, i8* %v, i64 %p5
  store i8 0, i8* %v5, align 1
  %v0 = getelementptr i8, i8* %v, i64 0
  store i8 0, i8* %v0, align 2
  ret void
}