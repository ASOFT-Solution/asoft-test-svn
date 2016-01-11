/****** Object:  StoredProcedure [dbo].[AP7631]    Script Date: 08/05/2010 09:45:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
-----Chuc nang Ke thua bao cao KD theo ma phan tich  
-----Created by: Dang Le Bao Quynh,
---- Date 08/07/2008

ALTER PROCEDURE [dbo].[AP7631]
       @OldReportID AS nvarchar(50) ,
       @NewReportID AS nvarchar(50),
       @DivisionID AS NVARCHAR(50)
AS
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT7621 WHERE ReportCode = @NewReportID )
   BEGIN
         INSERT INTO dbo.AT7621
                 ( 
                   DivisionID ,
                   ReportCode ,
                   LineID ,
                   LineCode ,
                   LineDescription ,
                   LevelID ,
                   Sign ,
                   AccuLineID ,
                   CaculatorID ,
                   FromAccountID ,
                   ToAccountID ,
                   FromCorAccountID ,
                   ToCorAccountID ,
                   AnaTypeID ,
                   FromAnaID ,
                   ToAnaID ,
                   IsPrint ,
                   BudgetID
                 )
             SELECT
				 @DivisionID,
                 @NewReportID ,
                 LineID ,
                 LineCode ,
                 LineDescription ,
                 LevelID ,
                 Sign ,
                 AccuLineID ,
                 CaculatorID ,
                 FromAccountID ,
                 ToAccountID ,
                 FromCorAccountID ,
                 ToCorAccountID ,
                 AnaTypeID ,
                 FromAnaID ,
                 ToAnaID ,
                 IsPrint ,
                 BudgetID
             FROM
                 AT7621
             WHERE
                 ReportCode = @OldReportID
                 AND DivisionID = @DivisionID
   END   