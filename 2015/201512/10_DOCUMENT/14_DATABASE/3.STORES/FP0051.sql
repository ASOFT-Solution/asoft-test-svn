IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[FP0051]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[FP0051]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Báo cáo theo dõi khấu hao TSCĐ
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 17/11/2015 by Phương Thảo
---- Modified on ... by ...
-- <Example>
/********************************************  
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]  
'********************************************/  
---- exec FP0051 @DivisionID=N'GS',@FromMonth=9,@FromYear=2015,@ToMonth=11,@ToYear=2015,@IsMonth=1  
  
CREATE PROCEDURE [dbo].[FP0051]    
    @DivisionID AS nvarchar(50),  
    @FromMonth as int,  
    @FromYear as int,  
    @ToMonth as int,  
    @ToYear as int,
	@IsMonth as tinyint
      
 AS  
declare   
	@FromPeriod as int,  
	@ToPeriod as int,
	@FromPeriod_Year as int,  
	@ToPeriod_Year as int,  
	@sSQL AS nvarchar(MAX),  
	@sSQL1 AS nvarchar(MAX)
	
set @FromPeriod = @FromMonth + @FromYear * 100  
set @ToPeriod = @ToMonth + @ToYear * 100  

SELECT @sSQL = '', @sSQL1 = ''
  

SELECT	AT1504.AssetID, AT1504.DivisionID, Sum(AT1504.DepAmount) as DepAmount,
		MAX(AT1504.ObjectID) AS ObjectID, MAX(AT1504.VoucherNo) AS VoucherNo,
		Convert(NVarchar(50),'') AS Serial, 
		Convert(NVarchar(50),'') AS Model, 
		Convert(NVarchar(50),'') AS ItemNo, 
		(Case when str(@IsMonth ) = 0 Then 
			Case When  TranMOnth <10 then '0'+rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) else    
										 rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) End 
		ELSE
		Case When str(@IsMonth ) = 1 Then (select Quarter from FV9999 Where DivisionID = AT1504.DivisionID and TranMonth = AT1504.TranMonth and TranYear = AT1504.TranYear) else   
		Ltrim(Rtrim(str(TranYear))) END END ) as MonthYear,
		AT1503.AssetName, AT1503.ConvertedAmount, AT1503.DepartmentID, AT1503.DepPeriods,
		CONVERT(Decimal(28,8),0) AS AddCostAmount	
INTO #FP0051_AT1504_1
FROM AT1504
LEFT JOIN AT1503 ON AT1503.AssetID = At1504.AssetID and AT1503.DivisionID = At1504.DivisionID 
WHERE AT1504.TranMonth+AT1504.TranYear*100 between str(@FromPeriod)  and str(@ToPeriod ) 
AND AT1504.DivisionID = @DivisionID 
GROUP BY AT1504.AssetID, AT1504.DivisionID, at1504.TranMonth, at1504.TranYear, 
		AT1503.AssetName, AT1503.ConvertedAmount, AT1503.DepartmentID, AT1503.DepPeriods


UPDATE T1
SET		AddCostAmount = ResidualNewValue  - ResidualOldValue
FROM #FP0051_AT1504_1	T1
INNER JOIN AT1506 T2 ON T1.DivisionID = T2.DivisionID AND T1.AssetID = T2.AssetID


SELECT * FROM #FP0051_AT1504_1


--IF EXISTS (SELECT TOP 1 1 FROM #FP0051_AT1504_2)
--BEGIN 
--	SELECT @sSQL = @sSQL +
--	'
--	SELECT	*
--	FROM	
--	(
--	SELECT	*			
--	FROM	#FP0051_AT1504_1	
--	) P
--	PIVOT
--	(SUM(DepAmount) FOR MonthYear IN ('
--	SELECT	@sSQL1 = @sSQL1 + CASE WHEN @sSQL1 <> '' THEN ',' ELSE '' END + '['+''+MonthYear+''+']'
--	FROM	#FP0051_AT1504_2
	
--	SELECT	@sSQL1 = @sSQL1 +')
--	) As T'
	
--END
--ELSE 
--SELECT * FROM #FP0051_AT1504_1 WHERE 1 = 0


--PRINT @sSQL
--PRINT @sSQL1
EXEC(@sSQL+ @sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

