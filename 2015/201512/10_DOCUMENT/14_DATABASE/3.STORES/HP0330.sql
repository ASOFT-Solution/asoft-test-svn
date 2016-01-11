IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0330]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0330]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In report Giấy nghỉ phép (CSG)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguyễn Thanh Sơn, date: 19/11/2013
-- <Example>
---- EXEC HP0330 'SAS','123456'

CREATE PROCEDURE HP0330
(
  @DivisionID VARCHAR (50),
  @VoucherID VARCHAR (50)
)    
AS 
SELECT H26.VoucherNo,H26.EmployeeID,
LTRIM(RTRIM(ISNULL(H00.LastName,'')))+' '+LTRIM(RTRIM(ISNULL(H00.MiddleName,'')))+' '+LTRIM(RTRIM(ISNULL(H00.FirstName,''))) AS EmployeeName,
H26.DepartmentID,A02.DepartmentName,H26.FromDate,H26.ToDate,H26.SabbaticalReason,H26.SabbaticalPlace
FROM HT0326 H26
LEFT JOIN AT1102 A02 ON A02.DivisionID = H26.DivisionID AND A02.DepartmentID = H26.DepartmentID
LEFT JOIN HT1400 H00 ON H00.DivisionID = H26.DivisionID AND H00.EmployeeID = H26.EmployeeID
WHERE H26.DivisionID =  @DivisionID
AND H26.VoucherID = @VoucherID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

