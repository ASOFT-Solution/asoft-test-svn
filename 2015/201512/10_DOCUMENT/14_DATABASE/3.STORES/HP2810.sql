IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2810]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2810]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------ Created by Nguyen Quoc Huy
------ Created Date 24/09/2008
------ Purpose: Tinh phep nam cho nhan vien
------ Edit by: Dang Le Bao Quynh; Date 18/11/2008
------ Purpose: Sua lai thu tuc tinh phep
------ Edit by: Trung Dung; Date 26/05/2011
------ Purpose: Bo sung quy doi ra ngay neu cong phep la theo gio 
----- Modify on 13/02/2014 by Bảo Anh: 1/ tính phép cho nhân viên ký hợp đồng từ 1 năm trở lên, số ngày phép tính từ ngày ký hợp đồng
-----                                  2/ Nếu có chấm công theo công trình thì lấy số công phép từ HT2432
			
----- Modify on 11/05/2015 by Bảo Anh:	1/ Bỏ điều kiện chỉ tính phép cho nhân viên ký hợp đồng từ 1 năm trở lên
-----									2/ Sửa lỗi tính sai số ngày phép trong năm, số tháng làm việc khi có QĐTV
		
CREATE PROCEDURE [dbo].[HP2810] @DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@ToDepartmentID as nvarchar(50),
				@TeamID as nvarchar(50),
				@EmployeeID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@IsAdded AS TINYINT,
				@CalDate As Datetime
AS
DECLARE		@EmpLoaMonthID as nvarchar(50),
			@EmployeeID1 as nvarchar(50),
			@WorkTerm as money,
			@HV1400Cursor as CURSOR,
			@HT2803Cursor CURSOR,
			@SQL as nvarchar(4000),
			@LoaCondID nvarchar(50),
			@FromPeriod int, 
			@ToPeriod int, 
			@DaysBeAllowed money,
			@DaysSpent	money,
			@AbsentSum AS MONEY,
			@TimeConvert AS MONEY,
			@SignDate datetime
			
SET NOCOUNT ON
Select @TimeConvert = TimeConvert  FROM HT0000 Where DivisionID = @DivisionID
SET @TimeConvert = CASE WHEN @TimeConvert IS NULL OR @TimeConvert=0 THEN 1 ELSE @TimeConvert end

SET @HV1400Cursor = CURSOR SCROLL KEYSET FOR
	/*
	--- Modify on 13/02/2014: Chỉ tính phép cho nhân viên ký hợp đồng từ 1 năm trở lên, số ngày phép tính từ ngày ký hợp đồng
	SELECT  HV1400.EmployeeID
	FROM HV1400
	INNER JOIN HT1360 On HV1400.DivisionID = HT1360.DivisionID And HV1400.EmployeeID = HT1360.EmployeeID
	LEFT JOIN HT1105 On HT1360.DivisionID = HT1105.DivisionID And HT1360.ContractTypeID = HT1105.ContractTypeID
	WHERE 	HV1400.DivisionID = @DivisionID and (HV1400.DepartmentID between @DepartmentID and @ToDepartmentID) and Isnull(HV1400.TeamID,'') like @TeamID 
			and HV1400.EmployeeID like @EmployeeID and HV1400.EmployeeStatus = 1 and isnull(HV1400.LoaCondID,'') <> ''
			and Isnull(HT1105.Months,0) >= 12
	*/
	--- Modify on 11/05/2015: Bỏ điều kiện chỉ tính phép cho nhân viên ký hợp đồng từ 1 năm trở lên
	SELECT  HV1400.EmployeeID
	FROM HV1400
	WHERE 	HV1400.DivisionID = @DivisionID and (HV1400.DepartmentID between @DepartmentID and @ToDepartmentID) and Isnull(HV1400.TeamID,'') like @TeamID 
			and HV1400.EmployeeID like @EmployeeID and (HV1400.EmployeeStatus = 1 or Isnull(LeaveDate,'12/31/9999') > @CalDate) and isnull(HV1400.LoaCondID,'') <> ''
	
OPEN @HV1400Cursor
FETCH NEXT FROM @HV1400Cursor INTO  @EmployeeID1---, @WorkTerm

---Insert cac nhan vien vao bang HT2803
WHILE @@FETCH_STATUS = 0
BEGIN
	--- Xac dinh ngày ký hợp đồng để tính thâm niên
	IF NOT EXISTS (SELECT Top 1 1 From HT1380 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID1 And DecidingDate < @CalDate)
	Begin
		SELECT top 1 @SignDate = SignDate From HT1360 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID1 Order by SignDate
	End
	ELSE
	Begin
		Declare @DecidingDate datetime
		SELECT @DecidingDate = DecidingDate FROM HT1380 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID1 And DecidingDate < @CalDate Order by DecidingDate DESC
		SELECT TOP 1 @SignDate = SignDate From HT1360 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID1 And datediff(DAY,@DecidingDate,SignDate) > 0 
								Order by datediff(DAY,@DecidingDate,SignDate)
	End
	
	--- Xac dinh so thang nhan vien lam viec den thoi diem hien tai
	SET @WorkTerm = Isnull(DateDiff(m,@SignDate,@CalDate),0)
	
	IF NOT EXISTS ( SELECT * FROM HT2803 WHERE EmployeeID = @EmployeeID1  AND TranMonth = @TranMonth AND TranYear = @TranYear and DivisionID = @DivisionID)
	BEGIN
		Exec AP0000  @DivisionID,@EmpLoaMonthID  OUTPUT, 'HT2803', 'HS', @TranYear, '' , 15, 3, 0, ''
		INSERT INTO HT2803 (DivisionID,EmpLoaMonthID, EmployeeID, TranMonth, TranYear ,WorkTerm,DaysInYear,DaysSpent,DaysPrevYear,DaysRemained)
			VALUES (@DivisionID,@EmpLoaMonthID, @EmployeeID1, @TranMonth, @TranYear, @WorkTerm,0,0,0,0)
	END

	FETCH NEXT FROM @HV1400Cursor INTO  @EmployeeID1---, @WorkTerm
 END

CLOSE @HV1400Cursor
DEALLOCATE @HV1400Cursor


			
			
SET @SQL = 'SELECT HT.DivisionID ,HT.EmployeeID, HT.WorkTerm, HV.LoaCondID
FROM HV1400 HV INNER JOIN HT2803 HT ON HV.EmployeeID = HT.EmployeeID AND HV.DivisionID = HT.DivisionID 
WHERE TranMonth =' + ltrim(@TranMonth) + ' 
AND TranYear =' + ltrim(@TranYear) + ' 
AND HT.DivisionID =''' + @DivisionID + ''' 
AND DepartmentID between ''' + @DepartmentID + ''' And ''' + @ToDepartmentID + '''
AND ISNULL(TeamID,'''') LIKE''' + @TeamID + ''' 
AND HT.EmployeeID LIKE''' + @EmployeeID + '''
AND isnull(LoaCondID,'''') <> '''' '

--Print @SQL

If not exists (Select 1 From sysobjects Where id = Object_id('HV2810') And Xtype = 'V')
	EXEC ( 'Create View HV2810 As ' + @SQL )
Else
	EXEC ( 'Alter View HV2810 As ' + @SQL )

SET @HT2803Cursor = CURSOR SCROLL KEYSET FOR

SELECT EmployeeID, WorkTerm, LoaCondID FROM HV2810

OPEN @HT2803Cursor

FETCH NEXT FROM @HT2803Cursor INTO @EmployeeID1, @WorkTerm, @LoaCondID

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @DaysBeAllowed = 0
	SET @DaysSpent = 0
	SET @AbsentSum = 0
		---------------Update DaysInYear----------------
	If not exists (Select Top 1 1 From HT2806 Where LoaCondID = @LoaCondID and DivisionID = @DivisionID)
		Begin
			Update HT2803 Set DaysInYear=0,DaysSpent=0,DaysPrevYear=0,DaysRemained=0 Where EmployeeID = @EmployeeID1 And TranMonth = @TranMonth And TranYear = @TranYear and DivisionID = @DivisionID
		End
	Else
		Begin
			If (Select IsManage From HT2806 Where LoaCondID = @LoaCondID and DivisionID = @DivisionID) = 0
				Select @DaysBeAllowed = Isnull(DaysAllowed,0) From HT2806 Where LoaCondID = @LoaCondID and DivisionID = @DivisionID
			Else
				Select Top 1 @DaysBeAllowed = Isnull(DaysBeAllowed,0) From HT2807 Where LoaCondID = @LoaCondID And @WorkTerm Between FromPeriod And ToPeriod-1 and DivisionID = @DivisionID

			--Cap nhat so ngay nghi trong nam
			UPDATE HT2803 SET DaysInYear = iSNULL(@DaysBeAllowed,0) WHERE EmployeeID = @EmployeeID1  And TranMonth = @TranMonth And TranYear = @TranYear and DivisionID = @DivisionID

			--Cap nhat so ngay nghi phep trong thang
			--- Modify on 13/02/2014: Nếu có chấm công theo công trình thì lấy số công phép từ HT2432
			IF EXISTS (Select top 1 1 From HT2432 Where DivisionID = @DivisionID And EmployeeID = @EmployeeID1 And TranMonth = @TranMonth And TranYear = @TranYear)
				Set @DaysSpent =(SELECT isnull(SUM( CASE WHEN UnitID = 'H' THEN isnull(AbsentAmount,0)/@TimeConvert Else isnull(AbsentAmount,0) end),0) 	FROM HT2432 
								LEFT JOIN HT1013 ON HT1013.AbsentTypeID	= HT2432.AbsentTypeID		
								WHERE TypeID = 'P' and TranMonth = @TranMonth and TranYear = @TranYear and HT2432.DivisionID = @DivisionID and EmployeeID = @EmployeeID1)
			ELSE
				Set @DaysSpent =(SELECT isnull(SUM( CASE WHEN UnitID = 'H' THEN isnull(AbsentAmount,0)/@TimeConvert Else isnull(AbsentAmount,0) end),0) 	FROM HT2401 
								LEFT JOIN HT1013 ON HT1013.AbsentTypeID	= HT2401.AbsentTypeID		
								WHERE TypeID = 'P' and TranMonth = @TranMonth and TranYear = @TranYear and HT2401.DivisionID = @DivisionID and EmployeeID = @EmployeeID1)				
				
			UPDATE HT2803 SET DaysSpent = isnull(@DaysSpent,0)	
			 WHERE EmployeeID = @EmployeeID1  And TranMonth = @TranMonth And TranYear = @TranYear and DivisionID = @DivisionID
			--Cap nhat so ngay phep con lai cua nam truoc
			SELECT @AbsentSum = SUM(isnull(DaysSpent,0)) FROM HT2803
			WHERE EmployeeID = @EmployeeID1 AND TranMonth <= @TranMonth and TranYear = @TranYear and DivisionID = @DivisionID

			IF @IsAdded = 1
				UPDATE HT2803 SET DaysPrevYear = 	Case When	(isnull((SELECT isnull(DaysRemained,0) FROM HT2803 
											Where TranMonth = 12 and TranYear = @TranYear-1 and EmployeeID = @EmployeeID1 and DivisionID = @DivisionID),0)
											- isnull(@AbsentSum,0)) < 0
									Then 0
									Else
											isnull(((SELECT isnull(DaysRemained,0) FROM HT2803 
											Where TranMonth = 12 and TranYear = @TranYear-1 and EmployeeID = @EmployeeID1 and DivisionID = @DivisionID)
											- isnull(@AbsentSum,0)),0) 
									End
				 WHERE EmployeeID = @EmployeeID1  And TranMonth = @TranMonth And TranYear = @TranYear and DivisionID = @DivisionID
			ELSE 
				UPDATE HT2803 SET DaysPrevYear = 	0
				 WHERE EmployeeID = @EmployeeID1  And TranMonth = @TranMonth And TranYear = @TranYear and DivisionID = @DivisionID
			--Cap nhat so ngay phep con lai
			
			IF @IsAdded = 1
				BEGIN
					UPDATE HT2803 SET DaysRemained = (isnull(DaysInYear,0) + isnull(DaysPrevYear,0))- isnull(@AbsentSum,0)
					WHERE EmployeeID = @EmployeeID1 and TranMonth = @TranMonth and TranYear = @TranYear and DivisionID = @DivisionID
				END
			ELSE
				BEGIN
					IF @TranMonth = 1
						UPDATE HT2803
						SET DaysRemained = isnull(DaysInYear,0) - isnull(@DaysSpent,0)
						WHERE EmployeeID = @EmployeeID1 and TranMonth = @TranMonth and TranYear = @TranYear and DivisionID = @DivisionID
					ELSE
						UPDATE HT2803
						SET DaysRemained = 	isnull(DaysInYear,0) -  
									isnull((Select isnull(DaysInYear,0) From HT2803 WHERE EmployeeID = @EmployeeID1 and TranMonth = @TranMonth-1 and TranYear = @TranYear and DivisionID = @DivisionID),0) +
									(isnull((Select isnull(DaysRemained,0) From HT2803 WHERE EmployeeID = @EmployeeID1 and TranMonth = @TranMonth-1 and TranYear = @TranYear and DivisionID = @DivisionID),0)
									 - isnull(@DaysSpent,0))
						WHERE EmployeeID = @EmployeeID1 and TranMonth = @TranMonth and TranYear = @TranYear and DivisionID = @DivisionID

				END
		End		
		 
		
	FETCH NEXT FROM @HT2803Cursor INTO @EmployeeID1, @WorkTerm, @LoaCondID
END

CLOSE @HT2803Cursor

DEALLOCATE @HT2803Cursor

SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
