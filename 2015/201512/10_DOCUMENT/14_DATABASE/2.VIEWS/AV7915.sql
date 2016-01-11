IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7915]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV7915]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Do du lieu bao cao BCDKT
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on by 
---- 
---- Modified on 22/12/2011 by Nguyễn Bình Minh: Bổ sung Amount3: Số đầu kỳ
---- Modified on 28/03/2013 by Bao Quynh: Bổ sung Amount4: Cung ky nam truoc

-- <Example>
---- 
CREATE VIEW [dbo].[AV7915] 
AS
SELECT 	DivisionID, T15.Type,
	 	T15.LineCode AS Code, 	
		T15.LineDescription AS Description, 
		T15.LineDescriptionE AS DescriptionE, 
		T15.Amount1 AS Opening, 
		T15.Amount2 AS Closing,
		T15.Amount3 AS PeriodOpening,
		T15.Amount4 AS LastYearClosing,
		T15.Level1 AS Level1,
		T15.Notes AS Notes
FROM 	AT7915 AS T15

WHERE	T15.PrintStatus =0 AND
		(T15.Type = 1 OR T15.Type = 2 or T15.Type = 9)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

