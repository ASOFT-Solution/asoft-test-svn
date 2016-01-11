IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP1629]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP1629]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--Created by Hoang Thi Lan
--Date 23/10/2003
--Purpose: Truy van chi phi nhan cong (MF1619) -- ExpenseID = COST002

---Edited by: VO THANH HUONG, date: 20/05/2005
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
-- Edit by : Trong Khanh [09/02/2012] -- Thêm 5 mã phân tích
-- Edit by : Hoàng vũ [10/08/2015] -- Bổ sung thêm phân quyền xem dữ liệu của người khác (Chi phi nhân công trực tiếp - MF0038)
-- Test: EXEC MP1629 'AS', 1,2014,12,2015,'ASOFTADMIN'

CREATE PROCEDURE [dbo].[MP1629] @DivisionID nvarchar(50),
			@FromMonth  int,   
			@FromYear  int,
			@ToMonth  int,
			@ToYear int,
			@UserID nvarchar(50)
			
as
Declare 	@sSQL as nvarchar(4000)


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


--Master MV1630
Set @sSQL='
Select   distinct(MV9000.VoucherTypeID),
	MV9000.TableID,
	MV9000.FromTable,
	MV9000.VoucherID,
	MV9000.BatchID,
	MV9000.DivisionID,
	MV9000.VoucherNo,
	MV9000.VoucherDate,
	MV9000.CurrencyID,
	MV9000.ExchangeRate,
	MV9000.ProductID,
	MV9000.EmployeeID,
	MV9000.VDescription
	
	
From MV9000 	left join AT1302 on MV9000.ProductID	=	AT1302.InventoryID AND AT1302.DivisionID = ''' + @DivisionID+ '''
	left join AT1202 on MV9000.ObjectID	=	AT1202.ObjectID					AND AT1202.DivisionID = ''' + @DivisionID+ '''	
	left join MT0699 on MV9000.MaterialTypeID	=	MT0699.MaterialTypeID		AND MT0699.DivisionID = ''' + @DivisionID+ '''
	' + @sSQLPer+ '				
Where MV9000.TranMonth + MV9000.TranYear*100 between '+ 
	cast(@FromMonth + @FromYear*100 as nvarchar(50))  + ' and ' + 
	cast(@ToMonth + @ToYear*100 as nvarchar(50)) + '				
	and MV9000.DivisionID='''+@DivisionID+''''+ @sWHEREPer+'
	and (MV9000.ExpenseID=''COST002'' or (Isnull(MV9000.ExpenseID,'''')='''' and
							(DebitAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST002''	and MT0700.DivisionID = ''' + @DivisionID+ ''') 
							or CreditAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST002''	and MT0700.DivisionID = ''' + @DivisionID+ '''))))

'
--print @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV1630' and Xtype ='V')
	Exec ('Create view MV1630 ----tao boi MP1629
						as '+@sSQL)
Else
	Exec ('Alter view MV1630 ----tao boi MP1629
						as '+@sSQL)

--Detail MV1629

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
	AT1302.InventoryName as ProductName,
	AT1302.UnitID as ProductUnitID,
	MV9000.UnitID,
	MV9000.EmployeeID,
	MV9000.VDescription,
	MV9000.TDescription,
	MV9000.PeriodID,
	MV9000.ExpenseID,
	MT0699.UserName,
	MV9000.MaterialTypeID,
	MV9000.ObjectID,
	AT1202.ObjectName as ObjectName,
	MV9000.TransactionTypeID ,
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
	
From MV9000 	left join AT1302 on MV9000.ProductID	=	AT1302.InventoryID and AT1302.DivisionID = ''' + @DivisionID+ '''
		left join AT1202 on MV9000.ObjectID	=	AT1202.ObjectID				and AT1202.DivisionID = ''' + @DivisionID+ '''
		left join MT0699 on MV9000.MaterialTypeID	=	MT0699.MaterialTypeID		and MT0699.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_01  on AT1011_01.AnaID = MV9000.Ana01ID and AT1011_01.AnaTypeID = ''A01'' and AT1011_01.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_02  on AT1011_02.AnaID = MV9000.Ana02ID and AT1011_02.AnaTypeID = ''A02'' and AT1011_02.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_03  on AT1011_03.AnaID = MV9000.Ana03ID and AT1011_03.AnaTypeID = ''A03'' and AT1011_03.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_04  on AT1011_04.AnaID = MV9000.Ana04ID and AT1011_04.AnaTypeID = ''A04'' and AT1011_04.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_05  on AT1011_05.AnaID = MV9000.Ana05ID and AT1011_05.AnaTypeID = ''A05'' and AT1011_05.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_06  on AT1011_06.AnaID = MV9000.Ana06ID and AT1011_06.AnaTypeID = ''A06'' and AT1011_06.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_07  on AT1011_07.AnaID = MV9000.Ana07ID and AT1011_07.AnaTypeID = ''A07'' and AT1011_07.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_08  on AT1011_08.AnaID = MV9000.Ana08ID and AT1011_08.AnaTypeID = ''A08'' and AT1011_08.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_09  on AT1011_09.AnaID = MV9000.Ana09ID and AT1011_09.AnaTypeID = ''A09'' and AT1011_09.DivisionID = ''' + @DivisionID+ '''
		left join AT1011 AT1011_10  on AT1011_10.AnaID = MV9000.Ana10ID and AT1011_10.AnaTypeID = ''A10'' and AT1011_10.DivisionID = ''' + @DivisionID+ '''
		' + @sSQLPer+ '	
Where MV9000.TranMonth + MV9000.TranYear*100 between '+ 
	cast(@FromMonth + @FromYear*100 as nvarchar(50))  + ' and ' + 
	cast(@ToMonth + @ToYear*100 as nvarchar(50)) + '				
	and MV9000.DivisionID='''+@DivisionID+'''
	'+ @sWHEREPer+'
	and (MV9000.ExpenseID=''COST002'' or (Isnull(MV9000.ExpenseID,'''')='''' and
							(DebitAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST002''	and MT0700.DivisionID = ''' + @DivisionID+ ''') 
							or CreditAccountID in (Select AccountID 
										  From MT0700
										  Where MT0700.ExpenseID=''COST002''	and MT0700.DivisionID = ''' + @DivisionID+ '''))))

'

If not exists (Select top 1 1 From SysObjects Where name = 'MV1629' and Xtype ='V')
	Exec ('Create view MV1629 ----tao boi MP1629
							as '+@sSQL)
Else
	Exec ('Alter view MV1629 ----tao boi MP1629
						as '+@sSQL)
Print @sSQL 						
					

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
