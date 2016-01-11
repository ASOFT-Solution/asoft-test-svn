
/****** Object:  StoredProcedure [dbo].[MP1605]    Script Date: 07/30/2010 11:25:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create By : Dang Le Bao Quynh; Date: 12/08/2008
--Purpose: Tra ra ket qua ke thua ket qua san xuat de tao bo he so
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP1605] 
	@PeriodID As nvarchar(50),
	@Unfinished As TinyInt
AS
If @Unfinished =  1
	Select Distinct ProductID As InventoryID, AT13.InventoryName As InventoryName, 1 As CoValue 
	From MT1001 MT10 
	Inner Join MT0810 MT08 On MT10.VoucherID = MT08.VoucherID
	Left Join AT1302 AT13 On MT10.ProductID = AT13.InventoryID
	Where MT08.PeriodID =  @PeriodID
Else
	Select Distinct ProductID As InventoryID, AT13.InventoryName As InventoryName, 1 As CoValue 
	From MT1001 MT10 
	Inner Join MT0810 MT08 On MT10.VoucherID = MT08.VoucherID
	Left Join AT1302 AT13 On MT10.ProductID = AT13.InventoryID
	Where MT08.PeriodID =  @PeriodID And ResultTypeID = 'R01'