/****** Object:  StoredProcedure [dbo].[AP0023]    Script Date: 07/28/2010 11:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





---- Created by Nguyen Van Nhan.
---- Date SaturDay, 31/05/2003.
---- Purpose: Loc ra cac phieu Nhap so du
---- Edit by Nguyen Quoc Huy, Date: 28/03/2007
--  Last Edit: Thuy Tuyen , date 02/04/2010
-- Bo sung cac thong tin DVT qui doi
---- Modified on 25/01/2013 by Bao Anh: Bổ sung các trường tham số Notes01 -> Notes15 (2T)
---- Modified on 10/08/2015 by Hoàng vũ: Bổ sung Phân quyền xem dữ liệu của người khác
---- Modified on 30/10/2015 by Tiểu Mai: Bổ sung 20 quy cách hàng hóa.
/********************************************
'* Edited by: [GS] [Tố Oanh] [28/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0023] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@UserID VARCHAR(50)

 AS
Declare @sSQL as nvarchar(4000)
		----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM WT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = AT2016.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = AT2016.CreateUserID '
				SET @sWHEREPer = ' AND (AT2016.CreateUserID = AT0010.UserID
										OR  AT2016.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		

----- Buoc  1 : Tra ra thong tin Master View AV0023

Set @sSQL='
Select 	AT2016.ReDeTypeID,
	AT2016.VoucherTypeID,
	VoucherNo,
	VoucherDate,
	ConvertedAmount = (Select Sum(ConvertedAmount) from At2017 Where voucherID = AT2016.VoucherID),
	AT2016.EmployeeID,
	 AT2016.WareHouseID as ImWareHouseID,
	AT2016.Description,
	AT1303.WareHouseName,
	AT2016.VoucherID,
	AT2016.OrderID,
	AT2016.ProjectID,
	AT2016.Status,
	AT2016.DivisionID,
	AT2016.TranMonth,
	AT2016.TranYear,
	AT2016.CreateDate,
             AT2016.CreateUserID,
             AT2016.LastModifyUserID,
             AT2016.LastModifyDate ,            
	AT2016.KindVoucherID,	
	AT2004.OrderNo as OrderNo
From AT2016 	left join AT2004 on AT2004.OrderID =AT2016.OrderID and AT2004.DivisionID =AT2016.DivisionID
              	left join AT1303 on AT1303.WareHouseID = AT2016.WareHouseID and AT1303.DivisionID = AT2016.DivisionID
				' + @sSQLPer+ '
Where 	AT2016.DivisionID ='''+@DivisionID+''' and
	AT2016.TranMonth ='+str(@TranMonth)+' and
	AT2016.TranYear ='+str(@TranYear)+ ''+ @sWHEREPer

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV0023')
	Exec('Create View AV0023 as '+@ssql)
Else
	Exec('Alter View AV0023 as '+@ssql)

	print @ssql
----- Buoc  2 : Tra ra thong tin Detail View AV0014

Set @ssQL='
Select 		AT2016.ReDeTypeID,
		AT2016.VoucherTypeID,
		AT2016.VoucherNo,
		AT2016.VoucherDate,
		InventoryTypeID,
	AT2016.ObjectID,	
	AT2016.WareHouseID as  ImWareHouseID,
	AT2016.EmployeeID,
	AT2017.TransactionID,
        AT2016.VoucherID,
        AT1302.Barcode,
       	AT2017.InventoryID,
	InventoryName,
        AT2017.UnitID,
	AT1304.UnitName,
       	ActualQuantity,
       	UnitPrice,
       	OriginalAmount,
      	ConvertedAmount,
     	AT2016.Description,
	AT2016.TranMonth,
	AT2016.TranYear,
	AT2016.DivisionID,
       	DiscountAmount,
       	SourceNo,
	DebitAccountID,
	CreditAccountID,
	LocationID,
	AT2017.Orders,
        	LimitDate,
	AT2017.Notes as Notes,
	AT2017.ConversionFactor,
	AT2017.ReVoucherID,
	AT2017.ReTransactionID ,
	AT2004.OrderNo as OrderNo,
	AT1302.IsSource,
	AT1302.IsLimitDate,
	AT1302.IsLocation,
	AT1302.MethodID,
	AT2017.Ana01ID,  AT2017.Ana02ID,  AT2017.Ana03ID,AT2017.Ana04ID	, AT2017.Ana05ID,
	AT2017.Ana06ID,  AT2017.Ana07ID,  AT2017.Ana08ID,AT2017.Ana09ID	, AT2017.Ana10ID,
	
	AT2017.Parameter01,AT2017.Parameter02, AT2017.Parameter03,AT2017.Parameter04, AT2017.Parameter05,
	AT2017.ConvertedQuantity, AT2017.ConvertedPrice, isnull(AT2017.ConvertedUnitID,AT1302.UnitID) as ConvertedUnitID ,  isnull(T04.UnitName,AT1304.UnitName) as ConvertedUnitName,
	Isnull(T09.Operator,0) as Operator, isnull(T09.ConversionFactor,1) as  T09ConversionFactor ,
	isnull(T09.DataType,0) as DataType  , T09.FormulaID, AT1319.FormulaDes,
	AT2017.Notes01, AT2017.Notes02, AT2017.Notes03, AT2017.Notes04, AT2017.Notes05, AT2017.Notes06, AT2017.Notes07, AT2017.Notes08,
	AT2017.Notes09, AT2017.Notes10, AT2017.Notes11, AT2017.Notes12, AT2017.Notes13, AT2017.Notes14, AT2017.Notes15,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID

From AT2017 	inner join AT1302 on AT1302.InventoryID =AT2017.InventoryID and AT1302.DivisionID =AT2017.DivisionID
		Left join AT8899 O99 on O99.DivisionID = AT2017.DivisionID And O99.VoucherID = AT2017.VoucherID And O99.TransactionID = AT2017.TransactionID
		Left join AT1304 on AT1304.UnitID  = AT2017.UnitID and AT1304.DivisionID  = AT2017.DivisionID
		inner join AT2016 on AT2016.VoucherID =AT2017.VoucherID and AT2016.DivisionID =AT2017.DivisionID
		left join AT2004 on AT2004.OrderID =AT2016.OrderID and AT2004.DivisionID =AT2016.DivisionID
	
		Left join AT1309 T09 on T09.InventoryID = AT2017.InventoryID and  AT2017.ConvertedUnitID = T09.UnitID and T09.DivisionID = AT2017.DivisionID
		Left Join AT1304 T04 on T04.UnitID =  isnull(AT2017.ConvertedUnitID,'''') and T04.DivisionID = AT2017.DivisionID
		Left Join AT1319 on isnull(T09.FormulaID,'''')  = AT1319.FormulaID and T09.DivisionID = AT1319.DivisionID
		' + @sSQLPer+ '

					
Where  	AT2017.DivisionID ='''+@DivisionID+''' and
	AT2017.TranMonth ='+Str(@TranMonth)+' and
	AT2017.TranYear ='+Str(@TranYear)+''+ @sWHEREPer
--Print @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV0024')
	Exec('Create View AV0024 as '+@ssql)
Else
	Exec('Alter View AV0024 as '+@ssql)
	--print @ssql