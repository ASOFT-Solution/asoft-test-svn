IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OOP2114]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OOP2114]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
-- Kiểm tra trước khi xóa/sửa danh sách checklist công việc
-- Nếu mã loại hình chưa được sử dụng thì cho phép xóa (Xóa ngầm) ngược lại thì báo message ID đã sử dụng không được phép xóa
-- <Param>
-- <Return>
-- <Reference>
-- <History>
-- Created by: Phan thanh hoàng vũ, Date: 19/10/2017
-- <Example> EXEC OOP2114 'KY', '', '', 'OOT2111', 0,NULL

CREATE PROCEDURE OOP2114 ( 
	@DivisionID varchar(50),--Trường hợp @DivisionID đúng với DivisionID đăng nhập thì cho xóa
	@APK NVARCHAR(MAX),
	@APKList NVARCHAR(MAX),
	@TableID NVARCHAR(MAX),	--OOT2111
	@Mode tinyint,			--0: Sửa, 1: Xóa
	@UserID Varchar(50)) 
AS 
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	IF @Mode = 1 --Kiểm tra và xóa
	BEGIN
		SET @sSQL = '
				DECLARE @Status TINYINT,
						@Message NVARCHAR(1000),
						@Cur CURSOR,
						@DelAPK VARCHAR(50),
						@DelDivisionID VARCHAR(50),
						@DelWorkID NVARCHAR(250)
				Declare @OOT2111temp table (
						Status tinyint,
						MessageID varchar(100),
						Params Nvarchar(4000))
				SET @Status = 0
				SET @Message = ''''
				Insert into @OOT2111temp (	Status, MessageID, Params) 
											Select 2 as Status, ''00ML000050'' as MessageID, Null as Params
											
				SET @Cur = CURSOR SCROLL KEYSET FOR
				SELECT D.APK, M.DivisionID, M.WorkID 
				FROM OOT2110 M WITH (NOLOCK) Inner join OOT2111 D WITH (NOLOCK) on M.APK = D.APKMaster and M.DeleteFlg = D.DeleteFlg
				WHERE cast(D.APK as Varchar(50)) IN ('''+@APKList+''') and D.DeleteFlg = 0
				OPEN @Cur
				FETCH NEXT FROM @Cur INTO @DelAPK, @DelDivisionID, @DelWorkID
				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF (@DelDivisionID != '''+@DivisionID+''')
							update @OOT2111temp set Params = ISNULL(Params,'''') + @DelWorkID+'','' where MessageID = ''00ML000050''
					ELSE 
						Begin
							--Xóa checklist công việc
							Update OOT2111 Set DeleteFlg = 1 WHERE cast(APK as Varchar(50)) = @DelAPK	
						End					
					FETCH NEXT FROM @Cur INTO @DelAPK, @DelDivisionID, @DelWorkID
					Set @Status = 0
				END
				CLOSE @Cur
				SELECT Status, MessageID, LEFT(Params,LEN(Params) - 1) AS Params From  @OOT2111temp where Params is not null'
			EXEC (@sSQL)
	END
	ELSE IF @Mode = 0 --Kiểm tra trước khi sửa
	BEGIN
		SET @sSQL = '
				DECLARE @Status TINYINT,
						@Message NVARCHAR(1000),
						@Params Varchar(100),
						@DelDivisionID Varchar(50), 
						@DelWorkID NVarchar(250)
				Declare @OOT2111temp table (
								Status tinyint,
								MessageID varchar(100),
								Params varchar(4000))
				SELECT @DelDivisionID = DivisionID, @DelWorkID = WorkID
				FROM OOT2110 WITH (NOLOCK) WHERE cast (APK as Varchar(50)) = N'''+@APK+'''			
				IF (@DelDivisionID !='''+ @DivisionID+''') --Kiểm tra khac DivisionID và không dùng chung
							Begin
								SET @Message = ''00ML000050'' 
								SET	@Status = 2
								SET @Params = @DelWorkID
							End 
				INSERT INTO @OOT2111temp (	Status, MessageID, Params) SELECT @Status as Status, @Message as MessageID, @Params as Params 			
				SELECT Status, MessageID,Params From  @OOT2111temp where Params is not null'
			EXEC (@sSQL)
	END
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
