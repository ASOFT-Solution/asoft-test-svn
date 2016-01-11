/****** Object:  View [dbo].[MV1608]    Script Date: 12/16/2010 15:38:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Van Nhan, Date 15/08/2003
------ Purpose: Loc ra cac PP tinh chi phi do dang
----- Edit by Bao Anh, date 14/04/2010	Bo sung truong tieng Anh BeginMethodNameE

ALTER VIEW [dbo].[MV1608] as 
Select 		MT1608.InprocessID,
	          	DivisionID,
		  InprocessDate,
	       	 EmployeeID,
		Description,
		BeginMethodID,
		--MT1618.EndMethodID,
		Case when BeginMethodID = 1 then N'Cập nhật bằng tay'
			Else Case When BeginMethodID = 2 then N'Chuyển từ đối tượng tâp hợp chi phí trước'
				Else N' Khác'
				End
			End as BeginMethodName,
		Case when BeginMethodID = 1 then N'Update by hand'
			Else Case When BeginMethodID = 2 then N'Transfer from previous period ID'
				Else N' Other'
				End
			End as BeginMethodNameE,
	/*
		Case when MT1618.EndMethodID = 'I01' then 'Öôùc löôïng töông ñöông'
			Else Case When MT1618.EndMethodID = 'I02' then 'Theo ñònh möùc'
				Else Case When MT1618.EndMethodID = 'I03' then 'Theo NVL Tröïc tieáp'
					Else 'Khaùc'
					End
				End
			End As EndMethodName,
*/
		CreateDate,
		CreateUserID,
		LastModifyUserID,
		LastModifyDate,
		Disabled 
 From MT1608  --left join MT1618 on MT1608.InprocessID=MT1618.InProcessID

GO


