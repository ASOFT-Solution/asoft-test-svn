IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ0260]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AQ0260]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by: Bao Anh , date : 03/12/2012
--- Purpose: Trả ra các phiếu bán hàng với số tiền còn lại sau khi kế thừa lập phiếu thu
--- Modify on 20/03/2013 by Bao Anh: Bo sung DebitAccountID de len dung so tien con lai khi TK cong no va thue khac nhau
--- Modify on 28/05/2013 by Khanh Van: Bo sung transactionTypeID =T99
--- Modify on 06/08/2013 by Khanh Van: Bo sung tru hang ban tra lai
CREATE VIEW [dbo].[AQ0260] as
Select AT9000.DivisionID, AT9000.VoucherID, DebitAccountID,
(isnull(OriginalAmount, 0) - isnull(OriginalAmountPT,0)) as EndOriginalAmount,
(isnull(ConvertedAmount, 0) - isnull(ConvertedAmountPT,0)) as EndConvertedAmount
FROM(
(Select 
	DivisionID, TranMonth, TranYear, VoucherID, DebitAccountID,
	isnull(Sum(AT9000.OriginalAmount), 0)  as OriginalAmount,
	isnull(Sum(AT9000.ConvertedAmount), 0)  as ConvertedAmount
From AT9000
Where TransactionTypeID in ('T04','T14')
Group by DivisionID, TranMonth, TranYear, VoucherID, DebitAccountID) AT9000

Left join (
	Select DivisionID, TVoucherID, CreditAccountID, sum(OriginalAmount) As OriginalAmountPT, sum(ConvertedAmount) As ConvertedAmountPT
	From AT9000
	Where TransactionTypeID In ('T01','T21','T99','T24','T34')
	Group by DivisionID, TVoucherID, CreditAccountID
	) K  on AT9000.DivisionID = K.DivisionID and AT9000.VoucherID = K.TVoucherID and AT9000.DebitAccountID = K.CreditAccountID)
	