
/****** Object:  View [dbo].[AV1705]    Script Date: 12/16/2010 14:53:29 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER VIEW [dbo].[AV1705] --- tao boi AP1705
		as  
		Select 
		AT1703.*,
		(Select ObjectName From AT1202 Where ObjectID = AT1703.ObjectID) As ObjectName,
		ApportionAmount as ConvertedUnit,
		Case AT1703.UseStatus 
		When 0 Then 'Ch?a pha?n bo?' 
		When 1 Then '?ang pha?n bo?' 
		When 8 Then 'Ng??ng pha?n bo?' 
		Else 'Pha?n bo? he?t' End As IsStop,
		CAST ( BeginMonth AS Varchar)  + '/' + CAST ( BeginYear AS Varchar) as MonthYearBegin,
		CAST ( AT1703.TranMonth AS Varchar)  + '/' + CAST ( AT1703.TranYear AS Varchar) as MonthYear,
		AV1702.VDescription
	From AT1703
	inner Join AV1702 On AV1702.VoucherID = AT1703.VoucherID
		and AV1702.AccountID =AT1703.CreditAccountID 
	Where  AT1703.DivisionID = 'ASNHT'
	And	AT1703.D_C = 'D' 
	and       AT1703.TranMonth + AT1703.TranYear*12 Between 24061 And 24120

GO


