
--- Created by Tieu Mai 
--- Purpose: update lại Division cho dữ liệu cũ chưa có cột Division.


IF EXISTS(Select Top 1 1 from WT8899 where DivisionID ='FIX_R06')
BEGIN
UPDATE WT88
set WT88.DivisionID = AT00.DivisionID
FROM WT8899 WT88
INNER JOIN (SELECT  AT2007.DivisionID, AT2007.VoucherID, AT2007.TransactionID 
   FROM AT2007  
   UNION
   SELECT  WT0096.DivisionID, WT0096.VoucherID, WT0096.TransactionID 
   FROM WT0096  
   UNION
   SELECT  AT2037.DivisionID, AT2037.VoucherID, AT2037.TransactionID 
   FROM AT2037 
   ) AT00
  ON WT88.VoucherID = AT00.VoucherID AND WT88.TransactionID = AT00.TransactionID
END