IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ4301]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP View [DBO].[AQ4301]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Create by: Đặng Lê Bảo Quỳnh
--Purpose: View chết lấy số dư tài khoản, dùng có các subquery khi cần, tăng tốc độ xử lý. 
CREATE VIEW [dbo].[AQ4301]  
AS  
SELECT 
  DivisionID, 
  DebitAccountID AS AccountID, 'D' AS D_C,   
  ConvertedAmount AS SignAmount, 
  OriginalAmount AS SignOriginal,  
  Quantity AS SignQuantity,   
  TranMonth, TranYear, VoucherDate,
  ObjectID,  
  InventoryID
FROM AT9000 
WHERE DebitAccountID IS NOT NULL AND DebitAccountID <> ''  
UNION ALL  
SELECT 
  DivisionID, 
  CreditAccountID AS AccountID, 'D' AS D_C,   
  -ConvertedAmount AS SignAmount, 
  -OriginalAmount AS SignOriginal,  
  -Quantity AS SignQuantity,   
  TranMonth, TranYear, VoucherDate,
  CASE WHEN TransactionTypeID ='T99' then CreditObjectID else ObjectID end AS ObjectID,   
  InventoryID
FROM AT9000 
WHERE CreditAccountID IS NOT NULL AND CreditAccountID <> ''  
