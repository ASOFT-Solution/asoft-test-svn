
/****** Object:  View [dbo].[OV1305]    Script Date: 12/16/2010 14:52:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---CREATED BY: VO THANH HUONG
---DATE:  07/12/2005
---PURPOSE: LAY DU LIEU CHO MAN HINH TRUY VAN


ALTER VIEW [dbo].[OV1305] AS 
Select   OT1305.DivisionID ,OT1305.FileID, OT1305.FileNo, OT1305.TransactionID, 
	OT1305.FileDate, OT1305.ObjectID, 
	OT1305.FileType, OT1305.Type, 
	OT1305.EndDate, OT1305.RegisNo, OT1305.Description, 
	OT1305.ProductID, OT1305.PUnitID, OT1305.UnitPrice, 
	AT1302.InventoryName as ProductName, 
	AT1302.UnitID as UnitID, ---DVT CUA TP TRONG AT1302
	AT1302.MethodID,
	AT1302.AccountID,
	AT1302.InventoryTypeID as ProductTypeID,	

	OT1305.MaterialID, OT1305.MUnitID, 
	AT1302_M.InventoryName as MaterialName, 
	OT1305.Var01,  		--kho cat 1 (In)	---  Kieu dang (thung)
	OT1305.Var02, 		--kho cat 1 (In)
	OT1305.Var03,  		--Quy cach dong goi (In)
	OT1305.Var04,  		--Xu ly be mat (In)  --- Xu ly be mat (Thung)
	OT1305.Var05,  		--Link_Market (In)  --- Link_Market (Thung)
	OT1305.Var06,   	--Link_Film (In)       --- Link_Film (Thung)
	OT1305.Var07, 
	OT1305.Var08, 
	OT1305.Var09, 
	OT1305.Var10, 		--Note (In)    ---  Note (Thung)
	OT1305.Date01, 	
	OT1305.Num01, 	--Length (In/thung) 
	OT1305.Num02, 	--Width (In/thung)
	OT1305.Num03, 	--Height	 (In/thung)
	OT1305.Num04, 	--Color (In/thung)
	OT1305.Num05, 	--So dao cat (In)
	OT1305.Num06, 	--Sp tren to (In)   --- sp tren tam (thung)
	OT1305.Num07, 	-- So lan sua doi (In)
	OT1305.Num08, 			--- KhoChay (Thung)
	OT1305.Num09, 			--- KhoCat (Thung)
	OT1305.Num10, 			--- So mat in
	OT1305.Num11, 			--- Xoan
	isnull(OT1305.Num12,0) as Num12, 			-- So lop (Thung)
	OT1305.Num13, 
	OT1305.Num14, 
	OT1305.Num15, 
	OT1305.Orders, 
	OT1305.Disabled, OT1305.CreateUserID, OT1305.CreateDate, OT1305.LastModifyUserID, OT1305.LastModifyDate,
       	
	AT1302_M.S1,
	AT1302_M.S3, 
	AT1202.ObjectName, 
	AT1202.VATNo, 
	AT1202.Address, 
	AT1202.Note,
	AT1202.Note1,
	case when AT1302_M.S1  = OT1306.SMaterial01ID then Num12 else 0 end as L01,
	case when AT1302_M.S1 =  OT1306.SMaterial02ID then Num12 else 0 end as L02,
	case when AT1302_M.S1 =  OT1306.SMaterial03ID  and Num11 = 1 then Num12 else 0 end as L03,
	case when AT1302_M.S1 =  OT1306.SMaterial03ID and Num11 <> 1  then Num12 else 0 end as L04	
From  OT1305 	left join AT1302 on AT1302.InventoryID  = OT1305.ProductID
		left join AT1302 AT1302_M on AT1302_M.InventoryID = OT1305.MaterialID	
		left join AT1202 on AT1202.ObjectID = OT1305.ObjectID
		left join OT1306 on OT1306.C01= OT1306.C01

GO


