IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7908]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7908]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
--- Created by Nguyen Van Nhan, Date  18/09/2008.
--- Tinh toan cac chi tieu so du no, du co cua cac chi tieu, len bang thuyet minh tai chinh lien quan den TSCD
---- Modified by on 11/10/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID

CREATE PROCEDURE [dbo].[AP7908]
       @DivisionID nvarchar(50) ,
       @ReportCode AS nvarchar(50) ,
       @TranYear AS INT,
       @StrDivisionID AS NVARCHAR(4000) = ''
AS
DECLARE
        @cur AS cursor ,
        @FromAccountID AS nvarchar(50) ,
        @ToAccountID AS nvarchar(50) ,
        @ToCorAccountID AS nvarchar(50) ,
        @FromCorAccountID AS nvarchar(50) ,
        @OperatorID AS nvarchar(50) ,
        @GroupID AS nvarchar(50) ,
        @TitleID AS nvarchar(50) ,
        @Amount01 AS decimal(28,8) ,
        @Amount02 AS decimal(28,8) ,
        @Amount03 AS decimal(28,8) ,
        @Amount04 AS decimal(28,8) ,
        @Amount05 AS decimal(28,8) ,
        @Amount06 AS decimal(28,8) ,
        @Amount07 AS decimal(28,8) ,
        @Amount08 AS decimal(28,8) ,
        @Amount09 AS decimal(28,8) ,
        @Amount10 AS decimal(28,8) ,
        @IsCol01 AS tinyint ,
        @IsCol02 AS tinyint ,
        @IsCol03 AS tinyint ,
        @IsCol04 AS tinyint ,
        @IsCol05 AS tinyint ,
        @IsCol06 AS tinyint ,
        @IsCol07 AS tinyint ,
        @IsCol08 AS tinyint ,
        @IsCol09 AS tinyint ,
        @IsCol10 AS tinyint

SET NOCOUNT ON
--- Xoa du lieu bang tam
DELETE  AT7910
INSERT  AT7910
    ( DivisionID,
      ReportCode ,
      GroupID ,
      TitleID ,
      LineDes ,
      LineLevel ,
      Amount01 ,
      Amount02 ,
      Amount03 ,
      Amount04 ,
      Amount05 ,
      Amount06 ,
      Amount07 ,
      Amount08 ,
      Amount09 ,
      Amount10 )
    SELECT	DivisionID,
			@ReportCode ,
			GroupID ,
			TitleID ,
			LineDes ,
			0 ,
			0 ,
			0 ,
			0 ,
			0 ,
			0 ,
			0 ,
			0 ,
			0 ,
			0 ,
			0
    FROM	AT7907
    WHERE	ReportCode = @ReportCode
			AND DivisionID = @DivisionID

--Print @ReportCode

SET @Cur = CURSOR SCROLL KEYSET FOR SELECT  AT7910.GroupID ,
											AT7910.TitleID ,
											AT7907.OperatorID
                                    FROM	AT7910 
                                    INNER JOIN AT7907 ON  AT7907.TitleID = AT7910.TitleID AND AT7907.GroupID = AT7910.GroupID AND AT7907.DivisionID = AT7910.DivisionID
                                    WHERE   AT7910.ReportCode = @ReportCode
											AND AT7910.DivisionID = @DivisionID
OPEN @Cur
FETCH NEXT FROM @Cur INTO @GroupID,@TitleID,@OperatorID
WHILE @@Fetch_Status = 0
      BEGIN
            SELECT	@IsCol01 = IsCol01 ,
					@IsCol02 = IsCol02 ,
					@IsCol03 = IsCol03 ,
					@IsCol04 = IsCol04 ,
					@IsCol05 = IsCol05 ,
					@IsCol06 = IsCol06 ,
					@IsCol07 = IsCol07 ,
					@IsCol08 = IsCol08 ,
					@IsCol09 = IsCol09 ,
					@IsCol10 =	 IsCol10
            FROM   AT7906
            WHERE  ReportCode = @ReportCode AND GroupID = @GroupID AND DivisionID = @DivisionID
            
            SET @Amount01 = 0
            SET @Amount02 = 0
            SET @Amount03 = 0
            SET @Amount04 = 0
            SET @Amount05 = 0
            SET @Amount06 = 0
            SET @Amount07 = 0
            SET @Amount08 = 0
            SET @Amount09 = 0
            SET @Amount10 = 0
            EXEC AP7907 @DivisionID , @TranYear , @ReportCode , @GroupID , @TitleID , @OperatorID , @IsCol01 , @IsCol02 , @IsCol03 , @IsCol04 , @IsCol05 , @IsCol06 , @IsCol07 , @IsCol08 , @IsCol09 , @IsCol10, @StrDivisionID

            FETCH NEXT FROM @Cur INTO @GroupID,@TitleID,@OperatorID
      END
CLOSE @Cur

SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

