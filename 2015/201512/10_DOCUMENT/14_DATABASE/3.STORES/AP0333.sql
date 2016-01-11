IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0333]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0333]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- LOAD Cập nhật tờ khai thuế nhà thầu -- Load tờ khai phát sinh
-- <History>
---- Create on 12/11/2015 by Trương Ngọc Phương Thảo
-- <Example>
/*
AP0333 @DivisionID = 'vg', @TaxReturnFileID = 'HCM-0300762150000-01_TBVMT-M032014' ,@UserID = ''
*/

CREATE PROCEDURE [dbo].[AP0333] 	
	@DivisionID NVARCHAR(50),
	@TaxReturnFileID NVARCHAR(50),
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = ''
SET @TaxReturnFileID = LTRIM(LEFT(@TaxReturnFileID,LEN(@TaxReturnFileID)-2))

SET @sSQL1 = '
SELECT AT0317.DivisionID, AT0317.VoucherID, AT0317.TaxReturnFileID, AT0317.TaxReturnID, AT0317.TranMonth, AT0317.TranYear, 
	   ISNULL(AT0317.IsPeriodTax,0) AS IsPeriodTax, AT0317.TranMonthTax, AT0317.TranYearTax, AT0317.TaxReturnDate, 
	   ISNULL(AT0317.ReturnTime,0) AS ReturnTime, AT0317.TaxAgentPeron,
       AT0317.TaxAgentCertificate, AT0317.TaxReturnPerson, AT0317.TaxAssignDate, AT0317.AmendedReturnDate, AT0317.MainReturnTax1, 
       AT0317.MainReturnTax2,AT0317.AmendedReturnTax 
FROM AT0317
WHERE AT0317.DivisionID = '''+@DivisionID+''' AND AT0317.TaxReturnFileID LIKE (CASE WHEN ISNULL('''+@TaxReturnFileID+''','''') <> '''' THEN '''+@TaxReturnFileID+'%'' ELSE '''' END)
	  AND AT0317.ReturnTime = (SELECT MAX(AT0317.ReturnTime)
	                         FROM AT0317 
	                         WHERE AT0317.DivisionID = '''+@DivisionID+''' 
	                         AND AT0317.TaxReturnFileID LIKE (CASE WHEN ISNULL('''+@TaxReturnFileID+''','''') <> '''' THEN '''+@TaxReturnFileID+'%'' ELSE '''' END)
	  						)
'
EXEC (@sSQL1)
--PRINT (@sSQL1)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

