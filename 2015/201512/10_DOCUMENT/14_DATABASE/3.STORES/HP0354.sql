IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0354]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0354]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- 
-- <History>
---- Create on 07/12/2015 by Bảo Anh: Tính số tiền bị trừ đi trễ/về sớm và đưa vào loại công tương ứng theo thiết lập (IPL)
---- Modified on ... by ...
---- <Example> HP0354 'CTY',4,2015,'04/03/2015','04/03/2015','%','%','ADMIN'
  
CREATE PROCEDURE [dbo].[HP0354]  @DivisionID nvarchar(50),      
    @TranMonth int,  
    @TranYear int,
    @FromDate datetime,  
    @ToDate datetime,  
    @DepartmentID nvarchar(50),
	@EmployeeID nvarchar(50) = '%',
	@UserID nvarchar(50)
                                                    
AS
   
Declare @AbsentTypeID nvarchar(50),
		@RestrictID nvarchar(50)

SELECT TOP 1 @RestrictID = RestrictID FROM HT1022 WHERE DivisionID = @DivisionID
AND (@FromDate >= FromDate and @ToDate <= (case when ToDate is NULL then '12/31/9999' else ToDate end))

SELECT @AbsentTypeID = InOutAbsentTypeID FROM HT0000 WHERE DivisionID = @DivisionID

DELETE HT2401 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear
AND DepartmentID like @DepartmentID AND EmployeeID like @EmployeeID AND (AbsentDate between @FromDate and @ToDate)
AND AbsentTypeID = @AbsentTypeID

SELECT HT56.AbsentDate, HT56.EmployeeID, HT56.DepartmentID, HT56.TeamID,
	(Select case when Isnull(HT56.IsConfirm,0) <> 1 then Isnull(NotConfirmCo,1) else Isnull(Coefficient,1) end *Isnull(Amount,0)
		From HT1023
		Where DivisionID = @DivisionID And RestrictID = @RestrictID
		And (Isnull(HT56.InLateMinutes,0) + Isnull(HT56.OutEarlyMinutes,0) >= isnull(FromMinute,0) And Isnull(HT56.InLateMinutes,0) + Isnull(HT56.OutEarlyMinutes,0) <= Case When isnull(ToMinute,0) = -1 Then 1440 Else isnull(ToMinute,0) End)
	) as InOutAmount
INTO #TAM
FROM HT0356 HT56
WHERE HT56.DivisionID = @DivisionID AND HT56.TranMonth = @TranMonth AND HT56.TranYear = @TranYear
AND (HT56.AbsentDate between @FromDate and @ToDate) AND HT56.DepartmentID like @DepartmentID AND HT56.EmployeeID like @EmployeeID

--- Update số tiền trừ đi trễ/về sớm chưa được duyệt hoặc không duyệt
INSERT HT2401 (APK,DivisionID,TranMonth,TranYear,AbsentDate,EmployeeID,DepartmentID,TeamID,AbsentTypeID,AbsentAmount,CreateUserID,CreateDate,LastModifyUserID,LastModifyDate)
SELECT newid(),@DivisionID,@TranMonth,@TranYear,AbsentDate,EmployeeID,DepartmentID,TeamID,@AbsentTypeID,InOutAmount,@UserID,getdate(),@UserID,getdate()
FROM #TAM

DROP TABLE #TAM

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON