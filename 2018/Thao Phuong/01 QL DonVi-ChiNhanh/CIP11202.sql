IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'CIP11202') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE CIP11202
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary> Kiểm tra trước khi xoá (xem DivisionID có đang được sử dụng hay không), 
			-- + Trường hợp @DivisionID đúng với DivisionID đăng nhập thì không cho xóa
			-- + Trường hợp @DivisionID có ParentDivisionID != NULL thì không cho xoá
-- <History>
---- Create on 25/01/2018 by Thảo Phương
---- Modified on 25/01/2018 by Thảo Phương
-- <Example> EXEC CIP11202 'AS', '', NULL
CREATE PROCEDURE CIP11202
( 
	@DivisionID varchar(50),--Trường hợp @DivisionID đúng với DivisionID đăng nhập và có ParentDivisionID != NULL thì không cho xóa
	@DivisionIDList NVARCHAR(MAX),
	@UserID Varchar(50)
)
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	BEGIN
		SET @sSQL = '
				DECLARE @Status TINYINT,
						@Message NVARCHAR(1000),
						@Cur CURSOR,
						@DelAPK Varchar(50),
						@DelDivisionID VARCHAR(50)

				Declare @AT1101temp table (
						Status tinyint,
						MessageID varchar(100),
						Params varchar(4000))
				SET @Status = 0
				SET @Message = ''''
				Insert into @AT1101temp (	Status, MessageID, Params) 
											Select 2 as Status, ''CFML000152'' as MessageID, Null as Params
											union all
											Select 2 as Status, ''00ML000112'' as MessageID, Null as Params
				SET @Cur = CURSOR SCROLL KEYSET FOR
				SELECT APK, DivisionID
				FROM AT1101 WITH (NOLOCK) WHERE DivisionID IN ('''+@DivisionIDList+''')
				OPEN @Cur
				FETCH NEXT FROM @Cur INTO @DelAPK, @DelDivisionID
				WHILE @@FETCH_STATUS = 0
				BEGIN

					IF (@DelDivisionID = '''+@DivisionID+''')
							update @AT1101temp set Params = ISNULL(Params,'''') where MessageID = ''CFML000152''
					ELSE IF (Select isnull(ParentDivisionID,1) from AT1101 where DivisionID = ''@DelDivisionID'')!=1
							update @AT1101temp set Params = ISNULL(Params,'''') where MessageID = ''00ML000112''
					ELSE 
						Begin
							DELETE FROM AT1101 WHERE APK = @DelAPK	
						End
					FETCH NEXT FROM @Cur INTO @DelAPK, @DelDivisionID
					Set @Status = 0
				END
				CLOSE @Cur
				SELECT Status, MessageID, LEFT(Params,LEN(Params) - 1) AS Params From  @AT1101temp where Params is not null'
			EXEC (@sSQL)
	END
END