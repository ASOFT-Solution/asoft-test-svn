IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0260]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0260]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bao Anh		Date: 08/01/2013
---- Purpose: Tra ra danh sach loi san pham
---- EXEC HP0260 'AS','ERR1,ERR2,ERR3'

CREATE PROCEDURE HP0260
( 
	@DivisionID as nvarchar(50),
	@List AS NVARCHAR(max)
	
) 
AS 

SELECT ErrorID, ErrorName, cast(1 as tinyint) as IsChecked 
FROM HT0259 Where DivisionID = @DivisionID 
And ErrorID in (Select Isnull(DATA,'') from (SELECT DATA FROM [Split] (@List,',')) A)
UNION
SELECT ErrorID, ErrorName, cast(0 as tinyint) as IsChecked 
FROM HT0259 Where DivisionID = @DivisionID And Disabled = 0
 And ErrorID not in (Select Isnull(DATA,'') from (SELECT DATA FROM [Split] (@List,',')) B)
Order by ErrorID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

