IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1122]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1122]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




---- Create by Mai Duyen Date: 04/12/2013
---- Purpose : Duyet cac nhan vien cap dưới de Insert vào bảng AT1120 (Sinolife)
---- AP1122 'AS','GD2',1

CREATE PROCEDURE [dbo].[AP1122]
	@DivisionID nvarchar(50),
	@ObjectID nvarchar(50)
	
	
AS

BEGIN
    Declare @ObjectID_TAM nvarchar(50),
			@LevelNo_Ins int,
			@AccAmount_Ins decimal (28,8),
			@ObjectID_Ins nvarchar(50),
			@ManagerID_Ins nvarchar(50),
			@Cur AS Cursor ,
			@CurIns AS Cursor ,
			@OrderNo int  -- STT
		
	If  EXISTS  ( SELECT Top 1 1 FROM AT1202 WHERE  DivisionID = @DivisionID  And ObjectTypeID = 'NV' AND ManagerID = @ObjectID ) 		
		BEGIN
			
			
			
			--Insert cac nhan vien cap duoi
			Set @OrderNo = 1
			--SELECT @LevelNo = LevelNo, 	@AccAmount = AccAmount FROM AT1202 WHERE  DivisionID = @DivisionID  And ObjectTypeID = 'NV' AND ManagerID = @ObjectID 
			--INSERT INTO AT1120 (DivisionID, ObjectID, LevelNo, AccAmount, OrderNo)
			--VALUES	 (@DivisionID, @ObjectID,  @LevelNo, @AccAmount, @OrderNo)
			
			SET @CurIns = CURSOR SCROLL KEYSET FOR   
			SELECT  ObjectID,LevelNo, AccAmount ,ManagerID FROM AT1202 WHERE  DivisionID = @DivisionID  And ObjectTypeID = 'NV' AND ManagerID = @ObjectID 	 
			OPEN @CurIns					 
			FETCH NEXT FROM @CurIns INTO @ObjectID_Ins ,@LevelNo_Ins ,@AccAmount_Ins ,@ManagerID_Ins
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO AT1120 (DivisionID, ObjectID, LevelNo, AccAmount, ManagerID, OrderNo)
				VALUES	 (@DivisionID, @ObjectID_Ins,  @LevelNo_Ins, @AccAmount_Ins,@ManagerID_Ins, @OrderNo)
				Set @OrderNo = @OrderNo  +1
			FETCH NEXT FROM @CurIns INTO @ObjectID_Ins ,@LevelNo_Ins ,@AccAmount_Ins ,@ManagerID_Ins
			END
			CLOSE @CurIns		
			
			--Duyet cursor de goi de quy cac nhan vien cap duoi
			SET @Cur = CURSOR SCROLL KEYSET FOR   
			SELECT ObjectID FROM AT1202 WHERE  DivisionID = @DivisionID  And ObjectTypeID = 'NV' AND ManagerID = @ObjectID 
			OPEN @Cur
			FETCH NEXT FROM @Cur INTO @ObjectID_TAM
			WHILE @@FETCH_STATUS = 0
			BEGIN
			
				IF ISNULL(@ObjectID_TAM,'') <> ''
					EXEC AP1122 @DivisionID ,@ObjectID_TAM
				
				FETCH NEXT FROM @Cur INTO @ObjectID_TAM
				
			END
			CLOSE @Cur		 
		END
		
END



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

