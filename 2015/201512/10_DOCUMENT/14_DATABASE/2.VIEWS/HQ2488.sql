IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HQ2488]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HQ2488]
GO

-- Create by: Dang Le Thanh Tram; Date: 09/05/2011  
-- Purpose: View chet danh sach de nghi dieu chinh ho so BHXH  
-- edited by: Thanh Thinh, Date 02/11/2015 : Giới tính, Sinh ngày, Tháng/năm bắt đầu đóng bảo hiểm xã hội , 
--Đến tháng năm , Mã, tên nơi khám chữa bệnh (lấy từ hồ sơ nhân viên)


CREATE VIEW [dbo].[HQ2488]  
AS  
	SELECT  HT87.DivisionID, HT87.VoucherID, HT87.VoucherNo, HT87.VoucherDate, HT87.HICount, HT87.OutOfTownCount,
		 HT87.UsingFromDate, HT87.UsingToDate, HT87.Descriptions, HT88.TransactionID, HT88.Orders, HT88.EmployeeID, 
		 HV14.FullName, HV14.SoInsuranceNo, HV14.HeInsuranceNo, HT88.EditFor,  HT88.OldContent, 
		 HT88.NewContent, HT88.Reason, HT88.Notes ,
		 hv14.IsMaleName, hv14.Birthday, CAST (MONTH(HV14.SOINSURBEGINDATE) AS nvarchar) + '/' + CAST (YEAR(HV14.SOINSURBEGINDATE) AS nvarchar) [StartSO] ,
		 CAST (MONTH(HT24.NearlyDate) AS nvarchar) + '/' + CAST (YEAR(HT24.NearlyDate) AS nvarchar) [NearlyDateSO],
		 HV14.HospitalID,hv14.HospitalName
	FROM HT2487 HT87  
	 INNER JOIN HT2488 HT88 
		ON HT87.VoucherID = HT88.VoucherID  and HT87.DivisionID = HT88.DivisionID  
	 INNER JOIN HV1400 HV14 
		ON HT88.EmployeeID = HV14.EmployeeID  and HT88.DivisionID = HV14.DivisionID 
	 LEFT JOIN 
		(	SELECT DivisionID , EmployeeID, MAX(SBEGINDATE) NearlyDate
			FROM HT2460 
			GROUP BY DivisionID ,EmployeeID
		) HT24 
		ON HT24.DivisionID = HT88.DivisionID AND HT88.EmployeeID = HT24.EmployeeID

	