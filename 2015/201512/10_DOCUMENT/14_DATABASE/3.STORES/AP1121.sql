IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1121]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1121]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Mai Duyen Date: 04/12/2013
---- Purpose : Duyet cac nhan vien dong cap co quan he gioi thieu de insert vao bang AT1120 (Sinolife)
---- Modify on 01/10/2014 by Bảo Anh: Sửa lỗi duyệt thiếu người giới thiệu (bổ sung cursor)
---- AP1121 'AS','TG',2


CREATE PROCEDURE [dbo].[AP1121]
	@DivisionID nvarchar(50),
	@ObjectID nvarchar(50),
	@LevelNo int ,
	@OrderNo int --STT
AS

BEGIN
    Declare	@ObjectID_TAM nvarchar(50),  -- NV co quan he gioi thieu voi @ObjectID
			@AccAmount decimal(28,8),
			@OrderNo_TAM int,  -- STT
			@ManagerID nvarchar(50),
			@Cur cursor
		
	SET @Cur = CURSOR SCROLL KEYSET FOR
	SELECT ObjectID, AccAmount, ManagerID  FROM AT1202 WHERE DivisionID = @DivisionID And MiddleID = @ObjectID AND LevelNo = @LevelNo And ObjectTypeID = 'NV'
		
    OPEN @Cur
	FETCH NEXT FROM @Cur INTO @ObjectID_TAM, @AccAmount, @ManagerID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF Isnull(@ObjectID_TAM,'') <> ''
			INSERT INTO AT1120 (DivisionID, ObjectID, LevelNo, AccAmount,ManagerID,OrderNo)
					VALUES (@DivisionID, @ObjectID_TAM, @LevelNo, @AccAmount,@ManagerID,@OrderNo)
			
		IF Isnull(@ObjectID_TAM,'') <> ''
			BEGIN
				Set @OrderNo_TAM =@OrderNo +1
				EXEC AP1121 @DivisionID, @ObjectID_TAM, @LevelNo , @OrderNo_TAM
			END
			
		FETCH NEXT FROM @Cur INTO @ObjectID_TAM, @AccAmount, @ManagerID
	END
END

CLOSE @Cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON