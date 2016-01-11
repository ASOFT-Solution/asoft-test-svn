IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2999]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2999]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Bao Anh		Date: 24/09/2012
---- Purpose: Bao cao ton kho theo mat hang (co quy cach)
---- Example: AP2999 N'AS',1,1,2012,2012,'09/25/2012','09/25/2012',N'K01',N'K99',N'0000000001',N'SAOS.00002',0
---- Modifile by Khanh Van date 23/08/2013 customize cho 2T, bổ sung ConvertedQuantity

CREATE PROCEDURE [dbo].[AP2999]
       @DivisionID AS nvarchar(50) ,
       @FromMonth AS int ,
       @ToMonth AS int ,
       @FromYear AS int ,
       @ToYear AS int ,
       @FromDate AS datetime ,
       @ToDate AS datetime ,
       @FromWareHouseID AS nvarchar(50) ,
       @ToWareHouseID AS nvarchar(50) ,
       @FromInventoryID AS nvarchar(50) ,
       @ToInventoryID AS nvarchar(50) ,
       @IsDate AS tinyint
AS

DECLARE
		@sSQLSelect AS nvarchar(4000) ,
		@sSQLFrom AS nvarchar(4000) ,
		@sSQLWhere AS nvarchar(4000) ,
		@sSQLUnion AS nvarchar(4000), 
	@FromMonthYearText NVARCHAR(20), 
	@ToMonthYearText NVARCHAR(20), 
	@FromDateText NVARCHAR(20), 
	@ToDateText NVARCHAR(20),
	@strTime        AS NVARCHAR(4000)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

IF @IsDate = 1
    ---- xac dinh so lieu theo ngay
    SET @strTime = ' and (  D_C=''BD''   or VoucherDate < ''' + @FromDateText + ''') '
ELSE
    SET @strTime = ' and ( D_C=''BD'' or TranMonth+ 100*TranYear< ' + @FromMonthYearText + ' ) ' 

SET @sSQLSelect = ' Select 	DivisionID, WareHouseID,	InventoryID, InventoryName,
		 Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
		 UnitID, UnitName, Specification, Notes01, Notes02, Notes03, Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, SourceNo,	
	InventoryID+WareHouseID as Key1, 
		 S1, S2, S3 ,
		S1Name,  S2Name, S3Name,				
		Sum(SignQuantity) as BeginQuantity,
		Sum(SignConvertedQuantity) as BeginConvertedQuantity,
		Sum(SignMarkQuantity) as BeginMarkQuantity,
		Sum(SignAmount) as BeginAmount'

SET @sSQLFrom = ' From AV7000'
SET @sSQLWhere = ' Where 	DivisionID like ''' + @DivisionID + ''' and
		(WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''')  And
		(InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') '
Set @sSQLWhere = @sSQLWhere + @strTime+ ' '
Set @sSQLWhere = @sSQLWhere + N'
		
	Group by  DivisionID, WareHouseID,InventoryID,InventoryName, 
			Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
			UnitID, UnitName, Specification, Notes01, Notes02, Notes03, Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, SourceNo, 
			S1, S2, S3 ,S1Name,  S2Name, S3Name '

 
IF NOT EXISTS ( SELECT	1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV7018' )
	   BEGIN
			 EXEC ( ' Create view AV7018 --AP2999
			 as '+@sSQLSelect+@sSQLFrom+@sSQLWhere )
	   END
	ELSE
	   BEGIN
			 EXEC ( ' Alter view AV7018 as  --AP2999
			 '+@sSQLSelect+@sSQLFrom+@sSQLWhere )
	   END

IF @IsDate = 1
    ---- xac dinh so lieu theo ngay
    SET @strTime = ' and (VoucherDate  Between  ''' + @FromDateText + '''  and ''' + @ToDateText + '''  ) '
ELSE
    SET @strTime = ' and (TranMonth+ 100*TranYear Between ' + @FromMonthYearText + ' and  ' + @ToMonthYearText + '  ) ' 
    
SET @sSQLSelect = 'Select 	AV7018.DivisionID, AV7018.InventoryID,
		AT1302.InventoryName,
		Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
		AV7018.WareHouseID,
		AT1303.WareHouseName,
		AV7018.UnitID,
		AV7018.UnitName,
		AV7018.Specification, AV7018.Notes01, AV7018.Notes02, AV7018.Notes03, AV7018.Notes04, AV7018.Notes05, AV7018.Notes06, AV7018.Notes07, AV7018.Notes08, AV7018.Notes09, AV7018.Notes10, AV7018.Notes11, AV7018.Notes12, AV7018.Notes13, AV7018.Notes14, AV7018.Notes15, AV7018.SourceNo,	
		BeginQuantity,
		BeginConvertedQuantity,
		BeginMarkQuantity,
		BeginAmount,
		0 as DebitQuantity,
		0 as CreditQuantity,
		0 as DebitConvertedQuantity,
		0 as CreditConvertedQuantity,
		0 as DebitMarkQuantity,
		0 as CreditMarkQuantity,
		0 as DebitAmount,
		0 as CreditAmount,
		0 as EndQuantity,
		0 as EndMarkQuantity,
		0 as EndAmount'

	SET @sSQLFrom = ' From AV7018 inner join AT1302 on AT1302.InventoryID =AV7018.InventoryID and AT1302.DivisionID =AV7018.DivisionID
			inner join AT1303 on AT1303.WareHouseID = AV7018.WareHouseID  and AT1303.DivisionID =AV7018.DivisionID'

	SET @sSQLWhere = ' where 	(AV7018.WareHouseID between ''' + @FromWareHouseID + ''' and ''' + @ToWareHouseID + ''') and AV7018.Key1 not in 	(Select  (ltrim(rtrim(InventoryID)) + ltrim(rtrim(WareHouseID)))  as Key1 	From AV7000 	
	Where 	AV7000.DivisionID =''' + @DivisionID + ''' and
					(AV7000.WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''') and
					(AV7000.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') and
					AV7000.D_C in (''D'', ''C'') '
		
SET @sSQLWhere = @sSQLWhere + @strTime+ ')'

print @sSQLSelect+@sSQLFrom+@sSQLWhere
SET @sSQLUnion = 
' Union all
	Select 	AV7000.DivisionID, AV7000.InventoryID,
		AT1302.InventoryName,
		AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03, AV7000.Parameter04, AV7000.Parameter05,
		AV7000.WareHouseID,
		AT1303.WareHouseName,
		AV7000.UnitID, 
		AV7000.UnitName,
		AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04,AV7000.Notes05,AV7000.Notes06,AV7000.Notes07,AV7000.Notes08,AV7000.Notes09,AV7000.Notes10,AV7000.Notes11,AV7000.Notes12,AV7000.Notes13,AV7000.Notes14,AV7000.Notes15,AV7000.SourceNo,	
		isnull(AV7018.BeginQuantity,0) as BeginQuantity,
				isnull(AV7018.BeginConvertedQuantity,0) as BeginConvertedQuantity,
		isnull(AV7018.BeginMarkQuantity,0) as BeginMarkQuantity,
		isnull(AV7018.BeginAmount,0) as BeginAmount,
		Sum(Case when D_C = ''D'' then isnull(AV7000.ActualQuantity,0) else 0 end) as DebitQuantity,
		Sum(Case when D_C = ''C'' then isnull(AV7000.ActualQuantity,0) else 0 end) as CreditQuantity,
		Sum(Case when D_C = ''D'' then isnull(AV7000.ConvertedQuantity,0) else 0 end) as DebitConvertedQuantity,
		Sum(Case when D_C = ''C'' then isnull(AV7000.ConvertedQuantity,0) else 0 end) as CreditConvertedQuantity,
		Sum(Case when D_C = ''D'' then isnull(AV7000.MarkQuantity,0) else 0 end) as DebitMarkQuantity,
		Sum(Case when D_C = ''C'' then isnull(AV7000.MarkQuantity,0) else 0 end) as CreditMarkQuantity,
		Sum(Case when D_C = ''D'' then isnull(AV7000.ConvertedAmount,0) else 0 end) as DebitAmount,
		Sum(Case when D_C = ''C'' then isnull(AV7000.ConvertedAmount,0) else 0 end) as CreditAmount,
		0 as EndQuantity,
		0 as EndMarkQuantity,
		0 as EndAmount	From AV7000 
	left join AV7018 on AV7000.WareHouseID = AV7018.WareHouseID and AV7000.InventoryID = AV7018.InventoryID and AV7000.DivisionID = AV7018.DivisionID	and AV7000.Parameter01 = AV7018.Parameter01 and AV7000.Parameter02 = AV7018.Parameter02
and AV7000.Parameter03 = AV7018.Parameter03 and AV7000.Parameter04 = AV7018.Parameter04 and AV7000.Parameter05 = AV7018.Parameter05 AND AV7000.UnitID = AV7018.UnitID and AV7000.SourceNo = AV7018.SourceNo
			inner join AT1302 on AT1302.InventoryID = AV7000.InventoryID and AT1302.DivisionID = AV7018.DivisionID
			inner join AT1303 on AT1303.WareHouseID = AV7000.WareHouseID and AT1303.DivisionID = AV7018.DivisionID
			
	Where 	AV7000.DivisionID =''' + @DivisionID + ''' and
		(AV7000.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''') and
		(AV7000.WareHouseID between N''' + @FromWareHouseID + ''' and N''' + @ToWareHouseID + ''') and
		AV7000.D_C in (''D'', ''C'') '
		
SET @sSQLUnion = @sSQLUnion + @strTime+ ' '
Set @sSQLUnion = @sSQLUnion + N'	
	
	Group by  AV7000.DivisionID, AV7000.InventoryID, AT1302.InventoryName,
			AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03, AV7000.Parameter04, AV7000.Parameter05,
			AV7000.WareHouseID, AT1303.WareHouseName,AV7000.UnitName,
			AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04,AV7000.Notes05,AV7000.Notes06,AV7000.Notes07,AV7000.Notes08,AV7000.Notes09,AV7000.Notes10,AV7000.Notes11,AV7000.Notes12,AV7000.Notes13,AV7000.Notes14,AV7000.Notes15,AV7000.SourceNo,		
			AV7000.UnitID, 	AV7018.BeginQuantity,	AV7018.BeginConvertedQuantity,AV7018.BeginMarkQuantity, AV7018.BeginAmount  '


IF NOT EXISTS ( SELECT	1 FROM	sysObjects	WHERE	Xtype = 'V' AND Name = 'AV2089' )
   BEGIN
		 EXEC ( ' Create view AV2089 as --AP2999
		 '+@sSQLSelect+@sSQLFrom+@sSQLWhere+@sSQLUnion )
   END
ELSE
   BEGIN
		 EXEC ( ' Alter view AV2089 as  --AP2999
		 '+@sSQLSelect+@sSQLFrom+@sSQLWhere+@sSQLUnion )
   END

SET @sSQLSelect = 'Select 	DivisionID, InventoryID, InventoryName,
	Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
	WareHouseID,	WareHouseName,
	AV2089.UnitID, 
	AV2089.UnitName,
	AV2089.Specification, AV2089.Notes01, AV2089.Notes02, AV2089.Notes03, AV2089.Notes04, AV2089.Notes05, AV2089.Notes06, AV2089.Notes07, AV2089.Notes08, AV2089.Notes09, AV2089.Notes10, AV2089.Notes11, AV2089.Notes12, AV2089.Notes13, AV2089.Notes14, AV2089.Notes15, AV2089.SourceNo, 	
	Sum(BeginQuantity) as BeginQuantity,
	Sum(BeginConvertedQuantity) as BeginConvertedQuantity,
	Sum(BeginMarkQuantity) as BeginMarkQuantity,
	Sum(BeginAmount) as BeginAmount, 
	Sum(DebitQuantity) as DebitQuantity,
	Sum(CreditQuantity) as CreditQuantity,
	Sum(DebitConvertedQuantity) as DebitConvertedQuantity,
	Sum(CreditConvertedQuantity) as CreditConvertedQuantity,
	Sum(DebitMarkQuantity) as DebitMarkQuantity,
	Sum(CreditMarkQuantity) as CreditMarkQuantity,
	Sum(DebitAmount) as DebitAmount,
	Sum(CreditAmount) as CreditAmount,
	Sum(BeginQuantity) + sum(DebitQuantity) - sum(CreditQuantity) as EndQuantity,
		Sum(BeginConvertedQuantity) + sum(DebitConvertedQuantity) - sum(CreditConvertedQuantity) as EndConvertedQuantity,
	Sum(BeginMarkQuantity) + sum(DebitMarkQuantity) - sum(CreditMarkQuantity) as EndMarkQuantity,
	Sum(BeginAmount) + Sum(DebitAmount) - sum(CreditAmount) as EndAmount'

SET @sSQLFrom= ' From AV2089 '
set @sSQLWhere= ' Where (BeginQuantity <> 0 or BeginAmount <> 0 or DebitQuantity <> 0 or DebitAmount <> 0 or
	CreditQuantity <> 0 or CreditAmount <> 0 or EndQuantity <> 0 or EndAmount <> 0) and DivisionID = ''' + @DivisionID + '''
Group by  DivisionID, InventoryID, InventoryName,
	Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
	WareHouseID, WareHouseName, UnitID, UnitName,
	AV2089.Specification, AV2089.Notes01, AV2089.Notes02, AV2089.Notes03,AV2089.Notes04, AV2089.Notes05, AV2089.Notes06, AV2089.Notes07, AV2089.Notes08, AV2089.Notes09, AV2089.Notes10, AV2089.Notes11, AV2089.Notes12, AV2089.Notes13, AV2089.Notes14, AV2089.Notes15, AV2089.SourceNo 	 '




IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2009' )
   BEGIN
		 EXEC ( ' Create view AV2009 as  --AP2999
		 '+@sSQLSelect+@sSQLFrom+@sSQLWhere  )
   END
ELSE
   BEGIN
		 EXEC ( ' Alter view AV2009 as  --AP2999
		 '+@sSQLSelect+@sSQLFrom+@sSQLWhere  )
/*

Set @sSQL = 
'SELECT AV2099.*,  AT1304.UnitName  F
	ROM AV2099  inner join AT1304 on AT1304.UnitID = AV2099.UnitID
Where BeginQuantity <> 0 or BeginAmount <> 0 or DebitQuantity <> 0 or DebitAmount <> 0 or
	CreditQuantity <> 0 or CreditAmount <> 0 or EndQuantity <> 0 or EndAmount <>0 
 '

If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV2009')
	Exec(' Create view AV2009 as '+@sSQL)
Else
	Exec(' Alter view AV2009 as '+@sSQL)
*/
   END