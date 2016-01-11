/****** Object:  View [dbo].[MQ2222]    Script Date: 12/16/2010 15:21:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----- Create By: Dang Le Bao Quynh; Date 16/11/2009
----- Purpose: View chet phuc vu viec ke thua ket qua san xuat lam ket qua san xuat

-- Edit by : Trong Khanh [10/02/2012] -- Thêm 5 mã phân tích
-- Edit by : Hoang vu [23/06/2015] -- Them cac truong ExtraID, InheritTableID, InheritVoucherID, InheritTransactionID,IsPhase, IsJob, IsResult (Custome Secoin)
								   -- Lấy thêm 3 trường ConvertedQuantity, InheritedConvertedQuantity và RemainConvertedQuantity
--- Modified by Tieu Mai on 30/10/2015: Bo sung 20 cot quy cach SxxID
--- Modified by Tieu Mai on 04/01/2016: Bo sung truong KITID

ALTER VIEW [dbo].[MQ2222]
AS

Select 
MT0810.VoucherID, 
MT0810.TranMonth, MT0810.Tranyear, MT0810.DivisionID, 
MT0810.VoucherTypeID, MT0810.VoucherNo, MT0810.VoucherDate, MT0810.Description, 
MT0810.EmployeeID, E1.FullName As EmployeeName, MT0810.KCSEmployeeID, E2.FullName As KCSEmployeeName, 
MT0810.IsWareHouse, MT0810.WareHouseID, AT1303.WareHouseName, MT0810.PeriodID, M1.Description As PeriodName, MT0810.TransferPeriodID, M2.Description As TransferPeriodName, 
MT0810.ObjectID, AT1202.ObjectName, 
MT0810.InventoryTypeID, MT0810.DepartmentID, MT0810.TeamID, 
MT1001.TransactionID, MT1001.Orders, MT1001.ProductID, AT1302.InventoryName As ProductName, AT1302.UnitID, 
MT1001.Quantity, 
isnull((Select Sum(isnull(Quantity,0)) From MT1001 M1 Where M1.MTransactionID = MT1001.TransactionID or M1.InheritTransactionID = MT1001.TransactionID),0) As InheritedQuantity,
MT1001.Quantity - isnull((Select Sum(isnull(Quantity,0)) From MT1001 M1 Where M1.MTransactionID = MT1001.TransactionID or M1.InheritTransactionID = MT1001.TransactionID),0) As RemainQuantity,
MT1001.ConvertedQuantity,
isnull((Select Sum(isnull(ConvertedQuantity,0)) From MT1001 M1 Where M1.MTransactionID = MT1001.TransactionID or M1.InheritTransactionID = MT1001.TransactionID),0) As InheritedConvertedQuantity,
MT1001.ConvertedQuantity - isnull((Select Sum(isnull(ConvertedQuantity,0)) From MT1001 M1 Where M1.MTransactionID = MT1001.TransactionID or M1.InheritTransactionID = MT1001.TransactionID),0) As RemainConvertedQuantity,
MT1001.SourceNo, MT1001.DebitAccountID, MT1001.CreditAccountID, MT1001.Note,
MT1001.Ana01ID, MT1001.Ana02ID, MT1001.Ana03ID, MT1001.Ana04ID, MT1001.Ana05ID, 
MT1001.Ana06ID, MT1001.Ana07ID, MT1001.Ana08ID, MT1001.Ana09ID, MT1001.Ana10ID, 
A1.AnaName as Ana01Name, A2.AnaName as Ana02Name, A3.AnaName as Ana03Name, A4.AnaName as Ana04Name, A5.AnaName as Ana05Name, 
A6.AnaName as Ana06Name, A7.AnaName as Ana07Name, A8.AnaName as Ana08Name, A9.AnaName as Ana09Name, A10.AnaName as Ana10Name, 
MT1001.ProductID1, P.InventoryName As ProductName1,
MT1001.InventoryID, Q.InventoryName,
Isnull(MT1001.ExtraID,MT2008.ExtraID) as ExtraID , isnull(A11.ExtraName, A12.ExtraName)  as ExtraName,
MT0810.VoucherNo as ReVoucherNo,
MT1001.InheritTableID, 
MT1001.InheritVoucherID, 
MT1001.InheritTransactionID,
MT0810.IsPhase, 
MT0810.IsJob, 
MT0810.IsResult,
M89.S01ID, M89.S02ID, M89.S03ID, M89.S04ID, M89.S05ID, M89.S06ID, M89.S07ID, M89.S08ID, M89.S09ID, M89.S10ID, 
M89.S11ID, M89.S12ID, M89.S13ID, M89.S14ID, M89.S15ID, M89.S16ID, M89.S17ID, M89.S18ID, M89.S19ID, M89.S20ID,
MT1001.KITID
From MT0810 
Inner Join MT1001 on MT0810.VoucherID = MT1001.VoucherID And MT0810.DivisionID = MT1001.DivisionID
LEFT JOIN MT8899 M89 ON M89.DivisionID = MT1001.DivisionID AND M89.TransactionID = MT1001.TransactionID AND M89.VoucherID = MT1001.VoucherID
Left join MT2008 on MT2008.DivisionID = MT1001.DivisionID and MT2008.VoucherID = MT1001.InheritVoucherID and MT2008.TransactionID = MT1001.InheritTransactionID
Left Join AT1311 A11 On MT1001.ExtraID = A11.ExtraID And MT0810.DivisionID = A11.DivisionID
Left Join AT1311 A12 On MT2008.ExtraID = A12.ExtraID And MT2008.DivisionID = A12.DivisionID
Left Join AT1202 On MT0810.ObjectID = AT1202.ObjectID And MT0810.DivisionID = AT1202.DivisionID
Left Join AT1103 E1 On MT0810.EmployeeID = E1.EmployeeID And MT0810.DivisionID = E1.DivisionID
Left Join AT1103 E2 On MT0810.KCSEmployeeID = E2.EmployeeID And MT0810.DivisionID = E2.DivisionID
Left Join AT1303 On MT0810.WareHouseID = AT1303.WareHouseID And MT0810.DivisionID = AT1303.DivisionID
Left Join MT1601 M1 On MT0810.PeriodID = M1.PeriodID And MT0810.DivisionID = M1.DivisionID
Left Join MT1601 M2 On MT0810.TransferPeriodID = M2.PeriodID And MT0810.DivisionID = M2.DivisionID
Left Join AT1302 On MT1001.ProductID = AT1302.InventoryID And MT0810.DivisionID = AT1302.DivisionID
Left Join AT1302 P On MT1001.ProductID1 = P.InventoryID And MT0810.DivisionID = P.DivisionID
Left Join AT1302 Q On MT1001.InventoryID = Q.InventoryID And MT0810.DivisionID = Q.DivisionID
Left Join AT1011 A1 On MT1001.Ana01ID = A1.AnaID And A1.AnaTypeID = 'A01' And MT0810.DivisionID = A1.DivisionID
Left Join AT1011 A2 On MT1001.Ana02ID = A2.AnaID And A2.AnaTypeID = 'A02' And MT0810.DivisionID = A2.DivisionID
Left Join AT1011 A3 On MT1001.Ana03ID = A3.AnaID And A3.AnaTypeID = 'A03' And MT0810.DivisionID = A3.DivisionID
Left Join AT1011 A4 On MT1001.Ana04ID = A4.AnaID And A4.AnaTypeID = 'A04' And MT0810.DivisionID = A4.DivisionID
Left Join AT1011 A5 On MT1001.Ana05ID = A5.AnaID And A5.AnaTypeID = 'A05' And MT0810.DivisionID = A5.DivisionID
Left Join AT1011 A6 On MT1001.Ana06ID = A6.AnaID And A6.AnaTypeID = 'A06' And MT0810.DivisionID = A6.DivisionID
Left Join AT1011 A7 On MT1001.Ana07ID = A7.AnaID And A7.AnaTypeID = 'A07' And MT0810.DivisionID = A7.DivisionID
Left Join AT1011 A8 On MT1001.Ana08ID = A8.AnaID And A8.AnaTypeID = 'A08' And MT0810.DivisionID = A8.DivisionID
Left Join AT1011 A9 On MT1001.Ana09ID = A9.AnaID And A9.AnaTypeID = 'A09' And MT0810.DivisionID = A9.DivisionID
Left Join AT1011 A10 On MT1001.Ana10ID = A10.AnaID And A10.AnaTypeID = 'A10' And MT0810.DivisionID = A10.DivisionID
Where ResultTypeID = 'R01'

GO


