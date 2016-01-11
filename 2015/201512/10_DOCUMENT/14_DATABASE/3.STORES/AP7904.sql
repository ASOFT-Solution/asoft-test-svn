/****** Object:  StoredProcedure [dbo].[AP7904]    Script Date: 08/05/2010 09:54:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-----Chuc nang Ke thua thiet lap  bang Luu chuyen tien te
-----Created by: Nguyen Thi Thuy Tuyen, 
---- Date 12/07/2007
/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7904]
    @OldReportID AS nvarchar(50), 
    @NewReportID AS nvarchar(50), 
    @UserID AS nvarchar(50)
AS

INSERT AT6502(DivisionID, ReportCode, LineCode, LineDescription, PrintCode, AccountIDFrom, AccountIDTo, CorAccountIDFrom, CorAccountIDTo, D_C, AmountSign, PeriodAmount, AccuSign, Accumulator, Level1, Suppress, PrintStatus, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, LineDescriptionE, Notes)
SELECT      DivisionID, @NewReportID, LineCode, LineDescription, PrintCode, AccountIDFrom, AccountIDTo, CorAccountIDFrom, CorAccountIDTo, D_C, AmountSign, PeriodAmount, AccuSign, Accumulator, Level1, Suppress, PrintStatus, @UserID,      GETDATE(),  @UserID,          GETDATE(),      LineDescriptionE, Notes
FROM AT6502 WHERE ReportCode = @OldReportID
