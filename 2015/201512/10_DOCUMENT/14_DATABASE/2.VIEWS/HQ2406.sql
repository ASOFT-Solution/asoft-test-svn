IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HQ2406]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HQ2406]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
/*Create by : Dang Le Bao Quynh; Date : 24/11/2008  
Purpose: View chet lay len thong tin quet the*/  
----Last edit by Trung Dung 11/05/2011 - Join EmployeeID tu HT1407 thay vi HT1406(Co truong hop Null)  
---- Modify on 04/09/2013 by Bao Anh: Thay Month(H06.AbsentDate) và Year(H06.AbsentDate) cho H06.TranMonth va H06.TranYear
---- Modify on 04/12/2013 by Bao Anh: Thay H06.TranMonth va H06.TranYear cho Month(H06.AbsentDate) và Year(H06.AbsentDate) như cũ

CREATE VIEW [dbo].[HQ2406]  
AS  
SELECT     H06.DivisionID, H06.TranMonth, H06.Tranyear, H06.AbsentCardNo, H06.AbsentDate, H06.AbsentTime, H06.MachineCode, H06.IOCode,     
                      H06.InputMethod, H07.EmployeeID, Null as Notes,  
                      Isnull(H06.ShiftCode,CASE Day(AbsentDate)     
                      WHEN 1 THEN H25.D01 WHEN 2 THEN H25.D02 WHEN 3 THEN H25.D03 WHEN 4 THEN H25.D04 WHEN 5 THEN H25.D05 WHEN 6 THEN H25.D06 WHEN    
                       7 THEN H25.D07 WHEN 8 THEN H25.D08 WHEN 9 THEN H25.D09 WHEN 10 THEN H25.D10 WHEN 11 THEN H25.D11 WHEN 12 THEN H25.D12 WHEN    
                       13 THEN H25.D13 WHEN 14 THEN H25.D14 WHEN 15 THEN H25.D15 WHEN 16 THEN H25.D16 WHEN 17 THEN H25.D17 WHEN 18 THEN H25.D18 WHEN    
                       19 THEN H25.D19 WHEN 20 THEN H25.D20 WHEN 21 THEN H25.D21 WHEN 22 THEN H25.D22 WHEN 23 THEN H25.D23 WHEN 24 THEN H25.D24 WHEN    
                       25 THEN H25.D25 WHEN 26 THEN H25.D26 WHEN 27 THEN H25.D27 WHEN 28 THEN H25.D28 WHEN 29 THEN H25.D29 WHEN 30 THEN H25.D30 WHEN    
                       31 THEN H25.D31 ELSE NULL END) as ShiftCode  
FROM         dbo.HT2408 AS H06     
 LEFT OUTER JOIN HT1407 AS H07 ON H07.AbsentCardNo = H06.AbsentCardNo and H07.DivisionID = H06.DivisionID    
        LEFT OUTER JOIN HT1025 AS H25 ON H07.EmployeeID = H25.EmployeeID and H07.DivisionID = H25.DivisionID    
---WHERE     (H25.TranMonth = Month(H06.AbsentDate)) AND (H25.TranYear = Year(H06.AbsentDate))
WHERE     H25.TranMonth = H06.TranMonth AND H25.TranYear = H06.TranYear