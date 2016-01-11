IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[DATATRAN]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[DATATRAN]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- In báo cáo ACC_Hồ sơ
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: by Thanh Sơn on 01/10/2014 
-- <Example>
/*

DATATRAN 'VG', 'AT2006', 'VoucherID'',''ReVoucherID','ASOFTADMIN'

*/
 CREATE PROCEDURE DATATRAN 
(	
	@BranchID VARCHAR(50),	
	@TableID VARCHAR(50),	
	@ColumnList NVARCHAR(MAX),
	@LastModifyUserID VARCHAR(50)
)
AS
DECLARE @CurColumns CURSOR, @ColumnID VARCHAR(50),
		@sSQL NVARCHAR(MAX) = '', @sSQL1 NVARCHAR(MAX) = '',
		@LasModifyDate DATETIME
		
SET @LasModifyDate = (SELECT GETDATE())
		
CREATE TABLE #Tam (ID TINYINT)

SET @CurColumns = CURSOR SCROLL KEYSET FOR
 SELECT col.name Col
 FROM syscolumns col
 INNER JOIN sysobjects tab ON tab.id = col.id 
 WHERE tab.name = @TableID
 AND col.name <> 'APK'

OPEN @CurColumns 
FETCH NEXT FROM @CurColumns INTO @ColumnID
WHILE @@FETCH_STATUS = 0
BEGIN
	DELETE #Tam
	INSERT INTO #Tam(ID) EXEC ('SELECT CASE WHEN '''+@ColumnID+''' IN ('''+@ColumnList+''') THEN 1 ELSE 0 END')
	IF EXISTS (SELECT * FROM #Tam WHERE ID = 1) SET @sSQL1 = @sSQL1 +''''+(SELECT @BranchID) + ''''+ '+' + @ColumnID + ', '
	ELSE IF @ColumnID = 'LastModifyUserID' SET @sSQL1 = @sSQL1 + ''''+@LastModifyUserID+''''+', '
		 ELSE IF @ColumnID = 'LastModifyDate' SET @sSQL1 = @sSQL1 + 'GETDATE()' + ', '
			  ELSE SET @sSQL1 = @sSQL1 + @ColumnID + ', '	
	
	SET @sSQL = @sSQL + @ColumnID + ', '
	FETCH NEXT FROM @CurColumns INTO @ColumnID
END
CLOSE @CurColumns
SET @sSQL = LEFT(@sSQL, LEN(@sSQL) - 1)
SET @sSQL1 = LEFT(@sSQL1, LEN(@sSQL1) - 1)


SELECT ('INSERT INTO [@DATANAME2].dbo.'+@TableID+' ('+@sSQL+')
SELECT '+@sSQL1+' ')


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
