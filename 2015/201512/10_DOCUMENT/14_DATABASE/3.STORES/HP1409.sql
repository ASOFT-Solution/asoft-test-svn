
/****** Object:  StoredProcedure [dbo].[HP1409]    Script Date: 09/20/2011 16:08:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1409]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1409]
GO

/****** Object:  StoredProcedure [dbo].[HP1409]    Script Date: 09/20/2011 16:08:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----Created by: Hoang Trong Khanh
-----Created date: 12/03/2012
-----purpose: Xóa các dữ liệu của các bảng liên quan khi xóa một nhân viên (Chuyển từ trigger HX1400 qua )
CREATE PROCEDURE 	[dbo].[HP1409] 
					@DivisionID nvarchar(50),
					@EmployeeID nvarchar(50)
AS


Declare	@D07_Cursor Cursor,
	@EmployeeName as nvarchar(100),
	@PermanentAddress AS nvarchar(250),
	@HomePhone AS nvarchar(50),----Tel
	@MobiPhone AS nvarchar(50),----PhoneNumber
	@Email AS nvarchar(100)	
	
Set @D07_Cursor = Cursor Scroll KeySet For
SELECT  ins.LastName + ' ' + ins.MiddleName + ' ' + ins.FirstName,
	ins.PermanentAddress,ins.HomePhone,ins.MobiPhone,ins.Email				
FROM HT1400 ins Where ins.EmployeeID = @EmployeeID And ins.DivisionID = @DivisionID 	
Open @D07_Cursor
Fetch Next From @D07_Cursor Into @EmployeeName, @PermanentAddress, @HomePhone,
		@MobiPhone,  @Email 		                                         
While @@FETCH_STATUS = 0
Begin	
	IF NOT EXISTS(SELECT ObjectID FROM AT1202 WHERE ObjectID=@EmployeeID and DivisionID = @DivisionID)
	INSERT INTO AT1202 (DivisionID,ObjectID,ObjectName,[Address],Tel,PhoneNumber,Email,IsCustomer,IsSupplier,IsUpdateName)
	VALUES(@DivisionID,@EmployeeID, @EmployeeName, @PermanentAddress, @HomePhone,@MobiPhone, @Email,1,0,0)
Fetch Next From @D07_Cursor Into @EmployeeName, @PermanentAddress, @HomePhone,
		@MobiPhone,  @Email
                                       

End
Close @D07_Cursor
DeAllocate @D07_Cursor

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


