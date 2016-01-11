
/****** Object:  View [dbo].[HQ2486]    Script Date: 12/14/2011 16:48:45 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HQ2486]'))
DROP VIEW [dbo].[HQ2486]
GO


/****** Object:  View [dbo].[HQ2486]    Script Date: 12/14/2011 16:48:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Create by: Dang Le Thanh Tra; Date: 09/05/2011  
-- Purpose: View chet de nghi cap l?i the bao hiem y te  
-- edited by: Thanh Thinh, Date 02/11/2015 Lấy thêm Trường CMND, ngày cấp, nơi cấp (TienTien)

CREATE VIEW [dbo].[HQ2486]  
AS  

  
SELECT HT86.*, HV00.FullName, HV00.BirthDay, HV00.IsMale, HV00.FullAddress, HV00.IdentifyCardNo ,
	HV00.IdentifyDate ,HV00.IdentifyPlace 
 FROM HT2486 HT86 
 INNER JOIN HV1400 HV00 
	ON HT86.EmployeeID = HV00.EmployeeID 
		and HT86.DivisionID = HV00.DivisionID


GO


