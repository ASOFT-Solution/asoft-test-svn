SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--PP:Tao view de truy van chi phi mua hang (Master)
--Au:Thuy Tuyen
--Dates:30/06/2008

ALTER VIEW [dbo].[AV3034] AS

SELECT 
T9.VoucherNo AS BHVoucherNo,
AT9000.VoucherID,
AT9000.VoucherNO, 
AT9000.VoucherDate,
AT9000.VoucherTypeID, 
AT9000.EmployeeID, 
AT1103.FullName, 
AT9000.VDescription,
SUM(ConvertedAmount) AS TotalCost, 
AT9000.TRanMonth, 
AT9000.TranYear, 
AT9000.DivisionID, AT9000.CreateUserID

FROM AT9000 
LEFT JOIN AT1103 ON AT9000.DivisionID = AT1103.DivisionID AND AT9000.EmployeeID = AT1103.EmployeeID
INNER JOIN (SELECT DISTINCT VoucherID, VoucherNO, DivisionID FROM AT9000 WHERE AT9000.TransactionTypeID IN ('T03') AND AT9000.TableID = 'AT9000' ) AS T9
    ON T9.DivisionID = AT9000.DivisionID AND T9.VoucherID = AT9000.VoucherID 
WHERE AT9000.TransactionTypeID IN ('T23') AND AT9000.TableID = 'AT9000' 
GROUP BY 
T9.VoucherNo, AT9000.VoucherID,AT9000.VoucherNO, AT9000.VoucherDate,
AT9000.VoucherTypeID, AT9000.EmployeeID,AT9000.VDescription, AT1103.FullName, AT9000.TRanMonth, AT9000.TranYear, AT9000.DivisionID, AT9000.CreateUserID

GO


