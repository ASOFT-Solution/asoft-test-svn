IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WITH(NOLOCK) WHERE ID = OBJECT_ID(N'[DBO].[AP7773]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7773]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



------ Cap nhat so du con ton,  tinh  gia xuat dich danh
------ Created by Nguyen Van Nhan.
------ Date 17/06/2003
----- Edited by Bao Anh		Date: 30/10/2012
----- Purpose: Cap naht so du theo mark cho AT0114 (2T)
/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/
---- Modified on 21/12/2015 by Phương Thảo: Sửa lại, không nhân cho hệ số quy đổi

CREATE PROCEDURE [dbo].[AP7773]
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @WareHouseID AS nvarchar(50) ,
       @InventoryID AS nvarchar(50) ,
       @ConversionFactor AS money ,
       @CreditAccountID AS nvarchar(50) ,
       @ReOldVoucherID AS nvarchar(50) ,
       @ReOldTransactionID nvarchar(50) ,
       @ReNewVoucherID nvarchar(50) ,
       @ReNewTransactionID nvarchar(50) ,
       @OldQuantity AS decimal(28,8) ,
       @NewQuantity AS decimal(28,8),
       @OldMarkQuantity AS decimal(28,8) ,
       @NewMarkQuantity AS decimal(28,8)
AS --Print ' Old' + @ReOldVoucherID+ @ReOldTransactionID
--Print ' New ' + @ReNewVoucherID+@ReNewTransactionID
IF @ConversionFactor = 0
   BEGIN
         SET @ConversionFactor = 1
   END

IF @ReOldVoucherID <> '' AND @ReOldTransactionID <> ''
   BEGIN
  
         UPDATE
             AT0114
         SET
             DeQuantity = DeQuantity - @OldQuantity,
             EndQuantity = EndQuantity + @OldQuantity,
             DeMarkQuantity = DeMarkQuantity - @OldMarkQuantity,
             EndMarkQuantity = EndMarkQuantity + @OldMarkQuantity
         WHERE
             DivisionID = @DivisionID AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID AND ReVoucherID = @ReOldVoucherID AND ReTransactionID = @ReOldTransactionID
   END
	

------------------------  



UPDATE
    AT0114
SET
    DeQuantity = Isnull(DeQuantity , 0) + @NewQuantity,
    EndQuantity = isnull(EndQuantity , 0) - @NewQuantity,
    DeMarkQuantity = Isnull(DeMarkQuantity , 0) + @NewMarkQuantity,
    EndMarkQuantity = isnull(EndMarkQuantity , 0) - @NewMarkQuantity
WHERE
    DivisionID = @DivisionID AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID AND ReVoucherID = @ReNewVoucherID AND ReTransactionID = @ReNewTransactionID












GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

