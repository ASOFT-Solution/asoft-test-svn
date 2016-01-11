IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2437]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2437]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- Created by Bảo Anh	Date: 05/08/2013
--- Purpose: Tạo file chấm công cho dữ liệu thuế (Thuận Lợi)
--- EXEC HP2437 'AS',1,2012,'01/01/2012','01/08/2012','PDS','admin'

CREATE PROCEDURE [dbo].[HP2437]   	@DivisionID nvarchar(50),
									@TranMonth int,
									@TranYear int,
									@FromDate datetime, 
									@ToDate datetime,
									@DepartmentID nvarchar(50),
									@CreateUserID nvarchar(50)
				
AS
	DECLARE 	@curHT2406_IN cursor,
				@curHT2406_OUT cursor,
				@EmployeeID1 nvarchar(50),
				@AbsentDate datetime,
				@AbsentTime nvarchar(100),
				@InAbsentTime nvarchar(100),
				@BeginTime nvarchar(100),
				@EndTime nvarchar(100),
				@TargetData nvarchar(50),
				@LateBeginPermit int,
				@EarlyEndPermit int,
				@ShiftCode nvarchar(50),				
				@sSQL nvarchar(max)
				
--- Lấy tên dữ liệu thuế theo thiết lập
SELECT @TargetData = TargetData, @LateBeginPermit = LateBeginPermit, @EarlyEndPermit = EarlyEndPermit
FROM HT0000 WHERE DivisionID = @DivisionID

--- Xóa bảng HT2406 của dữ liệu thuế trước khi insert
SET @sSQL = 'DELETE ' + @TargetData + '.dbo.HT2406
From ' + @TargetData + '.dbo.HT2406 HT06
inner join ' + @TargetData + '.dbo.HV1400 HV00 on HV00.DivisionID = HT06.DivisionID AND HV00.EmployeeID = HT06.EmployeeID
WHERE	HT06.DivisionID = ''' + @DivisionID + ''' AND HT06.TranYear*100+HT06.TranMonth = ''' + str(@TranYear*100+@TranMonth) + '''
	AND HV00.DepartmentID like ''' + @DepartmentID + '''
	AND (HT06.AbsentDate Between ''' + convert(nvarchar(20),@FromDate,101) + ''' And ''' + convert(nvarchar(20),@ToDate,101) + ''')'
EXEC(@sSQL)

--- Insert thông tin vào bảng quét thẻ của dữ liệu thuế
SET @sSQL = 'INSERT ' + @TargetData + '.dbo.HT2406 (DivisionID,EmployeeID,TranMonth,TranYear,AbsentCardNo,AbsentDate,MachineCode,IOCode)
			SELECT	HT06.DivisionID,HT06.EmployeeID,HT06.TranMonth,HT06.TranYear,HT06.AbsentCardNo,HT06.AbsentDate,HT06.MachineCode,HT06.IOCode
			FROM	HT2406 HT06 Inner Join HV1400 HV00 on HV00.DivisionID = HT06.DivisionID AND HV00.EmployeeID = HT06.EmployeeID
			WHERE	HT06.DivisionID = ''' + @DivisionID + ''' AND HT06.TranYear*100+HT06.TranMonth = ''' + str(@TranYear*100+@TranMonth) + '''
				AND HV00.DepartmentID like ''' + @DepartmentID + '''
				AND (HT06.AbsentDate Between ''' + convert(nvarchar(20),@FromDate,101) + ''' And ''' + convert(nvarchar(20),@ToDate,101) + ''')'
EXEC(@sSQL)

--- Update ShiftCode cho HT2406			
SET @sSQL = 'UPDATE ' + @TargetData + '.dbo.HT2406
			SET ShiftCode = Isnull(H06.ShiftCode,CASE Day(AbsentDate)     
                      WHEN 1 THEN H25.D01 WHEN 2 THEN H25.D02 WHEN 3 THEN H25.D03 WHEN 4 THEN H25.D04 WHEN 5 THEN H25.D05 WHEN 6 THEN H25.D06 WHEN    
                       7 THEN H25.D07 WHEN 8 THEN H25.D08 WHEN 9 THEN H25.D09 WHEN 10 THEN H25.D10 WHEN 11 THEN H25.D11 WHEN 12 THEN H25.D12 WHEN    
                       13 THEN H25.D13 WHEN 14 THEN H25.D14 WHEN 15 THEN H25.D15 WHEN 16 THEN H25.D16 WHEN 17 THEN H25.D17 WHEN 18 THEN H25.D18 WHEN    
                       19 THEN H25.D19 WHEN 20 THEN H25.D20 WHEN 21 THEN H25.D21 WHEN 22 THEN H25.D22 WHEN 23 THEN H25.D23 WHEN 24 THEN H25.D24 WHEN    
                       25 THEN H25.D25 WHEN 26 THEN H25.D26 WHEN 27 THEN H25.D27 WHEN 28 THEN H25.D28 WHEN 29 THEN H25.D29 WHEN 30 THEN H25.D30 WHEN    
                       31 THEN H25.D31 ELSE NULL END)
			FROM ' + @TargetData + '.dbo.HT2406 H06 LEFT OUTER JOIN ' + @TargetData + '.dbo.HT1025 H25
			On H06.DivisionID = H25.DivisionID and H06.EmployeeID = H25.EmployeeID
			Inner Join ' + @TargetData + '.dbo.HV1400 HV00 on HV00.DivisionID = H06.DivisionID AND HV00.EmployeeID = H06.EmployeeID					
			WHERE H06.DivisionID = ''' + @DivisionID + ''' AND H06.TranYear*100 + H06.TranMonth = ''' + str(@TranYear*100+@TranMonth) + '''
				AND HV00.DepartmentID like ''' + @DepartmentID + '''
				AND (H06.AbsentDate Between ''' + convert(nvarchar(20),@FromDate,101) + ''' And ''' + convert(nvarchar(20),@ToDate,101) + ''')'
EXEC(@sSQL)

--- Tạo bảng tạm chứa dữ liệu HT2406 của data thuế
CREATE TABLE #HT2406
(
	[APK] [uniqueidentifier],
	[DivisionID] nvarchar(50),
	[EmployeeID] [nvarchar](50),
	[AbsentDate] [datetime],
	[AbsentTime] [nvarchar](100),
	[ShiftCode] [nvarchar](50),
	[IOCode] [tinyint],
	[BeginTime] [nvarchar](100),
	[EndTime] [nvarchar](100),
	[InAbsentTime] [nvarchar](100)
)

SET @sSQL = 'INSERT INTO #HT2406 (APK, DivisionID, EmployeeID, AbsentDate, AbsentTime, ShiftCode, IOCode, BeginTime, EndTime, InAbsentTime)
SELECT	H08.APK, H08.DivisionID, H08.EmployeeID, H08.AbsentDate, NULL, H08.ShiftCode, H08.IOCode, H20.BeginTime, H20.EndTime, H09.AbsentTime
	FROM ' + @TargetData + '.dbo.HT2406 H08 
	Inner Join ' + @TargetData + '.dbo.HV1400 HV00 on HV00.DivisionID = H08.DivisionID AND HV00.EmployeeID = H08.EmployeeID	
	Inner join HT2406 H09 On H08.DivisionID = H09.DivisionID And H08.AbsentCardNo = H09.AbsentCardNo And H08.AbsentDate = H09.AbsentDate And H08.IOCode = H09.IOCode
	Inner join ' + @TargetData + '.dbo.HT1020 H20 On H08.DivisionID = H20.DivisionID And H08.ShiftCode = H20.ShiftID

WHERE H08.DivisionID = ''' + @DivisionID + ''' AND H08.TranYear*100 + H08.TranMonth = ''' + str(@TranYear*100+@TranMonth) + '''
	AND HV00.DepartmentID like ''' + @DepartmentID + '''
	AND (H08.AbsentDate Between ''' + convert(nvarchar(20),@FromDate,101) + ''' And ''' + convert(nvarchar(20),@ToDate,101) + ''')'
EXEC(@sSQL)

--- Tạo giờ quét vào và cập nhật vào bảng tạm
Set @curHT2406_IN = cursor static for 
Select EmployeeID, AbsentDate, ShiftCode, BeginTime, InAbsentTime From #HT2406 WHERE Isnull(IOCode,0) = 0

Open @curHT2406_IN

Fetch Next From @curHT2406_IN Into @EmployeeID1, @AbsentDate, @ShiftCode, @BeginTime, @InAbsentTime
While @@Fetch_Status = 0
Begin
	IF @InAbsentTime > dateadd(mi,@LateBeginPermit,@BeginTime)
		SET @AbsentTime = @InAbsentTime
	ELSE
		SELECT @AbsentTime = left(cast(dateadd(mi, 
			   rand(checksum(newid()))*(1+datediff(mi, @BeginTime, cast(dateadd(mi,@LateBeginPermit,@BeginTime) as time))), 
			   @BeginTime) as time),8)
           
    UPDATE #HT2406 SET AbsentTime = @AbsentTime
    WHERE DivisionID = @DivisionID AND EmployeeID = @EmployeeID1 AND AbsentDate = @AbsentDate
    AND ShiftCode = @ShiftCode AND Isnull(IOCode,0) = 0

	Fetch Next From @curHT2406_IN Into @EmployeeID1, @AbsentDate, @ShiftCode, @BeginTime, @InAbsentTime
End
Close @curHT2406_IN

--- Tạo giờ quét ra và cập nhật vào bảng tạm
Set @curHT2406_OUT = cursor static for 
Select EmployeeID, AbsentDate, ShiftCode, EndTime, InAbsentTime From #HT2406 WHERE Isnull(IOCode,0) <> 0

Open @curHT2406_OUT

Fetch Next From @curHT2406_OUT Into @EmployeeID1, @AbsentDate, @ShiftCode, @EndTime, @InAbsentTime
While @@Fetch_Status = 0
Begin
	IF @InAbsentTime < dateadd(mi,(-1)*@EarlyEndPermit,@EndTime)
		SET @AbsentTime = @InAbsentTime
	ELSE
		SELECT @AbsentTime = left(cast(dateadd(mi, 
			   rand(checksum(newid()))*(1+datediff(mi, cast(dateadd(mi,(-1)*@EarlyEndPermit,@EndTime) as time), @EndTime)), 
			   @EndTime) as time),8)
               
    UPDATE #HT2406 SET AbsentTime = @AbsentTime
    WHERE DivisionID = @DivisionID AND EmployeeID = @EmployeeID1 AND AbsentDate = @AbsentDate
    AND ShiftCode = @ShiftCode AND Isnull(IOCode,0) <> 0

	Fetch Next From @curHT2406_OUT Into @EmployeeID1, @AbsentDate, @ShiftCode, @EndTime, @InAbsentTime
End
Close @curHT2406_OUT

--- Cập nhật giờ quét vào HT2406 của dữ liệu thuế
SET @sSQL = 'UPDATE ' + @TargetData + '.dbo.HT2406
			SET AbsentTime = #HT2406.AbsentTime
			FROM ' + @TargetData + '.dbo.HT2406 H08 Inner join #HT2406 On H08.APK = #HT2406.APK'
			
EXEC(@sSQL)