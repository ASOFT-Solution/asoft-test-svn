IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0103]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP0103]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---- Create by Bao Anh		Date: 08/01/2013
---- Purpose: Tinh phe pham cho doi tuong THCP
---- EXEC MP0103 'AS','000','444',1,2012

CREATE PROCEDURE MP0103
( 
	@DivisionID as nvarchar(50),
	@FromPeriodID AS NVARCHAR(50),
	@ToPeriodID AS NVARCHAR(50),
	@TranMonth as int,
	@TranYear as int
) 
AS
Declare @SQL as nvarchar(4000),
		@PeriodID_cur AS CURSOR,
		@PeriodID as nvarchar(50),
		@WasteID as nvarchar(50),
		@UnitID as nvarchar(50),
		@Quantity_MV9000 as decimal(28,8),
		@Quantity_MT1001 as decimal(28,8)
		
Set @SQL = ''
Set @PeriodID = ''
Set @WasteID = ''
Set @UnitID = ''

Delete MT0103 Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear And (PeriodID Between @FromPeriodID And @ToPeriodID)

--- Xoa phieu nhap phe pham --Edit By Bao Quynh: 06/02/2013. Luu danh sach can xoa vao bang tam, xoa AT2007 truoc AT2006

Select VoucherID Into #Temp From AT2006 Where DivisionID = @DivisionID And KindVoucherID = 1
And VoucherID in (Select VoucherID From AT2007 Where DivisionID = @DivisionID and TranMonth = @TranMonth And TranYear = @TranYear
And VoucherID like 'MR%' And (Isnull(PeriodID,'') Between @FromPeriodID And @ToPeriodID))

Delete AT2007 Where DivisionID = @DivisionID and TranMonth = @TranMonth And TranYear = @TranYear 
And VoucherID In (Select VoucherID From #Temp)

Delete AT2006 Where DivisionID = @DivisionID And VoucherID In (Select VoucherID From #Temp)


SET @PeriodID_cur  = CURSOR SCROLL KEYSET FOR
Select PeriodID, WasteID, UnitID from MT1601 Left join AT1302 on MT1601.DivisionID = AT1302.DivisionID And MT1601.WasteID = AT1302.InventoryID
Where MT1601.DivisionID = @DivisionID And (MT1601.PeriodID between @FromPeriodID And @ToPeriodID)
And @TranMonth + @TranYear * 12 BETWEEN FromMonth + FromYear * 12 AND ToMonth + ToYear * 12 And Isnull(MT1601.WasteID,'') <> ''

OPEN @PeriodID_cur 

FETCH NEXT FROM @PeriodID_cur INTO @PeriodID, @WasteID, @UnitID
WHILE @@Fetch_Status = 0
    BEGIN
		Set @Quantity_MV9000 = 0
		Set @Quantity_MT1001 = 0
		
		Select @Quantity_MV9000 =  Sum(Quantity) from MV9000 Where DivisionID = @DivisionID And PeriodID = @PeriodID
		and ExpenseID = 'COST001' and D_C = 'D' and TranMonth = @TranMonth and TranYear = @TranYear
		and Isnull(MV9000.UnitID,'') = Isnull(@UnitID,'')
		
		Select @Quantity_MT1001 = SUM(Quantity) From MT1001 Inner join MT0810 On MT1001.DivisionID = MT0810.DivisionID And MT1001.VoucherID = MT0810.VoucherID
		Where MT1001.DivisionID = @DivisionID And MT0810.PeriodID = @PeriodID And MT1001.TranMonth = @TranMonth and MT1001.TranYear = @TranYear
		And Isnull(MT1001.UnitID,'') = Isnull(@UnitID,'')
		
		Insert into MT0103 (DivisionID, TranMonth, TranYear, PeriodID, WasteID, UnitID, Quantity) Values (@DivisionID, @TranMonth, @TranYear, @PeriodID, @WasteID, @UnitID, Isnull(@Quantity_MV9000,0) - Isnull(@Quantity_MT1001,0))
		
		FETCH NEXT FROM @PeriodID_cur INTO @PeriodID, @WasteID, @UnitID
	END
	
Close @PeriodID_cur