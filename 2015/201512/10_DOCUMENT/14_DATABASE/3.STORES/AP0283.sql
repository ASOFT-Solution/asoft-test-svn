IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0283]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0283]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Summary: Lấy ra danh sách công nợ phải thu theo đối tượng
----- Create by Lê Thị Hạnh 
----- Create Date 24/06/2014
----- AP0283 'KC', '2014-01-25 00:00:00.000'
----- AP0283 'TBI', '2014-01-25 00:00:00.000'
----------- Modify on Lê Thị Hạnh 25/06/2014
----------- Purpose: Sửa cách tính số ngày nợ quá hạn - lấy ngày hiện tại GETDATE() 




CREATE PROCEDURE [DBO].[AP0283]
(
	@DivisionID NVARCHAR(50)--,
	--@LoginDate	DATETIME	
)
AS

DECLARE @SSQL NVARCHAR(MAX), @SFROM NVARCHAR(MAX), @SWHERE NVARCHAR(MAX), @SSQL1 NVARCHAR(MAX), @CustomerName INT
SET @SSQL = ''
SET @SFROM = ''
SET @SSQL1 = ''
SET @SSQL = N'
		SELECT	 T09.ObjectID, T02.ObjectName, T09.VoucherNo, T09.CurrencyIDCN , T09.InvoiceNo,
					((DATEDIFF(DAY,T09.InvoiceDate,GETDATE())) - isnull(T02.ReDueDays,0) ) AS ExCreditLimit,
					(sum(isnull(T09.ConvertedAmount,0)) - Sum(isnull(T03.ConvertedAmount,0))) AS CreditLimitAmount,
					(sum(isnull(T09.OriginalAmountCN,0)) - Sum(isnull(T03.OriginalAmount,0))) AS CreditLimitAmountCN					 
					'
SET @SFROM = N'
		FROM	AT9000 T09
			LEFT JOIN AT1202 T02 ON T02.DivisionID = T09.DivisionID AND T02.ObjectID = T09.ObjectID AND T09.DivisionID = '''+@DivisionID+'''
			LEFT JOIN AT0303 T03 ON T03.DivisionID = T09.DivisionID AND T03.ObjectID = T09.ObjectID AND T09.DivisionID = '''+@DivisionID+'''
			AND T03.DebitVoucherID = T09.VoucherID AND T03.DebitBatchID = T09.BatchID
			AND T03.CurrencyID = T09.CurrencyID
			'
SET @SWHERE = N'
		WHERE T09.DivisionID = '''+@DivisionID+''' AND
				T09.DebitAccountID in (Select AT1005.AccountID From AT1005 Where AT1005.GroupID =''G03'' and  AT1005.IsObject =1) 
		' 
SET @SSQL1 = N'
		GROUP BY T09.ObjectID, T02.ObjectName,T09.VoucherNo, T09.CurrencyIDCN, T09.InvoiceNo,
					T09.InvoiceDate, T02.ReDueDays
        HAVING  (sum(isnull(T09.ConvertedAmount,0)) - Sum(isnull(T03.ConvertedAmount,0))) > 0 
		ORDER BY T09.ObjectID,T09.VoucherNo'

--SET @SQL = @SSQL + @SFROM + @SWHERE + @SSQL1
EXEC(@SSQL + @SFROM + @SWHERE + @SSQL1)
PRINT @SSQL + @SFROM + @SWHERE + @SSQL1
--EXEC @SQL
--PRINT (@SSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
