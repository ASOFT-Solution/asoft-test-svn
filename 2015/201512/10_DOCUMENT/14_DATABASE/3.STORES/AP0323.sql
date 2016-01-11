IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0323]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0323]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD Cập nhật tờ khai thuế TTĐB -- Load tờ khai phát sinh
-- <History>
---- Create on 29/05/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0323 @DivisionID = 'vg', @TaxReturnFileID = 'HCM-0300762150000-01_TBVMT-M032014' ,@UserID = ''
*/

CREATE PROCEDURE [dbo].[AP0323] 	
	@DivisionID NVARCHAR(50),
	@TaxReturnFileID NVARCHAR(50),
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = ''
SET @TaxReturnFileID = LTRIM(LEFT(@TaxReturnFileID,LEN(@TaxReturnFileID)-2))
SET @sSQL1 = '
SELECT AT39.DivisionID, AT39.VoucherID, AT39.TaxReturnFileID, AT39.TaxReturnID, AT39.TranMonth, AT39.TranYear, 
	   ISNULL(AT39.IsPeriodTax,0) AS IsPeriodTax, AT39.TranMonthTax, AT39.TranYearTax, AT39.TaxReturnDate, 
	   ISNULL(AT39.ReturnTime,0) AS ReturnTime, ISNULL(AT39.IsAppendix,0) AS IsAppendix, AT39.TaxAgentPeron,
       AT39.TaxAgentCertificate, AT39.TaxReturnPerson, AT39.TaxAssignDate, AT39.AmendedReturnDate, AT39.MainReturnTax, 
       AT39.AppendixReturnTax1, AT39.AppendixReturnTax21, AT39.AppendixReturnTax22, AT39.AmendedReturnTax , AT39.PrintDate,
       ISNULL(AT39.IsSETIncur,0) AS IsSETIncur, ISNULL(AT39.IsAppendix1,0) AS IsAppendix1, ISNULL(AT39.IsAppendix2,0) AS IsAppendix2
FROM AT0309 AT39
WHERE AT39.DivisionID = '''+@DivisionID+''' AND AT39.TaxReturnFileID LIKE (CASE WHEN ISNULL('''+@TaxReturnFileID+''','''') <> '''' THEN '''+@TaxReturnFileID+'%'' ELSE '''' END)
	  AND AT39.ReturnTime = (SELECT MAX(AT39.ReturnTime)
	                         FROM AT0309 AT39 
	                         WHERE AT39.DivisionID = '''+@DivisionID+''' 
	                         AND AT39.TaxReturnFileID LIKE (CASE WHEN ISNULL('''+@TaxReturnFileID+''','''') <> '''' THEN '''+@TaxReturnFileID+'%'' ELSE '''' END)
	  						)
'
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
