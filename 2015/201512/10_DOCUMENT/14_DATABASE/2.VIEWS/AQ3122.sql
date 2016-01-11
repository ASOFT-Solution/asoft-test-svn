IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ3122]') AND  OBJECTPROPERTY(ID, N'IsView') = 1)			
DROP VIEW [DBO].[AQ3122]
GO
/****** Object:  View [dbo].[AQ3122]    Script Date: 12/21/2010 13:57:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



--Create by: Dang Le Bao Quynh; Date:01/07/2009
--Purpose: In bao cao ban hang theo ma phan tich sap xep theo tieu thuc so luong
CREATE VIEW [dbo].[AQ3122] 
			 as SELECT *,
		(Select sum(isnull(Quantity,0)) From AV3121 A1 Where A1.Group1ID = AV3121.Group1ID And A1.InvID = AV3121.InvID) As InvSumOfQuantity,
		(Select sum(isnull(Quantity,0)) From AV3121 A1 Where A1.Group1ID = AV3121.Group1ID) As GrpSumOfQuantity,
		0 As InvSumOfConvertedAmount,
		0 As GrpSumOfConvertedAmount
		FROM AV3121



GO


