/****** Object:  StoredProcedure [dbo].[WP0315]    Script Date: 08/03/2010 15:02:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 ---- Created by Nguyen Quoc Huy
 ---- Date 18/09/2008.
 ---- purpose: Tra ra view len form IN bao cao phan tich tuoi ton kho

/********************************************
'* Edited by: [GS] [Việt Khánh] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[WP0315]     
    @ReportCode NVARCHAR(50),
    @DivisionID nvarchar(50),
    @IsVietnamese BIT
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @Selection01ID NVARCHAR(50), 
    @Selection02ID NVARCHAR(50), 
    @Selection03ID NVARCHAR(50), 
    @Selection01Name NVARCHAR(250), 
    @Selection02Name NVARCHAR(250), 
    @Selection03Name NVARCHAR(250)

 -------------- Lay thong tin tu ma bao cao truyen vao ------------ 
SELECT @Selection01ID = ISNULL(Selection01ID, ''), 
        @Selection02ID = ISNULL(Selection02ID, ''), 
        @Selection03ID = ISNULL(Selection03ID, '')
        
FROM WT4710
WHERE ReportCode = @ReportCode 

--------------- Lay ten cac tieu thuc -------------- 
IF @IsVietnamese = 1
	BEGIN
		IF @Selection01ID != '' SET @Selection01Name = (SELECT Description FROM AT6000 WHERE Code = @Selection01ID and DivisionID = @DivisionID)
		IF @Selection02ID != '' SET @Selection02Name = (SELECT Description FROM AT6000 WHERE Code = @Selection02ID and DivisionID = @DivisionID)
		IF @Selection03ID != '' SET @Selection03Name = (SELECT Description FROM AT6000 WHERE Code = @Selection03ID and DivisionID = @DivisionID)
	END
ELSE
	BEGIN
		IF @Selection01ID != '' SET @Selection01Name = (SELECT DescriptionE FROM AT6000 WHERE Code = @Selection01ID and DivisionID = @DivisionID)
		IF @Selection02ID != '' SET @Selection02Name = (SELECT DescriptionE FROM AT6000 WHERE Code = @Selection02ID and DivisionID = @DivisionID)
		IF @Selection03ID != '' SET @Selection03Name = (SELECT DescriptionE FROM AT6000 WHERE Code = @Selection03ID and DivisionID = @DivisionID)
	END

 --------- Tao view ---------- 
SET @sSQL = '
    SELECT 
		DivisionID,
		' + (CASE WHEN @Selection01Name IS NULL THEN 'NULL' ELSE 'N''' + LOWER(@Selection01Name) + '''' END) + ' AS Selection01,
        ' + (CASE WHEN @Selection02Name IS NULL THEN 'NULL' ELSE 'N''' + LOWER(@Selection02Name) + '''' END) + ' AS Selection02, 
        ' + (CASE WHEN @Selection03Name IS NULL THEN 'NULL' ELSE 'N''' + LOWER(@Selection03Name) + '''' END) + ' AS Selection03 
        
        FROM AT1101
        WHERE  DivisionID = '''+ @DivisionID   +''''     

 -- print @sSQL
IF NOT EXISTS (SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[WV0315]') AND OBJECTPROPERTY(id, N'IsView') = 1)
    EXEC('--- created by WP0315
        CREATE VIEW WV0315 AS ' + @sSQL)
 ELSE
    EXEC('--- created by WP0315
        ALTER VIEW WV0315 AS ' + @sSQL)