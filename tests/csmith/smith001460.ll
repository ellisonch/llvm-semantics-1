; ModuleID = '/home/grosu/celliso2/c-semantics/tests/csmith/smith001460.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

@g_4 = global i32* null, align 8
@g_6 = global [3 x [3 x i32]] [[3 x i32] [i32 -6, i32 -6, i32 -6], [3 x i32] [i32 -6, i32 -6, i32 -6], [3 x i32] [i32 -6, i32 -6, i32 -6]], align 16
@.str = private unnamed_addr constant [25 x i8] c"checksum g_6[0][0] = %d\0A\00", align 1
@.str1 = private unnamed_addr constant [25 x i8] c"checksum g_6[0][1] = %d\0A\00", align 1
@.str2 = private unnamed_addr constant [25 x i8] c"checksum g_6[0][2] = %d\0A\00", align 1
@.str3 = private unnamed_addr constant [25 x i8] c"checksum g_6[1][0] = %d\0A\00", align 1
@.str4 = private unnamed_addr constant [25 x i8] c"checksum g_6[1][1] = %d\0A\00", align 1
@.str5 = private unnamed_addr constant [25 x i8] c"checksum g_6[1][2] = %d\0A\00", align 1
@.str6 = private unnamed_addr constant [25 x i8] c"checksum g_6[2][0] = %d\0A\00", align 1
@.str7 = private unnamed_addr constant [25 x i8] c"checksum g_6[2][1] = %d\0A\00", align 1
@.str8 = private unnamed_addr constant [25 x i8] c"checksum g_6[2][2] = %d\0A\00", align 1
@__undefined = common global i64 0, align 8

define i64 @func_1() nounwind uwtable {
entry:
  %l_2 = alloca i8, align 1
  %l_3 = alloca i32*, align 8
  %l_5 = alloca i32*, align 8
  store i8 116, i8* %l_2, align 1
  store i32* null, i32** %l_3, align 8
  store i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 0, i64 1), i32** %l_5, align 8
  %tmp = load i8* %l_2, align 1
  %conv = sext i8 %tmp to i32
  %tmp1 = load i32** %l_5, align 8
  %tmp2 = load i32* %tmp1
  %and = and i32 %tmp2, %conv
  store i32 %and, i32* %tmp1
  %tmp3 = load i32** %l_5, align 8
  %tmp4 = load i32* %tmp3
  %conv5 = sext i32 %tmp4 to i64
  %conv6 = trunc i64 %conv5 to i32
  store i32 %conv6, i32* %tmp3
  %tmp7 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 0, i64 1), align 4
  %conv8 = sext i32 %tmp7 to i64
  ret i64 %conv8
}

define i32 @main(i32 %argc, i8** %argv) nounwind uwtable {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %call = call i64 @func_1()
  %tmp = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 0, i64 0), align 4
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str, i32 0, i32 0), i32 %tmp)
  %tmp2 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 0, i64 1), align 4
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str1, i32 0, i32 0), i32 %tmp2)
  %tmp4 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 0, i64 2), align 4
  %call5 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str2, i32 0, i32 0), i32 %tmp4)
  %tmp6 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 1, i64 0), align 4
  %call7 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str3, i32 0, i32 0), i32 %tmp6)
  %tmp8 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 1, i64 1), align 4
  %call9 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str4, i32 0, i32 0), i32 %tmp8)
  %tmp10 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 1, i64 2), align 4
  %call11 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str5, i32 0, i32 0), i32 %tmp10)
  %tmp12 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 2, i64 0), align 4
  %call13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str6, i32 0, i32 0), i32 %tmp12)
  %tmp14 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 2, i64 1), align 4
  %call15 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str7, i32 0, i32 0), i32 %tmp14)
  %tmp16 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 2, i64 2), align 4
  %call17 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str8, i32 0, i32 0), i32 %tmp16)
  %tmp18 = load i32* getelementptr inbounds ([3 x [3 x i32]]* @g_6, i32 0, i64 0, i64 1), align 4
  %call19 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str1, i32 0, i32 0), i32 %tmp18)
  %0 = load i32* %retval
  ret i32 %0
}

declare i32 @printf(i8*, ...)