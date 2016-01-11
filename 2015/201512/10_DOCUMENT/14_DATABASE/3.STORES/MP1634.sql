IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP1634]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP1634]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Hoang Thi Lan
--Date 27/10/2003
--Purpose: Truy van NVL (MF1624) --COST001

---Edited by: VO THANH HUONG, date: 20/05/2005
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
--Edit by : Trong Khanh [09/02/2012] -- Thêm 5 mã phân tích
--Edit by : Mai Duyen, Date 17/02/2014 -- bo sung them TransactionID 
--Edit by : Hoàng vũ, Date 10/08/2015 -- Bổ sung chức năng phân quyền xem dữ liệu người khác (Chi phí nguyên vật liệu-MF0043)
--Test: EXEC MP1634 'AS', 1, 2014, 12, 2016, 'NV003'
 
CREATE PROCEDURE [dbo].[MP1634] @DivisionID as nvarchar(50), 
				@FromMonth as int,
				@FromYear as int,
				@ToMonth int,
				@ToYear int,
				@UserID nvarchar(50)
as
Declare
	@sSQL as nvarchar(4000)

	
	----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM MT0000 WHERE DivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = MV9000.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = MV9000.CreateUserID '
				SET @sWHEREPer = ' AND (MV9000.CreateUserID = AT0010.UserID
										OR  MV9000.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		

--View MV1635 Master
Set @sSQL='
Select   distinct(MV9000.VoucherTypeID) ,
	MV9000.DivisionID,
--	MV9000.ProductID,
	MV9000.TableID,
	MV9000.FromTable,
	MV9000.VoucherID,
	MV9000.BatchID,
	MV9000.VoucherNo,
	MV9000.VoucherDate,
	MV9000.CurrencyID,
	MV9000.ExchangeRate,
	MV9000.VDescription,
--	MV9000.PeriodID,
	MV9000.EmployeeID,  AT1103.FullName
	
	
From MV9000 	left join AT1302 AT1302_P on MV9000.ProductID	=	AT1302_P.InventoryID
		left join AT1302 AT1302_I on MV9000.InventoryID	=	AT1302_I.InventoryID
		left join AT1202 on MV9000.ObjectID	=	AT1202.ObjectID						
		left join MT0699 on MV9000.MaterialTypeID	=	MT0699.MaterialTypeID					
		left join AT1103 on AT1103.EmployeeID = MV9000.EmployeeID	 and MV9000.DivisionID = AT1103.DivisionID
		' + @sSQLPer+ '
Where MV9000.TranMonth + MV9000.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) +' and ' + 
	cast(@ToMonth + @ToYear*100 as nvarchar(10)) + '			
	and MV9000.DivisionID='''+@DivisionID+'''
	'+ @sWHEREPer+'
	and (MV9000.ExpenseID=''COST001'' or (Isnull(MV9000.ExpenseID,'''')='''' and
							(DebitAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST001''	) or CreditAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST001''	))))
'


print @sSQL


If not exists (Select top 1 1 From SysObjects Where name = 'MV1635' and Xtype ='V')
	Exec ('Create view MV1635 as '+@sSQL)
Else
	Exec ('Alter view MV1635 as '+@sSQL)

--View MV1634 Detail
Set @sSQL='
Select   MV9000.VoucherTypeID,	
	MV9000.TransactionID,
	MV9000.TableID,
	MV9000.FromTable,
	MV9000.VoucherID,
	MV9000.BatchID,
	MV9000.DivisionID,
	MV9000.VoucherNo,
	MV9000.VoucherDate,
	MV9000.DebitAccountID,
	MV9000.CreditAccountID,
	MV9000.CurrencyID,
	MV9000.ExchangeRate,
	MV9000.OriginalAmount, 
	MV9000.ConvertedAmount,
	MV9000.ProductID,
	AT1302_P.InventoryName as ProductName,
	AT1302_P.UnitID as ProductUnitID,
	MV9000.InventoryID,
	AT1302_I.InventoryName,
	MV9000.Quantity,
	MV9000.UnitPrice,
	MV9000.UnitID,
	MV9000.EmployeeID,  AT1103.FullName, 
	MV9000.VDescription,
	MV9000.TDescription,
	MV9000.PeriodID,
	MV9000.ExpenseID,
	MT0699.UserName,
	MV9000.MaterialTypeID,
	MV9000.ObjectID,
	AT1202.ObjectName as ObjectName,
	MV9000.Orders, MV9000.TransactionTypeID,
	MV9000.Ana01ID, 
	MV9000.Ana02ID, 
	MV9000.Ana03ID,
	MV9000.Ana04ID,
	MV9000.Ana05ID,
	MV9000.Ana06ID,
	MV9000.Ana07ID,
	MV9000.Ana08ID,
	MV9000.Ana09ID,
	MV9000.Ana10ID,
	AT1011_01.AnaName as AnaName01, 	
	AT1011_02.AnaName as AnaName02, 
	AT1011_03.AnaName as AnaName03,
	AT1011_04.AnaName as AnaName04,
	AT1011_05.AnaName as AnaName05,
	AT1011_06.AnaName as AnaName06,
	AT1011_07.AnaName as AnaName07,
	AT1011_08.AnaName as AnaName08,
	AT1011_09.AnaName as AnaName09,
	AT1011_10.AnaName as AnaName10
	
From MV9000 	left join AT1302 AT1302_P on MV9000.ProductID	=	AT1302_P.InventoryID
		left join AT1302 AT1302_I on MV9000.InventoryID	=	AT1302_I.InventoryID
		left join AT1202 on MV9000.ObjectID	=	AT1202.ObjectID						
		left join MT0699 on MV9000.MaterialTypeID	=	MT0699.MaterialTypeID					
		left join AT1103 on AT1103.EmployeeID = MV9000.EmployeeID	 and MV9000.DivisionID = AT1103.DivisionID
		left join AT1011 AT1011_01  on AT1011_01.AnaID = MV9000.Ana01ID and AT1011_01.AnaTypeID = ''A01''
		left join AT1011 AT1011_02  on AT1011_02.AnaID = MV9000.Ana02ID and AT1011_02.AnaTypeID = ''A02''
		left join AT1011 AT1011_03  on AT1011_03.AnaID = MV9000.Ana03ID and AT1011_03.AnaTypeID = ''A03''
		left join AT1011 AT1011_04  on AT1011_04.AnaID = MV9000.Ana04ID and AT1011_04.AnaTypeID = ''A04''
		left join AT1011 AT1011_05  on AT1011_05.AnaID = MV9000.Ana05ID and AT1011_05.AnaTypeID = ''A05''
		left join AT1011 AT1011_06  on AT1011_06.AnaID = MV9000.Ana06ID and AT1011_06.AnaTypeID = ''A06''
		left join AT1011 AT1011_07  on AT1011_07.AnaID = MV9000.Ana07ID and AT1011_07.AnaTypeID = ''A07''
		left join AT1011 AT1011_08  on AT1011_08.AnaID = MV9000.Ana08ID and AT1011_08.AnaTypeID = ''A08''
		left join AT1011 AT1011_09  on AT1011_09.AnaID = MV9000.Ana09ID and AT1011_09.AnaTypeID = ''A09''
		left join AT1011 AT1011_10  on AT1011_10.AnaID = MV9000.Ana10ID and AT1011_10.AnaTypeID = ''A10''
		' + @sSQLPer+ '
Where MV9000.TranMonth + MV9000.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(10)) +' and ' + 
	cast(@ToMonth + @ToYear*100 as nvarchar(10)) + '			
	and MV9000.DivisionID='''+@DivisionID+'''
	'+ @sWHEREPer+'
	and (MV9000.ExpenseID=''COST001'' or (Isnull(MV9000.ExpenseID,'''')='''' and
							(DebitAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST001''	) or CreditAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST001''	))))
'


print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV1634' and Xtype ='V')
	Exec ('Create view MV1634 as '+@sSQL)
Else
	Exec ('Alter view MV1634 as '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
