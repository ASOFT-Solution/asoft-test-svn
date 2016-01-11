IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ3123]') AND  OBJECTPROPERTY(ID, N'IsView') = 1)			
DROP VIEW [DBO].[AQ3123]
GO
/****** Object:  View [dbo].[AQ3123]    Script Date: 12/21/2010 13:57:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Create by: Dang Le Bao Quynh; Date:01/07/2009
--Purpose: In bao cao ban hang theo ma phan tich sap xep theo tieu thuc thanh tien
CREATE VIEW [dbo].[AQ3123] 
			 as SELECT *,
		0 As InvSumOfQuantity,
		0 As GrpSumOfQuantity,
		(Select sum(isnull(ConvertedAmount,0)) From AV3121 A1 Where A1.Group1ID = AV3121.Group1ID And A1.InvID = AV3121.InvID) As InvSumOfConvertedAmount,
		(Select sum(isnull(ConvertedAmount,0)) From AV3121 A1 Where A1.Group1ID = AV3121.Group1ID) As GrpSumOfConvertedAmount
		FROM AV3121

GO


