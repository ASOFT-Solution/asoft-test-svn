IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5012]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5012]
GO
------ Created by Nguyen Van Nhan.  
------ Created Date 04/05/2004  
----- Purpose: Kiem tra Xoa du lieu tinh luong  
/********************************************  
'* Edited by: [GS] [Minh Lâm] [02/08/2010]  
'********************************************/  
  
CREATE PROCEDURE [dbo].[HP5012]  
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
  
IF NOT EXISTS ( SELECT TOP 1  
                    1  
                FROM  
                    HT3400  
                WHERE  
                    PayrollMethodID = @PayrollMethodID AND DivisionID = @DivisionID AND DepartmentID LIKE @DepartmentID1 AND IsNull(TeamID , '') LIKE IsNull(@TeamID1 , '') AND TranMonth = @TranMonth AND TranYear = @TranYear )  
   BEGIN  
         SET @Status = 1  
         SET @VietMess = N'HFML000162'--'Ph­¬ng ph¸p tÝnh l­¬ng ' + @PayrollMethodID + ' cho phßng ban ' + @DepartmentID1 + ' tæ nhãm ' + @TeamID1 + ' ch­a ®­îc tÝnh nªn kh«ng xãa ®­îc.'  
         SET @EngMess = N'HFML000162'--'Departments of ' + @DepartmentID1 + '  and teams of ' + @TeamID1 + ' that belong to the departmnents have not been calculated by the method of ' + @PayrollMethodID  
   END  
  
  
SELECT  
    @Status AS Status ,  
    @VietMess AS VieMessage ,  
    @EngMess AS EngMessage  
  
  
  
  