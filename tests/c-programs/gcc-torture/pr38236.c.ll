; ModuleID = './pr38236.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.X = type { i32 }

; Function Attrs: noinline nounwind uwtable
define i32 @foo(%struct.X* %p, i32* %q, i32 %a, i32 %b) #0 {
  %1 = alloca %struct.X*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %x = alloca %struct.X, align 4
  %y = alloca %struct.X, align 4
  store %struct.X* %p, %struct.X** %1, align 8
  store i32* %q, i32** %2, align 8
  store i32 %a, i32* %3, align 4
  store i32 %b, i32* %4, align 4
  %5 = load i32, i32* %3, align 4
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %7, label %8

; <label>:7                                       ; preds = %0
  store %struct.X* %x, %struct.X** %1, align 8
  br label %8

; <label>:8                                       ; preds = %7, %0
  %9 = load i32, i32* %4, align 4
  %10 = icmp ne i32 %9, 0
  br i1 %10, label %11, label %13

; <label>:11                                      ; preds = %8
  %12 = getelementptr inbounds %struct.X, %struct.X* %x, i32 0, i32 0
  store i32* %12, i32** %2, align 8
  br label %15

; <label>:13                                      ; preds = %8
  %14 = getelementptr inbounds %struct.X, %struct.X* %y, i32 0, i32 0
  store i32* %14, i32** %2, align 8
  br label %15

; <label>:15                                      ; preds = %13, %11
  %16 = load i32*, i32** %2, align 8
  store i32 1, i32* %16, align 4
  %17 = load %struct.X*, %struct.X** %1, align 8
  %18 = getelementptr inbounds %struct.X, %struct.X* %17, i32 0, i32 0
  %19 = load i32, i32* %18, align 4
  ret i32 %19
}

; Function Attrs: nounwind uwtable
define i32 @main() #1 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1
  %2 = call i32 @foo(%struct.X* null, i32* null, i32 1, i32 1)
  %3 = icmp ne i32 %2, 1
  br i1 %3, label %4, label %5

; <label>:4                                       ; preds = %0
  call void @abort() #3
  unreachable

; <label>:5                                       ; preds = %0
  ret i32 0
}

; Function Attrs: noreturn nounwind
declare void @abort() #2

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noreturn nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind }

!llvm.ident = !{!0}

!0 = !{!"Ubuntu clang version 3.7.1-svn253571-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"}
