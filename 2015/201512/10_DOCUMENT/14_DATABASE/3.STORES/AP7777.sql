/****** Object:  StoredProcedure [dbo].[AP7777]    Script Date: 08/05/2010 09:49:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---- Created by Nguyen Van Nhan, Date 13/06/2003
---- Purpose:  Update tinh hinh ton theo Lo, Date,chung tu nhap khi xuat kho
---- Edited by Bao Anh	Date: 30/10/2012
---- Porpose: Cap nhat so du theo mark vao AT0114 (2T)
/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7777]
       @UserID AS nvarchar(50) ,
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @WareHouseID AS nvarchar(50) ,
       @InventoryID AS nvarchar(50) ,
       @UnitID AS nvarchar(50) ,
       @ConversionFactor AS decimal(28,8) ,
       @IsSource tinyint ,
       @IsLimitDate tinyint ,
       @CreditAccountID AS nvarchar(50) ,
       @ReOldVoucherID AS nvarchar(50) ,
       @ReOldTransactionID AS nvarchar(50) ,
       @ReNewVoucherID AS nvarchar(50) ,
       @ReNewTransactionID AS nvarchar(50) ,
       @OldQuantity decimal(28,8) ,
       @NewQuantity decimal(28,8) ,
       @AllowOverShip AS tinyint ,
       @MethodID AS tinyint,
       @OldMarkQuantity decimal(28,8),
       @NewMarkQuantity decimal(28,8)
AS ---- Quan ly luong ton dich danh va tinh gia

IF @IsSource <> 0 OR @IsLimitDate <> 0 OR @MethodID = 3
   BEGIN
         EXEC AP7773 @DivisionID , @TranMonth , @TranYear , @WareHouseID , @InventoryID , @ConversionFactor , @CreditAccountID , @ReOldVoucherID , @ReOldTransactionID , @ReNewVoucherID , @ReNewTransactionID , @OldQuantity , @NewQuantity, @OldMarkQuantity,@NewMarkQuantity
   END