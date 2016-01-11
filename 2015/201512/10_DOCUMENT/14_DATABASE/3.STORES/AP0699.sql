/****** Object:  StoredProcedure [dbo].[AP0699]    Script Date: 07/29/2010 17:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Van Nhan,
---- Date 19/03/2003. Xu ly but toan so du
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
--- Edited by Bao Anh	Date: 05/08/2012
--- Purpose: Cap nhat du lieu cho AT2888 (so du ton kho co quy cach va so luong mark - yeu cau 2T)
--- Edited by Bao Anh	Date: 20/11/2012	
--- Purpose:	1. Dung @ActualQuantity cap nhat vao AT2008 va AT0114 (truoc day dung @ConvertedQuantity)
---				2. Bo sung ConvertedQuantity vao AT9000 khi chuyen but toan so du

ALTER PROCEDURE [dbo].[AP0699]
	@TransactionID nvarchar(50), 
	@DivisionID nvarchar(50),  
	@VoucherID nvarchar(50), 
	@TranYear  int, @TranMonth int,  
	@VoucherDate Datetime, 	
	@VoucherNo nvarchar(50),	
	@EmployeeID nvarchar(50), 	@ObjectID nvarchar(50),  	@VoucherTypeID nvarchar(50), 
	@CreateUserID nvarchar(50), 	@CreateDate  Datetime,	@Description nvarchar(250),
	@WareHouseID nvarchar(50), 	@WareHouseID2 nvarchar(50), 	
	@Status int, 			@KindVoucherID int,
	@CurrencyID nvarchar(50), 	@ExchangeRate decimal(28, 8),	
	@InventoryID nvarchar(50), 	@UnitID nvarchar(50),  		@MethodID tinyint,
	@ActualQuantity Decimal(28,8), 
	@UnitPrice Decimal(28,8),
	@ConvertedQuantity Decimal(28,8),
	@ConvertedUnitPrice Decimal(28,8),	
	@OriginalAmount Decimal(28,8), 
	@ConvertedAmount Decimal(28,8),
	@DebitAccountID nvarchar(50),
	@CreditAccountID nvarchar(50),   
	@SourceNo nvarchar(50),
	@IsLimitDate tinyint, 
	@IsSource tinyint,
	@LimitDate as datetime,
	@Orders as int,
	@LastModifyUserID as nvarchar(50),	                                      
	@LastModifyDate as nvarchar(50),
	@Notes as  nvarchar(250)	,
	@Ana01ID  as nvarchar(50), 
	@Ana02ID  as nvarchar(50), 
	@Ana03ID  as nvarchar(50),
	@Ana04ID  as nvarchar(50), 
	@Ana05ID  as nvarchar(50), 
	@Ana06ID  as nvarchar(50),
	@Ana07ID  as nvarchar(50), 
	@Ana08ID  as nvarchar(50), 
	@Ana09ID  as nvarchar(50),
	@Ana10ID  as nvarchar(50), 
	@IsTemp as TINYINT,
	@Parameter01 DECIMAL(28,8),
	@Parameter02 DECIMAL(28,8),
	@Parameter03 DECIMAL(28,8),
	@Parameter04 DECIMAL(28,8),
	@Parameter05 DECIMAL(28,8),
	@MarkQuantity DECIMAL(28,8)
	
 AS

	Exec AP0612 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 1, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05, @MarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam

	----- Chuyen  but toan so du sang b¶ng Transaction AT9000
If isnull(@IsTemp,0) =0 
	Insert AT9000 (VoucherID, BatchID, TransactionID, TableID, DivisionID, TranMonth, TranYear, TransactionTypeID,
	CurrencyID, ObjectID, DebitAccountID, ExchangeRate, OriginalAmount, ConvertedAmount,
	VoucherDate, VoucherTypeID, VoucherNo, Orders, EmployeeID, VDescription, BDescription, TDescription,
	Quantity, InventoryID, UnitID, Status, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, 
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
	UParameter01, UParameter02, UParameter03, UParameter04, UParameter05, MarkQuantity, ConvertedQuantity)    
	Values
	(@VoucherID, @VoucherID, @TransactionID, N'AT2017',
	@DivisionID, @TranMonth, @TranYear, N'T00',  --- So Du 
	@CurrencyID, @ObjectID, @DebitAccountID, 
	@ExchangeRate,          @OriginalAmount, @ConvertedAmount,
    @VoucherDate, @VoucherTypeID, @VoucherNo,                        
	@Orders, @EmployeeID, @Description, @Description, @Notes, @ActualQuantity,                       
	@InventoryID, @UnitID, 0, @CreateDate, @CreateUserID, @LastModifyDate, @LastModifyUserID, 
	@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID,
	@Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05, @MarkQuantity, @ConvertedQuantity)
GO
