/****** Object:  StoredProcedure [dbo].[AP4016]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
---- Created by Nguyen Van Nhan, Date 04/08/2003
---- Purpose: Xoa phieu nhap kho tu mua hang va hang ban tra lai.
---- Modified by Tiểu Mai on 08/01/2016: Bổ sung xóa thông tin quy cách hàng hóa.

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

ALTER PROCEDURE	 [dbo].[AP4016] 	@VoucherID nvarchar(50), 
					@BatchID nvarchar(50), 
					@DivisionID nvarchar(50), 
					@TranMonth as int, 
					@TranYear as int
AS

-------- Xoa thong tin quy cach---------
DELETE WT8899
FROM WT8899
LEFT JOIN AT2007 ON AT2007.DivisionID = WT8899.DivisionID AND AT2007.VoucherID = WT8899.VoucherID AND AT2007.TransactionID = WT8899.TransactionID AND WT8899.TableID = 'AT2007'
WHERE AT2007.DivisionID = @DivisionID AND AT2007.VoucherID = @VoucherID

-------- Xoa bang Detail ----------
Delete AT2007 
From AT2007 inner join AT2006 on AT2007.VoucherID = AT2006.VoucherID and AT2007.DivisionID = AT2006.DivisionID
Where 	AT2007.VoucherID =@VoucherID AND AT2007.DivisionID = @DivisionID
	--and
	--(AT2006.TableID ='AT9000' or AT2006.TableID ='AT2006') and
	--AT2006.BatchID = @BatchID
-------- Xoa bang Master  ----------

Delete AT2006 
Where 	AT2006.VoucherID =@VoucherID AND DivisionID = @DivisionID
	--and
	--(AT2006.TableID ='AT9000' or AT2006.TableID ='AT2006') and
	--AT2006.BatchID = @BatchID

Update AT9000 set IsStock =0
	Where 	VoucherID =@VoucherID and
		(TableID ='AT9000' or TableID ='AT2006') and
		BatchID = @BatchID AND DivisionID = @DivisionID
GO
