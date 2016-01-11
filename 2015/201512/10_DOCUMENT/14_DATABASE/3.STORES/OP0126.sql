IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0126]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0126]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 10/02/2014
---- Purpose : Hiển thị danh sách nhân viên ở màn hình giáng cấp (Sinolife)
---- OP0126 'AS','01/2012'

CREATE PROCEDURE [dbo].[OP0126]
	@DivisionID nvarchar(50),
	@Quarter nvarchar(8)
	
AS

DECLARE @FromMonth int,
		@ToMonth int,
		@TranYear int
		
SELECT TOP 1 @FromMonth = TranMonth FROM OV9999 WHERE DivisionID = @DivisionID And [Quarter] = @Quarter ORDER BY TranMonth
SELECT TOP 1 @ToMonth = TranMonth FROM OV9999 WHERE DivisionID = @DivisionID And [Quarter] = @Quarter ORDER BY TranMonth DESC
SELECT TOP 1 @TranYear = TranYear FROM OV9999 WHERE DivisionID = @DivisionID And [Quarter] = @Quarter ORDER BY TranMonth

SELECT	EmployeeID, EmployeeName, LevelNo, LevelName, ManagerID, ManagerName, QuarterAmount,
		(case when QuarterAmount < DownSales then 1 else 0 end) as IsDownLevel
FROM (
SELECT	AT1202.ObjectID as EmployeeID, AT1202.ObjectName as EmployeeName, AT1202.LevelNo,
		AT0101.LevelName, Isnull(AT0101.DownSales,0) as DownSales,
		AT1202.ManagerID, AT1202.ManagerID + ' - ' + T02.ObjectName as ManagerName,
		
		(Select SUM(OrderAmount) From OT0123
		Where DivisionID = @DivisionID And SalesmanID = AT1202.ObjectID	And YEAR(OrderDate) = @TranYear
				And (MONTH(OrderDate) between @FromMonth and @ToMonth)) as QuarterAmount			
		
FROM AT1202
LEFT JOIN AT0101 On AT1202.DivisionID = AT0101.DivisionID And AT1202.LevelNo = AT0101.LevelNo
LEFT JOIN AT1202 T02 On AT1202.DivisionID = T02.DivisionID And AT1202.ManagerID = T02.ObjectID

WHERE AT1202.DivisionID = @DivisionID AND AT1202.ObjectTypeID = 'NV'--- AND AT1202.LevelNo <> 0
) A

ORDER BY LevelNo, EmployeeID