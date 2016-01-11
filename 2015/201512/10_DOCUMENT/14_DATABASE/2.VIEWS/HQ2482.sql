IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HQ2482]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HQ2482]
GO
 --Tạo view HQ2482    
CREATE VIEW [dbo].[HQ2482]  
AS  
-- Create by: Dang Le Thanh Tra; Date: 26/04/2011  
-- Purpose: View chet load che do om dau  
  
SELECT  HT82.DivisionID, HT82.TranMonth, HT82.TranYear, HT82.EmployeeCount, HT82.FemaleCount, HT82.TotalOfSalary, HT82.Descriptions, HT83.Orders, HT83.EmployeeID, HV14.FullName, HT60.SNo, HT60.InsuranceSalary, HT83.CalCondition,  HT83.SITime,  HT83.LeaveDays, 
HT83.LeaveYeartoDate, HT83.Notes, HT83.Type, HV83.TypeDescription, HT83.TransactionID, HT82.VoucherID  
FROM HT2483 HT83  
 INNER JOIN HT2482 HT82 ON HT83.VoucherID = HT82.VoucherID  and HT83.DivisionID = HT82.DivisionID  
 INNER JOIN HT2460 HT60 ON HT82.DivisionID = HT60.DivisionID And  
  HT82.TranMonth = HT60.TranMonth And  
  HT82.TranYear = HT60.TranYear And  
  HT83.EmployeeID = HT60.EmployeeID  
 INNER JOIN HV1400 HV14 ON HT83.EmployeeID = HV14.EmployeeID  and HT83.DivisionID = HV14.DivisionID  
 LEFT JOIN HV2483 HV83 ON HV83.Type = HT83.Type