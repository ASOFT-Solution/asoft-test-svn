IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7717]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP7717]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Bao cao ton kho theo ma phan tich, co the tuy bien dong, cot
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Nguyen Van Nhan on 19/03/2005
----Edited by: 	Nguyen Quoc Huy
----Edited by: [GS] [Minh Lâm] [29/07/2010]
----Modified on 25/02/2014 by Bảo Anh: Bổ sung trường Ghi chú của MPT8 nếu dữ liệu cột là MPT8 (Sinolife)
----<Example>
/*
    EXEC WP0100,0, 1
*/

CREATE PROCEDURE AP7717
    @DivisionID NVARCHAR(50),
    @D_C NVARCHAR(1),			----' D Phat sinh No,C phat sinh Co, B so du
    @IsQuantity TINYINT,		---=  0 Thanh tien, 1 so luong
    @IsDate TINYINT,
    @FromMonth INT,
    @FromYear INT ,
    @ToMonth INT,
    @ToYear INT,
    @FromDate DATETIME,
    @ToDate DATETIME,
    @RowTypeID NVARCHAR(50) ,	----- IN, CI1, CI2, CI3, I01, I02, I03, MO, QU, YE ,VD,A01,A02,A03		
    @ColumnTypeID NVARCHAR(50) ,
    @Column01ID NVARCHAR(50),
    @Column02ID NVARCHAR(50),
    @Column03ID NVARCHAR(50),
    @Column04ID NVARCHAR(50),
    @Column05ID NVARCHAR(50),
    @Column06ID NVARCHAR(50),
    @Column07ID NVARCHAR(50),
    @Column08ID NVARCHAR(50),
    @Column09ID NVARCHAR(50),
    @Column10ID NVARCHAR(50),
    @Column11ID NVARCHAR(50),
    @Column12ID NVARCHAR(50),
    @Column13ID NVARCHAR(50),
    @Column14ID NVARCHAR(50),
    @Column15ID NVARCHAR(50),
    @Column16ID NVARCHAR(50),
    @Column17ID NVARCHAR(50),
    @Column18ID NVARCHAR(50),
    @Column19ID NVARCHAR(50),
    @Column20ID NVARCHAR(50),
    @Column21ID NVARCHAR(50),
    @Column22ID NVARCHAR(50),
    @Column23ID NVARCHAR(50),
    @Column24ID NVARCHAR(50),
    @Column25ID NVARCHAR(50),
    @Column26ID NVARCHAR(50),
    @Column27ID NVARCHAR(50),
    @Column28ID NVARCHAR(50),
    @Column29ID NVARCHAR(50),
    @Column30ID NVARCHAR(50),
    @Column31ID NVARCHAR(50),
    @FromWareHouseID NVARCHAR(50),
    @ToWareHouseID NVARCHAR(50) ,
    @strWhereClause NVARCHAR(250),
    @strGroupIn NVARCHAR(50)
AS
DECLARE @sSQL AS nvarchar(4000) ,
		@sSQL2 AS nvarchar(4000) ,
		@ColumnName AS nvarchar(250) ,
		@FieldAmount AS nvarchar(20) ,
		@sqlGroup AS nvarchar(4000) ,
		@strGroup AS nvarchar(50), 
		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

IF @IsQuantity = 1
	BEGIN --- Lay theo so luong
		IF @D_C = 'B' SET @FieldAmount = 'SignQuantity'
        ELSE SET @FieldAmount = 'ActualQuantity'
	END
ELSE
   BEGIN    --- Lay theo thenh tien
        IF @D_C = 'B' SET @FieldAmount = 'SignAmount'
        ELSE SET @FieldAmount = 'ConvertedAmount'
   END
EXEC AP7710 @RowTypeID , @ColumnName OUTPUT
EXEC AP7710 @strGroupIn , @strGroup OUTPUT

SET @sqlGroup = '  Group by  V7.DivisionID,' + @ColumnName + '  '
IF ISNULL(@strGroup , '') <> '' SET @sqlGroup = @sqlGroup + ', ' + @strGroup

---- Theo thang
SET @sSQL = ' Select V7.DivisionID, ' + @ColumnName + ' AS Column00ID '

IF ISNULL(@strGroup , '') <> '' SET @sSQL = @sSQL + ', ' + @strGroup + ' AS GroupID'
EXEC AP7710 @ColumnTypeID , @ColumnName OUTPUT

IF ISNULL(@Column01ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			SUM(CASE WHEN  ' + @ColumnName + ' =''' + @Column01ID + ''' THEN ' + @FieldAmount + ' ELSE 0  END) AS ColumnValue01'
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', 
			MAX(CASE WHEN  ' + @ColumnName + ' =''' + @Column01ID + ''' THEN Ana08Notes ELSE ''''  END) AS ColumnNotes01'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 AS ColumnValue01'
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', '''' AS ColumnNotes01'
   END

IF ISNULL(@Column02ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			SUM(CASE WHEN  ' + @ColumnName + ' = ''' + @Column02ID + ''' THEN ' + @FieldAmount + ' ELSE 0 END) AS ColumnValue02 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', 
			MAX(CASE WHEN  ' + @ColumnName + ' = ''' + @Column02ID + ''' THEN Ana08Notes ELSE '''' END) AS ColumnNotes02'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 AS ColumnValue02'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', '''' AS ColumnNotes02'
   END

IF ISNULL(@Column03ID, '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			SUM(CASE WHEN  ' + @ColumnName + ' = ''' + @Column03ID + ''' THEN ' + @FieldAmount + ' ELSE 0 END) AS ColumnValue03 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', 
			MAX(CASE WHEN  ' + @ColumnName + ' = ''' + @Column03ID + ''' then Ana08Notes ELSE '''' END) AS ColumnNotes03'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue03'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes03'
   END

IF ISNULL(@Column04ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			SUM(CASE WHEN  ' + @ColumnName + ' = ''' + @Column04ID + ''' THEN ' + @FieldAmount + ' ELSE 0 END) AS ColumnValue04 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', 
			MAX(CASE WHEN  ' + @ColumnName + ' = ''' + @Column04ID + ''' THEN Ana08Notes ELSE '''' END) AS ColumnNotes04'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue04'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', '''' AS ColumnNotes04'
   END

IF ISNULL(@Column05ID, '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			SUM(CASE WHEN  ' + @ColumnName + ' = ''' + @Column05ID + ''' THEN ' + @FieldAmount + ' ELSE 0 END) AS ColumnValue05 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', 
			MAX(CASE WHEN ' + @ColumnName + ' = ''' + @Column05ID + ''' THEN Ana08Notes ELSE '''' END) AS ColumnNotes05'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 AS ColumnValue05'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', '''' AS ColumnNotes05'
   END

IF ISNULL(@Column06ID, '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			SUM(CASE WHEN ' + @ColumnName + ' = ''' + @Column06ID + ''' THEN ' + @FieldAmount + ' ELSE 0 END) AS ColumnValue06 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', 
			MAX(CASE WHEN ' + @ColumnName + ' = ''' + @Column06ID + ''' THEN Ana08Notes ELSE ''''  END) AS ColumnNotes06'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 AS ColumnValue06'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08' SET @sSQL = @sSQL + ', '''' AS ColumnNotes06'
   END

IF ISNULL(@Column07ID, '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column07ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue07 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column07ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes07'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue07'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes07'
   END


IF isnull(@Column08ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column08ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue08 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column08ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes08'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue08'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes08'
   END

IF isnull(@Column09ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column09ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue09 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column09ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes09'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue09'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes09'
   END


IF isnull(@Column10ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column10ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue10 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column10ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes10'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue10'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes10'
   END

--11 den 20 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF isnull(@Column11ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column11ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue11 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column11ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes11'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue11'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes11'
   END

IF isnull(@Column12ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column12ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue12 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column12ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes12'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue12'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes12'
   END

IF isnull(@Column13ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column13ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue13 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column13ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes13'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue13'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes13'
   END

IF isnull(@Column14ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column14ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue14 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column14ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes14'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue14'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes14'
   END

IF isnull(@Column15ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column15ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue15 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column15ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes15'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue15'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes15'
   END

IF isnull(@Column16ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column16ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue16 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column16ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes16'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue16'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes16'
   END

IF isnull(@Column17ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column17ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue17 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column17ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes17'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue17'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes17'
   END


IF isnull(@Column18ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column18ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue18 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column18ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes18'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue18'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes18'
   END

IF isnull(@Column19ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column19ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue19 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column19ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes19'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue19'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes19'
   END


IF isnull(@Column20ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column20ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue20 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column20ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes20'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue20'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes20'
   END




--21 den 31 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF isnull(@Column21ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column21ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue21 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column21ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes21'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue21'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes21'
   END

IF isnull(@Column22ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column22ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue22 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column22ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes22'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue22'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes22'
   END

IF isnull(@Column23ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column23ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue23 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column23ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes23'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue23'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes23'
   END

IF isnull(@Column24ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column24ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue24 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column24ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes24'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue24'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes24'
   END

IF isnull(@Column25ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column25ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue25 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column25ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes25'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue25'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes25'
   END

IF isnull(@Column26ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column26ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue26 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column26ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes26'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue26'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes26'
   END

IF isnull(@Column27ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column27ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue27 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column27ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes27'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue27'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes27'
   END


IF isnull(@Column28ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column28ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue28 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column28ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes28'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue28'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes28'
   END

IF isnull(@Column29ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column29ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue29 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column29ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes29'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue29'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes29'
   END


IF isnull(@Column30ID , '') <> ''
   BEGIN
         SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column30ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue30 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column30ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes30'
   END
ELSE
   BEGIN
        SET @sSQL = @sSQL + ', 0 as ColumnValue30'
        --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes30'
   END   

IF isnull(@Column31ID , '') <> ''
   BEGIN
        SET @sSQL = @sSQL + ', 
			Sum(Case when  ' + @ColumnName + ' =''' + @Column31ID + ''' then ' + @FieldAmount + ' Else 0  End)   as ColumnValue31 '
		--- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', 
			max(Case when  ' + @ColumnName + ' =''' + @Column31ID + ''' then Ana08Notes Else ''''  End)   as ColumnNotes31'
   END
ELSE
   BEGIN
         SET @sSQL = @sSQL + ', 0 as ColumnValue31'
         --- Bổ sung trường ghi chú MPT8 (Sinolife)
		IF @ColumnTypeID = 'A08'
			SET @sSQL = @sSQL + ', '''' as ColumnNotes31'
   END
   

SET @sSQL = @sSQL + ' , ''' + @Column01ID + ''' as CaptionCol01 , ''' + @Column02ID + ''' as CaptionCol02 , ''' + @Column03ID + ''' as CaptionCol03 , ''' + @Column04ID + ''' as CaptionCol04 , ''' + @Column05ID + ''' as CaptionCol05  '
SET @sSQL = @sSQL + ' , ''' + @Column06ID + ''' as CaptionCol06 , ''' + @Column07ID + ''' as CaptionCol07 , ''' + @Column08ID + ''' as CaptionCol08 , ''' + @Column09ID + ''' as CaptionCol09 , ''' + @Column10ID + ''' as CaptionCol10  '
SET @sSQL = @sSQL + ' , ''' + @Column11ID + ''' as CaptionCol11 , ''' + @Column12ID + ''' as CaptionCol12 , ''' + @Column13ID + ''' as CaptionCol13 , ''' + @Column14ID + ''' as CaptionCol14 , ''' + @Column15ID + ''' as CaptionCol15  '
SET @sSQL = @sSQL + ' , ''' + @Column16ID + ''' as CaptionCol16 , ''' + @Column17ID + ''' as CaptionCol17 , ''' + @Column18ID + ''' as CaptionCol18 , ''' + @Column19ID + ''' as CaptionCol19 , ''' + @Column20ID + ''' as CaptionCol20  '
SET @sSQL = @sSQL + ' , ''' + @Column21ID + ''' as CaptionCol21 , ''' + @Column22ID + ''' as CaptionCol22 , ''' + @Column23ID + ''' as CaptionCol23 , ''' + @Column24ID + ''' as CaptionCol24 , ''' + @Column25ID + ''' as CaptionCol25  '
SET @sSQL = @sSQL + ' , ''' + @Column26ID + ''' as CaptionCol26 , ''' + @Column27ID + ''' as CaptionCol27 , ''' + @Column28ID + ''' as CaptionCol28 , ''' + @Column29ID + ''' as CaptionCol29 , ''' + @Column30ID + ''' as CaptionCol30	 '
SET @sSQL = @sSQL + ' , ''' + @Column31ID + ''' as CaptionCol31  '

SET @sSQL2 = ' 	
From AV7000 V7 
		 Where 	V7.DivisionID = ''' + @DivisionID + ''' and '
IF @D_C <> 'B'
   BEGIN
         SET @sSQL2 = @sSQL2 + ' D_C = ''' + @D_C + '''  and  '
   END


SET @sSQL2 = @sSQL2 + '  	  WareHouseID between ''' + @FromWareHouseID + ''' and ''' + @ToWareHouseID + ''' and
			(TranMonth + 100*TranYear <=   ' + @ToMonthYearText + ')    '
IF @D_C <> 'B'
   BEGIN  --- Lay so du
         SET @sSQL2 = @sSQL2 + ' and  (TranMonth + 100*TranYear >=  ' + @FromMonthYearText + ')  '
   END

IF isnull(@strWhereClause , '') <> ''
   BEGIN
         SET @sSQL2 = @sSQL2 + ' and (' + @strWhereClause + ')'
   END


SET @sSQL2 = @sSQL2 + @sqlGroup




--PRINT @sSQL

IF NOT EXISTS ( SELECT
                    1
                FROM
                    sysobjects
                WHERE
                    Name = 'AV7716' AND Xtype = 'V' )
   BEGIN
         EXEC ( '  Create View AV7716 as '+@sSQL + @sSQL2)
   END
ELSE
   BEGIN
         EXEC ( '  Alter View AV7716  As '+@sSQL + @sSQL2)
   END


SET @sSQL = '
Select V16.*, V66.SelectionName as Column00Name 

From AV7716 V16 Left join AV6666 V66 on V66.SelectionType =''' + @RowTypeID + ''' and
					  V66.SelectionID = V16.Column00ID AND V66.DivisionID = V16.DivisionID
Where isnull(Column00ID,'''')<>'''' and (
	isnull(ColumnValue01,0)<>0  or isnull(ColumnValue02,0)<>0 or isnull(ColumnValue03,0)<>0 or isnull(ColumnValue04,0)<>0 or isnull(ColumnValue05,0)<>0 
or  	isnull(ColumnValue06,0)<>0  or isnull(ColumnValue07,0)<>0 or isnull(ColumnValue08,0)<>0 or isnull(ColumnValue09,0)<>0 or isnull(ColumnValue10,0)<>0 
or 	isnull(ColumnValue11,0)<>0  or isnull(ColumnValue12,0)<>0 or isnull(ColumnValue13,0)<>0 or isnull(ColumnValue14,0)<>0 or isnull(ColumnValue15,0)<>0 
or  	isnull(ColumnValue16,0)<>0  or isnull(ColumnValue17,0)<>0 or isnull(ColumnValue18,0)<>0 or isnull(ColumnValue19,0)<>0 or isnull(ColumnValue20,0)<>0 
or 	isnull(ColumnValue21,0)<>0  or isnull(ColumnValue22,0)<>0 or isnull(ColumnValue23,0)<>0 or isnull(ColumnValue24,0)<>0 or isnull(ColumnValue25,0)<>0 
or  	isnull(ColumnValue26,0)<>0  or isnull(ColumnValue27,0)<>0 or isnull(ColumnValue28,0)<>0 or isnull(ColumnValue29,0)<>0 or isnull(ColumnValue30,0)<>0  or isnull(ColumnValue31,0)<>0 
)
 '

EXEC (@sSQL)

--IF NOT EXISTS ( SELECT 
--                    1
--                FROM
--                    sysobjects
--                WHERE
--                    Name = 'AV7717' AND Xtype = 'V' )
--   BEGIN
--         EXEC ( '  Create View AV7717 as '+@sSQL )
--   END
--ELSE
--   BEGIN
--         EXEC ( '  Alter View AV7717  As '+@sSQL )
--   END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
