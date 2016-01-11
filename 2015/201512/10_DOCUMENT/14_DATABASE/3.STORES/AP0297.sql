IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0297]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0297]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD DANH MỤC TỜ KHAI THUẾ BẢO VỆ MÔI TRƯỜNG -- Load tờ khai phát sinh
-- <History>
---- Create on 03/04/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0297 @DivisionID = 'vg', @TaxReturnFileID = 'HCM-0300762150000-01_TBVMT-M032014' ,@UserID = ''
*/

CREATE PROCEDURE [dbo].[AP0297] 	
	@DivisionID NVARCHAR(50),
	@TaxReturnFileID NVARCHAR(50),
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = ''
SET @TaxReturnFileID = LTRIM(LEFT(@TaxReturnFileID,LEN(@TaxReturnFileID)-2))
SET @sSQL1 = '
SELECT AT96.DivisionID, AT96.VoucherID, AT96.TaxReturnFileID, AT96.TaxReturnID,
       AT96.TranMonth, AT96.TranYear, ISNULL(AT96.IsPeriodTax,0) AS IsPeriodTax, AT96.TranMonthTax,
       AT96.TranYearTax, AT96.TaxReturnDate, AT96.TaxReturnName, AT96.ReturnTime, 
       ISNULL(AT96.IsAppendix,0) AS IsAppendix, AT96.TaxAgentPeron,
       AT96.TaxAgentCertificate, AT96.TaxReturnPerson, AT96.TaxAssignDate,
       AT96.ReportVoucherID, AT96.ETaxVoucherID, AT96.AmendedReturnDate, 
       AT96.MainReturnTax, AT96.AppendixReturnTax, AT96.AmendedReturnTax, PrintDate
FROM AT0296 AT96
WHERE AT96.DivisionID = '''+@DivisionID+''' AND AT96.TaxReturnFileID LIKE (CASE WHEN ISNULL('''+@TaxReturnFileID+''','''') <> '''' THEN '''+@TaxReturnFileID+'%'' ELSE '''' END)
	  AND AT96.ReturnTime = (SELECT MAX(AT96.ReturnTime)
	                         FROM AT0296 AT96 
	                         WHERE AT96.DivisionID = '''+@DivisionID+''' 
	                         AND AT96.TaxReturnFileID LIKE (CASE WHEN ISNULL('''+@TaxReturnFileID+''','''') <> '''' THEN '''+@TaxReturnFileID+'%'' ELSE '''' END)
	  						)

'
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
