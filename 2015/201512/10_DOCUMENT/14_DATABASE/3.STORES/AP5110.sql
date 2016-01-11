IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5110]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP5110]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Nguyen Thi Ngoc Minh, Date 07/08/2004.
----- In So chi tiet ban hang (NKSC)
----- Last Edit: Thuy Tuyen loac ra ca phieu hang ban tra lai (TransactionTypeID = 'T24')
----- Edited by: [GS] [Thanh Nguyen] [29/07/2010]
----- Edited by: [GS] [Anh Tuan] [18/10/2010] (Them kiem tra null cho Quantity de ko bi loi divide by zero)
----- Modified by Thanh Sơn on 22/01/2015: Lấy thêm trường VATRate
----- Modified by Thanh Thịnh on 23/09/2015: Lấy dữ liệu năm từ tháng bắt đầu niên độ TC
----- Modified by Tiểu Mai on 18/12/2015: Bổ sung trường ObjectID


CREATE PROCEDURE [dbo].[AP5110]
		@DivisionID AS nvarchar(50),
		@FromMonth AS INT,
		@FromYear AS INT,
		@ToMonth AS INT,
		@ToYear AS INT,
		@IsMonth as tinyint,
		@FromInventoryID as nvarchar(50),
		@ToInventoryID as nvarchar(50),
		@IncomeAccIDFrom as nvarchar(50),
		@IncomeAccIDTo as nvarchar(50),
		@ImExTaxAccID AS nvarchar(50),
		@SpecialTaxAccID AS nvarchar(50),
		@DecreaseAccIDFrom as nvarchar(50),
		@DecreaseAccIDTo as nvarchar(50),
		@PrimeCostAccID as nvarchar(50)
AS

DECLARE 	@sqlSELECT AS nvarchar(4000),
		@sqlWHERE AS nvarchar(4000),
		@strWHERE as nvarchar(4000)

If @IsMonth = 0
	Set @strWHERE = N'
	and TranMonth + TranYear*100 between ''' + ltrim(str(@FromMonth+@FromYear*100)) + N''' and ''' + ltrim(str(@ToMonth+@ToYear*100)) + N''''
Else
	Set @strWHERE = N'
	and TranMonth + TranYear*100 between ''' + ltrim(str(@FromMonth+@FromYear*100)) + N''' and ''' + ltrim(str(@ToMonth+@ToYear*100)) + N''''

Set @sqlSELECT = N'
Select distinct
	AV5000.DivisionID, VoucherID, TransactionID, VoucherNo, VoucherDate, AV5000.CreateDate, InvoiceNo, InvoiceDate, Serial, AV5000.ObjectID,
	isnull(TDescription, isnull(BDescription,VDescription)) as Description,
	CorAccountID, AV5000.InventoryID, AT1302.InventoryName,
	(Case when (AV5000.AccountID not in (N''' + @ImExTaxAccID + N''', N''' + @SpecialTaxAccID + N''') or
		AV5000.AccountID not between N''' + @DecreaseAccIDFrom + N''' and N''' + @DecreaseAccIDTo + N''') then
		isnull(ConvertedAmount,0) else 0 end) as ConvertedAmount,
	(Case when ((AV5000.AccountID not in (N''' + @ImExTaxAccID + N''', N''' + @SpecialTaxAccID + N''') or
		AV5000.AccountID not between N''' + @DecreaseAccIDFrom + N''' and N''' + @DecreaseAccIDTo + N''')
		and (isnull(Quantity,0) <> 0)) then
		isnull(ConvertedAmount,0)/isnull(Quantity,0) else 0 end) as UnitPrice,
	(Case when (AV5000.AccountID not in (N''' + @ImExTaxAccID + N''', N''' + @SpecialTaxAccID + N''') or
		AV5000.AccountID not between N''' + @DecreaseAccIDFrom + N''' and N''' + @DecreaseAccIDTo + N''') then
		isnull(Quantity,0) else 0 end) as Quantity,
	(Case when AV5000.AccountID in (N''' + @ImExTaxAccID + N''', N''' + @SpecialTaxAccID + N''') then
		isnull(ConvertedAmount,0) else 0 end) as TaxConvertedAmount,
	(Case when AV5000.AccountID between N''' + @DecreaseAccIDFrom + N''' and N''' + @DecreaseAccIDTo + N''' then
		isnull(ConvertedAmount,0) else 0 end) as DecreaseConvertedAmount,	
	(Case when AV5000.AccountID like N''' + @PrimeCostAccID + N'%'' then
		isnull(ConvertedAmount,0) else 0 end) as PrimeCostConvertedAmount, A10.VATRate
From AV5000
LEFT JOIN AT1010 A10 ON A10.DivisionID = AV5000.DivisionID AND A10.VATGroupID = AV5000.VATGroupID
INNER JOIN AT1302 on AT1302.InventoryID = AV5000.InventoryID and AT1302.DivisionID = AV5000.DivisionID
'
set @sqlWHERE = 
N'Where AV5000.DivisionID = N''' + @DivisionID + N''' and
	(AV5000.InventoryID between N''' + @FromInventoryID + N''' and N''' + @ToInventoryID + N''') and
	AV5000.TransactionTypeID not in (N''T03'', N''T13'', N''T23'', N''T33'', N''T98'', N''T00'', N''T05'', N''T06'', N''T07'', N''T11'', N''T14'' ,N''T24'') and
	((AV5000.AccountID between N''' + @IncomeAccIDFrom + N''' and N''' + @IncomeAccIDTo + N''') or
	AV5000.AccountID in (N''' + @ImExTaxAccID + N''', N''' + @SpecialTaxAccID + N''', N''' + @PrimeCostAccID + N''') or
	(AV5000.AccountID between N''' + @DecreaseAccIDFrom + N''' and N''' + @DecreaseAccIDTo + N'''))' + @strWHERE + '
'

--print @strSQL
If not exists (Select top 1 1 From SysObjects Where name = 'AV5110' and Xtype ='V')
	Exec ('Create view AV5110 	--created by AP5110
		as '+@sqlSELECT + @sqlWHERE)
Else
	Exec ('Alter view AV5110

 	--created by AP5110
		as '+@sqlSELECT + @sqlWHERE)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
