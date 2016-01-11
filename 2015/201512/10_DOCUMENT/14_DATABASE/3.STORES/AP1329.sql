/****** Object: StoredProcedure [dbo].[AP1329] Script Date: 07/29/2010 09:45:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- CREATE by:Thuy Tuyen ; Date 15/03/2009
---- Purpose : Tinh cong thuc thiet lap dvt qui doi
----last Edit: Thuy Tuyen, date :29/03/2010
---- Edit by: Tan Phu, date: 10/10/2012, kiemt ra truong hop chia cho 0
---- Modify on 19/06/2013 by Bảo Anh: Sửa cách bắt lỗi khi tính toán
/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1329] 
    @T01 NUMERIC(19, 4), 
    @T02 NUMERIC(19, 4), 
    @T03 NUMERIC(19, 4), 
    @T04 NUMERIC(19, 4), 
    @T05 NUMERIC(19, 4), 
    @SL NUMERIC(19, 4), 
    @FormulaDes NVARCHAR(4000), 
    @ResultOutput DECIMAL(28, 8) OUTPUT
AS

DECLARE @SQL NVARCHAR(1000)

SET @FormulaDes = REPLACE(@FormulaDes, '@T01', ISNULL(@T01, 0)) 
SET @FormulaDes = REPLACE(@FormulaDes, '@T02', ISNULL(@T02, 0)) 
SET @FormulaDes = REPLACE(@FormulaDes, '@T03', ISNULL(@T03, 0)) 
SET @FormulaDes = REPLACE(@FormulaDes, '@T04', ISNULL(@T04, 0)) 
SET @FormulaDes = REPLACE(@FormulaDes, '@T05', ISNULL(@T05, 0)) 
SET @FormulaDes = REPLACE(@FormulaDes, '@SL', ISNULL(@SL, 0)) 

----EXEC (@FormulaDes)
-- Generate divide-by-zero error.
BEGIN TRY
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ErrorTable]') AND type in (N'U'))
		DROP TABLE ErrorTable
	EXEC ('SELECT ' + @FormulaDes + ' AS ResultOutput, DivisionID INTO ErrorTable from AT1101')
	
	IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV1329')
	    EXEC('CREATE VIEW AV1329 AS SELECT ' + @FormulaDes + ' AS ResultOutput, DivisionID from AT1101')
	ELSE 
	    EXEC('ALTER VIEW AV1329 AS SELECT ' + @FormulaDes + ' AS ResultOutput, DivisionID from AT1101')
END TRY

    -- Execute the error retrieval routine.
BEGIN CATCH
	IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV1329')
	    EXEC('CREATE VIEW AV1329 AS SELECT 0 AS ResultOutput, DivisionID from AT1101')
	ELSE 
	    EXEC('ALTER VIEW AV1329 AS SELECT 0 AS ResultOutput, DivisionID from AT1101')
END CATCH;
SET @ResultOutput = (SELECT TOP 1 ResultOutput FROM AV1329)

SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON