; ModuleID = './931004-7.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.tiny = type { i8 }

; Function Attrs: nounwind uwtable
define void @f(i32 %n, i8 %x.coerce, i8 %y.coerce, i8 %z.coerce, i64 %l) #0 {
  %x = alloca %struct.tiny, align 1
  %y = alloca %struct.tiny, align 1
  %z = alloca %struct.tiny, align 1
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = getelementptr %struct.tiny, %struct.tiny* %x, i32 0, i32 0
  store i8 %x.coerce, i8* %3, align 1
  %4 = getelementptr %struct.tiny, %struct.tiny* %y, i32 0, i32 0
  store i8 %y.coerce, i8* %4, align 1
  %5 = getelementptr %struct.tiny, %struct.tiny* %z, i32 0, i32 0
  store i8 %z.coerce, i8* %5, align 1
  store i32 %n, i32* %1, align 4
  store i64 %l, i64* %2, align 8
  %6 = getelementptr inbounds %struct.tiny, %struct.tiny* %x, i32 0, i32 0
  %7 = load i8, i8* %6, align 1
  %8 = sext i8 %7 to i32
  %9 = icmp ne i32 %8, 10
  br i1 %9, label %10, label %11

; <label>:10                                      ; preds = %0
  call void @abort() #2
  unreachable

; <label>:11                                      ; preds = %0
  %12 = getelementptr inbounds %struct.tiny, %struct.tiny* %y, i32 0, i32 0
  %13 = load i8, i8* %12, align 1
  %14 = sext i8 %13 to i32
  %15 = icmp ne i32 %14, 11
  br i1 %15, label %16, label %17

; <label>:16                                      ; preds = %11
  call void @abort() #2
  unreachable

; <label>:17                                      ; preds = %11
  %18 = getelementptr inbounds %struct.tiny, %struct.tiny* %z, i32 0, i32 0
  %19 = load i8, i8* %18, align 1
  %20 = sext i8 %19 to i32
  %21 = icmp ne i32 %20, 12
  br i1 %21, label %22, label %23

; <label>:22                                      ; preds = %17
  call void @abort() #2
  unreachable

; <label>:23                                      ; preds = %17
  %24 = load i64, i64* %2, align 8
  %25 = icmp ne i64 %24, 123
  br i1 %25, label %26, label %27

; <label>:26                                      ; preds = %23
  call void @abort() #2
  unreachable

; <label>:27                                      ; preds = %23
  ret void
}

; Function Attrs: noreturn nounwind
declare void @abort() #1

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %x = alloca [3 x %struct.tiny], align 1
  store i32 0, i32* %1
  %2 = getelementptr inbounds [3 x %struct.tiny], [3 x %struct.tiny]* %x, i32 0, i64 0
  %3 = getelementptr inbounds %struct.tiny, %struct.tiny* %2, i32 0, i32 0
  store i8 10, i8* %3, align 1
  %4 = getelementptr inbounds [3 x %struct.tiny], [3 x %struct.tiny]* %x, i32 0, i64 1
  %5 = getelementptr inbounds %struct.tiny, %struct.tiny* %4, i32 0, i32 0
  store i8 11, i8* %5, align 1
  %6 = getelementptr inbounds [3 x %struct.tiny], [3 x %struct.tiny]* %x, i32 0, i64 2
  %7 = getelementptr inbounds %struct.tiny, %struct.tiny* %6, i32 0, i32 0
  store i8 12, i8* %7, align 1
  %8 = getelementptr inbounds [3 x %struct.tiny], [3 x %struct.tiny]* %x, i32 0, i64 0
  %9 = getelementptr inbounds [3 x %struct.tiny], [3 x %struct.tiny]* %x, i32 0, i64 1
  %10 = getelementptr inbounds [3 x %struct.tiny], [3 x %struct.tiny]* %x, i32 0, i64 2
  %11 = getelementptr %struct.tiny, %struct.tiny* %8, i32 0, i32 0
  %12 = load i8, i8* %11, align 1
  %13 = getelementptr %struct.tiny, %struct.tiny* %9, i32 0, i32 0
  %14 = load i8, i8* %13, align 1
  %15 = getelementptr %struct.tiny, %struct.tiny* %10, i32 0, i32 0
  %16 = load i8, i8* %15, align 1
  call void @f(i32 3, i8 %12, i8 %14, i8 %16, i64 123)
  call void @exit(i32 0) #2
  unreachable
                                                  ; No predecessors!
  %18 = load i32, i32* %1
  ret i32 %18
}

; Function Attrs: noreturn nounwind
declare void @exit(i32) #1

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noreturn nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noreturn nounwind }

!llvm.ident = !{!0}

!0 = !{!"Ubuntu clang version 3.7.1-svn253571-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"}
