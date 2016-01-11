IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP03214]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP03214]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load dữ liệu cho AF0064 - Chi phí mua hàng khi thực hiện phân bổ chi phí mua hàng[Customize LAVO]
-- <History>
---- Create on 24/04/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
 AP03214 @DivisionID = 'LV', @VoucherID = '6b59bbad-3933-484d-9098-3633f0cc7ef9', @Status = 0
 SELECT * FROM AT0305 WHERE VoucherID = '6b59bbad-3933-484d-9098-3633f0cc7ef9'
 */

CREATE PROCEDURE [dbo].[AP03214] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50), -- Của chứng từ PBCPMH
	@Status INT -- 0: Add, 1: Edit, 3: Delete
AS

DECLARE @sSQL NVARCHAR(MAX)
SET @Status = ISNULL(@Status,0)
-- Xoá dữ liệu chi phí mua hàng T23
DELETE FROM AT9000
WHERE DivisionID = @DivisionID 
   AND VoucherID IN (SELECT AT0321.POVoucherID
                     FROM AT0321
                     WHERE AT0321.DivisionID = @DivisionID AND AT0321.VoucherID = @VoucherID) 
   AND TransactionTypeID = 'T23'
-- lOAD DỮ LIỆU CHO FORM
SET @sSQL = '
SELECT AT0321.VoucherID, AT0321.POVoucherID, AT90.DebitAccountID, AT09.DebitAccountID AS CreditAccountID, AT09.ObjectID, 
	   AT12.ObjectName, AT12.[Address], NULL AS TDescription, NULL AS VDescription, 
	   AT01.BaseCurrencyID, ISNULL(AT14.ExchangeRate,0) AS ExchangeRate, 
	   SUM(ISNULL(AT0321.ExpenseConvertedAmount,0)) AS OriginalAmount,
	   SUM(ISNULL(AT0321.ExpenseConvertedAmount,0)) AS ConvertedAmount
FROM AT0321 
INNER JOIN AT9000 AT90 ON AT90.DivisionID = AT0321.DivisionID AND AT90.VoucherID = AT0321.POVoucherID AND AT90.TransactionID = AT0321.POTransactionID 
	 AND AT90.TransactionTypeID = ''T03''
INNER JOIN AT9000 AT09 ON AT09.DivisionID = AT0321.DivisionID AND AT09.VoucherID = AT0321.POCVoucherID AND AT09.TransactionTypeID IN (''T99'',''T02'',''T22'')
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = AT0321.DivisionID AND AT12.ObjectID = AT09.ObjectID
LEFT JOIN AT0001 AT01 ON AT01.DivisionID = AT0321.DivisionID 
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = AT01.DivisionID AND AT14.CurrencyID = AT01.BaseCurrencyID
WHERE AT0321.DivisionID = '''+@DivisionID+''' AND AT0321.[Check] = 1 AND AT0321.VoucherID = '''+@VoucherID+''' AND AT09.DebitAccountID NOT LIKE ''133%''
GROUP BY AT0321.VoucherID, AT0321.POVoucherID, AT90.DebitAccountID, AT09.DebitAccountID, AT09.ObjectID, 
	     AT12.ObjectName, AT12.[Address], AT14.ExchangeRate, AT01.BaseCurrencyID
'
EXEC (@sSQL)
--PRINT(@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
