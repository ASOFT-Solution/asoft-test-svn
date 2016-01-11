IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5009]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5009]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Giống store HP5002
---- Cảng sài gòn (Tính lương toàn công ty)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 13/11/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 13/11/2013 by 
-- <Example>
---- 

CREATE PROCEDURE [dbo].[HP5009]	
				@DivisionID AS nvarchar(50),	
				@TranMonth AS int, 
				@TranYear AS int , 
				@PayrollMethodID AS nvarchar(50), 
				@GeneralCoID AS nvarchar(50),
				@MethodID nvarchar(50),
				@BaseSalaryField  AS nvarchar(50),
				@BaseSalary AS decimal (28,8)
AS

Declare 
    @sSQL AS nvarchar(4000),
	@ListOfCo AS nvarchar(4000),
	@Temp AS nvarchar(500),
	@Pos1 AS int,
	@Pos2 AS int,
	@Pos3 AS int,
	@Value1 AS decimal (28,8),
	@Value2 AS decimal (28,8),
	@Value3 AS decimal (28,8),
	@Cur AS cursor,
	@CoefficientID nvarchar(50)
	
Set @ListOfCo =''

If @MethodID <> 'P06'
BEGIN
	Set @ListOfCo =@ListOfCo+'( '  + (Select top 1  'isnull( '+isnull(C01ID,'') +',0) '+ 
					(CASE WHEN isnull(C02ID,'') <>'' THEN '+ isnull('+isnull(C02ID,'')+',0)' ELSE '' end)+
					(CASE WHEN isnull(C03ID,'') <>'' THEN '+ isnull('+isnull(C03ID,'')+',0)'  ELSE '' end)+
					(CASE WHEN isnull(C04ID,'') <>'' THEN '+ isnull('+isnull(C04ID,'')+',0)'  ELSE '' end)+
					(CASE WHEN isnull(C05ID,'') <>'' THEN '+ isnull('+isnull(C05ID,'')+',0)'  ELSE '' end)
					 From HT5001 Where GeneralCoID = @GeneralCoID and DivisionID = @DivisionID Order by LineID )+')'
					 			 
	if Exists (Select top 1 1   From HT5001 Where GeneralCoID = @GeneralCoID and DivisionID = @DivisionID  and LineID =2)
		  Set @ListOfCo =@ListOfCo+ (Select top 1 [Sign]+'('+' isnull('+isnull(C01ID,'')+',0)'  + 
						(CASE WHEN isnull(C02ID,'') <>'' THEN '+ isnull('+isnull(C02ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C03ID,'') <>'' THEN '+ isnull('+isnull(C03ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C04ID,'') <>'' THEN '+ isnull('+isnull(C04ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C05ID,'') <>'' THEN '+ isnull('+isnull(C05ID,'')+',0)'  ELSE '' end)
						 From HT5001 Where GeneralCoID = @GeneralCoID and DivisionID = @DivisionID  and LineID =2 )+')'

	if Exists (Select top 1 1   From HT5001 Where GeneralCoID = @GeneralCoID and DivisionID = @DivisionID  and LineID =3)
		  Set @ListOfCo =@ListOfCo+ (Select top 1 [Sign]+'('+' isnull('+isnull(C01ID,'')+',0)' +
						(CASE WHEN isnull(C02ID,'') <>'' THEN '+ isnull('+isnull(C02ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C03ID,'') <>'' THEN '+ isnull('+isnull(C03ID,'')+',0)' ELSE '' end)+
						(CASE WHEN isnull(C04ID,'') <>'' THEN '+ isnull('+isnull(C04ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C05ID,'') <>'' THEN '+ isnull('+isnull(C05ID,'')+',0)'  ELSE '' end)
						 From HT5001 Where GeneralCoID = @GeneralCoID  and DivisionID = @DivisionID and LineID =3 )+')'

	if Exists (Select top 1 1   From HT5001 Where GeneralCoID = @GeneralCoID and LineID =4 and DivisionID = @DivisionID )
		  Set @ListOfCo =@ListOfCo+ (Select top 1 [Sign]+'(' +' isnull('+isnull(C01ID,'')+',0)' +
						(CASE WHEN isnull(C02ID,'') <>'' THEN '+ isnull('+isnull(C02ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C03ID,'') <>'' THEN '+ isnull('+isnull(C03ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C04ID,'') <>'' THEN '+ isnull('+isnull(C04ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C05ID,'') <>'' THEN '+ isnull('+isnull(C05ID,'')+',0)'  ELSE '' end)
						 From HT5001 Where GeneralCoID = @GeneralCoID and DivisionID = @DivisionID  and LineID =4 )+')'

	if Exists (Select top 1 1   From HT5001 Where GeneralCoID = @GeneralCoID and LineID =5 and DivisionID = @DivisionID )
		  Set @ListOfCo =@ListOfCo+ (Select top 1 [Sign]+'(' +' isnull('+isnull(C01ID,'')+',0)' +
						(CASE WHEN isnull(C02ID,'') <>'' THEN '+ isnull('+isnull(C02ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C03ID,'') <>'' THEN '+ isnull('+isnull(C03ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C04ID,'') <>'' THEN '+ isnull('+isnull(C04ID,'')+',0)'  ELSE '' end)+
						(CASE WHEN isnull(C05ID,'') <>'' THEN '+ isnull('+isnull(C05ID,'')+',0)'  ELSE '' end)
						 From HT5001 Where GeneralCoID = @GeneralCoID and LineID =5 and DivisionID = @DivisionID  )+')'
END

Set @Cur = cursor static for
Select CoefficientID From HT0003 Where IsConstant = 1  and DivisionID = @DivisionID 
Open @Cur
Fetch Next From @Cur Into @CoefficientID
While @@Fetch_Status=0
Begin
	Set @Pos1=PATINDEX('%' + @CoefficientID + '%' ,@ListOfCo )	
	If @Pos1 <>0 
	Begin
		SELECT	@Value1= ValueOfConstant 
		FROM	HT0003 
		WHERE	CoefficientID = @CoefficientID 
				AND DivisionID = @DivisionID 
				
		IF @MethodID <> 'P06'
			Set @ListOfCo=REPLACE(@ListOfCo,@CoefficientID, cast( @Value1 AS varchar(20)))
	END
	FETCH NEXT FROM @Cur INTO @CoefficientID
End


IF @MethodID = 'P10'
	Set @Temp =  '0 AS BaseSalary, '
ELSE
	BEGIN
		IF @BaseSalaryField ='Others' 
			BEGIN 
				Set @Temp =  str(@BaseSalary)+ ' AS BaseSalary, '
			END
		ELSE
			IF  @BaseSalaryField = 'SuggestSalary'
				Set @Temp =  '(Select SuggestSalary From HT1403 Where EmployeeID=HT2400.EmployeeID  and DivisionID = '''+@DivisionID+''' ) AS BaseSalary, '
			ELSE
				Set @Temp =  @BaseSalaryField+' AS BaseSalary, '
	END
	

If @MethodID<>'P06' ---- Khong phai luong cong trinh
	BEGIN
		SET @sSQL =' 	
				SELECT	NULL AS ProjectID, TranMonth, TranYear,  
						EmployeeID, DivisionID, DepartmentID, 
						'+@Temp+' TeamID, 
						'+@ListOfCo+' AS GeneralCo,
						IsJobWage
				FROM	HT2400
				WHERE 	DivisionID ='''+@DivisionID+''' and
						TranMonth ='+str(@TranMonth)+' and
						TranYear ='+str(@TranYear)+'  and
						IsJobWage = 1 AND -- Lương khoán
						DepartmentID IN (SELECT DepartmentID FROM HT5004 WHERE PayrollMethodID ='''+@PayrollMethodID+'''   AND DivisionID = '''+@DivisionID+''' ) '	
		
		IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE ='V' AND NAME=  'HV5009')
			EXEC ('CREATE VIEW HV5009 AS '+@sSQL)
		ELSE
			EXEC (' ALTER VIEW HV5009 AS  '+@sSQL)
	END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

