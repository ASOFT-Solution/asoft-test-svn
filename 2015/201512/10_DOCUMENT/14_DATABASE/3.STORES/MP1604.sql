
/****** Object:  StoredProcedure [dbo].[MP1604]    Script Date: 07/30/2010 11:24:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by Hoang Thi Lan
--Date 08/10/2003
--Purpose:lay du lieu dung cho viec sua bo he so theo san pham
--Edit by Nguyen Quoc Huy
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/
---- Modified by Tiểu Mai on 17/12/2015: Bổ sung 20 cột quy cách, trả dữ liệu không sinh view


ALTER procedure [dbo].[MP1604] @DivisionID nvarchar(50), @CoefficientID as nvarchar(50)
as
 Declare @sSQL as nvarchar(max)
 IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	 set @sSQL='
	Select distinct MT04.CoefficientID,
		MT05.DeCoefficientID,
		MT04.CreateDate,
		MT04.Disabled,
		MT04.CoefficientName,
		MT04.EmployeeID,
		AT03.FullName,	
		MT04.Description,
		MT04.InventoryTypeID,
		MT04.RefNo,
		MT04.CoType,
		MT05.InventoryID,
		AT02.InventoryName,
		MT05.CoValue,
		MT05.Notes,
		MT05.DivisionID,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID

	From MT1605 MT05
			Inner join MT1604 MT04 on MT05.CoefficientID=MT04.CoefficientID and MT05.DivisionID=MT04.DivisionID
							   left join AT1302 AT02 on MT05.InventoryID=AT02.InventoryID and MT05.DivisionID=AT02.DivisionID
			Left Join AT1103 AT03 On MT04.EmployeeID = AT03.EmployeeID and MT04.DivisionID = AT03.DivisionID
						and AT03.DivisionID = '''+@DivisionID+'''
			Left join MT8899 O99 on O99.DivisionID = MT05.DivisionID and O99.VoucherID = MT05.CoefficientID and O99.TransactionID = MT05.DeCoefficientID
	where  MT04.CoefficientID='''+@CoefficientID+''''
 ELSE
	set @sSQL='

	Select distinct MT04.CoefficientID,
		MT05.DeCoefficientID,
		MT04.CreateDate,
		MT04.Disabled,
		MT04.CoefficientName,
		MT04.EmployeeID,
		AT03.FullName,	
		MT04.Description,
		MT04.InventoryTypeID,
		MT04.RefNo,
		MT04.CoType,
		MT05.InventoryID,
		AT02.InventoryName,
		MT05.CoValue,
		MT05.Notes,
		MT05.DivisionID

	From MT1605 MT05
			Inner join MT1604 MT04 on MT05.CoefficientID=MT04.CoefficientID and MT05.DivisionID=MT04.DivisionID
							   left join AT1302 AT02 on MT05.InventoryID=AT02.InventoryID and MT05.DivisionID=AT02.DivisionID
			Left Join AT1103 AT03 On MT04.EmployeeID = AT03.EmployeeID and MT04.DivisionID = AT03.DivisionID
						and AT03.DivisionID = '''+@DivisionID+'''

	where  MT04.CoefficientID='''+@CoefficientID+''''

EXEC (@sSQL)










