/****** Object:  StoredProcedure [dbo].[AP7195]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created BY Van Nhan AND Thuy Tuyen, Date 21/12/2007.
---- Purpose: In bao cao chi tiet tai khoan ngoai bang

ALTER PROCEDURE [dbo].[AP7195] 
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
    @IsDate TINYINT
AS

IF @IsDate = 0 --- Tong hop
    EXEC AP7194 @DivisionID, @FromAccountID, @ToAccountID, @FromInventoryID, @ToInventoryID, @FromMonth, @FromYear, @toMonth, @ToYear
ELSE -- Chi tiet 
    EXEC AP7193 @DivisionID, @FromAccountID, @ToAccountID, @FromInventoryID, @ToInventoryID, @FromDate, @ToDate
GO
