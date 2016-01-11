IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0185]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0185]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load danh sách tờ khai khấu trừ thuế thu nhập cá nhân
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 29/04/2015
---- Modified on 
-- <Example>
/*
	
*/
CREATE PROCEDURE HP0185
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@TranYear INT
)
AS
SELECT APK, TaxreturnID, IsPeriod,
	CASE WHEN IsPeriod = 1 THEN RIGHT(100 + TranMonth, 2) + '/' +LEFT(TranYear,4) ELSE NULL END MonthYear,
	CASE WHEN ISNULL(IsPeriod,0) = 0 THEN [Quarter] ELSE NULL END [Quarter],
	TaxreturnTime, TaxAgentPerson, TaxAgentCertificate, TaxreturnPerson, SignDate
FROM HT0357
WHERE DivisionID = @DivisionID
AND (TranYear = @TranYear OR LEFT([Quarter],4) = @TranYear)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
