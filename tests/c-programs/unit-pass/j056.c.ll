; ModuleID = './j056.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.anon = type { i32 }

@x = global i32 0, align 4
@p1 = global i32* null, align 8
@a = common global [5 x i32] zeroinitializer, align 16
@p2 = global i32* bitcast (i8* getelementptr (i8, i8* bitcast ([5 x i32]* @a to i8*), i64 8) to i32*), align 8
@s = common global %struct.anon zeroinitializer, align 4
@p3 = global i32* getelementptr inbounds (%struct.anon, %struct.anon* @s, i32 0, i32 0), align 8

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1
  %2 = load i32*, i32** @p2, align 8
  %3 = load i32, i32* %2, align 4
  ret i32 %3
}

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"Ubuntu clang version 3.7.1-svn253571-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"}
