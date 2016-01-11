IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5008]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5008]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Giống HP5003 nhưng không WHERE Phòng ban
---- Tổng quỹ lương của Cảng sài gòn
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 13/11/2013 by Le Thi Thu Hien : 
---- 
---- Modified on 13/11/2013 by 
-- <Example>
---- 
CREATE PROCEDURE [dbo].[HP5008]
       @DivisionID nvarchar(50) ,
       @TranMonth int ,
       @TranYear int ,
       @PayrollMethodID nvarchar(50) ,
       @GeneralAbsentID nvarchar(50) 
AS
DECLARE
        @Type AS tinyint ,
        @Days AS decimal(28,8) ,
        @sSQLSELECT AS nvarchar(MAX) ,
        @sSQLFrom AS nvarchar(MAX) ,
        @sSQLWhere AS nvarchar(MAX) ,
        @IsMonth AS tinyint ,
        @TimeConvert AS decimal(28,8) ,
        @FromDate AS int ,
        @ToDate AS int ,
        @PeriodID nvarchar(50),
        @sSQL NVARCHAR(MAX)

SELECT   @PeriodID = PeriodID
FROM    HT5002
WHERE   GeneralAbsentID = @GeneralAbsentID AND DivisionID = @DivisionID

SELECT    @TimeConvert = TimeConvert
FROM    HT0000

SELECT	@Type = Type ,
		@Days = Days ,
		@IsMonth = IsMonth ,
		@FromDate = FromDate ,
		@ToDate = ToDate
FROM    HT5002 
Where GeneralAbsentID = @GeneralAbsentID AND DivisionID = @DivisionID


SET @Type = ISNULL(@Type , 0)
SET @Days = ISNULL(@Days , 24)

IF 'P06' <> (SELECT TOP 1 MethodID From HT5005 Where DivisionID = @DivisionID AND GeneralAbsentID = @GeneralAbsentID AND PayrollMethodID = @PayrollMethodID ) --- Các khoản thu nhập
		OR 'P06' <> (SELECT TOP 1 MethodID From HT5006 Where DivisionID = @DivisionID AND GeneralAbsentID = @GeneralAbsentID AND PayrollMethodID = @PayrollMethodID ) --- Các khoản giảm trừ

BEGIN
	--Edit by: Dang Le Bao Quynh viet gon lai dieu kien re nhanh
IF @IsMonth = 1
BEGIN
	IF @Type = 0 --- Luong công nhat
	BEGIN
		SET @sSQLSELECT = '
		SELECT 	Null As ProjectID,TranMonth,TranYear,EmployeeID,
				---Sum(AbsentAmount*ConvertUnit/CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + '  ELSE 1 END ) as AbsentAmount, 
				Sum(AbsentAmount*HT1013.ConvertUnit/(CASE WHEN HT1013.UnitID = ''H'' and ISNULL(H3.ConditionCode,'''') = ''''
				THEN ' + STR(@TimeConvert) + '  ELSE 1 END)) as AbsentAmount,
				HT2402.DivisionID,
				DepartmentID,
				ISNULL(TeamID,'''') as TeamID '
		SET @sSQLFrom = ' 
		FROM	HT2402  
		INNER JOIN HT1013 on HT2402.AbsentTypeID = HT1013.AbsentTypeID AND HT2402.DivisionID = HT1013.DivisionID
		LEFT JOIN HT1013 H3 on H3.ParentID = HT1013.AbsentTypeID AND H3.DivisionID = HT1013.DivisionID'
		SET @sSQLWhere = ' 
		WHERE	DepartmentID in (	SELECT	DepartmentID 
									FROM	HT5004 
		                       		WHERE 	DivisionID =''' + @DivisionID + ''' and										
											PayrollMethodID = ''' + @PayrollMethodID + ''' ) and
				HT2402.AbsentTypeID in (SELECT	AbsentTypeID 
										FROM	HT5003 
										WHERE	GeneralAbsentID =''' + @GeneralAbsentID + '''  
												AND DivisionID =''' + @DivisionID + ''' )  AND 
				HT2402.DivisionID =''' + @DivisionID + ''' AND 
				ISNULL(HT2402.PeriodID,'''') IN (''' + ISNULL(@PeriodID , '') + ''','''') and
				TranMonth =' + str(@TranMonth) + ' and
				TranYear =' + str(@TranYear) + ' 
		GROUP BY TranMonth, TranYear, 	EmployeeID, HT2402.DivisionID,DepartmentID,ISNULL(TeamID,'''') '
	END
	ELSE	---- Cong loai tru
	 BEGIN
		   SET @sSQLSELECT = '
			SELECT 	Null As ProjectID, HT2400.TranMonth, HT2400.TranYear,HT2400.EmployeeID,
					' + str(@Days) + ' + + Sum(Case when ISNULL(TypeID,'''') in ( ''G'', ''P'' )  then - ISNULL(AbsentAmount*ConvertUnit,0) ELSE 
								 Case When  ISNULL(TypeID,'''') =''T'' then ISNULL(AbsentAmount*ConvertUnit,0) ELSE 0 end  end/ 
								CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END ) as AbsentAmount,		
					HT2400.DivisionID,
					HT2400.DepartmentID,
					ISNULL(HT2400.TeamID,'''') as TeamID'
		   SET @sSQLFrom = ' 
			FROM		HT2400 	
			LEFT JOIN 	HT2402 
				ON		HT2402.EmployeeID = HT2400.EmployeeID and
						HT2402.DepartmentID = HT2400.DepartmentID and
						ISNULL(HT2402.TeamID,'''') = ISNULL(HT2400.TeamID,'''') and
						HT2402.DivisionID = HT2400.DivisionID and
						Ht2402.TranMonth = HT2400.TranMonth and
						Ht2402.TranYear = HT2400.TranYear
			LEFT JOIN 	(	SELECT  AbsentTypeID , TypeID, UnitID, ConvertUnit 
							FROM	HT1013 
			          	 	WHERE	IsMonth = 1 
									AND DivisionID =''' + @DivisionID + ''' 
									AND AbsentTypeID in (	SELECT	AbsentTypeID 
									                     	FROM	HT5003 
															WHERE	GeneralAbsentID  =''' + @GeneralAbsentID + '''  
																	AND DivisionID =''' + @DivisionID + ''' ) 
														) as H
				ON  H.AbsentTypeID = HT2402.AbsentTypeID '

			SET @sSQLWhere = ' 
			WHERE	HT2400.DepartmentID in (SELECT DepartmentID 
			     	                        From HT5004 
			     	                        Where 	DivisionID =''' + @DivisionID + ''' and										
											PayrollMethodID = ''' + @PayrollMethodID + ''' 
											)  and
					HT2400.DivisionID =''' + @DivisionID + ''' and
					ISNULL(HT2402.PeriodID,'''') IN (''' + ISNULL(@PeriodID , '') + ''','''') and
					HT2400.TranMonth =' + str(@TranMonth) + ' and
					HT2400.TranYear =' + str(@TranYear) + ' 

			GROUP BY	HT2400.TranMonth, HT2400.TranYear,HT2400.EmployeeID, 
						HT2400.DivisionID,HT2400.DepartmentID,ISNULL(HT2400.TeamID,'''') '
	 END
END
ELSE --- Tu cham cong ngay
BEGIN
IF @Type = 0 --- Luong công nhat
	BEGIN
	SET @sSQLSELECT = '
		SELECT 	Null As ProjectID, TranMonth,TranYear,
				EmployeeID,
				---Sum(AbsentAmount*ConvertUnit/ CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,
				Sum(AbsentAmount*HT1013.ConvertUnit/(CASE WHEN HT1013.UnitID = ''H'' and ISNULL(H3.ConditionCode,'''') = ''''
				THEN ' + STR(@TimeConvert) + '  ELSE 1 END)) as AbsentAmount,
				HT2401.DivisionID,
				DepartmentID,
				ISNULL(TeamID,'''') as TeamID '
		SET @sSQLFrom = ' 
		FROM		HT2401 
		INNER JOIN	HT1013 
			ON		HT2401.AbsentTypeID = HT1013.AbsentTypeID 
					AND HT2401.DivisionID = HT1013.DivisionID
		LEFT JOIN HT1013 H3 on H3.ParentID = HT1013.AbsentTypeID AND H3.DivisionID = HT1013.DivisionID'
		SET @sSQLWhere = '
		WHERE		DepartmentID in (SELECT DepartmentID 
		     		                 From HT5004 
		     		                 Where 	DivisionID =''' + @DivisionID + ''' and										
											PayrollMethodID = ''' + @PayrollMethodID + ''' 
									) AND 
					HT2401.DivisionID =''' + @DivisionID + ''' AND 							
					HT2401.AbsentTypeID in (SELECT AbsentTypeID From HT5003 
					Where GeneralAbsentID =''' + @GeneralAbsentID + '''  AND 
					DivisionID =''' + @DivisionID + ''' )  and
					TranMonth =' + str(@TranMonth) + ' and
					TranYear =' + str(@TranYear) + '  AND Day(AbsentDate) between ' + STR(@FromDate) + ' AND ' + STR(@ToDate) + '
		GROUP BY	TranMonth, TranYear, 	EmployeeID, 
					HT2401.DivisionID,DepartmentID,ISNULL(TeamID,'''') '
	END
ELSE	---- Cong loai tru
BEGIN
	SET @sSQLSELECT = '
	SELECT 	Null As ProjectID, HT2400.TranMonth,
			HT2400.TranYear,	HT2400.EmployeeID,
			' + str(@Days) + ' + + Sum( Case when ISNULL(TypeID,'''') in ( ''G'', ''P'' )  then - ISNULL(AbsentAmount*ConvertUnit, 0) ELSE 
						 Case When  ISNULL(TypeID,'''') =''T'' then ISNULL(AbsentAmount*ConvertUnit,0) ELSE 0 end  end/ 
						CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,		
			HT2400.DivisionID,
			HT2400.DepartmentID,
			ISNULL(HT2400.TeamID,'''') as TeamID '
	SET @sSQLFrom = ' 
	FROM		HT2400 	
	LEFT JOIN 	HT2401 
		ON		HT2401.EmployeeID = HT2400.EmployeeID and
				HT2401.DepartmentID = HT2400.DepartmentID and
				ISNULL(HT2401.TeamID,'''') = ISNULL(HT2400.TeamID,'''') and
				HT2401.DivisionID = HT2400.DivisionID and
				Ht2401.TranMonth = HT2400.TranMonth and
				Ht2401.TranYear = HT2400.TranYear
	LEFT  JOIN 	(	SELECT  AbsentTypeID , TypeID, ConvertUnit, UnitID 
					FROM	HT1013 
	           	 	WHERE	IsMonth = 0 
					AND DivisionID =''' + @DivisionID + ''' 
					AND AbsentTypeID in (	SELECT	AbsentTypeID 
											FROM	HT5003 
											WHERE	GeneralAbsentID  =''' + @GeneralAbsentID + '''  
													AND DivisionID =''' + @DivisionID + ''' ) 
				) AS H
		ON		H.AbsentTypeID = HT2401.AbsentTypeID'

	SET @sSQLWhere = ' 
	WHERE	HT2400.DepartmentID in (SELECT	DepartmentID 
									FROM	HT5004 
									WHERE 	DivisionID =''' + @DivisionID + ''' and										
											PayrollMethodID = ''' + @PayrollMethodID + ''' )  and
			HT2400.DivisionID =''' + @DivisionID + ''' AND 
			HT2400.TranMonth =' + str(@TranMonth) + ' and
			HT2400.TranYear =' + str(@TranYear) + '  AND Day(AbsentDate) between ' + STR(@FromDate) + ' AND ' + STR(@ToDate) + '
	GROUP BY	HT2400.TranMonth,HT2400.TranYear,HT2400.EmployeeID, 
				HT2400.DivisionID,HT2400.DepartmentID,ISNULL(HT2400.TeamID,'''') '
END
END
		
	IF NOT EXISTS ( SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND name = 'HV5008' )
	   BEGIN
			 EXEC ( 'CREATE VIEW HV5008 AS '+@sSQLSelect+@sSQLFrom+@sSQLWhere )
	   END
	ELSE
	   BEGIN
			 EXEC ( ' ALTER VIEW HV5008 AS  '+@sSQLSelect+@sSQLFrom+@sSQLWhere )
	   END
END
	---- Không tính trong store HP5004 mà tính trực tiếp tại đây
	---- Giống bảng HT3444 dùng để tính tổng quỹ lương công ty
	SET @sSQL =' 
		DELETE	HT3445 
		INSERT  HT3445 (TranMonth,TranYear,EmployeeID,DivisionID,DepartmentID,TeamID,GeneralCo, AbsentAmount , BaseSalary , GeneralAbsentID)
		SELECT V2.TranMonth, V2.TranYear, V2.EmployeeID,
				V2.DivisionID, V2.DepartmentID , V2.TeamID,
				Sum(isnull(V2.GeneralCo,0)), 	
				Sum(isnull(V3.AbsentAmount,0)) ,
				Min(V2.BaseSalary), '''+@GeneralAbsentID+'''
		FROM HV5009 V2 
		LEFT JOIN HV5008 V3 on 	V2.EmployeeID = V3.EmployeeID and 
						V2.DepartmentID = V3.DepartmentID and 
						isnull(V2.TeamID,'''') = isnull(V3.TeamID,'''') and
						V2.DivisionID = V3.DivisionID and
						V2.TranMonth = V3.TranMonth and
						V2.TranYear = V3.TranYear 
		WHERE	V2.DivisionID = ''' + @DivisionID + ''' and
				V2.TranMonth = ' + Str(@TranMonth) + '  and
				V2.TranYear =' + Str(@TranYear) + ' AND
				ISNULL(V2.IsJobWage,0) = 1
		GROUP BY V2.DivisionID, V2.TranMonth, V2.TranYear, V2.DepartmentID, V2.TeamID, V2.EmployeeID	
		'
		--PRINT(@sSQL)
		EXEC (@sSQL) 


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

