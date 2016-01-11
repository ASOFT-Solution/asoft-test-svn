IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP8003]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP8003]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load tờ khai 05KK-TNCN
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on 02/04/2015
---- Modified by:
-- <Example>
/*
	 HP8003 'VK', ''
*/
					
 CREATE PROCEDURE HP8003
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50)
)
AS	
SELECT (CASE WHEN OrderNo >= 23 THEN 2 ELSE 1 END) GroupID, *
FROM HT0009 WHERE DeclareRationType = '05KK-TNCN'

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
