
/****** Object:  StoredProcedure [dbo].[MP0021]    Script Date: 07/29/2010 17:12:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


---- Chiet tinh gia thanh theo quy trinh san xuat.
---- Created by Nguyen Van Nhan, chiet tinh gia thanh theo quy trinh san xuat
---- Edit by: Dang Le Bao Quynh; Date: 19/11/2008
---- Purpose: Cai tien toc do xu ly


/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[MP0021]  	
					@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int,
					@ProcedureID as nvarchar(50)--- Kiem
 AS
Declare @sSQL as nvarchar(4000),
	@PeriodID as nvarchar(50),
	@Cur as Cursor,
	@EndPeriodID as nvarchar(50),
	@ProductID as nvarchar(50),
	@ProductQuantity as decimal(28,8),
	@MaterialID as nvarchar(50),
	@ConvertedUnit as decimal(28,8),
	@QuantityUnit as decimal(28,8),
	@NexPeriodID as nvarchar(50)

Set Nocount on

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MT1633]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MT1633]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MT1634]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MT1634]

CREATE TABLE [dbo].[MT1633](
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[PeriodID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NULL,
	[MaterialID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[QuantityUnit] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	 CONSTRAINT [PK_MT1633] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

ALTER TABLE [dbo].[MT1633] ADD  DEFAULT (newid()) FOR [APK]

/*
CREATE TABLE [dbo].[MT1634] (
	[ProductID] [nvarchar] (20) NULL ,
	[PeriodID] [nvarchar] (20) NULL ,
	[FixProductID] [nvarchar] (20) NULL ,
	[QuantityUnit] [decimal](28, 8) NULL ,
	[ConvertedUnit] [decimal](28, 8) NULL 
) ON [PRIMARY]
*/
Set @EndPeriodID =(Select top 1 PeriodID From MT1631 Where  ProcedureID=@ProcedureID Order by StepID Desc)

Set @sSQL ='
		Select  		D10.DivisionID , 
				D10.ProductID as ProductID, 
				AT1302.InventoryTypeID,  
				D10.UnitID , 
				sum(D10.Quantity) as ProductQuantity
		From MT1001 D10 inner join MT0810 D08 on D08.VoucherID = D10.VoucherID and
								D08.DivisionID = D10.DivisionID		
				      inner join AT1302 on  AT1302.InventoryID = D10.ProductID and AT1302.DivisionID = D10.DivisionID
		where 	D08.PeriodID = '''+@EndPeriodID+''' and
			D08.DivisionID ='''+@DivisionID+''' and
			D08.ResultTypeID in (''R01'',''R03'')
	Group  by 
		   D10.DivisionID ,  D10.ProductID , AT1302.InventoryTypeID,  
		   D10.UnitID ' 	
	

if exists (select * from sysobjects where id = object_id(N'[dbo].[MT2222]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MT2222]
		CREATE TABLE [dbo].[MT2222](
		[APK] [uniqueidentifier] NOT NULL,
		[DivisionID] [nvarchar](3) NOT NULL,
		[ProductID] [nvarchar](50) NULL,
		[InventoryTypeID] [nvarchar](50) NULL,
		[UnitID] [nvarchar](50) NULL,
		[ProductQuantity] [decimal](28, 8) NULL,
		[PerfectRate] [decimal](28, 8) NULL,
		[MaterialRate] [decimal](28, 8) NULL,
		[HumanResourceRate] [decimal](28, 8) NULL,
		[OthersRate] [decimal](28, 8) NULL,
		 CONSTRAINT [PK_MT2222] PRIMARY KEY NONCLUSTERED 
			(
				[APK] ASC
			)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

	ALTER TABLE [dbo].[MT2222] ADD  DEFAULT (newid()) FOR [APK]

	INSERT MT2222(	DivisionID,
				ProductID ,
			         	 InventoryTypeID,
				 UnitID ,
			               ProductQuantity    
			     ) 

	EXEC (@sSQL)

------------------------------------------
/*
----1. Insert tat ca cac chi phi NC, SXC cho cong doan cuoi cung
Insert MT1633 ( PeriodID, MaterialID, ProductID, ExpenseID, MaterialTypeID, QuantityUnit, ConvertedUnit)
Select  PeriodID, null,  ProductID, ExpenseID, MaterialTypeID,QuantityUnit, ConvertedUnit
From MT4000
Where ExpenseID in ('COST002', 'COST003')   and PeriodID =@EndPeriodID and DivisionID =@DivisionID and isnull(ConvertedUnit,0)<>0

--Order by ProductID, ExpenseID, MaterialTypeID

-----2 Insert Chi phi NVL TT ma khong phai chuyen tu cong doan truoc ve -----------------------------------------------------
	Insert MT1633 ( PeriodID, MaterialID, ProductID, ExpenseID,  QuantityUnit, ConvertedUnit)
	Select PeriodID, MaterialID, ProductID, ExpenseID,  QuantityUnit, ConvertedUnit
	From MT4000 
	Where ExpenseID = 'COST001'   and PeriodID =@EndPeriodID and DivisionID =@DivisionID and
		MaterialID  not in (Select  ProductID From  MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID
								Where isnull(TransferPeriodID,'')=@EndPeriodID --and
								---PeriodID in (select PeriodID From MT1631 Where ProcedureID =@ProcedureID)
								)
-----3 Insert Chi phi NVL TT ma khong phai chuyen tu cong doan truoc ve -----------------------------------------------------
SET @Cur = Cursor Scroll KeySet FOR 
Select  ProductID,  MaterialID,   QuantityUnit, ConvertedUnit 
From MT4000 
Where ExpenseID = 'COST001'   and PeriodID =@EndPeriodID and DivisionID =@DivisionID and
		MaterialID  in (Select  ProductID From  MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID
								Where isnull(TransferPeriodID,'')=@EndPeriodID ---and
								---PeriodID in (select PeriodID From MT1631 Where ProcedureID =@ProcedureID)
								)

OPEN	@Cur
FETCH NEXT FROM @Cur INTO  @ProductID, @MaterialID, @QuantityUnit, @ConvertedUnit 
WHILE @@Fetch_Status = 0Begin
	---Print @MaterialID
   	Set @NexPeriodID =  (Select Top 1 PeriodID From  MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID
								Where isnull(TransferPeriodID,'')=@EndPeriodID-- and
								---PeriodID in (select PeriodID From MT1631 Where ProcedureID =@ProcedureID
								and ProductID = @MaterialID)--)	
	Insert MT1634 (PeriodID,  ProductID,  FixProductID, QuantityUnit, ConvertedUnit)
	Values  (@NexPeriodID, @MaterialID,  @ProductID, @QuantityUnit, @ConvertedUnit)


   FETCH NEXT FROM @Cur INTO  @ProductID, @MaterialID, @QuantityUnit, @ConvertedUnit 
End
Close @Cur
Deallocate @Cur
*/