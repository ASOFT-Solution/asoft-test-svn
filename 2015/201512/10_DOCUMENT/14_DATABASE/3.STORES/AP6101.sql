IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP6101]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP6101]
GO
/****** Object:  StoredProcedure [dbo].[AP6101]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----Chuc nang Ke thua bao cao quan tri dang 2  
-----Created by: Dang Le Bao Quynh,
---- Date 08/07/2008
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [01/08/2010]
'********************************************/


CREATE PROCEDURE [dbo].[AP6101] 	@OldReportID as nvarchar(50), 
				@NewReportID as nvarchar(50),
				@UserID as varchar(20)


 AS
		If not exists (Select Top 1 1 From AT6101 Where ReportCode = @NewReportID)
			Insert into AT6101(ReportCode, LineID, LineCode, LineDescription,AccountIDFrom,AccountIDTo,CorAccountIDFrom,CorAccountIDTo,LineType,
			BreakDetail,AmountSign,AccuSign,Accumulator,Accumulator1,Accumulator2,PrintStatus,Type,
            CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, IsAccount, LevelID, Sign, DivisionID)
			
            Select @NewReportID,LineID,LineCode,LineDescription,AccountIDFrom,AccountIDTo,CorAccountIDFrom,CorAccountIDTo,LineType,
			BreakDetail,AmountSign,AccuSign,Accumulator,Accumulator1,Accumulator2,PrintStatus,Type,
			@UserID,getDate(),@UserID,getDate(),IsAccount,LevelID,Sign, DivisionID
			From AT6101
			Where ReportCode = @OldReportID
GO
