IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1120]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1120]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Mai Duyen	Date: 05/12/2013
---- Purpose : Tra cuu so do quan he (Sinolife)
---- AP1120 'AS','GD',1
CREATE PROCEDURE [dbo].[AP1120]
	@DivisionID nvarchar(50),
	@ObjectID nvarchar(50),
	@LevelNo int
AS

DECLARE @SQL nvarchar(4000),
		@ObjectID_TAM nvarchar(50),
		@Cur as Cursor
		
		--1. Xoa bang AT1120 
		DELETE AT1120 WHERE DivisionID = @DivisionID
		
		IF Exists( Select Top 1 1 From AT1202 Where ObjectTypeID ='NV' AND ObjectID =@ObjectID AND LevelNo =@LevelNo) 
			BEGIN
					
				--2. Insert nhan vien can tra cuu vao bang AT1120
				INSERT INTO AT1120 (DivisionID, ObjectID, LevelNo, AccAmount,ManagerID, OrderNo)
				Select DivisionID, ObjectID, LevelNo, AccAmount ,ManagerID,1 From AT1202 Where ObjectTypeID ='NV' AND ObjectID =@ObjectID AND LevelNo =@LevelNo
				
				--3.Duyet cac nhan vien dong cap de insert vao bang AT1120
				EXEC AP1121 @DivisionID,@ObjectID,@LevelNo,2
				
				--4. Duyet cap con cua cac nhan vien dong cap de insert vao bang AT1120
				SET @Cur = CURSOR SCROLL KEYSET FOR
				SELECT ObjectID from AT1120 WHERE DivisionID = @DivisionID and LevelNo = @LevelNo ORDER BY OrderNo -- Duyet cac nhan vien dong cap
				OPEN @Cur
				FETCH NEXT FROM @Cur INTO @ObjectID_TAM
				WHILE @@FETCH_STATUS = 0
				BEGIN			
					IF ISNULL(@ObjectID_TAM,'') <> ''
						EXEC AP1122 @DivisionID,@ObjectID_TAM 
					
					FETCH NEXT FROM @Cur INTO @ObjectID_TAM	
				END
				CLOSE @Cur	
			END
			
			--5. Select du lieu
				Set @SQL= 'SELECT AT1120.ObjectID, T1.ObjectName as ObjectName ,AT1120.ManagerID , T2.ObjectName as ManagerName,
						   AT1120.LevelNo, AT0101.LevelName,  T1.AccAmount as AccAmount , AT1120.OrderNo
						   FROM AT1120
						   LEFT JOIN AT1202 T1 ON AT1120.DivisionID = T1.DivisionID AND AT1120.ObjectID = T1.ObjectID
						   LEFT JOIN AT1202 T2 ON AT1120.DivisionID = T2.DivisionID AND AT1120.ManagerID = T2.ObjectID
						   LEFT JOIN AT0101 ON  AT0101.LevelNo = AT1120.LevelNo
						   ORDER BY  AT1120.LevelNo DESC, OrderNo ASC'
			EXEC (@SQL)
			
			
			
			
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


