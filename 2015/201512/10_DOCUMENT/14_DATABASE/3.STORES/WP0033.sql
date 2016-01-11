IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WP0033]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[WP0033]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




---- Created by Khanh Van
---- Date 01/07/2013.
---- Purpose: Loc ra cac phieu xuat thanh pham nhap nguyen lieu de len man hinh truy van
---- Edit by Hoàng vũ, on 10/08/2015: Bổ sung phân quyền xem dữ liệu của người khác
---- Exmaple: exec WP0033 @DivisionID=N'AS',@VoucherID=N'',@TranMonth=8,@TranYear=2015, @UserID ='ASOFTADMIN'

CREATE PROCEDURE [dbo].[WP0033] 	
				@DivisionID as nvarchar(50),
				@VoucherID as nvarchar(50),
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
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = W26.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = W26.CreateUserID '
				SET @sWHEREPer = ' AND (W26.CreateUserID = AT0010.UserID
										OR  W26.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	


----- Tra ra thong tin Master View WV0033
IF ISNULL(@VoucherID, '') = ''
Begin
Set @sSQL='
Select 	W26.VoucherTypeID,		
		W26.VoucherNo,			
		W26.VoucherDate,
		W26.RefNo01,			
		W26.RefNo02,	
		W26.ObjectID,
		ObjectName, 
		W26.EmployeeID, 		
		T13.FullName,			
		W26.WareHouseID,
		(Select WareHouseName from AT1303 where AT1303.DivisionID=W26.DivisionID and AT1303.WarehouseID = W26.WarehouseID) as WareHouseName,
		W26.WareHouseID2,
		(Select WareHouseName from AT1303 where AT1303.DivisionID=W26.DivisionID and AT1303.WarehouseID = W26.WarehouseID2) as WareHouseName2,	
		W26.Description,			
		W26.VoucherID,			
		W26.OrderID,	
		W26.ProjectID,			
		W26.Status,			
		W26.DivisionID,	
		W26.KindVoucherID,
		sum(isnull(T07.ConvertedAmount,0)) as ConvertedAmount,
		W26.TranMonth,			
		W26.TranYear,			
		W26.CreateDate,             
		W26.CreateUserID,            	
		W26.LastModifyUserID,           	
		W26.LastModifyDate ,            
		T24.OrderNo as OrderNo

From WT2026  W26	left join AT1202 T22 on T22.ObjectID = W26.ObjectID and T22.DivisionID = W26.DivisionID
			left join AT2004 T24 on T24.OrderID = W26.OrderID and T24.DivisionID = W26.DivisionID
			left join AT1103 T13 on T13.EmployeeID = W26.EmployeeID and T13.DivisionID = W26.DivisionID
			left join AT2007 T07 on T07.VoucherID = W26.VoucherID and T07.DivisionID = W26.DivisionID
			' + @sSQLPer+ '

Where 	W26.DivisionID ='''+@DivisionID+''' and
	W26.TranMonth ='+str(@TranMonth)+' and
	W26.TranYear ='+str(@TranYear)+ ' '+ @sWHEREPer+'
Group by W26.VoucherTypeID, W26.VoucherNo, W26.VoucherDate, W26.RefNo01, W26.RefNo02, W26.ObjectID, 
	ObjectName, W26.EmployeeID,T13.FullName, W26.WareHouseID, W26.WareHouseID2,	W26.Description,
	W26.VoucherID,	W26.OrderID, W26.ProjectID,	W26.Status,	W26.DivisionID,	W26.TranMonth,	W26.TranYear,			W26.KindVoucherID,W26.CreateDate, W26.CreateUserID, W26.LastModifyUserID, 	W26.LastModifyDate ,            	T24.OrderNo 
' 
END
ELSE
BEGIN

----- Tra ra thong tin Detail View WV0034

Set @ssQL='
Select 	W26.VoucherTypeID,		
		W26.VoucherNo,			
		W26.VoucherDate,		
		W26.RefNo01,			
		W26.RefNo02,			
		T32.InventoryTypeID,	
		W26.ObjectID,			
		W26.WareHouseID,
		(Select WareHouseName from AT1303 where AT1303.DivisionID=W26.DivisionID and AT1303.WarehouseID = W26.WarehouseID) as WareHouseName,			
		(Select a.WareHouseID from AT2006 a where a.DivisionID = W26.DivisionID and a.VoucherID = ''NNL'+@VoucherID+''')as  WareHouseID2,	
		(Select WareHouseName from AT1303 where AT1303.DivisionID=W26.DivisionID and AT1303.WarehouseID = W26.WarehouseID and W26.VoucherID = ''NNL'+@VoucherID+''') as WareHouseName2,
		W26.EmployeeID,		
		W27.TransactionID,        		
		W26.VoucherID,       		
		W27.InventoryID,		
		T32.InventoryName,        	
		W27.UnitID,			
		T34.UnitName,
		ActualQuantity AS OldQuantity,
		ActualQuantity,       		
		W26.Description,			
		W26.TranMonth,	
		W26.TranYear,			
		W26.DivisionID,       		
		DebitAccountID, 	
		W26.ReDeTypeID,		
		W26.Status,			
		W27.ConversionFactor,
		CreditAccountID,		
		ApportionTable,			
		W27.ApportionID,
		ReTransactionID,		
		W27.ReVoucherID,
		Ana01ID,             		
		Ana02ID,             		
		Ana03ID,	
		Ana04ID,	
		Ana05ID,	
		Ana06ID,             		
		Ana07ID,             		
		Ana08ID,	
		Ana09ID,	
		Ana10ID,	
		W27.Orders,        		
		W27.Notes as TDescription,			
		T24.OrderNo,			
		T32.AccountID,			
		W27.PeriodID,			
		W27.OrderID,			
		M01.Description as PeriodName
     
From WT2027  W27	inner join AT1302 T32 on T32.InventoryID = W27.InventoryID and T32.DivisionID = W27.DivisionID
			Left join AT1304 T34 on T34.UnitID = W27.UnitID and T34.DivisionID = W27.DivisionID
			inner join AT2006 W26 on W26.VoucherID = W27.VoucherID and W26.DivisionID = W27.DivisionID
			Left join AT2004 T24 on T24.OrderID = W26.OrderID and T24.DivisionID = W26.DivisionID
			Left Join MT1601 M01 on M01.PeriodID = W27.PeriodID and M01.DivisionID = W27.DivisionID
			

Where  W27.DivisionID ='''+@DivisionID+''' and
	W27.TranMonth ='+Str(@TranMonth)+' and
	W27.TranYear ='+Str(@TranYear)+' and
	W26.VoucherID ='''+@VoucherID+'''
order by W27.Orders'
END
Print @sSQL
	Exec(@ssql)


GO


