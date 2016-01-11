IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1020_KOYO]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1020_KOYO]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Create by Tiểu Mai on 23/11/2015: In hợp đồng theo chi tiết đơn hàng (Customize cho KOYO, CustomizeIndex = 52)



CREATE PROCEDURE [dbo].[AP1020_KOYO]
	@DivisionID nvarchar(50),
	@ContractID nvarchar(50)
	
AS
	DECLARE @sSQL NVARCHAR (MAX)
	SET @sSQL = '
	SELECT 
	AT1020.DivisionID,
	AT1020.ContractID,
	AT1020.VoucherTypeID,
	AT1020.ContractNo,
	AT1020.SignDate,
	AT1020.CurrencyID,
	AT1020.ContractName,
	AT1020.ObjectID,
	AT1202.ObjectName,
	AT1020.ContractType,
	AT1020.Amount,
	AT1020.ConRef01,
	AT1020.ConRef02,
	AT1020.ConRef03,
	AT1020.ConRef04,
	AT1020.ConRef05,
	AT1020.ConRef06,
	AT1020.ConRef07,
	AT1020.ConRef08,
	AT1020.ConRef09,
	AT1020.ConRef10,
	AT1020.Description,
	AT1021.ContractDetailID,
	AT1021.StepID,
	AT1021.StepName,
	AT1021.StepDays,
	AT1021.PaymentPercent,
	AT1021.PaymentAmount,
	AT1021.StepStatus,
	AT1021.CompleteDate,
	AT1021.PaymentDate,
	AT1021.CorrectDate,
	AT1021.PaymentStatus,
	AT1021.Notes, O02.SOrderID, O02.InventoryID,AT1302.InventoryName, O02.OrderQuantity, O02.SalePrice, O02.ConvertedAmount, O02.OriginalAmount, O02.VATOriginalAmount, O02.VATConvertedAmount,
	O02.VATPercent, O02.DiscountConvertedAmount, O02.DiscountPercent, O02.AdjustQuantity, O02.UnitID,AT1304.UnitName, O02.QuotationID  
	FROM AT1020
	INNER JOIN AT1021 ON AT1021.DivisionID = AT1020.DivisionID AND AT1021.ContractID = AT1020.ContractID
	INNER JOIN AT1202 ON AT1202.DivisionID = AT1020.DivisionID AND AT1202.ObjectID = AT1020.ObjectID
	INNER JOIN OT2002 O02 ON O02.DivisionID = AT1020.DivisionID AND AT1020.ContractID = O02.Ana01ID
	LEFT JOIN AT1302 ON AT1302.DivisionID = O02.DivisionID AND AT1302.InventoryID = O02.InventoryID
	LEFT JOIN AT1304 ON AT1304.DivisionID = AT1302.DivisionID AND AT1304.UnitID = AT1302.UnitID
	WHERE AT1020.DivisionID = '''+@DivisionID+''' AND AT1020.ContractID = '''+@ContractID+''' '
	EXEC (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
