IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1022]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1022]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Create by Bảo Anh	Date: 01/12/2013
---- Purpose : In các mẫu báo cáo liên quan hợp đồng
---- Update by Mai Duyen, 11/12/2013: Bo sung them  mau bao cao AR1020_A, AR1020_B
---- Modified by Tiểu Mai on 23/11/2015: Bổ sung in hợp đồng theo chi tiết đơn hàng (Customize cho KOYO, CustomizeIndex = 52)
---- AP1022 'AS','','AR1020',''
---- AP1022 'LG','CT20120000000006','AR1020b',''


CREATE PROCEDURE [dbo].[AP1022]
	@DivisionID nvarchar(50),
	@ContractID nvarchar(50),
	@ReportID nvarchar(8),
	@Orderby varchar(4000) = ''
	
AS
IF ISNULL((SELECT TOP 1 CustomerName FROM CustomerIndex),-1) <> 40 ---- Customize cho LONG GIANG
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	IF @ReportID = 'AR1020_A' --- mẫu hợp đồng chuyển nhượng của Sinolife
		EXEC  AP1023 @DivisionID,@ContractID
	ELSE IF @ReportID = 'AR1020_B' --- báo cáo bảng thanh toán hàng tháng của Sinolife
			EXEC AP1024 @DivisionID,@ContractID
	ELSE IF ISNULL((SELECT TOP 1 CustomerName FROM CustomerIndex),-1) = 52  --- In hợp đồng của KOYO
			EXEC AP1020_KOYO @DivisionID,@ContractID
	ELSE 
	BEGIN
		SET @SQL = 'SELECT * FROM AV1020
				WHERE DivisionID = ''' + @DivisionID + ''' AND ContractID = ''' + @ContractID + ''''	
		EXEC(@SQL)					
	END
END
ELSE
BEGIN
	DECLARE	@FromDate DATETIME,
			@ToDate DATETIME,
			@All TINYINT,
			@ContractType TINYINT,
			@DisplayAll TINYINT
	SELECT @FromDate = FromDate, @ToDate = ToDate, @All = [All], @ContractType = ContractType, @DisplayAll = DisPlayAll FROM AT1020LONGGIANG
	
	SELECT A20.SignDate, A20.ContractNo, A20.[Description], A20.Amount, A20.ConvertedAmount, A20.ContractName,
		A20.ConRef01, A20.ConRef02, A20.ConRef03, A20.ConRef04, A20.ConRef05, A20.ConRef06,
       A20.ConRef07, A20.ConRef08, A20.ConRef09, A20.ConRef10, A20.ObjectID, A021.ObjectName,
       A90.VoucherDate, A90.VoucherNo, A90.TDescription, 
       A90.ConvertedAmount TConvertedAmount, A90.ObjectID TObjectID, A02.ObjectName TObjectName
	FROM AT1020 A20
	LEFT JOIN AT1202 A021 ON A021.DivisionID = A20.DivisionID AND A021.ObjectID = A20.ObjectID
	LEFT JOIN AT9000 A90 ON A90.DivisionID = A20.DivisionID AND A90.Ana02ID = A20.ContractNo
	LEFT JOIN AT1202 A02 ON A02.DivisionID = A90.DivisionID AND A02.ObjectID = A90.ObjectID
	WHERE A20.DivisionID = @DivisionID
	AND (@All = 1 OR (CONVERT(VARCHAR, A20.SignDate, 112) BETWEEN CONVERT(VARCHAR, @FromDate,112) AND CONVERT(VARCHAR, @ToDate,112)))
	AND (A20.ContractType = @ContractType OR @ContractType = 2)
END
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
