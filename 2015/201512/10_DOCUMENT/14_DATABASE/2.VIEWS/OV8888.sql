

/****** Object:  View [dbo].[OV8888]    Script Date: 12/16/2010 15:34:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[OV8888]
AS
SELECT     'G01' AS GroupId, N'OFML000185' AS GroupName, N'OFML000185' AS EGroupName,DivisionID from AT1101
UNION													 
SELECT     'G02' AS GroupId, N'OFML000186' AS GroupName, N'OFML000186' AS EGroupName,DivisionID from AT1101
UNION													 
SELECT     'G03' AS GroupId, N'OFML000187' AS GroupName, N'OFML000187' AS EGroupName,DivisionID from AT1101
UNION													 
SELECT     'G04' AS GroupId, N'OFML000188' AS GroupName, N'OFML000188' AS EGroupName,DivisionID from AT1101
UNION													 
SELECT     'G05' AS GroupId, N'OFML000189' AS GroupName, N'OFML000189' AS EGroupName,DivisionID from AT1101
UNION													 
SELECT     'G06' AS GroupId, N'OFML000190' AS GroupName, N'OFML000190' AS EGroupName,DivisionID from AT1101
UNION													 
SELECT     'G07' AS GroupId, N'OFML000191' AS GroupName, N'OFML000191' AS EGroupName,DivisionID from AT1101
UNION													 
SELECT     'G99' AS GroupId, N'OFML000192' AS GroupName, N'OFML000192' AS EGroupName,DivisionID from AT1101


GO


