IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2502]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2502]
GO
----Created by: Vo Thanh Huong, date: 08/09/2004  
----purpose: Ki?m tra m?c công t?i da khi luu ch?m công ngày  
  
/********************************************  
'* Edited by: [GS] [Việt Khánh] [02/08/2010]  
'********************************************/  
  
CREATE PROCEDURE [dbo].[HP2502]   
    @AbsentTypeID NVARCHAR(50),   
    @AbsentAmount DECIMAL,
    @DivisionID NVARCHAR(50)    
AS  
  
DECLARE   
    @Status TINYINT,   
    @VietMess NVARCHAR(4000),   
    @EngMess NVARCHAR(4000)  
  
SELECT @Status = 0, @VietMess = '', @EngMess = ''  
  
IF EXISTS(SELECT 1 FROM HT1013 WHERE DivisionID = @DivisionID And AbsentTypeID = @AbsentTypeID AND MaxValue < @AbsentAmount)   
    SELECT @Status = 1,   
        @VietMess = N'HFML000305',  --' B¹n ph¶i nhËp sè c«ng nhá h¬n c«ng tèi ®a.',   
        @EngMess = N'HFML000305' --'You can not input absent amount larger max value.'   
  
GOTO EndMess  
  
EndMess:  
SELECT @Status AS Status, @VietMess AS VieMessage, @EngMess AS EngMessage
