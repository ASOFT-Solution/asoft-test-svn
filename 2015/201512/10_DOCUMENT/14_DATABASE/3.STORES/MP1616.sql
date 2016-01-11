
/****** Object:  StoredProcedure [dbo].[MP1616]    Script Date: 07/29/2010 15:11:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date 22/10/2003
--Purpose: TËp hîp chi phÝ nh©n c«ng (MF1615) (§· tËp hîp chi phÝ)
--- Edit by Quoc Hoai
 /***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
-- Edit by : Trong Khanh [09/02/2012] -- Thêm 5 mã phân tích
-- Modified by Tiểu Mai on 22/12/2015: Bổ sung thông tin quy cách hàng hóa

ALTER PROCEDURE [dbo].[MP1616] @DivisionID as nvarchar(50),@PeriodID as nvarchar(50),@FromMonth as int,@FromYear as int,
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
	MV9000.PeriodID,
	MT1601.Description as PeriodName,
	MT0699.UserName,
	AT1302.InventoryName as ProductName,
	AT1302.UnitID,
	MV9000.VDescription,
	MV9000.TDescription,
	MV9000.Ana01ID,MV9000.Ana02ID,MV9000.Ana03ID,MV9000.Ana04ID,MV9000.Ana05ID,
	MV9000.Ana06ID,MV9000.Ana07ID,MV9000.Ana08ID,MV9000.Ana09ID,MV9000.Ana10ID,
	MV9000.ObjectID,
	MV9000.ExpenseID,	
	MV9000.MaterialTypeID,
	AT1202.ObjectName,
	MV9000.CreateDate,
	MV9000.CreateUserID, 
	MV9000.LastModifyDate,
	MV9000.LastModifyUserID,
	MV9000.DivisionID,
	Mt1601.IsDistribute as IsLocked,
	MV9000.PS01ID, MV9000.PS02ID, MV9000.PS03ID, MV9000.PS04ID, MV9000.PS05ID, MV9000.PS06ID, MV9000.PS07ID, MV9000.PS08ID, MV9000.PS09ID, MV9000.PS10ID, 
	MV9000.PS11ID, MV9000.PS12ID, MV9000.PS13ID, MV9000.PS14ID, MV9000.PS15ID, MV9000.PS16ID, MV9000.PS17ID, MV9000.PS18ID, MV9000.PS19ID, MV9000.PS20ID 
From MV9000 	left join AT1302 on MV9000.ProductID	=	AT1302.InventoryID
		left join AT1202 on MV9000.ObjectID	=	AT1202.ObjectID						
		Inner join Mt1601 on MT1601.PeriodID 	= 	MV9000.PeriodID 
		left join MT0699 on MT0699.MaterialTypeID =	MV9000.MaterialTypeID
Where MV9000.TranMonth+MV9000.TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+'
	and MV9000.DivisionID='''+@DivisionID+'''
	and MV9000.ExpenseID=''COST002'' 
	and MV9000.PeriodID like '''+@PeriodID+'''
	and IsNull(MV9000.MaterialTypeID,'''') <>''''
	'

--- and MT1601.IsForPeriodID = 0  --DTTHCP cha khong cho THCP NVL &NC
--print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV1616' and Xtype ='V')
	Exec ('Create view MV1616 as '+@sSQL)
Else
	Exec ('Alter view MV1616 as '+@sSQL)