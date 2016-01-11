IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV0303]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV0303]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--View chet dung de in bao cao tTong hop tinh hinh giao hang 
-- Last Edit : Thuy Tuyen , date 27/08/2008
--- Modify on 14/05/2015 by Bảo Anh: Bổ sung số đơn hàng

CREATE VIEW [dbo].[OV0303] as 
select DivisionID, InventoryID,Quantity01 as Quantity,Date01 as DeliDate,OrderDate,TranMonth,TranYear, TransactionID, VoucherNo from OV2302
Union all
select DivisionID, InventoryID,Quantity02 as Quantity,Date02 as DeliDate, OrderDate,TranMonth,TranYear, TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity03 as Quantity,Date03 as DeliDate,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select 	DivisionID, InventoryID,Quantity04 as Quantity, Date04 as DeliDate,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity05 as Quantity,Date05 as DeliDate,OrderDate,TranMonth,TranYear  , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity06 as Quantity,Date06 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, 	InventoryID,Quantity07 as Quantity,Date07 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity08 as Quantity,Date08 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity09 as Quantity,Date09 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity10 as Quantity,Date10 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity11 as Quantity,Date11 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo from OV2302
Union all
select DivisionID, InventoryID,Quantity12 as Quantity,Date12 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity13 as Quantity,Date13 as DeliDate  ,OrderDate,TranMonth,TranYear, TransactionID, VoucherNo  From OV2302
Union all
select 	DivisionID, InventoryID,Quantity14 as Quantity, Date14 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity15 as Quantity,Date15 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity16 as Quantity,Date16 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select 	DivisionID, InventoryID,Quantity17 as Quantity,Date17 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity18 as Quantity,Date18 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity19 as Quantity,Date19 as DeliDate  ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity20 as Quantity,Date20 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity21 as Quantity,Date21 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo from OV2302
Union all
select DivisionID, InventoryID,Quantity22 as Quantity,Date22 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity23 as Quantity,Date23 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, 	InventoryID,Quantity24 as Quantity, Date24 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity25 as Quantity,Date25 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity26 as Quantity,Date26 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, 	InventoryID,Quantity27 as Quantity,Date27 as DeliDate ,OrderDate,TranMonth,TranYear, TransactionID, VoucherNo  From OV2302
Union all
select DivisionID, InventoryID,Quantity28 as Quantity,Date28 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302
Union all
select DivisionID, InventoryID,Quantity29 as Quantity,Date29 as DeliDate ,OrderDate,TranMonth,TranYear, TransactionID, VoucherNo  From OV2302
Union all
select DivisionID, InventoryID,Quantity30 as Quantity,Date30 as DeliDate ,OrderDate,TranMonth,TranYear , TransactionID, VoucherNo From OV2302


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
