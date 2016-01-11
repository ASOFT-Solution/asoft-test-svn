IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0147]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0147]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--- Created by: Hoàng vũ, date: 26/03/2015  
---Customize-index = 43 (Khách hàng Secoin)
--- Purpose: Gửi mail; lấy dữ liệu ra template mail(Đục lỗ)
/*
Exec OP0147 'AS','SO/02/2014/0010'',''SO/02/2014/0011'',''SO/02/2014/0009'

*/
  
CREATE PROCEDURE [dbo].[OP0147] 
		@DivisionID nvarchar(50),      
        @SOrderID  nvarchar(Max)
AS  
		Declare @sSQL as nvarchar(max),
				@stWhere nvarchar(max),
				@Email nvarchar(max)
		Set @stWhere = ''
			
		IF @SOrderID IS NOT NULL
			SET @stWhere = @stWhere + ' and OT2001.SOrderID in ('''+ @SOrderID+''')'
		
		
		SET @sSQL = '  
							Select OT2001.VoucherNo, OT2001.OrderDate as VoucherDate
								 , OT2001.EmployeeID, AT1103_01.FullName as EmployeeName, AT1103_01.Email
								 , OT2001.ObjectID, AT1202.ObjectName, OT2001.DescriptionConfirm
								 , OT2001.LastModifyUserID, Isnull(AT1103_02.FullName, N''Admin'') as  LastModifyUserName
								 , OT2001.LastModifyDate
								 , OT2001.ContractNo, OT2001.ContractDate
								 , Case When OT2001.OrderStatus = 0 then N''No Accept''
										When OT2001.OrderStatus = 1 then N''Accept''
										Else Null End as OrderStatus
								 , DeliveryAddress
								 , ShipDate
								 , Note
							From OT2001 Left join AT1103 AT1103_01 on OT2001.EmployeeID = AT1103_01.EmployeeID and OT2001.DivisionID = AT1103_01.DivisionID
										Left join AT1103 AT1103_02 on OT2001.LastModifyUserID = AT1103_02.EmployeeID and OT2001.DivisionID = AT1103_02.DivisionID
										Left join AT1202 on OT2001.ObjectID = AT1202.ObjectID and OT2001.DivisionID = AT1202.DivisionID
							Where OT2001.OrderStatus = 1 and OT2001.OrderType = 0
							and OT2001.DivisionID = ''' + @DivisionID +''''+ @stWhere + ''+
							' Order by OT2001.OrderDate, OT2001.ObjectID'  
		
		EXEC(@sSQL)
		
		Print (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO