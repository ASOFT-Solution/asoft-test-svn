IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1026]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1026]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- 
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:  on: 
---- Modified on 
-- <Example>
/*
	 AP1026 'LTV', '', 'ADC/08/2014/0007'
*/

 CREATE PROCEDURE AP1026
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@ContractID VARCHAR(50)
)
AS
DECLARE @sSQL NVARCHAR(MAX), @AnaID VARCHAR(50), @sSQL1 NVARCHAR(10) = ''
-- Lấy mã phân tích hợp đồng

IF ISNULL((SELECT TOP 1 ContractType FROM AT1020 WHERE DivisionID = @DivisionID AND ContractNo = @ContractID), 0) = 0
SET @AnaID = ISNULL((SELECT TOP 1 ContractAnaTypeID FROM AT0000 WHERE DefDivisionID = @DivisionID),'')

IF ISNULL((SELECT TOP 1 ContractType FROM AT1020 WHERE DivisionID = @DivisionID AND ContractNo = @ContractID), 0) = 1
SET @AnaID = ISNULL((SELECT TOP 1 SalesContractAnaTypeID FROM AT0000 WHERE DefDivisionID = @DivisionID), '')

IF @AnaID = 'A01' SET @sSQL1 = 'Ana01ID'
IF @AnaID = 'A02' SET @sSQL1 = 'Ana02ID'
IF @AnaID = 'A03' SET @sSQL1 = 'Ana03ID'
IF @AnaID = 'A04' SET @sSQL1 = 'Ana04ID'
IF @AnaID = 'A05' SET @sSQL1 = 'Ana05ID'
IF @AnaID = 'A06' SET @sSQL1 = 'Ana06ID'
IF @AnaID = 'A07' SET @sSQL1 = 'Ana07ID'
IF @AnaID = 'A08' SET @sSQL1 = 'Ana08ID'
IF @AnaID = 'A09' SET @sSQL1 = 'Ana09ID'
IF @AnaID = 'A10' SET @sSQL1 = 'Ana10ID'
IF ISNULL(@AnaID, '') = ''    SET @sSQL1 = ''''''

SET @sSQL = '
SELECT A90.VoucherDate, A90.VoucherNo, A90.TDescription [Description], A90.ConvertedAmount, A90.ObjectID, A02.ObjectName
FROM AT9000 A90
LEFT JOIN AT1202 A02 ON A02.DivisionID = A90.DivisionID AND A02.ObjectID = A90.ObjectID
WHERE A90.DivisionID = '''+@DivisionID+'''
AND ISNULL('+@sSQL1+','''') = '''+@ContractID+'''
ORDER BY A90.VoucherDate, A90.VoucherNo, A90.Orders'

EXEC (@sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
