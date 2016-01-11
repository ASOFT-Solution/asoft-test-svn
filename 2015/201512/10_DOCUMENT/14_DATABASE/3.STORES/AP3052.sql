/****** Object:  StoredProcedure [dbo].[AP3052]    Script Date: 12/01/2011 14:35:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP3052]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP3052]
GO

/****** Object:  StoredProcedure [dbo].[AP3052]    Script Date: 12/01/2011 14:35:15 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by Nguyen Quoc Huy
--Date 04/10/2005
--Purpose:Hang ban bi tra lai
--Last Edit ThuyTuyen Them truong AT9000.DiscountRate,27/03/2007
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/
--Edited by: Dang Le Bao Quynh; Date: 01/12/2011
--Purpose: Them cac field phan loai va ma phan tich doi tuong

CREATE PROCEDURE [dbo].[AP3052] @DivisionID as nvarchar(50) ,@sSQLWhere as nvarchar(4000)  
as
declare @sSQL as nvarchar(4000) 
set @sSQL='
	Select  AT9000.ObjectID,
		OB.ObjectName,
		OB.S1, OB.S2, OB.S3, 
		OB.S1Name, OB.S2Name, OB.S3Name, 
		OB.O01ID,  OB.O02ID, OB.O03ID, OB.O04ID, OB.O05ID,
		OB.O01Name, OB.O02Name, OB.O03Name, OB.O04Name, OB.O05Name, 
		AT9000.InventoryID,
		AT1302.InventoryName,
		AT1302.UnitID,
		AT1304.UnitName,
		AT1302.InventoryTypeID,
		AT1302.Specification,
		AT9000.VoucherTypeID, 
		AT9000.VoucherNo,
		AT9000.VoucherDate,
		AT9000.RefNo01,	
		AT9000.RefNo02,	
		AT9000.Ana01ID, 
		AT9000.Ana02ID, 
		AT9000.Ana03ID, 
	    AT9000.Serial,
		AT9000.InvoiceNo,
		AT9000.InvoiceDate,
		isnull(AT9000.Quantity,0) as Quantity,
		AT9000.CurrencyID,
		isnull(AT9000.OriginalAmount,0)/(Case when isnull(AT9000.Quantity,0)=0 then 1 else AT9000.Quantity end) as SalePrice01,
		isnull(AT9000.ConvertedAmount,0)/(Case when isnull(AT9000.Quantity,0)=0 then 1 else AT9000.Quantity end) as SalePrice02,
		isnull(AT9000.OriginalAmount,0) as OriginalAmount,
		isnull(AT9000.ConvertedAmount,0) as ConvertedAmount, VATRate,
    	AT9000.VDescription,
		AT9000.BDescription,
		AT9000.TDescription,
		AT9000.DiscountRate, AT9000.DivisionID
     
	From AT9000 	left join AT1302 on AT9000.InventoryID=AT1302.InventoryID  and  AT9000.DivisionID=AT1302.DivisionID
		   	Left join AT1304 on AT1304.UnitID = AT1302.UnitID and  AT9000.DivisionID=AT1304.DivisionID
			left join AT1010 on AT1010.VATGroupID = AT9000.VATGroupID and  AT9000.DivisionID=AT1010.DivisionID
			Left Join 
			(Select 
					AT1202.DivisionID, AT1202.ObjectID, AT1202.ObjectName, 
					AT1202.S1, AT1202.S2,  AT1202.S3, 
					OS1.SName As S1Name, OS2.SName As S2Name, OS3.SName As S3Name, 
					AT1202.O01ID,  AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
					O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name
			From AT1202 
					Left join AT1015 O1 on O1.AnaID = AT1202.O01ID and O1.DivisionID = AT1202.DivisionID and O1.AnaTypeID = ''O01''
					Left join AT1015 O2 on O2.AnaID = AT1202.O02ID and O2.DivisionID = AT1202.DivisionID and O2.AnaTypeID = ''O02''
					Left join AT1015 O3 on O3.AnaID = AT1202.O03ID and O3.DivisionID = AT1202.DivisionID and O3.AnaTypeID = ''O03''
					Left join AT1015 O4 on O4.AnaID = AT1202.O04ID and O4.DivisionID = AT1202.DivisionID and O4.AnaTypeID = ''O04''
					Left join AT1015 O5 on O5.AnaID = AT1202.O05ID and O5.DivisionID = AT1202.DivisionID and O5.AnaTypeID = ''O05''
					Left join AT1207 OS1 on OS1.S = AT1202.S1 and OS1.DivisionID = AT1202.DivisionID and OS1.STypeID = ''O01''
					Left join AT1207 OS2 on OS2.S = AT1202.S2 and OS2.DivisionID = AT1202.DivisionID and OS2.STypeID = ''O02''
					Left join AT1207 OS3 on OS3.S = AT1202.S3 and OS3.DivisionID = AT1202.DivisionID and OS3.STypeID = ''O03'') OB
			On AT9000.ObjectID = OB.ObjectID And AT9000.DivisionID = OB.DivisionID
	where AT9000.DivisionID='''+@DivisionID+'''
	and AT9000.TransactionTypeID=''T24''
	and '+@sSQLWhere+''

--print @sSQL
If  exists (Select top 1 1 From SysObjects Where name = 'AV3052' and Xtype ='V')
	DROP view AV3052
Exec ('Create view AV3052 --tao boi AP3052
			 as '+@sSQL)
GO


