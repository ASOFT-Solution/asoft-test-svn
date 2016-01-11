/****** Object:  View [dbo].[MV9000]    Script Date: 02/08/2012 15:00:52 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MV9000]'))
DROP VIEW [dbo].[MV9000]
GO

/****** Object:  View [dbo].[MV9000]    Script Date: 02/08/2012 15:00:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Edit by Dang Le Bao Quynh
--Purpose: them truong SourceNo vao view
--Edit by: Dang Le Bao Quynh; Date 15/08/2007
--Purpose: Lay SourceNo truc tiep tu MT9000
--Edit by: Hoang Trong Khanh; Date 08/02/2012
-- Modified on 20/01/2015 by Le Thi Hanh: Bổ sung ConvertedQuantity
-- Modified by Tiểu Mai on 21/12/2015: Bổ sung thông tin quy cách (PS01ID --> PS20ID, S01ID --> S20ID)

CREATE VIEW [dbo].[MV9000] as
Select 	'AT9000' as FromTable,
	TableID,
	AT9000.VoucherID, AT9000.BatchID, AT9000.TransactionID,
	AT9000.DivisionID, TransactionTypeID, AT9000.TranMonth, AT9000.TranYear, 
	AT9000.PeriodID, AT9000.ExpenseID, AT9000.MaterialTypeID,
	VoucherTypeID, VoucherNo, VoucherDate,
	AT9000.ProductID,   		------- San pham duoc phan bo truc tiep	
	AT9000.CurrencyID, 
	AT9000.ExchangeRate, 
	AT9000.InventoryID,		-------- Nguyen vat lieu
	AT9000.UnitID,			-------- Don vi tinh Nguyen vat lieu
	Quantity, AT9000.UnitPrice,
	AT9000.OriginalAmount, AT9000.ConvertedAmount,
	ObjectID, 
	AT9000.DebitAccountID, AT9000.CreditAccountID, 
	AT9000.Orders,
	VDescription , BDescription, TDescription,EmployeeID,
	AT9000.Ana01ID,	AT9000.Ana02ID,	AT9000.Ana03ID,	AT9000.Ana04ID,	AT9000.Ana05ID, AT9000.Ana06ID,
	AT9000.Ana07ID, AT9000.Ana08ID, AT9000.Ana09ID, AT9000.Ana10ID ,
	CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
	CASE WHEN MT70.AccountID IS NULL THEN 'C' ELSE 'D' END as D_C,
	AT2007.SourceNo as SourceNo,
	CASE WHEN ISNULL(AT9000.ConvertedQuantity,0) <> 0 THEN ISNULL(AT9000.ConvertedQuantity,0) 
	     ELSE ISNULL(Quantity,0) END AS ConvertedQuantity,
	NULL as PS01ID, NULL as PS02ID, NULL as PS03ID, NULL as PS04ID, NULL as PS05ID, NULL as PS06ID, NULL as PS07ID, NULL as PS08ID, NULL as PS09ID, NULL as PS10ID,
	NULL as PS11ID, NULL as PS12ID, NULL as PS13ID, NULL as PS14ID, NULL as PS15ID, NULL as PS16ID, NULL as PS17ID, NULL as PS18ID, NULL as PS19ID, NULL as PS20ID,
	NULL as S01ID, NULL as S02ID, NULL as S03ID, NULL as S04ID, NULL as S05ID, NULL as S06ID, NULL as S07ID, NULL as S08ID, NULL as S09ID, NULL as S10ID,
	NULL as S11ID, NULL as S12ID, NULL as S13ID, NULL as S14ID, NULL as S15ID, NULL as S16ID, NULL as S17ID, NULL as S18ID, NULL as S19ID, NULL as S20ID     
From AT9000	
	LEFT JOIN AT2007 
		ON AT2007.VoucherID = AT9000.VoucherID 
			And AT2007.TransactionID = AT9000.TransactionID 
			And AT2007.DivisionID = AT9000.DivisionID
	LEFT JOIN MT0700 MT70
		ON MT70.ExpenseID IN ('COST001', 'COST002', 'COST003')
			AND AT9000.DebitAccountID = MT70.AccountID
	LEFT JOIN MT0700 MT71
		ON MT71.ExpenseID IN ('COST001', 'COST002', 'COST003')
			AND AT9000.CreditAccountID = MT71.AccountID
Where 	TransactionTypeID not in ('T00','T98') -- Loai but toan so du va but toan ket chuyen	
	--and DebitAccountID in (Select AccountID From MT0700 Where ExpenseID in ('COST001', 'COST002', 'COST003') ) 
	and CASE WHEN MT70.AccountID IS NULL 
					THEN CASE WHEN MT71.AccountID IS NULL 
								THEN 9
								ELSE left(AT9000.DebitAccountID,1) END 
					ELSE left(AT9000.CreditAccountID,1) END <> '9' 

--Union All
--Select 	'AT9000' as FromTable,
--	TableID,
--	VoucherID, BatchID, TransactionID,
--	DivisionID, TransactionTypeID, TranMonth, TranYear, 
--	PeriodID, ExpenseID, MaterialTypeID,
--	VoucherTypeID, VoucherNo, VoucherDate,
--	ProductID,   		----- San pham duoc phan bo truc tiep	
--	CurrencyID, 
--	ExchangeRate, 
--	InventoryID,		--- Nguyen vat lieu
--	UnitID,			---- Don vi tinh Nguyen vat lieu
--	Quantity, UnitPrice,
--	OriginalAmount, ConvertedAmount,
--	ObjectID, 
--	DebitAccountID, CreditAccountID, 
--	Orders,
--	VDescription , BDescription, TDescription,EmployeeID,
--	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
--	CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
--	'C' as D_C,
--	(select SourceNo From AT2007 Where AT2007.VoucherID=AT9000.VoucherID 
--		And AT2007.TransactionID=AT9000.TransactionID And AT2007.DivisionID=AT9000.DivisionID) as SourceNo,
--	CASE WHEN ISNULL(ConvertedQuantity,0) <> 0 THEN ISNULL(ConvertedQuantity,0) 
--	     ELSE ISNULL(Quantity,0) END AS ConvertedQuantity
--From AT9000	
--Where 	TransactionTypeID not in ('T00','T98') and  -- Loai but toan so du va but toan ket chuyen
--	CreditAccountID in (Select AccountID From MT0700 Where ExpenseID in ('COST001', 'COST002', 'COST003') )   and 
--	left(DebitAccountID,1) <> '9' 


Union All
Select 	'MT9000' as FromTable,
	MT9000.TableID,
	MT9000.VoucherID, BatchID, MT9000.TransactionID,
	MT9000.DivisionID, TransactionTypeID, TranMonth, TranYear, 
	PeriodID, MT9000.ExpenseID, MT9000.MaterialTypeID,
	VoucherTypeID, VoucherNo, VoucherDate,
	ProductID,   		----- San pham duoc phan bo truc tiep	
	CurrencyID, 
	ExchangeRate, 
	InventoryID,UnitID,
	Quantity, UnitPrice,
	OriginalAmount, ConvertedAmount,
	ObjectID, 
	DebitAccountID, CreditAccountID, 
	Orders,
	VDescription , BDescription, TDescription,EmployeeID,
	 Ana01ID,	 Ana02ID,	 Ana03ID,	Ana04ID,	Ana05ID,	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
	CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
	'D' as D_C,
	SourceNo, ISNULL(Quantity,0) AS ConvertedQuantity,
	MT9000.PS01ID, MT9000.PS02ID, MT9000.PS03ID, MT9000.PS04ID, MT9000.PS05ID, MT9000.PS06ID, MT9000.PS07ID, MT9000.PS08ID, MT9000.PS09ID, MT9000.PS10ID,
	MT9000.PS11ID, MT9000.PS12ID, MT9000.PS13ID, MT9000.PS14ID, MT9000.PS15ID, MT9000.PS16ID, MT9000.PS17ID, MT9000.PS18ID, MT9000.PS19ID, MT9000.PS20ID,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
From MT9000
	LEFT JOIN MT0700 MT70
		ON MT70.ExpenseID IN ('COST001', 'COST002', 'COST003')
			AND MT9000.DebitAccountID = MT70.AccountID
	LEFT JOIN MT0700 MT71
		ON MT71.ExpenseID IN ('COST001', 'COST002', 'COST003')
			AND MT9000.CreditAccountID = MT71.AccountID
	LEFT JOIN MT8899 O99 ON O99.DivisionID = MT9000.DivisionID AND O99.VoucherID = MT9000.VoucherID AND O99.TransactionID = MT9000.TransactionID AND O99.TableID = 'MT9000'		
Where 	TransactionTypeID not in ('T00','T98') -- Loai but toan so du va but toan ket chuyen
	--and DebitAccountID in (Select AccountID From MT0700 Where ExpenseID in ('COST001', 'COST002', 'COST003') ) 
	AND (MT70.DivisionID is not null OR MT71.DivisionID is not null)
	
--Union All
--Select 	'MT9000' as FromTable,
--	TableID,
--	VoucherID, BatchID, TransactionID,
--	DivisionID, TransactionTypeID, TranMonth, TranYear, 
--	PeriodID, ExpenseID, MaterialTypeID,
--	VoucherTypeID, VoucherNo, VoucherDate,
--	ProductID,   		----- San pham duoc phan bo truc tiep	
--	CurrencyID, 
--	ExchangeRate, 
--	InventoryID,UnitID,
--	Quantity, UnitPrice,
--	OriginalAmount, ConvertedAmount,
--	ObjectID, 
--	DebitAccountID, CreditAccountID, 
--	Orders,
--	VDescription , BDescription, TDescription,EmployeeID,
--	Null as Ana01ID,	Null as  Ana02ID,	Null as  Ana03ID, 	Null as Ana04ID, 	Null as Ana05ID, 	Null as Ana06ID, 	Null as Ana07ID, 	Null as Ana08ID, 	Null as Ana09ID, 	Null as Ana10ID,
--	CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
--	'C' as D_C,
--	SourceNo,
--	ISNULL(Quantity,0) AS ConvertedQuantity
--From MT9000
--Where 	TransactionTypeID not in ('T00','T98') and -- Loai but toan so du va but toan ket chuyen
--	CreditAccountID in (Select AccountID From MT0700 Where ExpenseID in ('COST001', 'COST002', 'COST003') )
GO


