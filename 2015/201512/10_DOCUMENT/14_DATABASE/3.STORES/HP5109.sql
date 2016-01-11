
/****** Object:  StoredProcedure [dbo].[HP5109]    Script Date: 01/05/2012 13:26:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP5109]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP5109]
GO

/****** Object:  StoredProcedure [dbo].[HP5109]    Script Date: 01/05/2012 13:26:05 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-----  Created by Trung Dung, Date 04/07/2011  
----   Purpose: Tao view in bao cao ket qua san xuat theo to nhom (Mau T05)  
--Tố Oanh: thêm trường HT2.TrackingDate [12/06/2013]
----   Modified on 6/8/2015 by Thanh Thịnh: Lấy tổng giá trị Quatity, Amount và max của UnitPrice
CREATE PROCEDURE [dbo].[HP5109]   
  @TranMonth int,  
  @TranYear int,  
  @DivisionID nvarchar(50),  
  @DepartmentID nvarchar(50),  
  @TeamID nvarchar(50)  
AS  
  
DECLARE  @sSQL varchar(8000)  
  
IF Exists (SELECT id from sysobjects where id=object_id('HV5109') and xtype='V')  
Drop VIEW HV5109  
  
SET @sSQL= '
			CREATE VIEW HV5109 --Tao boi HP5109  
		AS  
		SELECT TOP 100 PERCENT HT2.DivisionID, HT2.EmployeeID,HV14.FullName,  
			HT2.DepartmentID,AT1.DepartmentName,HT2.TeamID,HT11.TeamName,  
			HT10.ProductID,HT10.ProductName,SUM(HT2.Quantity) [Quantity],MAX(HT10.UnitPrice) [UnitPrice],
			SUM(HT2.Quantity*HT10.UnitPrice) as Amount, HT2.TrackingDate   
		FROM HT2403 HT2   
			INNER JOIN HV1400 HV14 
				ON HT2.EmployeeID= HV14.EmployeeID  AND HT2.DivisionID= HV14.DivisionID
			INNER JOIN HT1015 HT10 
				ON HT2.ProductID=HT10.ProductID  AND HT2.DivisionID=HT10.DivisionID
			LEFT JOIN AT1102 AT1 
				ON HT2.DepartmentID=AT1.DepartmentID AND HT2.DivisionID=AT1.DivisionID
			LEFT JOIN HT1101 HT11 
				ON HT2.TeamID=HT11.TeamID AND HT2.DivisionID=HT11.DivisionID 
		WHERE TranMonth=' + ltrim(@TranMonth) +   
			' and TranYear=' + ltrim(@TranYear) +    
			' and HT2.DivisionID=''' + @DivisionID +   
			''' and HT2.DepartmentID like ''' + @DepartmentID +   
			''' and HT2.TeamID like ''' + @TeamID + ''' 
		GROUP BY HT2.DivisionID, HT2.EmployeeID,HV14.FullName,  
			HT2.DepartmentID,AT1.DepartmentName,HT2.TeamID,HT11.TeamName,  
			HT10.ProductID,HT10.ProductName,HT2.TrackingDate,HT10.Orders
		ORDER BY HT2.DepartmentID,HT2.TeamID,HT10.Orders,HT10.ProductID'  	
EXEC(@sSQL)  
GO


