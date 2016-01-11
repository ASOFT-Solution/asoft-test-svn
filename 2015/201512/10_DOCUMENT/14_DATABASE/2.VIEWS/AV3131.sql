IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV3131]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV3131]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------------- 	Created View AV3131. Purpose: Hien thi chi tiet lai suat va tien thuong (View chet)
------------		Created  Date: 25/05/2005 by Nguyen Van Nhan
------------		Edited  Date: 25/05/2005 by Nguyen Quoc Huy

CREATE VIEW [dbo].[AV3131] as 
Select 
	AT3131.DivisionID, VoucherID,CalID,
	TranMonth, TranYear, CalMonth, CalYear, 
	AT3131.ObjectID, AT1202.ObjectName,
	ConvertedAmount, OriginalAmount,
	GiveOriginalAmount,
	GiveConvertedAmount,
	RemainOriginalAmount,
 	RemainConvertedAmount,
	BonusAmount,
	InterestAmount,
	VoucherNo,
	VoucherDate,
	InvoiceNo,
	InvoiceDate,
	Serial,
	DueDate,
	Ana01ID,
	Ana02ID ,
	Ana03ID,
	Ana04ID ,
	Ana05ID,
	Ana06ID ,
	Ana07ID,
	Ana08ID ,
	Ana09ID,
	Ana10ID ,
	CurrencyID,
	O01ID,
	O02ID,
	O03ID,
	O04ID,
	O05ID,
	S1 as CO1ID,
	S2 as  CO2ID,
	S3 as  CO3ID
From AT3131	inner join AT1202 on AT1202.ObjectID = AT3131.ObjectID and AT1202.DivisionID = AT3131.DivisionID

GO


