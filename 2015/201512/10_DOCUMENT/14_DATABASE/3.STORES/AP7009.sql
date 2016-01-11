/****** Object:  StoredProcedure [dbo].[AP7009]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Van Nhan, Date  13/12/2004
---- Purpose: Nhập xuât tồn theo lô
---- Notes: Xuat phat tu yeu cua cua City Ford

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[AP7009]     
    @DivisionID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT,                     
    @IsGroup TINYINT, 
    @GroupID NVARCHAR(50)    
AS

DECLARE 
    @GroupField AS NVARCHAR(50), 
    @sSQL NVARCHAR(4000)
    
IF @IsGroup <>0 
    BEGIN
        IF @GroupID = 'CI1' SET @GroupField = 'S1'
        ELSE IF @GroupID = 'CI2' SET @GroupField = 'S2'
        ELSE IF @GroupID = 'CI3' SET @GroupField = 'S3'
        ELSE IF @GroupID = 'I01' SET @GroupField = 'I01ID'    
        ELSE IF @GroupID = 'I02' SET @GroupField = 'I02ID'
        ELSE IF @GroupID = 'I03' SET @GroupField = 'I03ID'
        ELSE IF @GroupID = 'TYP' SET @GroupField = 'InventoryTypeID'
    END
ELSE
    SET @GroupField = 'DivisionID' 

---------------------------------
    ----     Lay so du dau.
        EXEC AP7008 @DivisionID, @WareHouseID, @FromInventoryID, @ToInventoryID, @FromMonth, @FromYear, @IsGroup, @GroupID

    ----     Lay so phat sinh No - Co trong ky
        EXEC AP7018 @DivisionID, @WareHouseID, @FromInventoryID, @ToInventoryID, @FromMonth, @FromYear, @ToMonth, @ToYear, @IsGroup, @GroupID

---print @sSQL
                
IF not Exists (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV7010')
    EXEC('Create view AV7010 AS '+ @sSQL)
ELSE
    EXEC('Alter view AV7010 AS '+ @sSQL)
GO
