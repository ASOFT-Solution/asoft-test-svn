
/****** Object:  StoredProcedure [dbo].[MP1615]    Script Date: 02/08/2012 17:25:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MP1615]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MP1615]
GO

/****** Object:  StoredProcedure [dbo].[MP1615]    Script Date: 02/08/2012 17:25:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date 22/10/2003
--Purpose: TËp hîp chi phÝ nh©n c«ng (MF1615)
--Edit by: Nguyen Quoc Huy
--Edit by: Le Quoc Hoai
--Edit by: Trong Khanh [02/08/2012] -- Thêm 5 mã phân tích
 /***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
-- Edit by : Trong Khanh [09/02/2012] -- Thêm 5 mã phân tích
-- Modified by Tiểu Mai on 22/12/2015: Bổ sung thông tin quy cách hàng hóa

CREATE PROCEDURE [dbo].[MP1615] @DivisionID as nvarchar(50),@FromMonth as int,@FromYear as int,
	@ToMonth as int,@ToYear as int
as
Declare
	@FromPeriod as int,
	@ToPeriod as int,
	@sSQL as nvarchar(4000)
Set @FromPeriod=@FromMonth+@FromYear*100
Set @ToPeriod=@ToMonth+@ToYear*100
Set @sSQL='

Select   MV9000.VoucherTypeID,
	MV9000.TransactionID,
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
	MV9000.ExpenseID,	
	MV9000.MaterialTypeID,
	MT0699.UserName,
	MV9000.PeriodID,
	MT1601.Description as PeriodName,
	AT1302.InventoryName as ProductName,
	AT1302.UnitID,
	MV9000.VDescription,
	MV9000.TDescription,
	MV9000.Ana01ID,MV9000.Ana02ID,MV9000.Ana03ID,MV9000.Ana04ID,MV9000.Ana05ID,
	MV9000.Ana06ID,MV9000.Ana07ID,MV9000.Ana08ID,MV9000.Ana09ID,MV9000.Ana10ID,
	MV9000.ObjectID,
	AT1202.ObjectName ,
	MV9000.CreateDate,
	MV9000.CreateUserID, 
	MV9000.LastModifyDate,
	MV9000.LastModifyUserID,
	MV9000.DivisionID,
	0 as IsLocked,
	MV9000.PS01ID, MV9000.PS02ID, MV9000.PS03ID, MV9000.PS04ID, MV9000.PS05ID, MV9000.PS06ID, MV9000.PS07ID, MV9000.PS08ID, MV9000.PS09ID, MV9000.PS10ID, 
	MV9000.PS11ID, MV9000.PS12ID, MV9000.PS13ID, MV9000.PS14ID, MV9000.PS15ID, MV9000.PS16ID, MV9000.PS17ID, MV9000.PS18ID, MV9000.PS19ID, MV9000.PS20ID
From MV9000 	left join AT1302 on MV9000.ProductID	=	AT1302.InventoryID
		left join AT1202 on MV9000.ObjectID	=	AT1202.ObjectID			
		left join MT0699 on MV9000.MaterialTypeID	=	MT0699.MaterialTypeID
		left join MT1601 on MV9000.PeriodID		= MT1601.PeriodID
		
Where MV9000.TranMonth+MV9000.TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+'
	and MV9000.DivisionID='''+@DivisionID+'''
	and (MV9000.ExpenseID=''COST002'' or (Isnull(MV9000.ExpenseID,'''')='''' and
							 (DebitAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST002'' 	) or CreditAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST002'' 	))))

	and (IsNull(MV9000.MaterialTypeID,'''')='''' or isnull(MV9000.PeriodID,'''') ='''') '


----print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV1615' and Xtype ='V')
	Exec ('Create view MV1615 as '+@sSQL)
Else
	Exec ('Alter view MV1615 as '+@sSQL)
GO


