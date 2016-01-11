IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2462]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2462]
GO
/****** Object:  StoredProcedure [dbo].[HP2462]    Script Date: 11/02/2011 16:03:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-----Created by: Vo Thanh Huong
-----Created date: 08/07/2004
-----purpose:Kiem tra truoc khi xoa 

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2462] 
    @DivisionID NVARCHAR(50), 
    @DepartmentID NVARCHAR(50),
    @ToDepartmentID NVARCHAR(50), 
    @EmployeeID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT,
    @Condition NVARCHAR(1000)
AS

Declare 
    @Status TINYINT, 
    @VietMess NVARCHAR(4000), 
    @EngMess NVARCHAR(4000)
    
SET @Status = 0
SET @VietMess = ''
SET @EngMess = ''

IF EXISTS (SELECT TOP 1 1 FROM HT2461
            WHERE DivisionID = @DivisionID 
                AND DepartmentID between @DepartmentID and @ToDepartmentID And isnull (DepartmentID,'''#''') in (@Condition) 
                AND EmployeeID like @EmployeeID 
                AND TranMonth = @TranMonth 
                AND TranYear = @TranYear)
BEGIN
    SET @Status = 1
    SET @VietMess = "HFML000366"--'Nh©n viªn nµy ®· ®­îc tÝnh BHXH. B¹n kh«ng thÓ xo¸! '
    SET @EngMess = "HFML000366"--'This Employee has been calculated insurance, you can not delete!'
    GOTO EndMess
END


EndMess:

SELECT @Status AS Status, @VietMess AS VieMessage, @EngMess AS EngMessages
GO


