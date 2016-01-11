/****** Object:  StoredProcedure [dbo].[AP7198]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--- Created BY Van Nhan, Date .
--- Purpose: In so tai khoan ngoai bang. Tong hop, chi tiet.

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7198] 
    @DivisionID NVARCHAR(50), 
    @FromAccountID AS NVARCHAR(50), 
    @ToAccountID AS NVARCHAR(50), 
    @FromInventoryID AS NVARCHAR(50), 
    @ToInventoryID AS NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @IsDate AS TINYINT
AS

IF @IsDate = 0 --- Tong hop
    EXEC AP7197 @DivisionID, @FromAccountID, @ToAccountID, @FromInventoryID, @ToInventoryID, @FromMonth, @FromYear, @toMonth, @ToYear
ELSE -- Chi tiet 
    EXEC AP7196 @DivisionID, @FromAccountID, @ToAccountID, @FromInventoryID, @ToInventoryID, @FromDate, @ToDate
GO
