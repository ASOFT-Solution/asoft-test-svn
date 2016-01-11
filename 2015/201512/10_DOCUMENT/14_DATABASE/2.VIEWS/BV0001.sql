IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[BV0001]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[BV0001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- View do ra tat ca cac bao cao
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 15/09/2011 by Le Thi Thu Hien
---- 
---- Modified on 15/09/2011 by 
-- <Example>
---- 
CREATE VIEW BV0001
AS 

SELECT ReportCode, ReportName, ChartType, IsGeneral FROM BT0010

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

