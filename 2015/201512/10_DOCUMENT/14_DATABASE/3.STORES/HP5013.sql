
/****** Object:  StoredProcedure [dbo].[HP5013]    Script Date: 08/05/2010 10:01:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Xoa du lieu tinh luong

ALTER PROCEDURE [dbo].[HP5013]
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @PayrollMethodID AS nvarchar(50) ,
       @DepartmentID1 AS nvarchar(50) ,
       @TeamID1 AS nvarchar(50)
AS
DECLARE
        @Status AS tinyint ,
        @VietMess AS nvarchar(250) ,
        @EngMess AS nvarchar(250)

SET @Status = 0
SET @VietMess = ''
SET @EngMess = ''


DELETE
        HT3400
WHERE
        PayrollMethodID = @PayrollMethodID AND DivisionID = @DivisionID AND DepartmentID LIKE @DepartmentID1 AND IsNull(TeamID , '') LIKE IsNull(@TeamID1 , '') AND TranMonth = @TranMonth AND TranYear = @TranYear 
		
		