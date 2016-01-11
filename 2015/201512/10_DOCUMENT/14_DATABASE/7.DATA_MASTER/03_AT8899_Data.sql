--- Created by Tieu Mai 
--- Purpose: update lại Division cho dữ liệu cũ chưa có cột Division.

IF EXISTS(Select Top 1 1 from AT8899 where DivisionID ='FIX_R06')
BEGIN
UPDATE AT88
set AT88.DivisionID = AT00.DivisionID
FROM AT8899 AT88
INNER JOIN (SELECT  AT9000.DivisionID, AT9000.VoucherID, AT9000.TransactionID 
			FROM AT9000 
   ) AT00
  ON AT88.VoucherID = AT00.VoucherID AND AT88.TransactionID = AT00.TransactionID
END