
/****** Object:  StoredProcedure [dbo].[MP1624]    Script Date: 07/29/2010 15:27:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Created  by: Vo Thanh Huong, date : 09/05/2005
--Purpose: In bao cao chi phi phat sinh NVL
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
--- Modified by Tiểu Mai on 17/12/2015: Load bổ sung 20 cột quy cách, bỏ view


ALTER PROCEDURE [dbo].[MP1624] @DivisionID as nvarchar(50),				
				@VoucherID nvarchar(50)
as
Declare
	@sSQL as nvarchar(4000),
	@sSQL1 as nvarchar(4000)

		Set @sSQL='
Select   MV9000.VoucherTypeID, MV9000.TransactionID, MV9000.TableID, MV9000.FromTable, MV9000.VoucherID, MV9000.BatchID, MV9000.DivisionID,
	MV9000.VoucherNo,MV9000.VoucherDate,MV9000.DebitAccountID,MV9000.CreditAccountID,MV9000.CurrencyID,MV9000.ExchangeRate,MV9000.OriginalAmount,
	MV9000.ConvertedAmount,MV9000.ProductID,AT1302_P.InventoryName as ProductName,AT1302_P.UnitID as ProductUnitID,MV9000.InventoryID,AT1302_I.InventoryName,
	MV9000.Quantity,MV9000.UnitPrice,MV9000.UnitID,MV9000.EmployeeID, AT1103.FullName,MV9000.VDescription,MV9000.PeriodID,MV9000.ExpenseID,
	MT0699.UserName,MV9000.MaterialTypeID,MV9000.ObjectID,AT1202.ObjectName as ObjectName, MV9000.Orders,
	MV9000.Ana01ID, MV9000.Ana02ID, MV9000.Ana03ID, MV9000.Ana04ID, MV9000.Ana05ID,MV9000.Ana06ID,MV9000.Ana07ID,MV9000.Ana08ID,MV9000.Ana09ID,MV9000.Ana10ID, 
	AT1011_01.AnaName as AnaName01, 	AT1011_02.AnaName as AnaName02, AT1011_03.AnaName as AnaName03,AT1011_04.AnaName as AnaName04,
	AT1011_05.AnaName as AnaName05,AT1011_06.AnaName as AnaName06,AT1011_07.AnaName as AnaName07,AT1011_08.AnaName as AnaName08,
	AT1011_09.AnaName as AnaName09,AT1011_10.AnaName as AnaName10,
	MV9000.PS01ID, MV9000.PS02ID, MV9000.PS03ID, MV9000.PS04ID, MV9000.PS05ID, MV9000.PS06ID, MV9000.PS07ID, MV9000.PS08ID, MV9000.PS09ID, MV9000.PS10ID, 
	MV9000.PS11ID, MV9000.PS12ID, MV9000.PS13ID, MV9000.PS14ID, MV9000.PS15ID, MV9000.PS16ID, MV9000.PS17ID, MV9000.PS18ID, MV9000.PS19ID, MV9000.PS20ID,
	MV9000.S01ID, MV9000.S02ID, MV9000.S03ID, MV9000.S04ID, MV9000.S05ID, MV9000.S06ID, MV9000.S07ID, MV9000.S08ID, MV9000.S09ID, MV9000.S10ID, 
	MV9000.S11ID, MV9000.S12ID, MV9000.S13ID, MV9000.S14ID, MV9000.S15ID, MV9000.S16ID, MV9000.S17ID, MV9000.S18ID, MV9000.S19ID, MV9000.S20ID
	'
	SET @sSQL1 = '			
From MV9000 	left join AT1302 AT1302_P on MV9000.ProductID	=	AT1302_P.InventoryID and MV9000.DivisionID = AT1302_P.DivisionID
		left join AT1302 AT1302_I on MV9000.InventoryID	=	AT1302_I.InventoryID and MV9000.DivisionID = AT1302_I.DivisionID
		left join AT1202 on MV9000.ObjectID	=	AT1202.ObjectID and MV9000.DivisionID = AT1202.DivisionID
		left join MT0699 on MV9000.MaterialTypeID	=	MT0699.MaterialTypeID and MV9000.DivisionID = MT0699.DivisionID
		left join AT1103 on  AT1103.EmployeeID  = MV9000.EmployeeID and AT1103.DivisionID = MV9000.DivisionID 
		left join AT1011 AT1011_01  on AT1011_01.AnaID = MV9000.Ana01ID and AT1011_01.AnaTypeID = ''A01'' and MV9000.DivisionID = AT1011_01.DivisionID
		left join AT1011 AT1011_02  on AT1011_02.AnaID = MV9000.Ana02ID and AT1011_02.AnaTypeID = ''A02'' and MV9000.DivisionID = AT1011_02.DivisionID
		left join AT1011 AT1011_03  on AT1011_03.AnaID = MV9000.Ana03ID and AT1011_03.AnaTypeID = ''A03'' and MV9000.DivisionID = AT1011_03.DivisionID	
		left join AT1011 AT1011_04  on AT1011_04.AnaID = MV9000.Ana04ID and AT1011_04.AnaTypeID = ''A04'' and MV9000.DivisionID = AT1011_04.DivisionID
		left join AT1011 AT1011_05  on AT1011_05.AnaID = MV9000.Ana05ID and AT1011_05.AnaTypeID = ''A05'' and MV9000.DivisionID = AT1011_05.DivisionID
		left join AT1011 AT1011_06  on AT1011_06.AnaID = MV9000.Ana06ID and AT1011_06.AnaTypeID = ''A06'' and MV9000.DivisionID = AT1011_06.DivisionID
		left join AT1011 AT1011_07  on AT1011_07.AnaID = MV9000.Ana07ID and AT1011_07.AnaTypeID = ''A07'' and MV9000.DivisionID = AT1011_07.DivisionID
		left join AT1011 AT1011_08  on AT1011_08.AnaID = MV9000.Ana08ID and AT1011_08.AnaTypeID = ''A08'' and MV9000.DivisionID = AT1011_08.DivisionID
		left join AT1011 AT1011_09  on AT1011_09.AnaID = MV9000.Ana09ID and AT1011_09.AnaTypeID = ''A09'' and MV9000.DivisionID = AT1011_09.DivisionID
		left join AT1011 AT1011_10  on AT1011_10.AnaID = MV9000.Ana10ID and AT1011_10.AnaTypeID = ''A10'' and MV9000.DivisionID = AT1011_10.DivisionID
Where 	 MV9000.DivisionID='''+@DivisionID+''' and 
	MV9000.VoucherID = ''' + @VoucherID + '''  and 
	(MV9000.ExpenseID=''COST001'' or (Isnull(MV9000.ExpenseID,'''')= '''' and
							(DebitAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST001''
										   and MT0700.DivisionID='''+@DivisionID+''' ) or CreditAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST001''
										    and MT0700.DivisionID='''+@DivisionID+''' ))))
'	


EXEC (@sSQL+@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON