/****** Object:  StoredProcedure [dbo].[AP7017]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created BY Nguyen Thi Ngoc Minh
--- Date 11/11/2004.
---- purpose: Tra ra VIEW len form In bao cao phan tich ton kho

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7017]
    @ReportCode NVARCHAR(50)
AS

DECLARE 
    @sSQL AS NVARCHAR(4000), 
    @IsReceivable AS TINYINT, 
    @AccountSQL AS NVARCHAR(4000), 
    @Selection01ID AS NVARCHAR(50), 
    @Selection02ID AS NVARCHAR(50), 
    @Selection03ID AS NVARCHAR(50), 
    @Selection04ID AS NVARCHAR(50), 
    @Selection05ID AS NVARCHAR(50), 
    @Selection01Name AS NVARCHAR(250), 
    @Selection02Name AS NVARCHAR(250), 
    @Selection03Name AS NVARCHAR(250), 
    @Selection04Name AS NVARCHAR(250), 
    @Selection05Name AS NVARCHAR(250)

--------------Lay thong tin tu ma bao cao truyen vao------------
SELECT @Selection01ID = ISNULL(Filter1ID, ''), 
       @Selection02ID = ISNULL(Filter2ID, ''), 
       @Selection03ID = ISNULL(Filter3ID, ''), 
       @Selection04ID = ISNULL(Filter4ID, ''), 
       @Selection05ID = ISNULL(Filter5ID, '')        
FROM AT4711
WHERE ReportCode =  @ReportCode 

---------------Lay ten cac tieu thuc--------------
IF @Selection01ID != '' SET @Selection01Name = (SELECT Description FROM AT6000 WHERE Code = @Selection01ID)
IF @Selection02ID != '' SET @Selection02Name = (SELECT Description FROM AT6000 WHERE Code = @Selection02ID)
IF @Selection03ID != '' SET @Selection03Name = (SELECT Description FROM AT6000 WHERE Code = @Selection03ID)
IF @Selection04ID != '' SET @Selection04Name = (SELECT Description FROM AT6000 WHERE Code = @Selection04ID)
IF @Selection05ID != '' SET @Selection05Name = (SELECT Description FROM AT6000 WHERE Code = @Selection05ID)

---------Tao view----------
SET @sSQL = '
    SELECT ' + (CASE WHEN @Selection01Name IS NULL THEN 'null' ELSE 'N''' + LOWER(@Selection01Name) + '''' END) + ' AS Selection01, 
        ' + (CASE WHEN @Selection02Name IS NULL THEN 'null' ELSE 'N''' + LOWER(@Selection02Name) + '''' END) + ' AS Selection02, 
        ' + (CASE WHEN @Selection03Name IS NULL THEN 'null' ELSE 'N''' + LOWER(@Selection03Name) + '''' END) + ' AS Selection03, 
        ' + (CASE WHEN @Selection04Name IS NULL THEN 'null' ELSE 'N''' + LOWER(@Selection04Name) + '''' END) + ' AS Selection04, 
        ' + (CASE WHEN @Selection05Name IS NULL THEN 'null' ELSE 'N''' + LOWER(@Selection05Name) + '''' END) + ' AS Selection05
    '
        
--print @sSQL

IF NOT EXISTS (SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[AV7027]') AND OBJECTPROPERTY(id, N'IsView') = 1)
    EXEC ('---created BY AP7017
        CREATE VIEW AV7027 AS ' + @sSQL)
ELSE
    EXEC ('---created BY AP7017
        ALTER VIEW AV7027 AS ' + @sSQL)
GO
