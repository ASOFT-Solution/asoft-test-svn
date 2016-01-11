IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1406]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1406]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----- Created by: Dang Le Bao Quynh, Date 06/06/2006.
----- Purpose: Tao du lieu ngam cho chuc nang cap quyen theo du lieu
----- Edit By: Dang Le Bao Quynh, Date 07/06/2006.
----- Edit By: Dang Le Bao Quynh, Date 27/08/2007

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/
---- Modified on 23/07/2013 by Lê Thị Thu Hiền : Bổ sung IsCommon : Check dùng chung
----

CREATE PROCEDURE [dbo].[AP1406] 
    @DivisionID NVARCHAR(50), 
    @ModuleID NVARCHAR(50), 
    @DataID NVARCHAR(50), 
    @DataName NVARCHAR(250), 
    @DataType char(2), 
    @Date DATETIME, 
    @UserID NVARCHAR(50), 
    @Status char(1),
    @IsCommon TINYINT = 0
AS

SET NOCOUNT OFF

IF @Status = 'A' --Neu trang thai la them moi
    IF @DataType<>'PE'
        BEGIN
            IF NOT EXISTS (SELECT DivisionID + DataID + DataType FROM AT1407 WHERE DivisionID + DataID + DataType = @DivisionID + @DataID + @DataType)
                BEGIN
                	IF @IsCommon = 0
                	BEGIN
                		INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID) 
						SELECT DISTINCT @DivisionID, ModuleID, @DataID, @DataName, @DataType, GETDATE(), @UserID, GETDATE(), @UserID FROM AT1409 WHERE AT1409.DivisionID =  @DivisionID	
                	END
                	IF @IsCommon = 1
                	BEGIN
                		INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID) 
						SELECT DISTINCT AT1101.DivisionID, ModuleID, @DataID, @DataName, @DataType, GETDATE(), @UserID, GETDATE(), @UserID 
						FROM AT1409 , AT1101

                	END
                    
                END

            IF NOT EXISTS (SELECT DivisionID + DataID + DataType FROM AT1406 WHERE DivisionID + DataID + DataType = @DivisionID + @DataID + @DataType)
                BEGIN
                	IF @IsCommon = 0
                	BEGIN
                		INSERT INTO AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, Permission, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID) 
						SELECT DISTINCT @DivisionID, ModuleID, GroupID, @DataID, @DataType, 1, GETDATE(), @UserID, GETDATE(), @UserID 
						FROM AT1401 
						INNER JOIN AT1409 ON AT1409.DivisionID =  AT1401.DivisionID 
						WHERE AT1401.DivisionID =  @DivisionID
                	END
                	IF @IsCommon = 1
                	BEGIN
                		INSERT INTO AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, Permission, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID) 
						SELECT DISTINCT AT1101.DivisionID, ModuleID, GroupID, @DataID, @DataType, 1, GETDATE(), @UserID, GETDATE(), @UserID 
						FROM AT1401 , AT1101
						INNER JOIN AT1409 ON AT1409.DivisionID =  AT1101.DivisionID 

                	END
                    
                END
        END
    ELSE
        BEGIN
            IF NOT EXISTS (SELECT DivisionID + ModuleID + DataID + DataType FROM AT1407 WHERE DivisionID + ModuleID + DataID + DataType = @DivisionID + @ModuleID + @DataID + @DataType)
                BEGIN
                	IF @IsCommon = 0
                	BEGIN
                		INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)  
						SELECT DISTINCT @DivisionID, @ModuleID, @DataID, @DataName, @DataType, GETDATE(), @UserID, GETDATE(), @UserID
                	END
                	IF @IsCommon = 1
                	BEGIN
                		INSERT INTO AT1407(DivisionID, ModuleID, DataID, DataName, DataType, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)  
						SELECT DISTINCT AT1101.DivisionID, @ModuleID, @DataID, @DataName, @DataType, GETDATE(), @UserID, GETDATE(), @UserID
						FROM AT1101 
                	END
                    
                END

            IF NOT EXISTS (SELECT DivisionID + ModuleID + DataID + DataType FROM AT1406 WHERE DivisionID + ModuleID + DataID + DataType = @DivisionID + @ModuleID + @DataID + @DataType)
                BEGIN
                	IF @IsCommon = 0
                	BEGIN
                		INSERT INTO AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, Permission, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)  
						SELECT DISTINCT @DivisionID, @ModuleID, GroupID, @DataID, @DataType, 1, GETDATE(), @UserID, GETDATE(), @UserID 
						FROM AT1401 
						INNER JOIN AT1409 ON AT1409.DivisionID =  AT1401.DivisionID 
						WHERE AT1401.DivisionID =  @DivisionID                		
                	END
                	IF @IsCommon = 1
                	BEGIN
                		INSERT INTO AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, Permission, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)  
						SELECT DISTINCT AT1101.DivisionID, @ModuleID, GroupID, @DataID, @DataType, 1, GETDATE(), @UserID, GETDATE(), @UserID 
						FROM AT1401 , AT1101
						INNER JOIN AT1409 ON AT1409.DivisionID =  AT1101.DivisionID               		
                	END
                    
                END
        END 

IF @Status='E' -- Neu trang thai la sua
BEGIN
	If @DataType<>'PE'
	BEGIN
		IF NOT EXISTS (SELECT DivisionID + DataID + DataType FROM AT1407 WHERE DivisionID + DataID + DataType = @DivisionID + @DataID + @DataType )
		BEGIN
			IF @IsCommon = 0
			BEGIN
				INSERT INTO AT1407(DivisionID,ModuleID,DataID,DataName,DataType,CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 
				SELECT DISTINCT @DivisionID,ModuleID,@DataID,@DataName, @DataType, getDate(), @UserID, getDate(), @UserID
				FROM AT1409 
				WHERE DivisionID = @DivisionID
			END
			IF @IsCommon = 1
			BEGIN
				INSERT INTO AT1407(DivisionID,ModuleID,DataID,DataName,DataType,CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 
				SELECT DISTINCT AT1101.DivisionID,ModuleID,@DataID,@DataName, @DataType, getDate(), @UserID, getDate(), @UserID
				FROM AT1409, AT1101
			END
			
		END
		
		IF NOT EXISTS (SELECT DivisionID + DataID + DataType FROM AT1406 WHERE DivisionID + DataID + DataType = @DivisionID + @DataID + @DataType )
		BEGIN
			IF @IsCommon = 0
			BEGIN
				INSERT INTO AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, Permission,CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 
				SELECT DISTINCT @DivisionID,ModuleID,GroupID,@DataID,@DataType, 1,getDate(),@UserID, GETDATE(), @UserID 
				FROM AT1401 
				INNER JOIN AT1409 ON AT1409.DivisionID =  AT1401.DivisionID 
				WHERE AT1401.DivisionID =  @DivisionID
			END
			IF @IsCommon = 1
			BEGIN
				INSERT INTO AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, Permission,CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 
				SELECT DISTINCT AT1101.DivisionID,ModuleID,GroupID,@DataID,@DataType, 1,getDate(),@UserID, GETDATE(), @UserID 
				FROM AT1401 , AT1101
				INNER JOIN AT1409 ON AT1409.DivisionID =  AT1101.DivisionID 
			END
			
		END
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT DivisionID + ModuleID + DataID + DataType FROM AT1407 WHERE DivisionID + ModuleID + DataID + DataType = @DivisionID + @ModuleID + @DataID + @DataType )
		BEGIN
			IF @IsCommon = 0
			BEGIN
				INSERT INTO AT1407(DivisionID,ModuleID,DataID,DataName,DataType,CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 
				SELECT DISTINCT @DivisionID,@ModuleID,@DataID,@DataName, @DataType, getDate(), @UserID, GETDATE(), @UserID
			END
			IF @IsCommon = 1
			BEGIN
				INSERT INTO AT1407(DivisionID,ModuleID,DataID,DataName,DataType,CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 
				SELECT DISTINCT AT1101.DivisionID,@ModuleID,@DataID,@DataName, @DataType, getDate(), @UserID, GETDATE(), @UserID
				FROM AT1101 
			END
			
		END
		
		IF NOT EXISTS (SELECT DivisionID + ModuleID + DataID + DataType FROM AT1406 WHERE DivisionID + ModuleID + DataID + DataType = @DivisionID + @ModuleID + @DataID + @DataType )
		BEGIN
			IF @IsCommon = 0
			BEGIN
				INSERT INTO AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, Permission,CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 
				SELECT DISTINCT @DivisionID,@ModuleID,GroupID,@DataID,@DataType, 1,getDate(),@UserID, GETDATE(), @UserID 
				FROM AT1401 
				INNER JOIN AT1409 ON AT1409.DivisionID =  AT1401.DivisionID 
				WHERE AT1401.DivisionID =  @DivisionID
			END
			IF @IsCommon = 1
			BEGIN
				INSERT INTO AT1406(DivisionID, ModuleID, GroupID, DataID, DataType, Permission,CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 
				SELECT DISTINCT AT1101.DivisionID,@ModuleID,GroupID,@DataID,@DataType, 1,getDate(),@UserID, GETDATE(), @UserID 
				FROM AT1401 , AT1101
				INNER JOIN AT1409 ON AT1409.DivisionID =  AT1101.DivisionID 
			END
			
		END
	END	
	UPDATE AT1407 SET DataName = @DataName, LastModifyDate=getDate(), LastModifyUserID=@UserID WHERE DataID=@DataID And DataType = @DataType and DivisionID = @DivisionID
END
    
IF @Status = 'D' --Neu trang thai la xoa
    BEGIN
    	IF @IsCommon = 0
    	BEGIN
    		DELETE AT1406 WHERE DataID = @DataID AND DataType = @DataType and DivisionID = @DivisionID
			DELETE AT1407 WHERE DataID = @DataID AND DataType = @DataType and DivisionID = @DivisionID    		
    	END
    	IF @IsCommon = 1
    	BEGIN
    		DELETE AT1406 WHERE DataID = @DataID AND DataType = @DataType 
			DELETE AT1407 WHERE DataID = @DataID AND DataType = @DataType 
    	END
        
    END 
    
SET NOCOUNT ON

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

