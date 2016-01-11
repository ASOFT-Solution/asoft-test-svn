IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2222]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2222]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- Create by: Dang Le Bao Quynh; Date : 02/10/2007
-- Purpose: Tra ve ngay dao han cua mot doi tuong
---- Modified on 13/03/2012 by Lê Thị Thu Hiền : Bổ sung @PaymentTermID
---- Modified on 22/03/2012 by Lê Thị Thu Hiền : Bổ sung IsDueDate
---- Modified on 31/01/2013 by Dang Le Bao Quynh : Xu ly ngay dao han = ngay chung tu or ngay hoa don
---- Modified on 09/12/2015 by Phuong Thao : Customize Meiko (@CustomerName = 50) Lấy ngày cuối cùng của tháng

/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP2222]
       @ObjectID nvarchar(50) ,
       @VoucherDate datetime ,
       @InvoiceDate datetime ,
       @TransactionType nvarchar(50), -- PU: Mua hang; SA: Ban hang
       @PaymentTermID NVARCHAR(50) = '',
       @DivisionID NVARCHAR(50) = ''

AS
DECLARE @DueType nvarchar(50) , --01: Tinh theo ngay hoa don; 02: Tinh theo ngay hach toan
        @DueDays int ,
        @TheDay int ,
        @TheMonth int ,
        @CloseDay int ,
        @CloseDate datetime ,
        @CalDate datetime ,
        @ReturnDate DATETIME,
		@CustomerName INT
  
 
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName) 
        
SET @ReturnDate = NULL

IF ISNULL(@PaymentTermID,'') = ''
BEGIN
	IF @TransactionType = 'PU'
		BEGIN
         SELECT	@PaymentTermID = PaymentTermID
         FROM	AT1208
         WHERE	IsDueDate = 1 
				AND PaymentTermID IN ( SELECT	PaPaymentTermID
                                       FROM		AT1202
				                       WHERE	ObjectID = @ObjectID 
												AND DivisionID = @DivisionID)
				AND DivisionID = @DivisionID
	   END
	IF @TransactionType = 'SA'
	   BEGIN
		 SELECT	@PaymentTermID = PaymentTermID
		 FROM	AT1208
		 WHERE	IsDueDate = 1 
				AND PaymentTermID IN (	SELECT  RePaymentTermID
										FROM    AT1202
										WHERE	ObjectID = @ObjectID 
												AND DivisionID = @DivisionID)
				AND DivisionID = @DivisionID
	   END
END


IF isnull(@PaymentTermID , '') <> ''
BEGIN
         SELECT	@DueType = DueType ,
				@DueDays = DueDays ,
				@TheDay = TheDay ,
				@TheMonth = TheMonth ,
				@CloseDay = CloseDay
         FROM   AT1208
         WHERE  PaymentTermID = @PaymentTermID
				AND DivisionID = @DivisionID
				AND IsDueDate = 1
				
         IF @DueDays >= 0 -- Dieu khoan thanh toan sau n ngay
            BEGIN
                  IF @DueType = '01' -- Theo ngay hoa don
                     BEGIN
                           SET @ReturnDate = DateAdd(d , @DueDays , @InvoiceDate)
                     END
                  ELSE -- Theo ngay hach toan
                     BEGIN
                           SET @ReturnDate = DateAdd(d , @DueDays , @VoucherDate)
                     END
            END
         ELSE -- Dieu khoan thanh toan theo ngay khoa so
            BEGIN
                  IF @DueType = '01' -- Theo ngay hoa don
                     BEGIN
                           IF @CloseDay > 0 -- Ngay khoa so khong phai la ngay cuoi thang 
                              BEGIN
                                    SET @CloseDate = ltrim(Month(@InvoiceDate)) + '/' + ltrim(@CloseDay) + '/' + ltrim(Year(@InvoiceDate))
                              END
                           ELSE -- Ngay khoa so la ngay cuoi thang
                              BEGIN
                                    IF Month(@InvoiceDate) IN ( 1 , 3 , 5 , 7 , 8 , 10 , 12 )
                                       BEGIN
                                             SET @CloseDate = ltrim(Month(@InvoiceDate)) + '/' + ltrim(31) + '/' + ltrim(Year(@InvoiceDate))
                                       END
                                    ELSE
                                       BEGIN
                                             IF Month(@InvoiceDate) = 2
                                                BEGIN
                                                      IF Year(@InvoiceDate) % 4 = 0 -- Thang nhuan
                                                         BEGIN
                                                SET @CloseDate = ltrim(Month(@InvoiceDate)) + '/' + ltrim(29) + '/' + ltrim(Year(@InvoiceDate))
                                                         END
                                                      ELSE
                                                         BEGIN
                                                               SET @CloseDate = ltrim(Month(@InvoiceDate)) + '/' + ltrim(28) + '/' + ltrim(Year(@InvoiceDate))
                                                         END
                                                END
                                             ELSE
                                                BEGIN
                                                      SET @CloseDate = ltrim(Month(@InvoiceDate)) + '/' + ltrim(30) + '/' + ltrim(Year(@InvoiceDate))
                                                END
                                       END
                              END

                           IF @TheDay > 0 -- Ngay dao han ko phai la ngay cuoi thang
                              BEGIN
                                    IF @InvoiceDate > @CloseDate
                                       BEGIN
                                             SET @ReturnDate = DateAdd(m , 1 , @CloseDate) -- cong them 1 thang cho ngay dao han do ngay tinh toan vuot qua ngay khoa so
                                       END
                                    ELSE
                                       BEGIN
                                             SET @ReturnDate = @CloseDate
                                       END
                                    SET @ReturnDate = DateAdd(m , @TheMonth - 1 , @ReturnDate) -- Gia tang so thang dao han theo thiet lap
                                    SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(@TheDay) + '/' + ltrim(Year(@ReturnDate))
                              END
                           ELSE -- Ngay dao han la cuoi thang
                              BEGIN
                                    IF @InvoiceDate > @CloseDate
                                       BEGIN
                                             SET @ReturnDate = DateAdd(m , 1 , @CloseDate) -- cong them 1 thang cho ngay dao han do ngay tinh toan vuot qua ngay khoa so
                                       END
                                    ELSE
                                       BEGIN
                                             SET @ReturnDate = @CloseDate
                                       END
                                    SET @ReturnDate = DateAdd(m , @TheMonth - 1 , @ReturnDate) -- Gia tang so thang dao han theo thiet lap

                                    IF Month(@ReturnDate) IN ( 1 , 3 , 5 , 7 , 8 , 10 , 12 )
                                       BEGIN
                                             SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(31) + '/' + ltrim(Year(@ReturnDate))
                                       END
                                    ELSE
                                       BEGIN
                                             IF Month(@ReturnDate) = 2
                                                BEGIN
                                                      IF Year(@ReturnDate) % 4 = 0 -- Thang nhuan
                                                         BEGIN
                                                               SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(29) + '/' + ltrim(Year(@ReturnDate))
                                                         END
                                                      ELSE
                                                         BEGIN
                                                               SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(28) + '/' + ltrim(Year(@ReturnDate))
    END
                                                END
                                             ELSE
                                                BEGIN
                                                      SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(30) + '/' + ltrim(Year(@ReturnDate))
                                                END
                                       END
                              END



                     END
                  ELSE -- Theo ngay hach toan
                     BEGIN
                           IF @CloseDay > 0 -- Ngay khoa so khong phai la ngay cuoi thang 
                              BEGIN
                                    SET @CloseDate = ltrim(Month(@VoucherDate)) + '/' + ltrim(@CloseDay) + '/' + ltrim(Year(@VoucherDate))
                              END
                           ELSE -- Ngay khoa so la ngay cuoi thang
                              BEGIN
                                    IF Month(@VoucherDate) IN ( 1 , 3 , 5 , 7 , 8 , 10 , 12 )
                                       BEGIN
                                             SET @CloseDate = ltrim(Month(@VoucherDate)) + '/' + ltrim(31) + '/' + ltrim(Year(@VoucherDate))
                                       END
                                    ELSE
                                       BEGIN
											 IF Month(@VoucherDate) = 2
												BEGIN
													  IF Year(@VoucherDate) % 4 = 0 -- Thang nhuan
														 BEGIN
															   SET @CloseDate = ltrim(Month(@VoucherDate)) + '/' + ltrim(29) + '/' + ltrim(Year(@VoucherDate))
														 END
													  ELSE
														 BEGIN
															   SET @CloseDate = ltrim(Month(@VoucherDate)) + '/' + ltrim(28) + '/' + ltrim(Year(@VoucherDate))
														 END
												END
											 ELSE
												BEGIN
													  SET @CloseDate = ltrim(Month(@VoucherDate)) + '/' + ltrim(30) + '/' + ltrim(Year(@VoucherDate))
												END
                                       END
                              END

                           IF @TheDay > 0 -- Ngay dao han ko phai la ngay cuoi thang
                              BEGIN
                                    IF @VoucherDate > @CloseDate
                                       BEGIN
                                             SET @ReturnDate = DateAdd(m , 1 , @CloseDate) -- cong them 1 thang cho ngay dao han do ngay tinh toan vuot qua ngay khoa so
                                       END
                                    ELSE
                                       BEGIN
                                             SET @ReturnDate = @CloseDate
                                       END
                                    SET @ReturnDate = DateAdd(m , @TheMonth - 1 , @ReturnDate) -- Gia tang so thang dao han theo thiet lap
                                    SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(@TheDay) + '/' + ltrim(Year(@ReturnDate))
                              END
                           ELSE -- Ngay dao han la cuoi thang
                              BEGIN
                                    IF @VoucherDate > @CloseDate
                                       BEGIN
                                             SET @ReturnDate = DateAdd(m , 1 , @CloseDate) -- cong them 1 thang cho ngay dao han do ngay tinh toan vuot qua ngay khoa so
                                       END
                                    ELSE
                                       BEGIN
                                             SET @ReturnDate = @CloseDate
                                       END
                                    SET @ReturnDate = DateAdd(m , @TheMonth - 1 , @ReturnDate) -- Gia tang so thang dao han theo thiet lap

                                    IF Month(@ReturnDate) IN ( 1 , 3 , 5 , 7 , 8 , 10 , 12 )
                                       BEGIN
                                             SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(31) + '/' + ltrim(Year(@ReturnDate))
                                       END
                                    ELSE
                                       BEGIN
                                             IF Month(@ReturnDate) = 2
                                                BEGIN
                                                      IF Year(@ReturnDate) % 4 = 0 -- Thang nhuan
                                                         BEGIN
                                                               SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(29) + '/' + ltrim(Year(@ReturnDate))
                                                         END
                                                      ELSE
                                                         BEGIN
                                                               SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(28) + '/' + ltrim(Year(@ReturnDate))
                                                         END
                                                END
                                             ELSE
                                                BEGIN
                                                      SET @ReturnDate = ltrim(Month(@ReturnDate)) + '/' + ltrim(30) + '/' + ltrim(Year(@ReturnDate))
                                                END
                                       END
                              END



                     END
            END
   END
--Tra ve gia tri
IF(@CustomerName = 50)
BEGIN
	SELECT    DATEADD(mm,DATEDIFF(mm,0,@ReturnDate)+1,-1) AS ReturnDate
END
ELSE
	SELECT    @ReturnDate AS ReturnDate



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

