/****** Object:  StoredProcedure [dbo].[MP1613]    Script Date: 12/30/2010 13:28:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--Created by Hoang Thi Lan
--Date 21/10/2003
--Purpose :Truy vÊn chi phÝ dë dang ®Çu kú
--Edit by Nguyen Quoc Huy
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
-- Modified by Tiểu Mai on 21/12/2015: Bổ sung thông tin quy cách, bỏ view

ALTER PROCEDURE [dbo].[MP1613] @DivisionID as nvarchar(50),
				@VoucherTypeID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)
as 
Declare @sSQL as nvarchar(4000),
		@sSQL1 as nvarchar(4000),
		@sSQL2 as nvarchar(4000)

Set @sSQL = '
	Select Distinct MT1612.VoucherTypeID,
		MaterialID,
		MT1612.DivisionID,
		AT1302_M.InventoryName as MaterialName,
		AT1302_M.UnitID ,
		MT0699.MaterialTypeID,
		MT0699.UserName,
		MT1612.WipVoucherID,
		MT1612.VoucherID,
		MT1612.VoucherNo,
	       	MT1612.EmployeeID,
		AT1103.FullName,
		MT1612.Description,
		MT1612.VoucherDate,
		MT0699.ExpenseID,
		PeriodID,
		ProductID,	
		AT1302_P.InventoryName as ProductName,
		ProductQuantity,
		MaterialPrice,
		ConvertedAmount,
		PerfectRate,
		ConvertedUnit,
		WipQuantity,
		(Case when MT0699.UserName is null then ''MFML000133'' else ''MFML000134'' end) as Notes,
		MT1612.PS01ID, MT1612.PS02ID, MT1612.PS03ID, MT1612.PS04ID, MT1612.PS05ID, MT1612.PS06ID, MT1612.PS07ID, MT1612.PS08ID, MT1612.PS09ID, MT1612.PS10ID, 
		MT1612.PS11ID, MT1612.PS12ID, MT1612.PS13ID, MT1612.PS14ID, MT1612.PS15ID, MT1612.PS16ID, MT1612.PS17ID, MT1612.PS18ID, MT1612.PS19ID, MT1612.PS20ID,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
		A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
		A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
		A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
		A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
		'
SET @sSQL1 = '			
	From  MT1612	 left join MT0699 on MT1612.MaterialTypeID = MT0699.MaterialTypeID and MT1612.DivisionID = MT0699.DivisionID
		left join AT1103 on MT1612.EmployeeID=AT1103.EmployeeID and MT1612.DivisionID=AT1103.DivisionID
					and AT1103.DivisionID='''+ @DivisionID +'''
		left join AT1302 AT1302_P on MT1612.ProductID=AT1302_P.InventoryID and MT1612.DivisionID=AT1302_P.DivisionID
		left join AT1302 AT1302_M on MT1612.MaterialID = AT1302_M.InventoryID and MT1612.DivisionID = AT1302_M.DivisionID
		left join MT8899 O99 on O99.DivisionID = MT1612.DivisionID and O99.VoucherID = MT1612.VoucherID and O99.TransactionID = MT1612.WipVoucherID and O99.TableID = ''MT1612''
		LEFT JOIN AT0128 A10 ON A10.DivisionID = MT1612.DivisionID AND A10.StandardID = MT1612.PS01ID AND A10.StandardTypeID = ''S01''
		LEFT JOIN AT0128 A11 ON A11.DivisionID = MT1612.DivisionID AND A11.StandardID = MT1612.PS02ID AND A11.StandardTypeID = ''S02''
		LEFT JOIN AT0128 A12 ON A12.DivisionID = MT1612.DivisionID AND A12.StandardID = MT1612.PS03ID AND A12.StandardTypeID = ''S03''
		LEFT JOIN AT0128 A13 ON A13.DivisionID = MT1612.DivisionID AND A13.StandardID = MT1612.PS04ID AND A13.StandardTypeID = ''S04''
		LEFT JOIN AT0128 A14 ON A14.DivisionID = MT1612.DivisionID AND A14.StandardID = MT1612.PS05ID AND A14.StandardTypeID = ''S05''
		LEFT JOIN AT0128 A15 ON A15.DivisionID = MT1612.DivisionID AND A15.StandardID = MT1612.PS06ID AND A15.StandardTypeID = ''S06''
		LEFT JOIN AT0128 A16 ON A16.DivisionID = MT1612.DivisionID AND A16.StandardID = MT1612.PS07ID AND A16.StandardTypeID = ''S07''
		LEFT JOIN AT0128 A17 ON A17.DivisionID = MT1612.DivisionID AND A17.StandardID = MT1612.PS08ID AND A17.StandardTypeID = ''S08''
		LEFT JOIN AT0128 A18 ON A18.DivisionID = MT1612.DivisionID AND A18.StandardID = MT1612.PS09ID AND A18.StandardTypeID = ''S09''
		LEFT JOIN AT0128 A19 ON A19.DivisionID = MT1612.DivisionID AND A19.StandardID = MT1612.PS10ID AND A19.StandardTypeID = ''S10''
		LEFT JOIN AT0128 A20 ON A20.DivisionID = MT1612.DivisionID AND A20.StandardID = MT1612.PS11ID AND A20.StandardTypeID = ''S11''
		LEFT JOIN AT0128 A21 ON A21.DivisionID = MT1612.DivisionID AND A21.StandardID = MT1612.PS12ID AND A21.StandardTypeID = ''S12''
		LEFT JOIN AT0128 A22 ON A22.DivisionID = MT1612.DivisionID AND A22.StandardID = MT1612.PS13ID AND A22.StandardTypeID = ''S13''
		LEFT JOIN AT0128 A23 ON A23.DivisionID = MT1612.DivisionID AND A23.StandardID = MT1612.PS14ID AND A23.StandardTypeID = ''S14''
		LEFT JOIN AT0128 A24 ON A24.DivisionID = MT1612.DivisionID AND A24.StandardID = MT1612.PS15ID AND A24.StandardTypeID = ''S15''
		LEFT JOIN AT0128 A25 ON A25.DivisionID = MT1612.DivisionID AND A25.StandardID = MT1612.PS16ID AND A25.StandardTypeID = ''S16''
		LEFT JOIN AT0128 A26 ON A26.DivisionID = MT1612.DivisionID AND A26.StandardID = MT1612.PS17ID AND A26.StandardTypeID = ''S17''
		LEFT JOIN AT0128 A27 ON A27.DivisionID = MT1612.DivisionID AND A27.StandardID = MT1612.PS18ID AND A27.StandardTypeID = ''S18''
		LEFT JOIN AT0128 A28 ON A28.DivisionID = MT1612.DivisionID AND A28.StandardID = MT1612.PS19ID AND A28.StandardTypeID = ''S19''
		LEFT JOIN AT0128 A29 ON A29.DivisionID = MT1612.DivisionID AND A29.StandardID = MT1612.PS20ID AND A29.StandardTypeID = ''S20''
	Where 		MT1612.DivisionID='''+ @DivisionID +''' and
			MT1612.VoucherID ='''+@VoucherID+''' '
SET @sSQL2 = '
Union
Select 	Null as	VoucherTypeID,
	Null as 	MaterialID,
	MT0699.DivisionID,
	Null as	  MaterialName,
	Null as		UnitID ,
		MT0699.MaterialTypeID,
		MT0699.UserName,
	Null as	WipVoucherID,
	Null as	VoucherID,
	Null as	VoucherNo,
	Null as	EmployeeID,
	Null as	FullName,
	Null as	Description,
	Null as	VoucherDate,
		MT0699.ExpenseID,
	Null as	PeriodID,
	Null as	ProductID,	
	Null as	 ProductName,
	Null as	ProductQuantity,
	Null as	MaterialPrice,
	Null as	ConvertedAmount,
	Null as	PerfectRate,
	Null as	ConvertedUnit,
	Null as	WipQuantity,
	 ''MFML000135''  as Notes,
	NULL as PS01ID, NULL as PS02ID, NULL as PS03ID, NULL as PS04ID, NULL as PS05ID, NULL as PS06ID, NULL as PS07ID, NULL as PS08ID, NULL as PS09ID, NULL as PS10ID, 
	NULL as PS11ID, NULL as PS12ID, NULL as PS13ID, NULL as PS14ID, NULL as PS15ID, NULL as PS16ID, NULL as PS17ID, NULL as PS18ID, NULL as PS19ID, NULL as PS20ID,
	NULL as S01ID, NULL as S02ID, NULL as S03ID, NULL as S04ID, NULL as S05ID, NULL as S06ID, NULL as S07ID, NULL as S08ID, NULL as S09ID, NULL as S10ID, 
	NULL as S11ID, NULL as S12ID, NULL as S13ID, NULL as S14ID, NULL as S15ID, NULL as S16ID, NULL as S17ID, NULL as S18ID, NULL as S19ID, NULL as S20ID,
	NULL AS StandardName01, NULL AS StandardName02, NULL AS StandardName03, NULL AS StandardName04, NULL AS StandardName05,
	NULL AS StandardName06, NULL AS StandardName07, NULL AS StandardName08, NULL AS StandardName09, NULL AS StandardName10,
	NULL AS StandardName11, NULL AS StandardName12, NULL AS StandardName13, NULL AS StandardName14, NULL AS StandardName15, 
	NULL AS StandardName16, NULL AS StandardName17, NULL AS StandardName18, NULL AS StandardName19, NULL AS StandardName20
		
From MT0699
Where ExpenseID  in (''Cost002'',''Cost003'') and IsUsed = 1
	and (MaterialTypeID  not in (Select MaterialTypeID From MT1612 Where ExpenseID  in (''Cost002'',''Cost003'') and  MT1612.DivisionID='''+ @DivisionID +''' and
		VoucherID ='''+@VoucherID+'''  ))'



EXEC (@sSQL+@sSQL1+@sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON