IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wBLVT]'))
DROP VIEW [dbo].[wBLVT]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE         VIEW [dbo].[wBLVT] as
		select ngayct,mavt,makho,MaDvt, soluong,soluongQD,soluong_x, soluong_xQD,dongia,dongiaQD,mact,kt, mtiddt from blvt 
		union all
		select ngayct,mavt,makho,MaDvt, soluong,soluongQD,0,0,dudau/soluong,dudau/soluongQD,'POB',null,null from obNTXT