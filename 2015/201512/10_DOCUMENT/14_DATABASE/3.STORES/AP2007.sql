IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2007]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP2007]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
---- Created by Nguyen Van Nhan, Date 08/12/2003.
---- Purpose: Bao cao ton kho theo kho theo tai khoan
---- Edited by Nguyen Quoc Huy, Date 06/11/2006
---- Edited by: Dang Le Bao Quynh; Date 04/07/2008
---- Purpose: Them truong WareHouseName
---- Modified by Thanh Sơn on 16/07/2014: lấy dữ liệu trực tiếp từ store, không sinh ra view AV2007
---- Modified by Mai Duyen on 16/01/2015: Bo sung AT1302.Barcode
CREATE PROCEDURE [dbo].[AP2007]
       @DivisionID AS nvarchar(50) ,
       @FromMonth AS int ,
       @FromYear AS int ,
       @ToMonth AS int ,
       @ToYear AS int ,
       @WareHouseID AS nvarchar(50) ,
       @FromAccountID AS nvarchar(50) ,
       @ToAccountID AS nvarchar(50)
AS
DECLARE
        @sSQLSelect AS nvarchar(4000) ,
        @sSQLFrom AS nvarchar(4000) ,
        @sSQLWhere AS nvarchar(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)

--B/c cho 1 ky
IF @FromMonth + @FromYear * 100 = @ToMonth + 100 * @ToYear
   BEGIN
         SET @sSQLSelect = '
Select   AT2008.DivisionID, AT2008.WareHouseID, AT1303.WareHouseName,AT2008.InventoryID, InventoryName,
	AT1302.Barcode,
	AT1302.UnitID, AT1302.InventoryTypeID,
	AT1302.S1, AT1302.S2, AT1302.S3,AT1304.UnitName,
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
	AT2008.InventoryAccountID, AT1005.AccountName,  
	Sum(isnull(BeginQuantity,0)) as BeginQuantity,
	sum(isnull(EndQuantity,0)) as EndQuantity,
	Sum(isnull(DebitQuantity,0)) as DebitQuantity,
	Sum(isnull(CreditQuantity,0)) as CreditQuantity,
	Sum(isnull(BeginAmount,0)) as BeginAmount,
	Sum(isnull(EndAmount,0)) as EndAmount,
	Sum(isnull(DebitAmount,0)) as DebitAmount,
	Sum(isnull(CreditAmount,0)) as CreditAmount,
	Sum(isnull(InDebitAmount,0)) as InDebitAmount,
	Sum(isnull(InCreditAmount,0)) as InCreditAmount,
	Sum(isnull(InDebitQuantity,0)) as InDebitQuantity,
	Sum(isnull(InCreditQuantity,0)) as InCreditQuantity'
         SET @sSQLFrom = ' From AT2008 	inner join AT1302 on AT1302.InventoryID =AT2008.InventoryID and AT1302.DivisionID =AT2008.DivisionID
		inner join AT1304 on AT1304.UnitID = AT1302.UnitID and AT1304.DivisionID = AT1302.DivisionID
		Left join AT1005 on AT1005.AccountID = AT2008.InventoryAccountID and AT1005.DivisionID = AT2008.DivisionID
		Left Join AT1303 On AT2008.WareHouseID = AT1303.WareHouseID and AT2008.DivisionID = AT1303.DivisionID'

         SET @sSQLWhere = ' Where 	--AT1302.Disabled = 0 and
	AT2008.DivisionID =''' + @DivisionID + ''' and
	(AT2008.InventoryAccountID between ''' + @FromAccountID + ''' and ''' + @ToAccountID + ''') and
	AT2008.WareHouseID like ''' + @WareHouseID + ''' and
	( TranMonth  +100*TranYear  between ' + @FromMonthYearText + ' and ' + @ToMonthYearText + ') 
Group by AT2008.DivisionID, AT2008.WareHouseID, AT1303.WareHouseName, AT2008.InventoryID,	InventoryName,	AT1302.Barcode, AT1302.UnitID,	AT1304.UnitName, 	AT1302.InventoryTypeID, AT1302.S1, AT1302.S2,  AT1302.S3,   
		AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, AT2008.InventoryAccountID, AT1005.AccountName '
   END
ELSE --B/c cho nhieu ky
   BEGIN
         SET @sSQLSelect = '
Select   AT2008.DivisionID, AT2008.WareHouseID, AT1303.WareHouseName, AT2008.InventoryID, AT1302.InventoryName,
	AT1302.Barcode,
	AT1302.UnitID,AT1304.UnitName,	
	AT2008.InventoryAccountID, AT1302.InventoryTypeID,
	AT1005.AccountName,
	AT1302.S1, AT1302.S2, AT1302.S3,
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
	BeginQuantity = isnull((Select Sum(isnull(BeginQuantity,0)) From AT2008 T08 Where 	T08.InventoryID = AT2008.InventoryID and 
									T08.InventoryAccountID = AT2008.InventoryAccountID and
									T08.DivisionID = ''' + @DivisionID + ''' and
									T08.TranMonth + T08.TranYear*100 = ' + @FromMonthYearText + ' and
									T08.WareHouseID like ''' + @WareHouseID + '''  ),0) ,
	EndQuantity = isnull((Select Sum(isnull(EndQuantity,0)) From AT2008 T08 Where 	T08.InventoryID = AT2008.InventoryID and 
									T08.InventoryAccountID = AT2008.InventoryAccountID and
									T08.DivisionID = ''' + @DivisionID + ''' and
									T08.TranMonth + T08.TranYear*100 = ' + @ToMonthYearText + ' and
									T08.WareHouseID like ''' + @WareHouseID + '''  ) ,0),
	sum(isnull(DebitQuantity,0)) as DebitQuantity,
	sum(isnull(CreditQuantity,0)) as CreditQuantity,
	BeginAmount = isnull((Select Sum(isnull(BeginAmount,0)) From AT2008 T08 Where 	T08.InventoryID = AT2008.InventoryID and 
									T08.InventoryAccountID = AT2008.InventoryAccountID and
									T08.DivisionID = ''' + @DivisionID + ''' and
									T08.TranMonth + T08.TranYear*100 = ' + @FromMonthYearText + ' and
									T08.WareHouseID like ''' + @WareHouseID + '''  ),0) ,
	EndAmount = isnull((Select Sum(isnull(EndAmount,0)) From AT2008 T08 Where 	T08.InventoryID = AT2008.InventoryID and 
									T08.InventoryAccountID = AT2008.InventoryAccountID and
									T08.DivisionID = ''' + @DivisionID + ''' and
									T08.TranMonth + T08.TranYear*100 = ' + @ToMonthYearText + ' and
									T08.WareHouseID like ''' + @WareHouseID + '''  ) ,0),
	
	Sum(isnull(DebitAmount,0)) as DebitAmount,
	sum(isnull(CreditAmount,0)) as CreditAmount,
	Sum(isnull(InDebitAmount,0)) as InDebitAmount,
	Sum(isnull(InCreditAmount,0)) as InCreditAmount,
	Sum(isnull(InDebitQuantity,0)) as InDebitQuantity,
	Sum(isnull(InCreditQuantity,0)) as InCreditQuantity '
         SET @sSQLFrom = 'From AT2008 	inner join AT1302 on At1302.InventoryID =AT2008.InventoryID and At1302.DivisionID =AT2008.DivisionID
		inner join AT1304 on AT1304.UnitID = AT1302.UnitID and AT1304.DivisionID = AT1302.DivisionID
		Left join AT1005 on AT1005.AccountID = AT2008.InventoryAccountID and AT1005.DivisionID = AT2008.DivisionID
		Left Join AT1303 On AT2008.WareHouseID = AT1303.WareHouseID and AT2008.DivisionID = AT1303.DivisionID '
         SET @sSQLWhere = 'Where --AT1302.Disabled = 0 and
	AT2008.DivisionID =''' + @DivisionID + ''' and
	(AT2008.InventoryAccountID between ''' + @FromAccountID + ''' and ''' + @ToAccountID + ''') and
	AT2008.WareHouseID like ''' + @WareHouseID + ''' and
	( TranMonth  +100*TranYear  between ' + @FromMonthYearText + ' and ' + @ToMonthYearText + ') 
Group by AT2008.DivisionID, AT2008.WareHouseID, AT1303.WareHouseName, AT2008.InventoryID,	AT1302.InventoryName, AT1302.Barcode,	AT1302.UnitID,	AT1304.UnitName,
	 AT2008.InventoryAccountID, 	AT1302.InventoryTypeID, 	AT1005.AccountName,
	AT1302.S1,	AT1302.S2, 	AT1302.S3 , AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03
 '
END

IF EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2017' )
   BEGIN
         DROP VIEW AV2017
   END
EXEC ( ' Create view AV2017 as '+ @sSQLSelect + @sSQLFrom + @sSQLWhere)

SET @sSQLSelect = ' Select * From AV2017 		
Where 	(BeginQuantity <> 0 or EndQuantity<>0 or DebitQuantity<>0 or CreditQuantity<>0 or BeginAmount<>0 or EndAmount <>0 or DebitAmount<>0 or
	CreditAmount<>0) '

IF EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2007' )
   BEGIN
         DROP VIEW AV2007
   END
EXEC (@sSQLSelect )

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
