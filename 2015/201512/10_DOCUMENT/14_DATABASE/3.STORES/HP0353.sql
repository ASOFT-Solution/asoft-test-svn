IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0353]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0353]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE HP0353
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@TranYear INT
)
AS
SELECT APK, TaxreturnID, TaxreturnYear, FromMonth, FromYear, ToMonth, ToYear,
       TaxreturnTime, IsNotEnoughYear, NotEnougheReason, TaxAgentPerson,
       TaxAgentCertificate, TaxreturnPerson, SignDate, CreateDate, CreateUserID,
       LastModifyUserID, LastModifyDate
FROM HT0353
WHERE DivisionID = @DivisionID
AND TaxreturnYear = @TranYear

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
