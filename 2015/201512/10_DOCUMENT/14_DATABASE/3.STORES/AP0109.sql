IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0109]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0109]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Creater by Bảo Anh	Date: 03/01/2016
--- Purpose: Cập nhật mã phân tích hợp đồng cho đơn hàng bán

CREATE PROCEDURE [dbo].[AP0109]  
				@DivisionID nvarchar(50),
				@ContractNo nvarchar(50),
				@SOrderID nvarchar (50),
				@TransactionID nvarchar (50)
AS

Declare @ContractAnaTypeID AS NVARCHAR(50)
	
SET @ContractAnaTypeID = ISNULL((SELECT TOP 1 SalesContractAnaTypeID FROM AT0000 WHERE DefDivisionID = @DivisionID), 'A03')

IF @ContractAnaTypeID = 'A01'
	UPDATE OT2002 SET Ana01ID = @ContractNo WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID and TransactionID = @TransactionID
ELSE IF @ContractAnaTypeID = 'A02'
	UPDATE OT2002 SET Ana02ID = @ContractNo WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID and TransactionID = @TransactionID
ELSE IF @ContractAnaTypeID = 'A03'
	UPDATE OT2002 SET Ana03ID = @ContractNo WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID and TransactionID = @TransactionID
ELSE IF @ContractAnaTypeID = 'A04'
	UPDATE OT2002 SET Ana04ID = @ContractNo WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID and TransactionID = @TransactionID
ELSE IF @ContractAnaTypeID = 'A05'
	UPDATE OT2002 SET Ana05ID = @ContractNo WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID and TransactionID = @TransactionID
