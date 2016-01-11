/****** Object: StoredProcedure [dbo].[MP2001] Script Date: 08/02/2010 08:20:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created BY: Vo Thanh Huong
---Created date: 11/11/2004
---purpose: Kiem tra truoc khi luu ngay ke hoach san xuat

/********************************************
'* Edited BY: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP2001] 
@DivsionID NVARCHAR(50), @PlanID NVARCHAR(50), 
@Date01 DATETIME, @Date02 DATETIME, @Date03 DATETIME, @Date04 DATETIME, @Date05 DATETIME, @Date06 DATETIME, @Date07 DATETIME, @Date08 DATETIME, @Date09 DATETIME, @Date10 DATETIME, 
@Date11 DATETIME, @Date12 DATETIME, @Date13 DATETIME, @Date14 DATETIME, @Date15 DATETIME, @Date16 DATETIME, @Date17 DATETIME, @Date18 DATETIME, @Date19 DATETIME, @Date20 DATETIME, 
@Date21 DATETIME, @Date22 DATETIME, @Date23 DATETIME, @Date24 DATETIME, @Date25 DATETIME, @Date26 DATETIME, @Date27 DATETIME, @Date28 DATETIME, @Date29 DATETIME, @Date30 DATETIME, 
@Date31 DATETIME, @Date32 DATETIME, @Date33 DATETIME, @Date34 DATETIME, @Date35 DATETIME, @Date36 DATETIME, @Date37 DATETIME, @Date38 DATETIME, @Date39 DATETIME, @Date40 DATETIME
AS

DECLARE 
    @VieMess NVARCHAR(4000), 
    @EngMess NVARCHAR(4000), 
    @Status TINYINT, 
    @sSQL NVARCHAR(4000), 
    @cur CURSOR, 
    @Time INT, 
    @Date NVARCHAR(10)

SELECT @Status = 0, @VieMess = '', @EngMess = '', @sSQL = ''

IF @Date01 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date01, 103) + ''' AS DATE, 1 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date02 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date02, 103) + ''' AS Date, 2 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date03 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date03, 103) + ''' AS Date, 3 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date04 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date04, 103) + ''' AS Date, 4 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date05 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date05, 103) + ''' AS Date, 5 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date06 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date06, 103) + ''' AS Date, 6 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date07 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date07, 103) + ''' AS Date, 7 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date08 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date08, 103) + ''' AS Date, 8 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date09 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date09, 103) + ''' AS Date, 9 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date10 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date10, 103) + ''' AS Date, 10 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date11 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date11, 103) + ''' AS Date, 11 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date12 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date12, 103) + ''' AS Date, 12 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date13 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date13, 103) + ''' AS Date, 13 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date14 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date14, 103) + ''' AS Date, 14 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date15 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date15, 103) + ''' AS Date, 15 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date16 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date16, 103) + ''' AS Date, 16 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date17 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date17, 103) + ''' AS Date, 17 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date18 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date18, 103) + ''' AS Date, 18 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date19 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date19, 103) + ''' AS Date, 19 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date20 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date20, 103) + ''' AS Date, 20 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date21 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date21, 103) + ''' AS Date, 21 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date22 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date22, 103) + ''' AS Date, 22 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date23 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date23, 103) + ''' AS Date, 23 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date24 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date24, 103) + ''' AS Date, 24 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date25 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date25, 103) + ''' AS Date, 25 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date26 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date26, 103) + ''' AS Date, 26 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date27 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date27, 103) + ''' AS Date, 27 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date28 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date28, 103) + ''' AS Date, 28 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date29 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date29, 103) + ''' AS Date, 29 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date30 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date30, 103) + ''' AS Date, 30 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date31 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date31, 103) + ''' AS Date, 31 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date32 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date32, 103) + ''' AS Date, 32 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date33 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date33, 103) + ''' AS Date, 33 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date34 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date34, 103) + ''' AS Date, 34 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date35 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date35, 103) + ''' AS Date, 35 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date36 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date36, 103) + ''' AS Date, 36 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date37 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date37, 103) + ''' AS Date, 37 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date38 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date38, 103) + ''' AS Date, 38 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date39 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date39, 103) + ''' AS Date, 39 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '
IF @Date40 IS NOT NULL SET @sSQL = @sSQL + 'SELECT ''' + CONVERT(VARCHAR(10), @Date40, 103) + ''' AS Date, 40 AS Time, ''' + @DivsionID + ''' AS DivisionID UNION '

IF @sSQL NOT LIKE '' 
    BEGIN
        SET @sSQL = left(@sSQL, LEN(@sSQL) - 5) 
        IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV2008')
            DROP VIEW MV2008
        EXEC('CREATE VIEW MV2008 --- tao boi MP2001
                AS ' + @sSQL)

        SET @cur = CURSOR SCROLL KEYSET FOR 
            SELECT Date, Time FROM MV2008 ORDER BY Time

        OPEN @cur
        FETCH NEXT FROM @cur INTO @Date, @Time 
        While @@FETCH_STATUS = 0 
            BEGIN
                IF EXISTS(SELECT TOP 1 1 FROM MV2008 WHERE CONVERT(DATETIME, Date, 103) = CONVERT(DATETIME, @Date, 103) AND Time < @Time) 
                SET @VieMess = @VieMess + LTRIM(RTRIM(STR(@Time))) + ', '
                SET @EngMess = @EngMess + LTRIM(RTRIM(STR(@Time))) +', ' 
                FETCH NEXT FROM @cur INTO @Date, @Time
            END
        CLOSE @cur
    END

IF @VieMess NOT LIKE ''
    BEGIN
        SET @Status =1
        SET @VieMess = 'MFML000227|' + left(@VieMess, LEN(@VieMess)-1)
        SET @EngMess = 'The time ' + left(@EngMess, LEN(LTRIM(RTRIM(@EngMess)))-1) + ' is need different the previous time ' 
    END
SET NOCOUNT OFF

GOTO EndMess
EndMess:
SELECT @Status AS Status, @VieMess AS Message, @EngMess AS EngMess




