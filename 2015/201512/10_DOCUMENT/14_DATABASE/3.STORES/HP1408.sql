/****** Object:  StoredProcedure [dbo].[HP1408]    Script Date: 09/20/2011 16:08:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1408]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1408]
GO

/****** Object:  StoredProcedure [dbo].[HP1408]    Script Date: 09/20/2011 16:08:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----Created by: Hoang Trong Khanh
-----Created date: 12/03/2012
-----purpose: Xóa các dữ liệu của các bảng liên quan khi xóa một nhân viên (Chuyển từ trigger HX1400 qua)
----- Edited by Bao Anh		Date: 23/12/2012	Xoa thong tin luu tru

CREATE PROCEDURE 	[dbo].[HP1408]  
					@DivisionID nvarchar(50),
					@EmployeeID nvarchar(50)
AS

DELETE HT1301 
FROM HT1301 inner join HT1400 DEL On DEL.EmployeeID = HT1301.EmployeeID and DEL.DivisionID = HT1301.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

DELETE HT1405 
From HT1405 inner join HT1400 DEL On DEL.EmployeeID = HT1405.EmployeeID and DEL.DivisionID = HT1405.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

DELETE HT1404 
From HT1404  inner join HT1400 DEL On DEL.EmployeeID = HT1404.EmployeeID and DEL.DivisionID = HT1404.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

DELETE HT1403
From HT1403  inner join HT1400 DEL On DEL.EmployeeID = HT1403.EmployeeID and DEL.DivisionID = HT1403.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

DELETE HT1402
From HT1402  inner join HT1400 DEL On DEL.EmployeeID = HT1402.EmployeeID and DEL.DivisionID = HT1402.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

DELETE HT1401
From HT1401  inner join HT1400 DEL On DEL.EmployeeID = HT1401.EmployeeID and DEL.DivisionID = HT1401.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

DELETE HT1407
From HT1407  inner join HT1400 DEL On DEL.EmployeeID = HT1407.EmployeeID and DEL.DivisionID = HT1407.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

DELETE HT1408
From HT1408  inner join HT1400 DEL On DEL.EmployeeID = HT1408.EmployeeID and DEL.DivisionID = HT1408.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

DELETE HT1412
From HT1412  inner join HT1400 DEL On DEL.EmployeeID = HT1412.EmployeeID and DEL.DivisionID = HT1412.DivisionID
Where DEL.EmployeeID = @EmployeeID And DEL.DivisionID = @DivisionID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




