IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0120]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0120]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Chuyển bút toán tạm ứng qua Module Nhân sự
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 26/11/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 26/11/2012 by 
-- <Example>
---- EXEC AP0120 'AS', 'ADMIN', 1, 2011
---- SELECT * FROM HT2500
CREATE PROCEDURE AP0120
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS int
) 
AS 
DECLARE @AdvanceAccountID AS NVARCHAR(50),
		@AdvanceID AS NVARCHAR(50),
		@cur cursor,
		@ObjectID AS NVARCHAR(50)
		
SET @AdvanceAccountID = (SELECT TOP 1 AdvanceAccountID  FROM HT0000 WHERE DivisionID = @DivisionID)

DELETE FROM HT2500 WHERE TranMonth = @TranMonth AND TranYear = @TranYear AND ISNULL(IsTranfer, 0) = 1

SELECT	B.ObjectID, B.VoucherDate, B.ConvertedAmount, B.VDescription
INTO	#TAM
FROM (
		SELECT	A.ObjectID, MAX(A.VoucherDate) AS VoucherDate, SUM(A.ConvertedAmount) AS ConvertedAmount,
				MAX(VDescription) AS VDescription

		FROM	AT9000 A
		WHERE	A.DivisionID = @DivisionID
				AND A.TranMonth = @TranMonth
				AND A.TranYear = @TranYear
				AND A.ObjectID IN (SELECT EmployeeID FROM HT1400 WHERE DivisionID = @DivisionID)
				AND A.DebitAccountID = @AdvanceAccountID
		GROUP BY	A.ObjectID
	)B


		
SET @cur = cursor static for
SELECT ObjectID From #TAM

Open @cur
Fetch Next From @cur Into @ObjectID

While @@FETCH_STATUS=0
BEGIN	
EXEC AP0000  @DivisionID, @AdvanceID  OUTPUT, 'HT2500', 'AT', @TranYear, '', 15, 3, 0, ''
	
INSERT INTO HT2500 
(DivisionID,	TranMonth,			TranYear,
AdvanceID,		DepartmentID,		TeamID,
EmployeeID,		AdvanceDate,		AdvanceAmount,
[Description],
CreateUserID,	CreateDate,			LastModifyUserID,		LastModifyDate,
IsTranfer
)

SELECT	@DivisionID, @TranMonth, @TranYear,
		@AdvanceID, H.DepartmentID, H.TeamID,
		ObjectID, VoucherDate, ConvertedAmount,
		VDescription,
		@UserID, GETDATE(), @UserID, GETDATE(),
		1
FROM	#TAM T
LEFT JOIN HT1403 H ON DivisionID = @DivisionID AND H.EmployeeID = T.ObjectID
WHERE	ObjectID = @ObjectID

Fetch Next From @cur Into @ObjectID
End

Close @cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

