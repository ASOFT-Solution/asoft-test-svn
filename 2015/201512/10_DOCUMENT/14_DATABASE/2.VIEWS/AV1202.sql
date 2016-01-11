/****** Object:  View [dbo].[AV1202]    Script Date: 12/16/2010 14:55:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Creater by: Nguyen Quoc Huy
--Date: 14/03/2006
-- View chet

ALTER VIEW [dbo].[AV1202] AS 	
Select AT1202.DivisionID,
	ObjectID, ObjectName, 
	S1, AT1207_S1.Sname as Sname1,
	S2, AT1207_S2.Sname as Sname2,
	S3, AT1207_S3.Sname as Sname3,
	AT1202.ObjectTypeID, ObjectTypeName,
	AT1202.Redays, AT1202.IsLockedOver,	
	IsSupplier, IsCustomer, IsUpdateName, 
	TradeName, LegalCapital, Address, 
	 
	FieldID, 	CurrencyID,CountryID, CityID, PaymentID, FinanceStatusID, 
	AreaID, RePaymentTermID, PaPaymentTermID,  BrabNameID, EmployeeID, 
	PaAccountID, ReAccountID,

	Tel, Fax, Email, Website, Note, BankName, Contactor,
	BankAddress, BankAccountNo, 	LicenseNo, LicenseOffice, 
	LicenseDate, Register, Potentility,
	AT1202.Disabled, AT1202.CreateDate, AT1202.CreateUserID, AT1202.LastModifyDate, AT1202.LastModifyUserID, 
	VATNo, ReCreditLimit, PaCreditLimit, ReDueDays, PaDueDays, 
	PaDiscountDays, PaDiscountPercent, 

	O01ID, AT1015_O01.AnaName AS AnaName1,
	O02ID, AT1015_O02.AnaName AS AnaName2,
	O03ID, AT1015_O03.AnaName AS AnaName3,
	O04ID, AT1015_O04.AnaName AS AnaName4,
	O05ID, AT1015_O05.AnaName AS AnaName5,

	DeAddress, ReAddress, Note1, AT1202.IsCommon
   

From AT1202 	Left Join AT1201 On AT1202.ObjectTypeID = AT1201.ObjectTypeID and AT1202.DivisionID = AT1201.DivisionID

		Left Join AT1207 AT1207_S1 On AT1202.S1= AT1207_S1.S and AT1207_S1.STypeID ='O01' and AT1202.DivisionID= AT1207_S1.DivisionID
		Left Join AT1207 AT1207_S2 On AT1202.S2= AT1207_S2.S and AT1207_S2.STypeID ='O02' and AT1202.DivisionID= AT1207_S2.DivisionID
		Left Join AT1207 AT1207_S3 On AT1202.S3= AT1207_S3.S and AT1207_S3.STypeID ='O03' and AT1202.DivisionID= AT1207_S3.DivisionID
		Left Join AT1015 AT1015_O01 On AT1202.O01ID= AT1015_O01.AnaID and AT1015_O01.AnaTypeID ='O01' and AT1202.DivisionID= AT1015_O01.DivisionID
		Left Join AT1015 AT1015_O02 On AT1202.O02ID= AT1015_O02.AnaID and AT1015_O02.AnaTypeID ='O02' and AT1202.DivisionID= AT1015_O02.DivisionID
		Left Join AT1015 AT1015_O03 On AT1202.O03ID= AT1015_O03.AnaID and AT1015_O03.AnaTypeID ='O03' and AT1202.DivisionID= AT1015_O03.DivisionID
		Left Join AT1015 AT1015_O04 On AT1202.O04ID= AT1015_O04.AnaID and AT1015_O04.AnaTypeID ='O04' and AT1202.DivisionID= AT1015_O04.DivisionID
		Left Join AT1015 AT1015_O05 On AT1202.O05ID= AT1015_O05.AnaID and AT1015_O05.AnaTypeID ='O05' and AT1202.DivisionID= AT1015_O05.DivisionID

GO


