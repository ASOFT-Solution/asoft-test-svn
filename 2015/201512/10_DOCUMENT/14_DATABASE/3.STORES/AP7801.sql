IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7801]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7801]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---------- Created by Nguyen Van Nhan,
---------- Created Date 20.08.2003
---------- Thuc hien but toan ket chuyen tu dong
---------- Edit by: Dang Le Bao Quynh; Date: 18/06/2007 
---------- Purpose: Bo sung cap nhat ma phan tich
---------- Edit By: Dang Le Bao Quynh; Date 11/01/2008
---------- Purpose: Bo sung ket chuyen chi tiet theo doi tuong
---------- Edit By: Dang Le Bao Quynh; Date 04/11/2008
---------- Purpose: Cho phép loc doi tuong
---- Modified on 19/11/2011 by Le Thi Thu Hien : Bo sung 5 khoan muc ana
---- Modified on 24/11/2011 by Le Thi Thu Hien : Bo sung Loc theo khoan muc
---- Modified on 07/02/2012 by Thien Huynh : Bo sung 5 khoan muc Ana06ID-Ana10ID
-- <Example>
---- 


CREATE PROCEDURE [dbo].[AP7801]
       @DivisionID nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @AllocationID AS nvarchar(50) ,
       @VoucherNo AS nvarchar(50) ,
       @VoucherDate AS nvarchar(50) ,
       @BDescription AS nvarchar(250) ,
       @VDescription AS nvarchar(250) ,
       @TDescription AS nvarchar(250) ,
       @CreateUserID AS nvarchar(50) ,
       @LastModifyUserID AS nvarchar(50) ,
       @Ana01ID AS nvarchar(50) ,
       @Ana02ID AS nvarchar(50) ,
       @Ana03ID AS nvarchar(50) ,
       @Ana04ID AS nvarchar(50) ,
       @Ana05ID AS nvarchar(50) ,
       @Ana06ID AS nvarchar(50) ,
       @Ana07ID AS nvarchar(50) ,
       @Ana08ID AS nvarchar(50) ,
       @Ana09ID AS nvarchar(50) ,
       @Ana10ID AS nvarchar(50) ,
       @DetailForObject AS bit = 0 ,
       @FilterObjectID AS nvarchar(4000) = ''
       
AS
SET NOCOUNT ON
DECLARE
        @AT7802Cursor AS cursor ,
        @SequenceDesc AS nvarchar(100) ,
        @SourceAccountIDFrom AS nvarchar(50) ,
        @SourceAccountIDTo AS nvarchar(50) ,
        @TargetAccountID AS nvarchar(50) ,
        @SourceAmountID AS tinyint ,
        @AllocationMode AS tinyint ,
        @Percentage AS decimal(28,8) ,
        @VoucherDateConv AS datetime,
        @VoucherTypeID AS nvarchar(50),
        @AnaTypeID AS NVARCHAR(50),
        @FromAnaID AS NVARCHAR(50),
        @ToAnaID AS NVARCHAR(50)	
		--@LastModifyUserID as nvarchar(50)

SET @LastModifyUserID = @CreateUserID

IF EXISTS ( SELECT 1 FROM AT7802 WHERE AllocationID = @AllocationID )
   BEGIN
         SET @AT7802Cursor = CURSOR SCROLL KEYSET FOR 
				SELECT            T2.SequenceDesc ,			---- Thu tu buoc thuc hien
                                  T2.SourceAccountIDFrom ,	---- Tu tai khoan nguon
                                  T2.SourceAccountIDTo ,	---- Den tai khoan nguon	
                                  T2.TargetAccountID ,		---- Tai khoan dich: can ket chuyen vao
                                  T2.SourceAmountID ,		---- So du No, So Du Co, So Lon hon		
                                  T2.AllocationMode ,		----- Ket chuyen so Trong Ky, Trong Nam, So du					
                                  T2.Percentage ,			---- Ty lap phan tram ket chuyen						
                                  T2.VoucherTypeID ,
                                  T2.SequenceDesc ,
                                  T2.SequenceDesc,
                                  CASE WHEN ISNULL(@Ana01ID,'') <> '' THEN @Ana01ID ELSE T2.Ana01ID END Ana01ID,
                                  CASE WHEN ISNULL(@Ana02ID,'') <> '' THEN @Ana02ID ELSE T2.Ana02ID END Ana02ID,
                                  CASE WHEN ISNULL(@Ana03ID,'') <> '' THEN @Ana03ID ELSE T2.Ana03ID END Ana03ID,
                                  CASE WHEN ISNULL(@Ana04ID,'') <> '' THEN @Ana04ID ELSE T2.Ana04ID END Ana04ID,
                                  CASE WHEN ISNULL(@Ana05ID,'') <> '' THEN @Ana05ID ELSE T2.Ana05ID END Ana05ID,
                                  CASE WHEN ISNULL(@Ana06ID,'') <> '' THEN @Ana06ID ELSE T2.Ana06ID END Ana06ID,
                                  CASE WHEN ISNULL(@Ana07ID,'') <> '' THEN @Ana07ID ELSE T2.Ana07ID END Ana07ID,
                                  CASE WHEN ISNULL(@Ana08ID,'') <> '' THEN @Ana08ID ELSE T2.Ana08ID END Ana08ID,
                                  CASE WHEN ISNULL(@Ana09ID,'') <> '' THEN @Ana09ID ELSE T2.Ana09ID END Ana09ID,
                                  CASE WHEN ISNULL(@Ana10ID,'') <> '' THEN @Ana10ID ELSE T2.Ana10ID END Ana10ID,
                                  T2.AnaTypeID,
                                  T2.FromAnaID,
                                  T2.ToAnaID                                  
                FROM		AT7802 AS T2 
                INNER JOIN	AT7801 AS T1
                    ON		T2.AllocationID = T1.AllocationID 
							AND T2.DivisionID = @DivisionID
                WHERE       T2.AllocationID = @AllocationID
				ORDER BY    T2.SequenceID

         OPEN @AT7802Cursor
         FETCH NEXT FROM @AT7802Cursor INTO @SequenceDesc,@SourceAccountIDFrom,@SourceAccountIDTo,@TargetAccountID,@SourceAmountID,@AllocationMode,@Percentage,@VoucherTypeID,@BDescription	,@TDescription, @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, @AnaTypeID, @FromAnaID, @ToAnaID
         WHILE @@FETCH_STATUS = 0
               BEGIN
	---           Print ' TEST ' +@AllocationID+' @VDescription '+ @SourceAccountIDFrom
					 SET @VoucherDateConv = CAST(@VoucherDate as datetime)
                     EXEC AP7802 @AllocationID , @DivisionID , @TranMonth , @TranYear , @VoucherTypeID , @VoucherNo , @VoucherDateConv , @VDescription , @BDescription , @TDescription , @SourceAccountIDFrom , @SourceAccountIDTo , @TargetAccountID , @SourceAmountID , @AllocationMode , @Percentage , @SequenceDesc , @CreateUserID , @LastModifyUserID , @Ana01ID , @Ana02ID , @Ana03ID , @Ana04ID , @Ana05ID , @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, @DetailForObject , @FilterObjectID, @AnaTypeID, @FromAnaID, @ToAnaID

                     FETCH NEXT FROM @AT7802Cursor INTO @SequenceDesc,@SourceAccountIDFrom,@SourceAccountIDTo,@TargetAccountID,@SourceAmountID,@AllocationMode,@Percentage,@VoucherTypeID,@BDescription,@TDescription, @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, @AnaTypeID, @FromAnaID, @ToAnaID

               END
         CLOSE @AT7802Cursor
         DEALLOCATE @AT7802Cursor

   END

SET NOCOUNT OFF


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

