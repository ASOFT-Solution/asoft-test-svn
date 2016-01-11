IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0146]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0146]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--- Created by: Hoàng vũ, date: 26/03/2015  
---Customize-index = 43 (Khách hàng Secoin)
--- Purpose: Trả ra Danh sách nhân viên nhận mail (Kiểm tra có email thì hiện ra)
/*
Exec OP0146 'AS','%','%'

*/
  
CREATE PROCEDURE [dbo].[OP0146] 
		@DivisionID nvarchar(50),      
        @DepartmentID nvarchar (50),  
		@EmployeeID nvarchar (50)
AS  
		Declare @sSQL as varchar(max),
				@stWhere varchar(max) 
		
		Set @stWhere = ''

		IF @DepartmentID is not null or @DepartmentID != N'%'
			Set @stWhere =  @stWhere + ' And ISNULL(AT1103.DepartmentID, '''') Like N''%' + @DepartmentID+ '%'''
				
		IF @EmployeeID IS NOT NULL or @EmployeeID != N'%'
			SET @stWhere = @stWhere + 'AND ISNULL(AT1103.EmployeeID,'''') LIKE N''%'+@EmployeeID+'%'''
		
		
			SET @sSQL = '  
							SELECT AT1103.DivisionID, AT1103.EmployeeID
								 , AT1103.FullName as EmployeeName, AT1103.DepartmentID
								 , AT1102.DepartmentName, AT1103.EmployeeTypeID
								 , AT1104.EmployeeName as EmployeeTypeName
								 , AT1103.HireDate, AT1103.EndDate, AT1103.BirthDay
								 , AT1103.Address, AT1103.Tel, AT1103.Fax, AT1103.Email
							From AT1103 left join AT1102 on AT1103.DivisionID = AT1102.DivisionID 
															and AT1103.DepartmentID = AT1102.DepartmentID
										left join AT1104 on AT1103.DivisionID = AT1104.DivisionID 
															and AT1103.EmployeeTypeID = AT1104.EmployeeTypeID
							Where AT1103.Disabled = 0 and AT1103.Email is not null and AT1103.DivisionID = ''' + @DivisionID +''''+ @stWhere + 
							'Order by AT1103.DepartmentID, AT1103.EmployeeID'  
		
		EXEC(@sSQL)
		
		Print (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
