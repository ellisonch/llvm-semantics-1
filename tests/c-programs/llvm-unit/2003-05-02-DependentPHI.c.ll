; ModuleID = './2003-05-02-DependentPHI.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.List = type { %struct.List*, i32 }

@Node0 = global %struct.List { %struct.List* null, i32 5 }, align 8
@Node1 = global %struct.List { %struct.List* @Node0, i32 4 }, align 8
@Node2 = global %struct.List { %struct.List* @Node1, i32 3 }, align 8
@Node3 = global %struct.List { %struct.List* @Node2, i32 2 }, align 8
@Node4 = global %struct.List { %struct.List* @Node3, i32 1 }, align 8
@Node5 = global %struct.List { %struct.List* @Node4, i32 0 }, align 8
@.str = private unnamed_addr constant [7 x i8] c"%d %d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %PrevL = alloca %struct.List*, align 8
  %CurL = alloca %struct.List*, align 8
  store i32 0, i32* %1
  store %struct.List* null, %struct.List** %PrevL, align 8
  store %struct.List* @Node5, %struct.List** %CurL, align 8
  br label %2

; <label>:2                                       ; preds = %19, %0
  %3 = load %struct.List*, %struct.List** %CurL, align 8
  %4 = icmp ne %struct.List* %3, null
  br i1 %4, label %5, label %24

; <label>:5                                       ; preds = %2
  %6 = load %struct.List*, %struct.List** %CurL, align 8
  %7 = getelementptr inbounds %struct.List, %struct.List* %6, i32 0, i32 1
  %8 = load i32, i32* %7, align 4
  %9 = load %struct.List*, %struct.List** %PrevL, align 8
  %10 = icmp ne %struct.List* %9, null
  br i1 %10, label %11, label %15

; <label>:11                                      ; preds = %5
  %12 = load %struct.List*, %struct.List** %PrevL, align 8
  %13 = getelementptr inbounds %struct.List, %struct.List* %12, i32 0, i32 1
  %14 = load i32, i32* %13, align 4
  br label %16

; <label>:15                                      ; preds = %5
  br label %16

; <label>:16                                      ; preds = %15, %11
  %17 = phi i32 [ %14, %11 ], [ -1, %15 ]
  %18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i32 %8, i32 %17)
  br label %19

; <label>:19                                      ; preds = %16
  %20 = load %struct.List*, %struct.List** %CurL, align 8
  store %struct.List* %20, %struct.List** %PrevL, align 8
  %21 = load %struct.List*, %struct.List** %CurL, align 8
  %22 = getelementptr inbounds %struct.List, %struct.List* %21, i32 0, i32 0
  %23 = load %struct.List*, %struct.List** %22, align 8
  store %struct.List* %23, %struct.List** %CurL, align 8
  br label %2

; <label>:24                                      ; preds = %2
  ret i32 0
}

declare i32 @printf(i8*, ...) #1

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"Ubuntu clang version 3.7.1-svn253571-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"}
