IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1004]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1004]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Lấy dữ liệu loại tiền bao gồm cả tỷ giá, số lẻ
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 07/09/2011 by Nguyễn Bình Minh
---- 
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh
-- <Example>
---- 
CREATE VIEW AV1004
AS
SELECT		CUR.DivisionID, CUR.CurrencyID, CUR.CurrencyName, CUR.ExchangeRate, CUR.Operator,
			CASE WHEN CUR.CurrencyID = QD.BaseCurrencyID THEN QD.ConvertedDecimals ELSE CUR.ExchangeRateDecimal END AS ExchangeRateDecimal,
			CASE WHEN CUR.CurrencyID = QD.BaseCurrencyID THEN QD.ConvertedDecimals ELSE CUR.ExchangeRateDecimal END AS OriginalDecimal,
			QD.ConvertedDecimals,
			CUR.DecimalName, CUR.UnitName, CUR.IsCommon,
			QD.BaseCurrencyID, QD.QuantityDecimals, QD.UnitCostDecimals
FROM		AT1004 CUR
LEFT JOIN	AT1101 QD
		ON	QD.DivisionID = CUR.DivisionID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

