IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ0261]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AQ0261]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by: Bao Anh , date : 03/12/2012
--- Purpose: Trả ra các phiếu mua hàng với số tiền còn lại sau khi kế thừa lập phiếu chi
--- Modify on 20/03/2013 by Bao Anh: Bo sung DebitAccountID de len dung so tien con lai khi TK cong no va thue khac nhau
--- Modify on 28/05/2013 by Khanh Van: Bo sung transactionTypeID =T99
--- Modify on 06/08/2013 by Khanh Van: Bo sung tru hang mua tra lai

CREATE VIEW [dbo].[AQ0261] as
Select AT9000.DivisionID, AT9000.VoucherID, CreditAccountID,
(isnull(OriginalAmount, 0) - isnull(OriginalAmountPC,0)) as EndOriginalAmount,
(isnull(ConvertedAmount, 0) - isnull(ConvertedAmountPC,0)) as EndConvertedAmount 
FROM(
(Select 
	DivisionID, TranMonth, TranYear, VoucherID, CreditAccountID,
	isnull(Sum(AT9000.OriginalAmount), 0)  as OriginalAmount,
	isnull(Sum(AT9000.ConvertedAmount), 0)  as ConvertedAmount
From AT9000
Where TransactionTypeID in ('T03','T13')
Group by DivisionID, TranMonth, TranYear, VoucherID, CreditAccountID) AT9000

Left join (
	Select DivisionID, TVoucherID, DebitAccountID, sum(OriginalAmount) As OriginalAmountPC, sum(ConvertedAmount) As ConvertedAmountPC
	From AT9000
	Where TransactionTypeID In ('T02','T22','T99', 'T25', 'T35') 
	Group by DivisionID, TVoucherID, DebitAccountID
	) K  on AT9000.DivisionID = K.DivisionID and AT9000.VoucherID = K.TVoucherID and AT9000.CreditAccountID = K.DebitAccountID)