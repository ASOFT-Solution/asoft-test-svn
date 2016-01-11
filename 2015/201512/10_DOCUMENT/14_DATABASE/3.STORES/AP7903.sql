/****** Object: StoredProcedure [dbo].[AP7903] Script Date: 08/05/2010 09:54:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-----Chuc nang Ke thua thiet lap bang ke qua kinh doanh 
-----Created by: Nguyen Thi Thuy Tuyen, 
---- Date 12/07/2007
/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7903]
    @OldReportID AS nvarchar(50), 
    @NewReportID AS nvarchar(50), 
    @UserID AS nvarchar(50)
AS

INSERT AT7602(DivisionID, ReportCode, Type, LineCode, LineDescription, PrintCode, AccountIDFrom, AccountIDTo, CorAccountIDFrom, CorAccountIDTo, D_C, AmountSign, PeriodAmount, AccuSign, Accumulator, Level1, Suppress, PrintStatus, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, ColStatus01, ColStatus02, ColStatus03, ColStatus04, ColStatus05, ColStatus06, IsLastPeriod, LineDescriptionE, Notes)
SELECT      DivisionID, @NewReportID, Type, LineCode, LineDescription, PrintCode, AccountIDFrom, AccountIDTo, CorAccountIDFrom, CorAccountIDTo, D_C, AmountSign, PeriodAmount, AccuSign, Accumulator, Level1, Suppress, PrintStatus, @UserID,      GETDATE(),  @UserID,          GETDATE(),      ColStatus01, ColStatus02, ColStatus03, ColStatus04, ColStatus05, ColStatus06, IsLastPeriod, LineDescriptionE, Notes
FROM AT7602 WHERE ReportCode = @OldReportID
