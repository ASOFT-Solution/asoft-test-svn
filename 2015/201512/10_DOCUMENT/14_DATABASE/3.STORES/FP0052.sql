IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[FP0052]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[FP0052]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Báo cáo theo dõi khấu hao TSCĐ (Cusomize Meiko)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
--- Create on 17/11/2015 by Phương Thảo
---- Modified on ... by ...
---- exec FP0052 @Divisionid=N'GS',@FromPeriod=201511,@ToPeriod=201512
  
CREATE PROCEDURE [dbo].[FP0052]    
    @DivisionID AS nvarchar(50),  
    @FromPeriod as int,  
    @ToPeriod as int
   
      
 AS  
declare   
	@FromYear as int,  
	@ToYear as int,
	@sSQL AS nvarchar(MAX),  
	@sSQL1 AS nvarchar(MAX),  
	@sqlTemp AS nvarchar(MAX),
	@sSQL2 AS NVARCHAR(MAX), 
	@sSQL3 AS NVARCHAR(MAX),
	@sFROM AS NVARCHAR(MAX),  
	@sWHERE AS NVARCHAR(MAX),  
   
	@GroupID as nvarchar(250),  
	@tmp cursor,  
	@i as int,
	@BeginMonth as int   


set @FromYear = LTRIM(RTRIM(LEFT(@FromPeriod,4)))
set @ToYear = LTRIM(RTRIM(LEFT(@FromPeriod,4))) 

  
----- Lay bao cao so chi tiet TSCD-----------------------  
set @sSQL = '   
SELECT	AT1503.DivisionID,  
		AT1503.AssetID,  
		AT1503.AssetName,   
		AT1503.AssetGroupID, 
		AT1501.AssetGroupName,  
		--AT1503.ConvertedAmount AS OldConvertedAmount,
		-- Nguyen gia  
		 (Case when exists (select top 1 AssetID   
			  from AT1506   
			  Where AssetID = AT1503.AssetID and DivisionID = AT1503.DivisionID  
			   and AT1506.TranMonth + 100*AT1506.TranYear <= ' + str(3+@FromYear*100) + ')  
		 Then (select top 1 AT1506.ConvertedNewAmount   
		   From AT1506   
		   Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID  
			and AT1506.TranMonth + 100*AT1506.TranYear <=' + str(3+@FromYear*100) + ' 
		   Order by AT1506.TranYear Desc,AT1506.TranMonth Desc)  
		 Else AT1503.ConvertedAmount end) as ConvertedAmount,   
		 
		 -- Khau hao luy ke tu 31/3 --> thoi diem in
		 DepAmount = isnull((Select Sum(DepAmount)   
					  From AT1504   
					  Where  DivisionID = AT1503.DivisionID   
						and AssetID = At1503.AssetID   
						and AT1504.TranMonth + AT1504.TranYear * 100 between ' + str(4+@FromYear*100) + ' and ' + str(@ToPeriod) + N'),0),

		-- Khau hao luy ke tinh den 31/3
		DepAmountInYear = isnull((Select Sum(DepAmount)   
		From AT1504   
		Where  DivisionID = AT1503.DivisionID   
		and AssetID = At1503.AssetID   
		and AT1504.TranMonth + AT1504.TranYear * 100 <= ' + str(3+@FromYear*100)+ N'),0),

		 
		-- Tang trong ky   (so với 31/3)
		 Isnull((Case when exists (select top 1 AssetID   
			  from AT1506   
			  Where AT1506.AssetID = AT1503.AssetID   
			  and AT1503.DivisionID = AT1503.DivisionID  
			  and AT1506.ConvertedOldAmount < AT1506.ConvertedNewAmount  
			  and AT1506.TranMonth + 100*AT1506.TranYear between ' + str(4+@FromYear*100) + ' and  ' + str(@ToPeriod) + ')   
         
		 Then (select sum(AT1590.ConvertedAmount)  
		   From AT1506 inner join AT1590 on AT1590.DivisionID = AT1506.DivisionID   
		   and AT1590.VoucherID = AT1506.RevaluateID  
		   Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID  
			and AT1506.TranMonth + 100*AT1506.TranYear between' + str(4+@FromYear*100) + ' and ' + str(@ToPeriod ) + ')  
     
		 Else (Select AT03.ConvertedAmount   
		   From AT1503 AT03   
		   Where AT03.AssetID = AT1503.AssetID and AT03.DivisionID = AT1503.DivisionID   
		   and Month(AT1503.EstablishDate) + Year(AT1503.EstablishDate)*100 between   ' +  str(4+@FromYear*100) + 'and ' + str(@ToPeriod ) + ')end),0) as DeConvertedAmount,   '


Set @sSQL1 = N' 
-- Giam trong ky   (từ thời điểm in so với 31/3)
 Isnull((Case when exists (select top 1 AssetID    from AT1523     
      Where AssetID = AT1503.AssetID and DivisionID = AT1503.DivisionID    
   and AT1523.ReduceMonth + 100*AT1523.ReduceYear between ' +  str(4+@FromYear*100) + ' and ' + str(@ToPeriod) + ')   
 Then (select top 1 AT1523.ConvertedAmount     
   From AT1523     
   Where AT1523.AssetID = AT1503.AssetID and AT1523.DivisionID = AT1503.DivisionID    
    and AT1523.ReduceMonth + 100*AT1523.ReduceYear between  ' +  str(4+@FromYear*100) + ' and ' + str(@ToPeriod) + '   
   Order by AT1523.ReduceYear Desc,AT1523.ReduceMonth Desc)   
   when exists (select top 1 AssetID   
      from AT1506   
      Where AT1503.AssetID = AT1503.AssetID   
      and AT1503.DivisionID = AT1503.DivisionID  
      and AT1506.ConvertedOldAmount > AT1506.ConvertedNewAmount  
      and AT1506.TranMonth + 100*AT1506.TranYear between ' + str(4+@FromYear*100)+ ' and  ' + str(@ToPeriod) + ')  
        
   Then (select sum(AT1590.ConvertedAmount)  
   From AT1506 inner join AT1590 on AT1590.DivisionID = AT1506.DivisionID   
   and AT1590.VoucherID = AT1506.RevaluateID  
   Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID  
    and AT1506.TranMonth + 100*AT1506.TranYear between' + str(4+@FromYear*100) + ' and ' + str(@ToPeriod ) + ')   
   Else 0 end ),0) as CrConvertedAmount,  
        
 -- Hao mon luy ke (tính đến 31/03)
 AccuDepAmount = ( isnull (AT1503.ConvertedAmount,0)    
   - isnull(AT1503.ResidualValue,0)  
   + isnull((Select Sum(DepAmount)   
      From AT1504   
      Where DivisionID = AT1503.DivisionID and AssetID = At1503.AssetID   
      and AT1504.TranMonth+AT1504.TranYear*100 <= ' + str(3+@FromYear*100) + ') ,0))  
 '
   

SET @sFROM = N'  
INTO #FF0052_TS
FROM AT1503     
LEFT JOIN AT1501 on At1501.AssetGroupID = AT1503.AssetGroupID AND At1501.DivisionID = AT1503.DivisionID   
LEFT JOIN AT1523 on AT1523.AssetID = AT1503.AssetID AND AT1523.DivisionID = AT1503.DivisionID  
'  
SET @sWHERE = N'  
WHERE  AT1503.DivisionID like N''' + @DivisionID + ''' and    
 Month(AT1503.EstablishDate) + Year(AT1503.EstablishDate)*100 <= ' + str(@ToPeriod) + '  
  
'

      
Set @sSQL2='     
SELECT AT1603.DivisionID,    
 AT1603.ToolID,    
 AT1603.ToolName,     
  AT1603.CreditAccountID as GroupID, AT1005.AccountName as GroupName,
-- Nguyen gia    
 (Case when exists (select top 1 ToolID     
      from AT1606 Where ToolID = AT1603.ToolID and ReVoucherID = AT1603.VoucherID and DivisionID = AT1603.DivisionID    
       and AT1606.TranMonth + 100 * AT1606.TranYear <= ' + str(3+@FromYear*100) + ')    
 Then (select top 1 AT1606.ConvertedNewAmount    
   From AT1606     
   Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
    and AT1606.TranMonth + 100 * AT1606.TranYear <= ' + str(3+@FromYear*100) + '   
   Order by AT1606.TranYear Desc,AT1606.TranMonth Desc)    
 Else AT1603.ConvertedAmount end) as ConvertedAmount, 

 -- So phan bo (từ thời điểm in so với 31/03)
 DepAmount =isnull((Select sum (DepAmount)     
    from AT1604    
    Where AT1604.DivisionID like ''' + @DivisionID+ '''     
     and AT1603.ToolID=AT1604.ToolID and AT1603.VoucherID = AT1604.ReVoucherID    
     and AT1604.TranMonth + AT1604.Tranyear * 100 between ' + str(4+@FromYear*100) + ' and ' + cast(@ToPeriod as nvarchar(10)) + '),0), 

-- Hao mon luy ke (tính đến 31/03)
AccuDepAmount = isnull(DepPeriod,0)+(Select isnull(sum (DepAmount),0)     
     from AT1604      
     Where AT1604.DivisionID like ''' + @DivisionID + '''     
      and AT1603.ToolID = AT1604.ToolID and AT1603.VoucherID = AT1604.ReVoucherID    
      and AT1604.TranMonth + AT1604.Tranyear * 100 <= ' + cast(3+@FromYear*100 as nvarchar(10)) + ')
INTO #FF0052_CCDC     
FROM AT1603 Inner join AT1005 on AT1005.DivisionID = AT1603.DivisionID and AT1005.AccountID = AT1603.CreditAccountID       
WHERE AT1603.DivisionID like ''' +  @DivisionID + '''      
and AT1603.BeginMonth + AT1603.BeginYear * 100 <= ' + str(@ToPeriod) + '   
 '    
      
Set @sSQL3=N' 
SELECT	DivisionID, AssetGroupID, AssetGroupName,
		SUM(ConvertedAmount) AS ConvertedAmount,
		SUM(DepAmountInYear) AS DepAmountInYear,
		SUM(DepAmount) AS DepAmount, 
		SUM(DeConvertedAmount) AS DeConvertedAmount,
		SUM(CrConvertedAmount) AS CreConvertedAmount,
		SUM(AccuDepAmount) AS AccuDepAmount
FROM	#FF0052_TS
GROUP BY DivisionID, AssetGroupID, AssetGroupName
UNION ALL
SELECT	DivisionID, GroupID AS AssetGroupID, GroupName AS AssetGroupName,
		SUM(ConvertedAmount) AS ConvertedAmount,
		NULL AS DepAmountInYear,
		SUM(DepAmount) AS DepAmount,
		NULL AS DeConvertedAmount, NULL AS CrConvertedAmount,
		SUM(AccuDepAmount) AS AccuDepAmount
FROM	#FF0052_CCDC
GROUP BY DivisionID, GroupID, GroupName
UNION ALL
SELECT	AV5000.DivisionID, AV5000.AccountID, AT1005.AccountName,
		SUM(CASE WHEN AV5000.TranYear * 100 + TranMonth < ' + str(4+@FromYear*100) + ' OR AV5000.TransactionTypeID = ''' + 'T00' + ''' 
                            THEN ISNULL(SignAmount, 0)  ELSE 0 
                    END) AS ConvertedAmount,
		NULL AS DepAmountInYear,
		NULL AS DepAmount,
		NULL AS DeConvertedAmount, NULL AS CrConvertedAmount,
		NULL AS AccuDepAmount
FROM	AV5000 Inner join AT1005 on AT1005.DivisionID = AV5000.DivisionID and AT1005.AccountID = AV5000.AccountID  
WHERE AV5000.AccountID LIKE ''241%'' 
GROUP BY AV5000.DivisionID, AV5000.AccountID, AT1005.AccountName
'
     
--PRINT (@sSQL)  
--PRINT (@sqlTemp)  
--PRINT (@sSQL1)  
--PRINT (@sFROM)  
--PRINT (@sWHERE)  
--PRINT (@sSQL2)  
--PRINT (@sSQL3)  

EXEC (@sSQL + @sSQL1 + @sFROM + @sWHERE+ @sSQL2+ @sSQL3)  

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

