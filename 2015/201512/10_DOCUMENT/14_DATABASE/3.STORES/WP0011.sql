IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0011]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WP0011]
(
	@DivisionID nvarchar(50)							
	, @TransactionID as nvarchar(50) 
	, @Quantity as decimal(28,8)
	, @ConnID nvarchar(50)
) 
AS
Declare @Status as tinyint, 
		@MaxQuantity decimal(28,8),
		@sSQL NVARCHAR(MAX),
		@Table NVARCHAR(MAX),
		@Mess as nvarchar(100)
	
SET @Mess = ''
SET @Status = 0
SET @ConnID = ISNULL(@ConnID, '')	

Set @Table = 'Select @rowcount =  ActualQuantity from AV3208'+ @ConnID+' 
Where TransactionID = '''+@TransactionID+'''
And DivisionID = '''+@DivisionID+''' '
  
EXEC sp_executesql @Table, N'@rowcount int output', @MaxQuantity output;
-- Nếu số lượng (kế thừa) nhỏ hơn số lượng (điều chỉnh trên grid) 
if(@MaxQuantity < @Quantity)
Begin
	Set @Status =1
	Set  @Mess= N'WFML000150'
	GOTO RETURN_VALUES	 
End

---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status, @MaxQuantity as ActualQuantity , @Mess as Message

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

