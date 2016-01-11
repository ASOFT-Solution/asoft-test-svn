IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP9011]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP9011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bao Anh	Date: 26/09/2012
---- Purpose: Bo duyet tam thu chi
-- <Example> AP9011 'AS','H1/01/2012/0001','T22'
 
CREATE PROCEDURE AP9011
		@DivisionID as nvarchar(50), 
		@VoucherID as nvarchar(50), 
		@TransactionTypeID as nvarchar(50)
AS

	Delete AT9000
	Where DivisionID =@DivisionID and VoucherID=@VoucherID and TransactionTypeID=@TransactionTypeID

	Set nocount on
	Update AT9010 set Status = 0
	Where DivisionID =@DivisionID and VoucherID=@VoucherID and TransactionTypeID=@TransactionTypeID
	Set nocount off
