IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2426]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2426]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Xu ly In cham tháng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 17/09/2004 by Vo Thanh Huong
---- 
---- Modified on 14/12/2010 by Huynh Trung Dung : Them tham so @ToDepartmentID
---- Modified on 10/01/2014 by Le Thi Thu Hien : Bo sung them HV00.BaseSalary, HV00.InsuranceSalary, TeamName cho Vietroll
-- <Example>
---- 


CREATE PROCEDURE [dbo].[HP2426]		
			@DivisionID nvarchar(50),
			@DepartmentID	nvarchar(50),	
			@ToDepartmentID	nvarchar(50),	
			@TeamID nvarchar(50),
			@EmployeeID nvarchar(50),					
			@FromTranMonth int,
			@FromTranYear int,
			@ToTranMonth int,
			@ToTranYear int,
			@lstOfAbsent nvarchar(250)			
AS
DECLARE @sSQL1 nvarchar(max),
		@sSQL2 nvarchar(max),	
		@AbsentTypeID nvarchar(max),
		@DateAmount int,
		@i int,
		@AbsentTypeName nvarchar(50)

Set @AbsentTypeID = case when @lstOfAbsent = '%' then  ' like ''' +@lstOfAbsent + ''''  else ' in (''' + replace(@lstOfAbsent, ',',''',''') + ''')' end 

Set @sSQL1 = '
	SELECT		DISTINCT H00.AbsentTypeID, H00.DivisionID, Caption, Orders, UnitID
	FROM		HT2402 H00 
	INNER JOIN	HT1013 H01 
		ON		H00.AbsentTypeID = H01.AbsentTypeID 
				AND H00.DivisionID = H01.DivisionID
	WHERE	H00.DivisionID = N''' + @DivisionID + ''' and
			DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
			Isnull(TeamID, '''') like Isnull(''' + @TeamID + ''', '''') and
			TranMonth + TranYear*100 between ' + cast(@FromTranMonth + @FromTranYear*100 as nvarchar(10)) + ' and ' +  
			cast(@ToTranMonth + @ToTranYear*100 as nvarchar(10)) +' and
			H00.AbsentTypeID ' + @AbsentTypeID 
			
			 

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'HV2415')
	EXEC('CREATE VIEW HV2415 ----TAO BOI HP2424
			AS ' + @sSQL1)
ELSE
	EXEC('ALTER VIEW HV2415 ----TAO BOI HP2424
			AS ' + @sSQL1)

Set @sSQL2 = '
	SELECT  H00.DivisionID, H00.DepartmentID,  AT00.DepartmentName,  HV00.TeamName,
			H00.EmployeeID, FullName, 
			CASE WHEN Birthday is Null then Null else convert(Varchar(10),Birthday,103) end as Birthday , 
			H00.AbsentTypeID,  
			sum(AbsentAmount) as AbsentAmount, 
			HV00.Orders, DutyName, 
			TranMonth, TranYear,
			HV00.BaseSalary, HV00.InsuranceSalary
	FROM		HT2402  H00  
	LEFT JOIN	HV1400 HV00 
		ON		HV00.EmployeeID = H00.EmployeeID 
				AND HV00.DivisionID = H00.DivisionID 
	INNER JOIN	AT1102  AT00 
		ON		AT00.DepartmentID = H00.DepartmentID 
				AND AT00.DivisionID = H00.DivisionID 
	WHERE	H00.DivisionID = N''' + @DivisionID + ''' and
			H00.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
			Isnull(H00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and  
			H00.EmployeeID like ''' + @EmployeeID + ''' and 	
			H00.TranMonth + H00.TranYear*100 between ' + cast(@FromTranMonth + @FromTranYear*100 as nvarchar(10)) + ' and ' +  
			cast(@ToTranMonth + @ToTranYear*100 as nvarchar(10))+ '  and
			H00.AbsentTypeID ' + @AbsentTypeID + ' 

	GROUP BY	H00.DivisionID, H00.DepartmentID,  AT00.DepartmentName, HV00.TeamName, H00.EmployeeID, FullName, 
				Birthday, H00.AbsentTypeID, HV00.Orders,  DutyName, TranMonth, TranYear, HV00.BaseSalary, HV00.InsuranceSalary '
/*
Union
Select  H00.DivisionID, ''zzzzzzzz'' as DepartmentID, ''TOÅNG COÄNG'' as DepartmentName, '''' as EmployeeID, '''' asFullName, 
		NULL as Birthday,  H00.AbsentTypeID, sum( AbsentAmount) as AbsentAmount, 
		0 as Orders, '''' as DutyName
	From HT2402  H00  
	Where H00.DivisionID = ''' + @DivisionID + ''' and
		H00.DepartmentID like ''' + @DepartmentID + ''' and
		Isnull(H00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and  
		H00.EmployeeID like ''' + @EmployeeID + ''' and 	
		TranYear = ' + cast(@TranYear as nvarchar(4)) + ' and
		TranMonth = ' + cast(@TranMonth as nvarchar(2)) + 
	' Group by H00.DivisionID, H00.AbsentTypeID'
*/

IF NOT EXISTS (SELECT  1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'HV2424')
	EXEC('CREATE VIEW HV2424 ----TAO BOI HP2426
			AS '+ @sSQL2)
ELSE
	EXEC('ALTER VIEW HV2424 ----TAO BOI HP2426
			AS ' + @sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

