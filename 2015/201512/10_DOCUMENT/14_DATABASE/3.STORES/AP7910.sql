IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7910]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7910]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/
---- Craeted by Van Nhan, Date 14/09/2008.
--- Purpose: In bao cao thuyet minh tai chinh.
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị

CREATE PROCEDURE [dbo].[AP7910]
       @DivisionID nvarchar(50) ,
       @ReportCode AS nvarchar(50) ,
       @TranYear AS INT,
       @StrDivisionID AS NVARCHAR(4000) = ''
       
AS 

DECLARE @StrDivisionID_New AS NVARCHAR(4000)
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END

----- Phan I, II, III, IV
IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7904' )
   BEGIN
         EXEC ( 'Drop view AV7904 ' )
   END
EXEC ( ' CREATE VIEW   AV7904 AS 
		SELECT DivisionID, ReportCode, Isnull(TitleName,'''') AS  TitleName,TitleID, isnull(Description,'''') AS Description, SubTitleName 
		FROM AT7904
		WHERE GroupID in (''01'',''02'',''03'',''04'',''05'')  and DivisionID = '''+@DivisionID+'''')
IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7917' )
   BEGIN
         EXEC ( 'Drop view AV7917 ' )
   END
EXEC ( ' CREATE VIEW   AV7917 AS 
		SELECT DivisionID,ReportCode, Isnull(TitleName,'''') AS  TitleName,TitleID, isnull(Description,'''') AS Description, SubTitleName 
		FROM AT7904
		WHERE GroupID in (''08'') and DivisionID = '''+@DivisionID+'''' )

---Print ' CREATE VIEW   AV7904 AS SELECT ReportCode, Isnull(TitleName,'''') AS  TitleName,TitleID, isnull(Description,'''') AS Description, SubTitleName FROM At7904 '
---- Phan V (muc 01, 02, 03, 04, 05, 06, 07 ) --- So du cac tai khoan
EXEC AP7909 @DivisionID , @ReportCode , @TranYear, @StrDivisionID

IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7905' )
   BEGIN
         EXEC ( 'Drop view AV7905 ' )
   END
EXEC ( ' CREATE VIEW   AV7905 AS 
		SELECT DivisionID,'''+@ReportCode+''' AS ReportCode, GroupID, TitleID, TitleName, LineDes,  Amount01, Amount02 
		FROM AT7909  
		WHERE GroupID in (''01'', ''02'', ''03'', ''04'', ''05'', ''06'', ''07'') and DivisionID = '''+@DivisionID+'''' )
---- Muc 22b, c, d, e, g
IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7913' )
   BEGIN
         EXEC ( 'Drop view AV7913 ' )
   END
EXEC ( ' CREATE VIEW   AV7913 AS 
		SELECT DivisionID,'''+@ReportCode+''' AS ReportCode, GroupID, TitleID, TitleName, LineDes,  Amount01, Amount02 
		FROM AT7909  
		WHERE GroupID in (''22b'', ''22c'', ''22d'', ''22d1'', ''22e'', ''22g'', ''23'', ''24'') and DivisionID = '''+@DivisionID+'''' )

IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7914' )
   BEGIN
         EXEC ( 'Drop view AV7914 ' )
   END
EXEC ( ' CREATE VIEW   AV7914 AS 
		SELECT DivisionID,'''+@ReportCode+''' AS ReportCode, GroupID, TitleID, TitleName, LineDes,  Amount01, Amount02 
		FROM AT7909  
		WHERE GroupID in (''25'', ''26'', ''27'', ''28'', ''29'', ''30'', ''31'', ''32'', ''33'') and DivisionID = '''+@DivisionID+'''' )

IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7918' )
   BEGIN
         EXEC ( 'Drop view AV7918 ' )
   END
EXEC ( ' CREATE VIEW   AV7918 AS 
		SELECT DivisionID,'''+@ReportCode+''' AS ReportCode, GroupID, TitleID, TitleName, LineDes,  Amount01, Amount02 
		FROM AT7909  
		WHERE GroupID in (''34'') and DivisionID = '''+@DivisionID+'''')

IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7910' )
   BEGIN
         EXEC ( 'Drop view AV7910 ' )
   END
EXEC ( ' CREATE VIEW   AV7910 AS 
		SELECT DivisionID,'''+@ReportCode+''' AS ReportCode, GroupID, TitleID, TitleName, LineDes,  Amount01, Amount02 
		FROM AT7909  
		WHERE GroupID in (''13'', ''14'', ''15'', ''16'', ''17'', ''18'', ''18'', ''19'', ''20'') and DivisionID = '''+@DivisionID+'''')


IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7911' )
   BEGIN
         EXEC ( 'Drop view AV7911 ' )
   END
EXEC ( ' CREATE VIEW   AV7911 AS 
		SELECT DivisionID,'''+@ReportCode+''' AS ReportCode, GroupID, TitleID, TitleName, LineDes,  Amount01, Amount02 
		FROM AT7909  
		WHERE GroupID in (''21'') and DivisionID = '''+@DivisionID+'''' )


---- Phan V (muc 08, 09, 10, 12) --- Bao cao lien quan den tai san co dinh
EXEC AP7908 @DivisionID , @ReportCode , @TranYear,@StrDivisionID
---- View cho muc 08 - Tang giam TSCD Huu hinh

IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7906' )
   BEGIN
         EXEC ( 'Drop view AV7906 ' )
   END
EXEC ( ' CREATE VIEW   AV7906 AS 
SELECT 	AT7910.DivisionID, AT7910.ReportCode, AT7910.GroupID, TitleID, LineDes,  LineLevel, 
		Amount01,	 Amount02,	 Amount03,	 Amount04,	 Amount05,	 Amount06,	 Amount07,	 Amount08,	 Amount09,	 Amount10,
		Caption01,	Caption02,	Caption03,	Caption04,	Caption05,	Caption06,	Caption07,	Caption08,	Caption09,	Caption10
FROM	AT7910  
INNER JOIN AT7906 on AT7906.ReportCode= AT7910.ReportCode and AT7910.GroupID =AT7906.GroupID and AT7910.DivisionID =AT7906.DivisionID
WHERE AT7910.GroupID =''08'' and AT7910.DivisionID = '''+@DivisionID+'''' )

---- View cho muc 09 - Tang giam TSCD thue tai chinh
IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7907' )
   BEGIN
         EXEC ( 'Drop view AV7907 ' )
   END
EXEC ( ' CREATE VIEW   AV7907 AS 
SELECT 	AT7910.DivisionID,AT7910.ReportCode, AT7910.GroupID, TitleID, LineDes,  LineLevel, 
		Amount01,	 Amount02,	 Amount03,	 Amount04,	 Amount05,	 Amount06,	 Amount07,	 Amount08,	 Amount09,	 Amount10,
		Caption01,	Caption02,	Caption03,	Caption04,	Caption05,	Caption06,	Caption07,	Caption08,	Caption09,	Caption10
FROM	AT7910  
INNER JOIN AT7906 on AT7906.ReportCode= AT7910.ReportCode and AT7910.GroupID =AT7906.GroupID and AT7910.DivisionID =AT7906.DivisionID
WHERE AT7910.GroupID =''09'' and AT7910.DivisionID = '''+@DivisionID+'''' )



---- View cho muc 10 - Tang giam TSCD Vo hinh
IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7908' )
   BEGIN
         EXEC ( 'Drop view AV7908 ' )
   END
EXEC ( ' CREATE VIEW   AV7908 AS 
SELECT 	AT7910.DivisionID, AT7910.ReportCode, AT7910.GroupID, TitleID, LineDes,  LineLevel, 
		Amount01,	 Amount02,	 Amount03,	 Amount04,	 Amount05,	 Amount06,	 Amount07,	 Amount08,	 Amount09,	 Amount10,
		Caption01,	Caption02,	Caption03,	Caption04,	Caption05,	Caption06,	Caption07,	Caption08,	Caption09,	Caption10
FROM	AT7910  
INNER JOIN AT7906 on AT7906.ReportCode= AT7910.ReportCode and AT7910.GroupID =AT7906.GroupID and AT7910.DivisionID =AT7906.DivisionID
WHERE AT7910.GroupID =''10'' and AT7910.DivisionID = '''+@DivisionID+'''' )


---- View cho muc 12 - Tang giam bat dong san dau tu
IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7909' )
   BEGIN
         EXEC ( 'Drop view AV7909 ' )
   END
EXEC ( ' CREATE VIEW   AV7909  AS 
SELECT 	AT7910.DivisionID, AT7910.ReportCode, AT7910.GroupID, TitleID, LineDes,  LineLevel, 
		Amount01,	 Amount02,	 Amount03,	 Amount04,	 Amount05,	 Amount06,	 Amount07,	 Amount08,	 Amount09,	 Amount10,
		Caption01,	Caption02,	Caption03,	Caption04,	Caption05,	Caption06,	Caption07,	Caption08,	Caption09,	Caption10
FROM AT7910  
INNER JOIN AT7906 on AT7906.ReportCode= AT7910.ReportCode and AT7910.GroupID =AT7906.GroupID and AT7910.DivisionID =AT7906.DivisionID
WHERE AT7910.GroupID =''12'' and AT7910.DivisionID = '''+@DivisionID+'''')

----- View cho phan von chu so huu.

IF EXISTS ( SELECT TOP 1
                1
            FROM
                sysObjects
            WHERE
                Xtype = 'V' AND Name = 'AV7912' )
   BEGIN
         EXEC ( 'Drop view AV7912 ' )
   END
EXEC ( ' CREATE VIEW   AV7912  AS 
SELECT 	AT7910.DivisionID, AT7910.ReportCode, AT7910.GroupID, TitleID, LineDes,  LineLevel, 
		Amount01,	 Amount02,	 Amount03,	 Amount04,	 Amount05,	 Amount06,	 Amount07,	 Amount08,	 Amount09,	 Amount10,
		Caption01,	Caption02,	Caption03,	Caption04,	Caption05,	Caption06,	Caption07,	Caption08,	Caption09,	Caption10
FROM AT7910  
INNER JOIN AT7906 on AT7906.ReportCode= AT7910.ReportCode and AT7910.GroupID =AT7906.GroupID and AT7910.DivisionID =AT7906.DivisionID
WHERE AT7910.GroupID =''22'' and AT7910.DivisionID = '''+@DivisionID+'''')

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

