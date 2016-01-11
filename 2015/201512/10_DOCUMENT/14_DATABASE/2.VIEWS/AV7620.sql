IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7620]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV7620]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--View chet
--Creater by Nguyen Quoc Huy, Date 13/10/2008
--In bao cao ket qua kinh doanh theo ma phan tich
---- Modified on 05/11/2012 by Lê Thị Thu Hiền : Bổ sung JOIN DivisionID
---- Modified on 15/01/2013 by Thiên Huỳnh : Bổ sung LevelID
---- Modified on 17/04/2013 by Lê Thị Thu Hiền : Amount21,	Amount22,	Amount23,	Amount24,
---- Modified on 22/07/2013 by Lê Thị Thu Hiền : Bổ sung DivisionName, DivisionNameE

CREATE VIEW [dbo].[AV7620] as
SELECT 	
	LevelID,
	LineDescription,
	LineCode,
	Amount01,
	Amount02,
	Amount03,
	Amount04,
	Amount05,
	Amount06,
	Amount07,
	Amount08,
	Amount09,
	Amount10,
	Amount11,
	Amount12,
	Amount13,
	Amount14,
	Amount15,
	Amount16,
	Amount17,
	Amount18,
	Amount19,
	Amount20,
	Amount21,
	Amount22,
	Amount23,
	Amount24,
	AT7622.DivisionID,
	AT1101.DivisionName,
	AT1101.DivisionNameE,
	Amount01LastPeriod,
	Amount02LastPeriod,
	Amount03LastPeriod,
	Amount04LastPeriod,
	Amount05LastPeriod,
	Amount06LastPeriod,
	Amount07LastPeriod,
	Amount08LastPeriod,
	Amount09LastPeriod,
	Amount10LastPeriod,
	Amount11LastPeriod,
	Amount12LastPeriod,
	Amount13LastPeriod,
	Amount14LastPeriod,
	Amount15LastPeriod,
	Amount16LastPeriod,
	Amount17LastPeriod,
	Amount18LastPeriod,
	Amount19LastPeriod,
	Amount20LastPeriod,
	Amount21LastPeriod,
	Amount22LastPeriod,
	Amount23LastPeriod,
	Amount24LastPeriod

FROM		AT7622 
INNER JOIN	AT7621 
	ON		AT7621.ReportCode = AT7622.ReportCode AND AT7621.LineID = AT7622.LineID AND AT7622.DivisionID = AT7621.DivisionID
LEFT JOIN	AT1101 ON AT1101.DivisionID = AT7622.DivisionID
WHERE AT7621.IsPrint = 1 

---SELECT * FROM AT7622


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

