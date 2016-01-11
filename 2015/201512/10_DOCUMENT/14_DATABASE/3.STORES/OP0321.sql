IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0321]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0321]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 01/09/2014
---- Purpose : Liệt kê các nhân viên cần cập nhật người quản lý khi người giới thiệu lên cấp (Sinolife)
---- Modify on 18/09/2014 by Bảo Anh: Chỉ lấy các người được giới thiệu nhưng đồng cấp
---- OP0321 'SNL','KH0001'

CREATE PROCEDURE [dbo].[OP0321]
	@DivisionID nvarchar(50),
	@SalesmanID nvarchar(50)
		
AS

BEGIN
	Declare @ObjectID nvarchar(50),
			@LevelNo int,
			@Cur cursor
	
	SET @Cur = CURSOR SCROLL KEYSET FOR
    SELECT ObjectID, LevelNo FROM AT1202 WHERE DivisionID = @DivisionID AND ObjectTypeID = 'NV' AND Isnull(MiddleID,'') = @SalesmanID
		AND LevelNo = (Select LevelNo From AT1202 Where DivisionID = @DivisionID AND ObjectTypeID = 'NV' AND ObjectID = @SalesmanID)
    
    OPEN @Cur
	FETCH NEXT FROM @Cur INTO @ObjectID, @LevelNo
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF Isnull(@ObjectID,'') <> ''
		BEGIN
			INSERT INTO OT0113 (DivisionID, ObjectID, LevelNo)
			VALUES (@DivisionID, @ObjectID, @LevelNo)
			
			SET @SalesmanID = @ObjectID
			EXEC OP0321 @DivisionID, @SalesmanID
		END	
		FETCH NEXT FROM @Cur INTO @ObjectID, @LevelNo
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

