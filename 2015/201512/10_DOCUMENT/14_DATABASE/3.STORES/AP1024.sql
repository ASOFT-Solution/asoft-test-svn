IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1024]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1024]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 23/01/2014
---- Purpose : In báo cáo bảng thanh toán hàng tháng (customize Sinolife)
---- AP1024 'AS','CT20120000000015'

CREATE PROCEDURE [dbo].[AP1024]
	@DivisionID nvarchar(50),
	@ContractID nvarchar(50)
	
AS

DECLARE @SQL nvarchar(4000)

SELECT	T20.ContractNo, T20.SignDate, T20.Amount,
		OT2002.InventoryID as InventoryTypeID,
		OT2002.Ana08ID as InventoryID, AT1011.AnaName as InventoryName,
		T21.StepID, T21.StepName, T21.PaymentDate, T21.PaymentAmount, T21.Notes,
		
		(Select PaymentAmount From AT1021 Where DivisionID = @DivisionID And ContractID = @ContractID And StepID = 1) as AdvanceAmount,
		(Select PaymentDate From AT1021 Where DivisionID = @DivisionID And ContractID = @ContractID And StepID = 2) as FirstPaymentDate,
		(Select top 1 PaymentDate From AT1021 Where DivisionID = @DivisionID And ContractID = @ContractID Order by StepID DESC) as LastPaymentDate	
		
FROM AT1020 T20
INNER JOIN AT1021 T21 On T20.DivisionID = T21.DivisionID And T20.ContractID = T21.ContractID
LEFT JOIN OT2002 On T20.DivisionID = OT2002.DivisionID And T20.STransactionID = OT2002.TransactionID
LEFT JOIN AT1011 On OT2002.DivisionID = AT1011.DivisionID And OT2002.Ana08ID = AT1011.AnaID And AT1011.AnaTypeID = 'A08'

WHERE T20.DivisionID = @DivisionID
AND T20.ContractID = @ContractID

ORDER BY T21.StepID