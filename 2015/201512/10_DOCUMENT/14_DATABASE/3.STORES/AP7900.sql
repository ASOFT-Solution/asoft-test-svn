IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7900]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7900]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---- 	Created by Nguyen Van Nhan, Date 30/03/2004
--- 	Purpose: Kiem tra cong len cap cha co lap lai hay khong
--- Modified on 15/04/2013 by Le Thi Thu Hien : Bo sung WHERE ReportCode = @ReportCodeID)
/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP7900]
	   @DivisionID nvarchar(50) ,
       @ReportCodeID AS nvarchar(50) ,
       @LineID AS nvarchar(50) ,
       @ParLineID AS nvarchar(50)
AS
DECLARE
        @Status AS tinyint ,
        @ParentLineID AS nvarchar(50)

SET @Status = 0
IF @LineID = ''
   BEGIN --- them moi
         GOTO ENDMES
   END
SET @ParentLineID = @ParLineID

IF @ParLineID = @LineID
   BEGIN
         SET @Status = 1
   END

--Set  @ParentLineID = (Select ParrentLineID  From AT7902 Where LineID = @LineID)
--If @ParentLineID = @LineID 
	--Set @Status = 1

WHILE @LineID <> @ParentLineID AND @ParentLineID <> '' AND @Status = 0
      BEGIN
            SET @ParentLineID = ( SELECT	ParrentLineID
                                  FROM		AT7902
                                  WHERE		LineID = @LineID 
										AND DivisionID=@DivisionID
										AND ReportCode = @ReportCodeID)	
--	print @ParentLineID
            IF @ParentLineID = @LineID
               BEGIN
                     SET @Status = 1
               END
            SET @LineID = @ParentLineID
      END

ENDMES:
SELECT
    @Status AS Status

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

