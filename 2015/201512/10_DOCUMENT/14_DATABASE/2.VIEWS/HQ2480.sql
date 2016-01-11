IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HQ2480]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HQ2480]
GO
CREATE VIEW [dbo].[HQ2480]  
AS  
-- Create by: Dang Le Thanh Tra; Date: 26/04/2011  
-- Purpose: View chet load che do thai san  
  
SELECT  HT80.DivisionID, HT80.TranMonth, HT80.TranYear, HT80.EmployeeCount, HT80.FemaleCount, HT80.TotalOfSalary, HT80.Descriptions, HT81.Orders, HT81.EmployeeID, HV14.FullName, HT60.SNo, HT60.InsuranceSalary, HT81.SITime,  HT81.LeaveDate, HT81.LeaveDays,
 HT81.LeaveYeartoDate, HT81.Notes, HT81.Type, HV81.TypeDescription, HT81.TransactionID, HT80.VoucherID  
FROM HT2481 HT81  
 INNER JOIN HT2480 HT80 ON HT81.VoucherID = HT80.VoucherID  and HT81.DivisionID = HT80.DivisionID  
 INNER JOIN HT2460 HT60 ON HT80.DivisionID = HT60.DivisionID And  
  HT80.TranMonth = HT60.TranMonth And  
  HT80.TranYear = HT60.TranYear And  
  HT81.EmployeeID = HT60.EmployeeID  
 INNER JOIN HV1400 HV14 ON HT81.EmployeeID = HV14.EmployeeID  and HT81.DivisionID = HV14.DivisionID  
 LEFT JOIN HV2481 HV81 ON HV81.Type = HT81.Type