/****** Object:  StoredProcedure [dbo].[MP1622]    Script Date: 02/08/2012 15:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MP1622]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MP1622]
GO

/****** Object:  StoredProcedure [dbo].[MP1622]    Script Date: 02/08/2012 15:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date 27/10/2003
--Purpose: TËp hîp chi phÝ NVL
--Edit by: Nguyen Quoc Huy
--Edit by Quoc Hoai
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'* Edited by : [GS] [Cẩm Loan] [24/12/2010] [Add distinct]
'**************************************************************/
--Edit by : Trong Khanh [10/02/2012] -- Theem 5 mã phân tích
--Edit by : Thiên Huỳnh [24/01/2014] -- Kết thêm Đơn vị
-- Modified by Tiểu Mai on 22/12/2015: Bổ sung thông tin quy cách hàng hóa
  
CREATE PROCEDURE [dbo].[MP1622] @DivisionID as nvarchar(50),@FromMonth as int,@FromYear as int,
	@ToMonth as int,@ToYear as int
as
Declare
	@FromPeriod as int,
	@ToPeriod as int,
	@sSQL as nvarchar(4000)
Set @FromPeriod=@FromMonth+@FromYear*100
Set @ToPeriod=@ToMonth+@ToYear*100
Set @sSQL='
Select distinct  MV9000.VoucherTypeID,
	MV9000.TransactionID,
	MV9000.DivisionID,
	MV9000.TableID,
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
	MV9000.Quantity,
	MV9000.UnitPrice,
	MV9000.VDescription,
	MV9000.TDescription,
	MV9000.Ana01ID,MV9000.Ana02ID,MV9000.Ana03ID,MV9000.Ana04ID,MV9000.Ana05ID,
	MV9000.Ana06ID,MV9000.Ana07ID,MV9000.Ana08ID,MV9000.Ana09ID,MV9000.Ana10ID,
	MV9000.ObjectID,
	MV9000.ExpenseID,
	MV9000.PeriodID,
	MT1601.Description as PeriodName,
	MV9000.MaterialTypeID,
	MV9000.CreateDate,
	MV9000.CreateUserID, 
	MV9000.LastModifyDate,
	MV9000.LastModifyUserID,
	MV9000.InventoryID,
	AT1302_I.InventoryName,
	AT1302_I.UnitID as InventoryUnitID,
	AT1202.ObjectName as ObjectName,
	MT0699.UserName,
	0 as IsLocked,
	MV9000.PS01ID, MV9000.PS02ID, MV9000.PS03ID, MV9000.PS04ID, MV9000.PS05ID, MV9000.PS06ID, MV9000.PS07ID, MV9000.PS08ID, MV9000.PS09ID, MV9000.PS10ID, 
	MV9000.PS11ID, MV9000.PS12ID, MV9000.PS13ID, MV9000.PS14ID, MV9000.PS15ID, MV9000.PS16ID, MV9000.PS17ID, MV9000.PS18ID, MV9000.PS19ID, MV9000.PS20ID,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
From MV9000 	
		left join AT1302 AT1302_P on MV9000.ProductID	=	AT1302_P.InventoryID
			And MV9000.DivisionID	=	AT1302_P.DivisionID
		left join AT1302 AT1302_I on MV9000.InventoryID	=	AT1302_I.InventoryID
			And MV9000.DivisionID	=	AT1302_I.DivisionID
		left join AT1202 on MV9000.ObjectID	=	AT1202.ObjectID						
			And MV9000.DivisionID	=	AT1202.DivisionID
		left join MT0699 on MV9000.MaterialTypeID	=	MT0699.MaterialTypeID	
			And MV9000.DivisionID	=	MT0699.DivisionID					
		left join MT1601 on MT1601.PeriodID 	= 	MV9000.PeriodID
			And MV9000.DivisionID	=	MT1601.DivisionID
		left join MT8899 O99 on O99.DivisionID = MV9000.DivisionID and O99.VoucherID = MV9000.VoucherID and O99.TransactionID = MV9000.TransactionID and O99.TableID = ''MT9000''
Where MV9000.TranMonth+MV9000.TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+'
	and MV9000.DivisionID='''+@DivisionID+'''
	and (MV9000.ExpenseID=''COST001'' or (Isnull(MV9000.ExpenseID,'''')='''' and
							(DebitAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST001'' 	) or CreditAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST001'' 	))))
		and (IsNull(MV9000.MaterialTypeID,'''')='''' or isnull(MV9000.PeriodID,'''') ='''') '

--print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV1622' and Xtype ='V')
	Exec ('Create view MV1622 as '+@sSQL)
Else
	Exec ('Alter view MV1622 as '+@sSQL)
GO


