IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'CIP0058') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE CIP0058
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary> Kiểm tra khác đơn vị trước khi sửa mặt hàng, Trường hợp @DivisionID đúng với DivisionID đăng nhập thì cho sửa
-- <History>
---- Create on 08/02/2018 by Thảo Phương
---- Modified on 08/02/2018 by Thảo Phương
-- <Example>
CREATE PROCEDURE CIP0058 ( 
	@DivisionID varchar(50),--Trường hợp @DivisionID đúng với DivisionID đăng nhập thì cho sửa
	@InventoryID NVARCHAR(MAX),
	@UserID Varchar(50)) 
AS 
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	SET @sSQL = '
				DECLARE @Status TINYINT,
						@Message NVARCHAR(1000),
						@Params Varchar(100),
						@UpdateDivisionID Varchar(50), 
						@UpdateInventoryID  Varchar(50), 
						@UpdateIsCommon tinyint
				Declare @AT1302temp table (
								Status tinyint,
								MessageID varchar(100),
								Params varchar(4000))
				SELECT @UpdateDivisionID = DivisionID, @UpdateInventoryID = InventoryID, @UpdateIsCommon = Isnull(IsCommon, 0)
				FROM AT1302 WITH (NOLOCK) WHERE InventoryID = '''+@InventoryID+'''
				
				IF (@UpdateDivisionID !='''+ @InventoryID+''' and @UpdateIsCommon != 1) --Kiểm tra khac DivisionID và không dùng chung
							Begin
								SET @Message = ''00ML000050'' 
								SET	@Status = 2
								SET @Params = @UpdateInventoryID
							End 
			
				INSERT INTO @AT1302temp (Status, MessageID, Params) SELECT @Status as Status, @Message as MessageID, @Params as Params 			
				SELECT Status, MessageID,Params From  @AT1302temp where Params is not null'
	EXEC (@sSQL)
END