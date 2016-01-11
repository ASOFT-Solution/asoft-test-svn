IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3060]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3060]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by: Bảo Anh, date:  21/01/2014
--- Lọc ra danh sách khách hàng đến đợt thanh toán (Sinolife)
--- Modified on 08/10/2015 by Tieu Mai: Sửa tiền hạch toán theo thiết lập đơn vị-chi nhánh

--- EXEC AP3060 'AS','01/20/2014'

CREATE PROCEDURE [dbo].[AP3060] 
				@DivisionID nvarchar(50),
				@LogInDate datetime
AS
Declare @BankAccountNo as nvarchar(50)
SELECT @BankAccountNo = BankAccountNo
FROM AT1016
WHERE DivisionID = @DivisionID
AND BankAccountID = (Select top 1 BankAccountID From AT1101 Where DivisionID = @DivisionID)

SELECT	T20.ContractNo, T20.ContractName, T20.SignDate, Isnull(T21.TransferObjectID,T20.ObjectID) as ObjectID,
		Isnull(T02.ObjectName,AT1202.ObjectName) as ObjectName, T20.CurrencyID, T20.[Description],
		T21.StepID, T21.StepName, T21.PaymentPercent, T21.PaymentAmount, T21.CompleteDate, T21.PaymentDate, T21.Paymented,
		(T21.PaymentAmount - Isnull(T21.Paymented,0)) as RemainAmount,
		@BankAccountNo as BankAccountNo

FROM AT1021 T21
INNER JOIN AT1020 T20 On T20.DivisionID = T21.DivisionID And T20.ContractID = T21.ContractID
LEFT JOIN AT1202 On T20.DivisionID = AT1202.DivisionID And T20.ObjectID = AT1202.ObjectID
LEFT JOIN AT1202 T02 On T21.DivisionID = T02.DivisionID And T21.TransferObjectID = T02.ObjectID

WHERE T21.DivisionID = @DivisionID AND T20.ContractType = 1
AND T21.PaymentDate <= @LogInDate ---AND Isnull(T21.StepStatus,0) <> 0
AND (T21.PaymentAmount - Isnull(T21.Paymented,0)) > 0

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

