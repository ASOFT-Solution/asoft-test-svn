/****** Object:  StoredProcedure [dbo].[HP2399]    Script Date: 07/30/2010 14:22:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create by: Doan Ngoc Lien
--Edit by: Dang Le Baoq Quynh; Date 07/08/2008
--Them ke thua tu ho so luong

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2399] @DivisionID AS nvarchar(50),
				@DepartmentID AS nvarchar(50),
				@TeamID AS nvarchar(50),
				@EmployeeID AS nvarchar(50),
				@TranMonth AS int,
				@TranYear AS int,
				@FromTranMonth AS int,
				@FromTranYear AS int,
				@Mode as int = 2
AS
DECLARE @TempYear AS nvarchar(20),
	@TempMonth AS nvarchar(20),
	@EmpFileID AS nvarchar(50),
	@DivisionID1 AS nvarchar(50),
	@EmployeeID1 AS nvarchar(50),
	--@DepartmentID1 AS VARCHAR(20),
	--@TeamID1 AS VARCHAR(20),
	@I01 AS decimal(28,8),
	@I02 AS decimal(28,8),
	@I03 AS decimal(28,8),
	@I04 AS decimal(28,8),
	@I05 AS decimal(28,8),
	@I06 AS decimal(28,8),
	@I07 AS decimal(28,8),
	@I08 AS decimal(28,8),
	@I09 AS decimal(28,8),
	@I10 AS decimal(28,8),
	@I11 AS decimal(28,8),
	@I12 AS decimal(28,8),
	@I13 AS decimal(28,8),
	@I14 AS decimal(28,8),
	@I15 AS decimal(28,8),
	@I16 AS decimal(28,8),
	@I17 AS decimal(28,8),
	@I18 AS decimal(28,8),
	@I19 AS decimal(28,8),
	@I20 AS decimal(28,8),
	@HT2422Cursor AS CURSOR
SET @TempYear = cast(@TranYear as nvarchar(20))
SET @TempMonth = case when len(ltrim(rtrim(str(@TranMonth))))=1 then '0' + ltrim(rtrim(str(@TranMonth)))
		else ltrim(rtrim(str(@TranMonth)))end
If @Mode = 2 
Begin
	SET @HT2422Cursor = CURSOR SCROLL KEYSET FOR
	SELECT HT1.EmployeeID,HT1.DivisionID,
		HT1.I01,HT1.I02,HT1.I03,HT1.I04,HT1.I05,HT1.I06,HT1.I07,HT1.I08,HT1.I09,HT1.I10,
		HT1.I11,HT1.I12,HT1.I13,HT1.I14,HT1.I15,HT1.I16,HT1.I17,HT1.I18,HT1.I19,HT1.I20	 
	FROM HT2422 HT1 INNER JOIN HT2400 HT2 ON HT1.EmployeeID = HT2.EmployeeID and HT1.DivisionID = HT2.DivisionID 
	WHERE HT2.DivisionID = @DivisionID 
		and HT2.DepartmentID LIKE @DepartmentID and 
		isnull(HT2.TeamID,'') LIKE @TeamID and 
		HT2.EmployeeID like @EmployeeID and 
		HT2.EmployeeID Not In (Select EmployeeID From HT2422 Where DivisionID = @DivisionID And TranMonth = @TranMonth and TranYear = @TranYear) And
		HT1.TranMonth = @FromTranMonth and 	HT1.TranYear = @FromTranYear and 
		HT2.TranMonth = @TranMonth and HT2.TranYear = @TranYear
End
Else
Begin
	SET @HT2422Cursor = CURSOR SCROLL KEYSET FOR
	SELECT HT2.EmployeeID,HT2.DivisionID,
		0 as I01,0 as I02,0 as I03,0 as I04,0 as I05,0 as I06,0 as I07,0 as I08,0 as I09,0 as I10,
		0 as I11,0 as I12,0 as I13,0 as I14,0 as I15,0 as I16,0 as I17,0 as I18,0 as I19,0 as I20	 
	FROM HT2400 HT2 
	WHERE HT2.DivisionID = @DivisionID 
		and HT2.DepartmentID LIKE @DepartmentID and 
		isnull(HT2.TeamID,'') LIKE @TeamID and 
		HT2.EmployeeID like @EmployeeID and 
		HT2.EmployeeID Not In (Select EmployeeID From HT2422 Where DivisionID = @DivisionID And TranMonth = @TranMonth and TranYear = @TranYear) And
		HT2.TranMonth = @TranMonth and HT2.TranYear = @TranYear
End
OPEN @HT2422Cursor
FETCH NEXT FROM @HT2422Cursor INTO @EmployeeID1,@DivisionID1,@I01,@I02,@I03,@I04,@I05,@I06,@I07,@I08,@I09,@I10,@I11,@I12,@I13,@I14,@I15,@I16,@I17,@I18,@I19,@I20
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS(SELECT HT1.EmployeeID FROM HT2422 HT1 INNER JOIN HT2400 HT2 ON HT1.EmployeeID = HT2.EmployeeID and HT1.DivisionID = HT2.DivisionID
				 WHERE HT1.EmployeeID LIKE @EmployeeID1 
			AND HT2.DivisionID LIKE @DivisionID1 AND HT2.DepartmentID LIKE @DepartmentID
			AND HT1.TranMonth = @TranMonth AND HT1.TranYear = @TranYear
			AND ISNULL(HT2.TeamID,'') LIKE ISNULL(@TeamID,''))
			BEGIN
				EXEC AP0000 @DivisionID1, @EmpFileID OUTPUT,'HT2422','HS',@TempYear,@TempMonth,15,3,0,''
				INSERT INTO HT2422(EmpFileID,EmployeeID,DivisionID,TranMonth,TranYear,
					I01,I02,I03,I04,I05,I06,I07,I08,I09,I10,I11,I12,I13,I14,I15,I16,I17,I18,I19,I20)
				VALUES(@EmpFileID,@EmployeeID1,@DivisionID1,@TranMonth,@TranYear,
					@I01,@I02,@I03,@I04,@I05,@I06,@I07,@I08,@I09,@I10,@I11,@I12,@I13,@I14,@I15,@I16,@I17,@I18,@I19,@I20)
			END
		FETCH NEXT FROM @HT2422Cursor INTO @EmployeeID1,@DivisionID1,@I01,@I02,@I03,@I04,@I05,@I06,@I07,@I08,@I09,@I10,@I11,@I12,@I13,@I14,@I15,@I16,@I17,@I18,@I19,@I20
	END
	CLOSE @HT2422Cursor
	DEALLOCATE @HT2422Cursor