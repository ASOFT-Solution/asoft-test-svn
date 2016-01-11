IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0065]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0065]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Load giao diện màn hình thiết lập dữ liệu nhập từ Excel - A00065
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/09/2011 by Nguyễn Bình Minh
---- 
---- Modified on 29/09/2011 by 
-- <Example>
---- AP0065 'AS', 9, 2011, 'ReceivableReceiptVoucher', '', 'vi-VN', 1
CREATE PROCEDURE [DBO].[AP0065]
(
	 @DivisionID AS NVARCHAR(50),
	 @TranMonth AS TINYINT,
	 @TranYear AS INT,
	 @ImportTransTypeID AS NVARCHAR(50), 
	 @ImportTemplateID AS NVARCHAR(50), 
	 @Language AS NVARCHAR(20),
	 @Mode AS TINYINT -- 0: Load dữ liệu cho Form, 1: Load dữ liệu cho lưới
) 
AS
DECLARE @sPeriod AS VARCHAR(10)
SET @sPeriod = REPLACE(STR(@TranMonth, 2) + '/' + STR(@TranYear, 4), ' ', '0')

SET NOCOUNT ON
IF @Mode = 0
BEGIN	
	IF ISNULL(@ImportTemplateID, '') = '' -- Tạo mới
	BEGIN
		SELECT	TOP 1
				ImportTransTypeID AS ImportTemplateID,
				CASE WHEN @Language  = 'vi-VN' THEN ImportTransTypeName ELSE ImportTransTypeNameEng END AS ImportTemplateName,
				'Data' AS DefaultSheet,	
				'A' AS AnchorCol,		10 AS StartRow,
				'C:\IMPORTS' AS DataFolder,		TemplateFileName AS DefaultFileName,
				0 AS Disabled
		FROM	A00065
		WHERE	ImportTransTypeID = @ImportTransTypeID
	END
	ELSE
	BEGIN
		SELECT	*
		FROM	A01065
		WHERE	ImportTemplateID = @ImportTemplateID
	END
END
IF @Mode = 1
BEGIN
	IF ISNULL(@ImportTemplateID, '') = '' -- Tạo mới
	BEGIN
		SELECT		OrderNum,
					ColID,				ColName,				
					CASE WHEN @Language = 'vi-VN' THEN
						CASE	WHEN ColType = 0 THEN N'Chuỗi'
								WHEN ColType = 1 THEN N'Số'
								WHEN ColType = 2 THEN N'Ngày tháng'
						END
					ELSE
						CASE	WHEN ColType = 0 THEN N'Text'
								WHEN ColType = 1 THEN N'Number'
								WHEN ColType = 2 THEN N'Date'
						END
					END AS ColTypeName,
					ColWidth,			ColLength,				
					'' AS CustomerCheckExpression,
					'' AS CustomerCheckMessage,	
					IsObligated AS IsObligated,
					IsObligated AS OIsObligated,
					DataCol,
					CONVERT(TINYINT, 0) AS Editable,
					CONVERT(TINYINT, 0) AS Disabled
		FROM		A00065
		WHERE		ImportTransTypeID = @ImportTransTypeID
		ORDER BY	OrderNum		
	END
	ELSE
	BEGIN
		SELECT		TLD.*,
					CASE WHEN @Language = 'vi-VN' THEN
						CASE	WHEN BTL.ColType = 0 THEN N'Chuỗi'
								WHEN BTL.ColType = 1 THEN N'Số'
								WHEN BTL.ColType = 2 THEN N'Ngày tháng'
						END
					ELSE
						CASE	WHEN BTL.ColType = 0 THEN N'Text'
								WHEN BTL.ColType = 1 THEN N'Number'
								WHEN BTL.ColType = 2 THEN N'Date'
						END
					END AS ColTypeName,
					BTL.ColLength,
					BTL.IsObligated AS OIsObligated,					
					TLD.IsObligated
		FROM		A01065 TL
		INNER JOIN	A01066 TLD
				ON	TLD.ImportTemplateID = TL.ImportTemplateID
		INNER JOIN	A00065 BTL
				ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID
		WHERE		TL.ImportTemplateID = @ImportTemplateID
		ORDER BY	TLD.OrderNum
	END	
END



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

