IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1021]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1021]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---- Created by: Bảo Anh	Date: 03/11/2013
---- Purpose: Kiểm tra trước khi xóa hợp đồng
---- EXEC AP1021 'LG','HT/02/2015/001'
CREATE PROCEDURE AP1021
( 
	@DivisionID NVARCHAR(50), 
	@ContractID NVARCHAR(50)
)
 AS

DECLARE @Status TINYINT, @AnaID VARCHAR(50), @sSQL1 NVARCHAR(10) = '', @sSQL NVARCHAR(2000) = '',
		@Message NVARCHAR(250)

SET @Status = 0

IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE DivisionID = @DivisionID 
				AND ContractDetailID IN	(SELECT ContractDetailID FROM AT1021 WHERE DivisionID = @DivisionID AND ContractID = @ContractID))
BEGIN		
	SET @Status = 1
	SET @Message = N'CFML000054'
	GOTO EndMess
END
-- Lấy theo thiết lập chọn hợp đồng bán/mua	
IF ISNULL((SELECT ContractType FROM AT1020 WHERE DivisionID = @DivisionID AND ContractID = @ContractID), 0) = 0
SET @AnaID = ISNULL((SELECT TOP 1 ContractAnaTypeID FROM AT0000 WHERE DefDivisionID = @DivisionID),'')

IF ISNULL((SELECT ContractType FROM AT1020 WHERE DivisionID = @DivisionID AND ContractID = @ContractID), 0) = 1
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

DECLARE @ContractNo VARCHAR(50)
SET @ContractNo = (SELECT ContractNo FROM AT1020 WHERE DivisionID = @DivisionID AND ContractID = @ContractID)

CREATE TABLE #TAM (IsUsed TINYINT)
SET @sSQL = '
INSERT INTO #TAM (IsUsed)
SELECT TOP 1 1 FROM AT9000 WHERE DivisionID = '''+@DivisionID+''' AND '+@sSQL1+' = '''+@ContractNo+''''
EXEC (@sSQL)

IF EXISTS (SELECT TOP 1 1 FROM #TAM)
BEGIN
	SET @Status = 1
	SET @Message = N'CFML000054'
	GOTO EndMess
END

EndMess:
SELECT @Status [Status], @Message [Message]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
