; ModuleID = '/home/grosu/celliso2/c-semantics/tests/gcc-torture/960117-1.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%0 = type { i16, %union.T_VALS }
%struct.T_VAL = type <{ i16, %union.T_VALS }>
%union.T_VALS = type <{ i8* }>

@curval = global %0 zeroinitializer, align 2
@idc = internal global i16 0, align 2
@id_space = internal global [2 x [33 x i8]] zeroinitializer, align 16
@cur_line = internal global i32 0, align 4
@char_pos = internal global i32 0, align 4

define i32 @gnu_dev_major(i64 %__dev) nounwind uwtable inlinehint {
entry:
  %__dev.addr = alloca i64, align 8
  store i64 %__dev, i64* %__dev.addr, align 8
  %tmp = load i64* %__dev.addr, align 8
  %shr = lshr i64 %tmp, 8
  %and = and i64 %shr, 4095
  %tmp1 = load i64* %__dev.addr, align 8
  %shr2 = lshr i64 %tmp1, 32
  %conv = trunc i64 %shr2 to i32
  %and3 = and i32 %conv, -4096
  %conv4 = zext i32 %and3 to i64
  %or = or i64 %and, %conv4
  %conv5 = trunc i64 %or to i32
  ret i32 %conv5
}

define i32 @gnu_dev_minor(i64 %__dev) nounwind uwtable inlinehint {
entry:
  %__dev.addr = alloca i64, align 8
  store i64 %__dev, i64* %__dev.addr, align 8
  %tmp = load i64* %__dev.addr, align 8
  %and = and i64 %tmp, 255
  %tmp1 = load i64* %__dev.addr, align 8
  %shr = lshr i64 %tmp1, 12
  %conv = trunc i64 %shr to i32
  %and2 = and i32 %conv, -256
  %conv3 = zext i32 %and2 to i64
  %or = or i64 %and, %conv3
  %conv4 = trunc i64 %or to i32
  ret i32 %conv4
}

define i64 @gnu_dev_makedev(i32 %__major, i32 %__minor) nounwind uwtable inlinehint {
entry:
  %__major.addr = alloca i32, align 4
  %__minor.addr = alloca i32, align 4
  store i32 %__major, i32* %__major.addr, align 4
  store i32 %__minor, i32* %__minor.addr, align 4
  %tmp = load i32* %__minor.addr, align 4
  %and = and i32 %tmp, 255
  %tmp1 = load i32* %__major.addr, align 4
  %and2 = and i32 %tmp1, 4095
  %shl = shl i32 %and2, 8
  %or = or i32 %and, %shl
  %conv = zext i32 %or to i64
  %tmp3 = load i32* %__minor.addr, align 4
  %and4 = and i32 %tmp3, -256
  %conv5 = zext i32 %and4 to i64
  %shl6 = shl i64 %conv5, 12
  %or7 = or i64 %conv, %shl6
  %tmp8 = load i32* %__major.addr, align 4
  %and9 = and i32 %tmp8, -4096
  %conv10 = zext i32 %and9 to i64
  %shl11 = shl i64 %conv10, 32
  %or12 = or i64 %or7, %shl11
  ret i64 %or12
}

define zeroext i16 @get_id(i8 signext %c) nounwind uwtable {
entry:
  %c.addr = alloca i8, align 1
  store i8 %c, i8* %c.addr, align 1
  %tmp = load i8* %c.addr, align 1
  %tmp1 = load i8** getelementptr inbounds (%struct.T_VAL* bitcast (%0* @curval to %struct.T_VAL*), i32 0, i32 1, i32 0), align 2
  %arrayidx = getelementptr inbounds i8* %tmp1, i64 0
  store i8 %tmp, i8* %arrayidx
  ret i16 0
}

define zeroext i16 @get_tok() nounwind uwtable {
entry:
  %c = alloca i8, align 1
  store i8 99, i8* %c, align 1
  %tmp = load i16* @idc, align 2
  %idxprom = sext i16 %tmp to i64
  %arrayidx = getelementptr inbounds [2 x [33 x i8]]* @id_space, i32 0, i64 %idxprom
  %arraydecay = getelementptr inbounds [33 x i8]* %arrayidx, i32 0, i32 0
  store i8* %arraydecay, i8** getelementptr inbounds (%struct.T_VAL* bitcast (%0* @curval to %struct.T_VAL*), i32 0, i32 1, i32 0), align 2
  %tmp1 = load i32* @cur_line, align 4
  %shl = shl i32 %tmp1, 10
  %tmp2 = load i32* @char_pos, align 4
  %or = or i32 %shl, %tmp2
  %conv = trunc i32 %or to i16
  store i16 %conv, i16* getelementptr inbounds (%struct.T_VAL* bitcast (%0* @curval to %struct.T_VAL*), i32 0, i32 0), align 2
  %tmp3 = load i8* %c, align 1
  %call = call zeroext i16 @get_id(i8 signext %tmp3)
  ret i16 %call
}

define i32 @main() nounwind uwtable {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval
  %call = call zeroext i16 @get_tok()
  call void @exit(i32 0) noreturn nounwind
  unreachable

return:                                           ; No predecessors!
  %0 = load i32* %retval
  ret i32 %0
}

declare void @exit(i32) noreturn nounwind