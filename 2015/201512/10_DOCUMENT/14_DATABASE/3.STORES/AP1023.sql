IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1023]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1023]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Mai Duyen	Date: 11/12/2013
---- Purpose : In hợp đồng chuyển nhượng (Sinolife)
---- AP1023 'AS','CT20120000000006'

CREATE PROCEDURE [dbo].[AP1023]
	@DivisionID nvarchar(50),
	@ContractID nvarchar(50)
	
AS

DECLARE  @SQL nvarchar(4000)

Set @SQL = 'SELECT 
AT1020.DivisionID,
AT1020.ContractID,
AT1020.VoucherTypeID,
AT1020.ContractNo,
AT1020.SignDate,
AT1020.CurrencyID,
AT1020.ContractName,
AT1020.ObjectID,
AT1202.ObjectName,
AT1020.ContractType,
AT1020.Amount,
AT1020.ConRef01,
AT1020.ConRef02,
AT1020.ConRef03,
AT1020.ConRef04,
AT1020.ConRef05,
AT1020.ConRef06,
AT1020.ConRef07,
AT1020.ConRef08,
AT1020.ConRef09,
AT1020.ConRef10,
AT1020.Description,
AT0001.CompanyName,
AT0001.Tel,
AT0001.Fax,
AT0001.Address,--dia chi cong ty ban
AT1016.BankAccountNo,
AT1016.BankName,
AT0001.Chairmain,
AT0001.Director, 
AT1202.LicenseNo,---So CMND nguoi mua
AT1202.LegalCapital, --Nam sinh nguoi mua
AT1202.Note, --Ngay cap CMND nguoi mua
AT1202.Note1, --Noi cap CMND nguoi mua
AT1202.Address as ObjectAddress,--dia chi nguoi mua
AT1202.Tel as ObjectTel,
OT2002.Ana08ID as InventoryID, OT2002.SalePrice, OT2002.ConvertedSalePrice,
OT2002.InventoryID as InventoryTypeID, OT2002.Ana09ID as PaymentID,
AT1011.Notes, AT1011.Note01, AT1011.Amount01,
(Select PaymentAmount From AT1021 Where DivisionID = AT1020.DivisionID And ContractID = AT1020.ContractID And StepID = 1) as AdvanceAmount,
(Select count(StepID) From AT1021 Where DivisionID = AT1020.DivisionID And ContractID = AT1020.ContractID And StepID <> 1) as PaymentTimes

FROM AT1020
LEFT JOIN AT0001 On  AT0001.DivisionID = AT1020.DivisionID
LEFT JOIN AT1202 ON AT1202.DivisionID = AT1020.DivisionID AND AT1202.ObjectID = AT1020.ObjectID
LEFT JOIN AT1016 on AT1016.DivisionID = AT1020.DivisionID  AND AT1016.BankAccountID = AT0001.BankAccountID
LEFT JOIN OT2002 On AT1020.DivisionID = OT2002.DivisionID AND AT1020.STransactionID = OT2002.TransactionID
LEFT JOIN AT1011 On AT1011.DivisionID = OT2002.DivisionID AND AT1011.AnaID = OT2002.Ana08ID And AT1011.AnaTypeID = ''A08''

WHERE AT1020.DivisionID = '''+ @DivisionID +  '''AND AT1020.ContractID = ''' + @ContractID + ''''	
--PRINT @SQL
EXEC ( @SQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


