; ModuleID = '/home/david/src/c-semantics/tests/integration/sumn.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"10\00", align 1
@.str1 = private unnamed_addr constant [13 x i8] c"sum(%d)==%d\0A\00", align 1

define i32 @main(i32 %argc, i8** %argv) nounwind uwtable {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %input = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %call = call i32 @atoi(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0)) nounwind readonly
  store i32 %call, i32* %input, align 4
  %0 = load i32* %input, align 4
  %call1 = call i32 @sum(i32 %0)
  store i32 %call1, i32* %result, align 4
  %1 = load i32* %input, align 4
  %2 = load i32* %result, align 4
  %call2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str1, i32 0, i32 0), i32 %1, i32 %2)
  %3 = load i32* %result, align 4
  ret i32 %3
}

declare i32 @atoi(i8*) nounwind readonly

define i32 @sum(i32 %n) nounwind uwtable {
entry:
  %n.addr = alloca i32, align 4
  %sum = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %sum, align 4
  store i32 1, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %n.addr, align 4
  %cmp = icmp sle i32 %0, %1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %i, align 4
  %3 = load i32* %sum, align 4
  %add = add nsw i32 %3, %2
  store i32 %add, i32* %sum, align 4
  %4 = load i32* %i, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, i32* %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %5 = load i32* %sum, align 4
  ret i32 %5
}

declare i32 @printf(i8*, ...)