IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2518]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2518]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiểm tra bút toán tạm ứng đã sử dụng chưa
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 26/11/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 26/11/2012 by 
-- <Example>
---- 
CREATE PROCEDURE HP2518
( 
		@DivisionID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS int
) 
AS 
Declare @Status as tinyint,
		@Message as nvarchar(250)
		
SET @Status = 0
SET @Message = ''

	IF EXISTS (SELECT TOP 1 1 FROM HT3400 
	WHERE DivisionID = @DivisionID And TranMonth+TranYear*12 = @TranMonth+@TranYear*12 And PayRollMethodID In (Select PayrollMethodID From HT5006 
						Where DivisionID = @DivisionID And SubID In (Select SubID From HT0005 Where SourceTableName = 'HT2500' And IsTranfer=1 And DivisionID = @DivisionID)
					)
	)
		Begin
			Set @Status =1
			Set @Message ='HFML000439'
			GOTO EndMess
		End
	IF NOT EXISTS ( SELECT TOP 1 1 AdvanceAccountID FROM HT0000 WHERE DivisionID = @DivisionID)
		Begin
			Set @Status = 2
			Set @Message ='HFML000440'
			GOTO EndMess
		End



EndMess:
Select @Status as Status, @Message as Message

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

