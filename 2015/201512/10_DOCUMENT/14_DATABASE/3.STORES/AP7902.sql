/****** Object:  StoredProcedure [dbo].[AP7902]    Script Date: 08/05/2010 09:53:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


-----Chuc nang Ke thua thiet lap  bang can doi ke toan  
-----Created by: Nguyen Thi Thuy Tuyen,
---- Date 12/07/2007
/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/
--Last Edit by Thiên Huỳnh on [25/05/2012]
--Không sinh LineID nửa, Vì sinh LineID sẽ làm mất liên kết giữa LineID và ParentLineID

ALTER PROCEDURE [dbo].[AP7902]
	   @DivisionID as nvarchar(50),
       @OldReportID AS nvarchar(50) ,
       @NewReportID AS nvarchar(50) ,
       @UserID AS nvarchar(50) ,
       @TranYear int
AS
DECLARE
        @cur AS cursor ,
        @LineID AS nvarchar(50) ,
        @ReportCode AS nvarchar(50) ,
        @Type AS tinyint ,
        @LineCode AS nvarchar(50) ,
        @LineDescription AS nvarchar(250) ,
        @AccountIDFrom AS nvarchar(50) ,
        @AccountIDTo AS nvarchar(50) ,
        @D_C AS tinyint ,
        @Detail AS tinyint ,
        @ParrentLineID AS nvarchar(50) ,
        @Accumulator AS nvarchar(50) ,
        @Level1 AS tinyint ,
        @PrintStatus AS tinyint ,
        @LineDescriptionE AS nvarchar(250) ,
        @Notes AS nvarchar(250)

SET @Cur = CURSOR SCROLL KEYSET FOR SELECT
                                        LineID ,
                                        ReportCode ,
                                        Type ,
                                        LineCode ,
                                        LineDescription ,
                                        AccountIDFrom ,
                                        AccountIDTo ,
                                        D_C ,
                                        Detail ,
                                        ParrentLineID ,
                                        Accumulator ,
                                        Level1 ,
                                        PrintStatus ,
                                        LineDescriptionE ,
                                        Notes
                                    FROM
                                        AT7902
                                    WHERE
                                        RePortCode = @OldReportID
                                        AND DivisionID = @DivisionID

OPEN @Cur
FETCH NEXT FROM @Cur INTO @LineID,@ReportCode,@Type,@LineCode,@LineDescription,@AccountIDFrom,@AccountIDTo,@D_C,@Detail,@ParrentLineID,@Accumulator,@Level1,@PrintStatus,@LineDescriptionE,@Notes
WHILE @@Fetch_Status = 0

      BEGIN


            BEGIN
				  --Khong sinh LineID nua, Vi Sinh LineID se lam mat lien ket giua LineID va ParentLineID
                  --EXEC AP0000 @DivisionID, @LineID OUTPUT , 'AT7902' , 'L' , @TranYear , '' , 16 , 3 , 0 , '-'
                  INSERT
                      AT7902
                      (
                        DivisionID ,
                        LineID ,
                        ReportCode ,
                        Type ,
                        LineCode ,
                        LineDescription ,
                        AccountIDFrom ,
                        AccountIDTo ,
                        D_C ,
                        Detail ,
                        ParrentLineID ,
                        Accumulator ,
                        Level1 ,
                        PrintStatus ,
                        CreateDate ,
                        CreateUserID ,
                        LastModifyDate ,
                        LastModifyUserID ,
                        LineDescriptionE ,
                        Notes )
                  VALUES
                      (
                        @DivisionID ,
                        @LineID ,
                        @NewReportID ,
                        @Type ,
                        @LineCode ,
                        @LineDescription ,
                        @AccountIDFrom ,
                        @AccountIDTo ,
                        @D_C ,
                        @Detail ,
                        @ParrentLineID ,
                        @Accumulator ,
                        @Level1 ,
                        @PrintStatus ,
                        getdate() ,
                        @UserID ,
                        getdate() ,
                        @UserID ,
                        @LineDescriptionE ,
                        @Notes )
            END


            FETCH NEXT FROM @Cur INTO @LineID,@ReportCode,@Type,@LineCode,@LineDescription,@AccountIDFrom,@AccountIDTo,@D_C,@Detail,@ParrentLineID,@Accumulator,@Level1,@PrintStatus,@LineDescriptionE,@Notes
      END

CLOSE @Cur