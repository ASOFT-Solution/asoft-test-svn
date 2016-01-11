IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0127]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0127]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 10/02/2014
---- Purpose : Giáng cấp nhân viên không đạt doanh số (Sinolife)
---- OP0127 'AS','TG3',2

CREATE PROCEDURE [dbo].[OP0127]
	@DivisionID nvarchar(50),
	@EmployeeID nvarchar(50),
	@LevelNo int
	
AS

DECLARE @NewLevelNo int,
		@NewManagerID nvarchar(50)

SET @NewLevelNo = @LevelNo - 1

IF @LevelNo = (Select LevelCounts from AT0000 Where DefDivisionID = @DivisionID) - 1	--- nếu là cấp cao nhất
BEGIN
	--- Set người quản lý chính là người giới thiệu
	SELECT @NewManagerID = MiddleID from AT1202 Where DivisionID = @DivisionID AND ObjectID = @EmployeeID
	
	--- cập nhật lại cấp và người giới thiệu
	UPDATE AT1202 Set LevelNo = @NewLevelNo, ManagerID = @NewManagerID
	WHERE DivisionID = @DivisionID AND ObjectID = @EmployeeID
	
	--- cập nhật lại người quản lý cho các nhân viên cấp dưới của nhân viên bị giáng cấp
	UPDATE AT1202 Set ManagerID = @NewManagerID
	WHERE DivisionID = @DivisionID AND ObjectID in (Select ObjectID From AT1202 Where DivisionID = @DivisionID And ManagerID = @EmployeeID)	
END

ELSE --- không phải cấp cao nhất
BEGIN
	--- cập nhật lại cấp
	UPDATE AT1202 Set LevelNo = @NewLevelNo
	WHERE DivisionID = @DivisionID AND ObjectID = @EmployeeID
	
	--- cập nhật lại người quản lý cho các nhân viên cấp dưới của nhân viên bị giáng cấp
	UPDATE AT1202 Set ManagerID = (Select ManagerID From AT1202 Where DivisionID = @DivisionID And ObjectID = @EmployeeID)
	WHERE DivisionID = @DivisionID AND ObjectID in (Select ObjectID From AT1202 Where DivisionID = @DivisionID And ManagerID = @EmployeeID)
END