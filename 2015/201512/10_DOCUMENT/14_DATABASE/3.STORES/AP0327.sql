IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0327]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0327]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD Cập nhật tờ khai thuế tài nguyên -- Load tờ khai phát sinh
-- <History>
---- Create on 02/06/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0327 @DivisionID = 'vg', @TaxReturnFileID = 'HCM-0300762150000-01_TBVMT-M032014' ,@UserID = ''
*/

CREATE PROCEDURE [dbo].[AP0327] 	
	@DivisionID NVARCHAR(50),
	@TaxReturnFileID NVARCHAR(50),
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = ''
SET @TaxReturnFileID = LTRIM(LEFT(@TaxReturnFileID,LEN(@TaxReturnFileID)-2))
SET @sSQL1 = '
SELECT AT30.DivisionID, AT30.VoucherID, AT30.TaxReturnFileID, AT30.TaxReturnID, AT30.TranMonth, AT30.TranYear, 
	   ISNULL(AT30.IsPeriodTax,0) AS IsPeriodTax, AT30.TranMonthTax, AT30.TranYearTax, AT30.TaxReturnDate, 
	   ISNULL(AT30.ReturnTime,0) AS ReturnTime, ISNULL(AT30.IsAppendix,0) AS IsAppendix, AT30.TaxAgentPeron,
       AT30.TaxAgentCertificate, AT30.TaxReturnPerson, AT30.TaxAssignDate, AT30.AmendedReturnDate, AT30.MainReturnTax1, 
       AT30.MainReturnTax2,AT30.AmendedReturnTax , AT30.PrintDate,
       ISNULL(AT30.NRTTypeID,0) AS NRTTypeID
FROM AT0310 AT30
WHERE AT30.DivisionID = '''+@DivisionID+''' AND AT30.TaxReturnFileID LIKE (CASE WHEN ISNULL('''+@TaxReturnFileID+''','''') <> '''' THEN '''+@TaxReturnFileID+'%'' ELSE '''' END)
	  AND AT30.ReturnTime = (SELECT MAX(AT30.ReturnTime)
	                         FROM AT0310 AT30 
	                         WHERE AT30.DivisionID = '''+@DivisionID+''' 
	                         AND AT30.TaxReturnFileID LIKE (CASE WHEN ISNULL('''+@TaxReturnFileID+''','''') <> '''' THEN '''+@TaxReturnFileID+'%'' ELSE '''' END)
	  						)
'
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
