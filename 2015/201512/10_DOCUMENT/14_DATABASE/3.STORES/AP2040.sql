/****** Object:  StoredProcedure [dbo].[AP2040]    Script Date: 09/27/2010 13:18:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/



----- Created by Nguyen Quoc Huy.
---- Created Date 25/01/2007
---- Purpose: Kiem tra rang buoc du lieu cho kiem ke kho

ALTER PROCEDURE [dbo].[AP2040]
       @DivisionID AS nvarchar(50) ,
       @WareHouseID AS nvarchar(50) ,
       @FromInventoryID AS nvarchar(50) ,
       @ToInventoryID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int
AS
DECLARE
        @MessageID AS nvarchar(250)

SET @MessageID = ''

	----- Xu ly chung
IF EXISTS ( SELECT TOP 1
                1
            FROM
                AT2037 INNER JOIN AT2036
            ON  AT2036.VoucherID = AT2037.VoucherID
                AND AT2036.DivisionID = AT2037.DivisionID
            WHERE
                AT2037.DivisionID = @DivisionID AND AT2036.WareHouseID = @WareHouseID AND AT2037.TranMonth = @TranMonth AND AT2037.TranYear = @TranYear AND IsAdjust = 0 )
   BEGIN
         SET @MessageID = 'WFML000001'
         GOTO EndMess
   END


EndMess:
SELECT
    @MessageID as MessageID;
