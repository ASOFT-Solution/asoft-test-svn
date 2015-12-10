-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
if exists (select top 1 1 from sysobjects where name = 'GetTonKho')
Drop function GetTonKho
go

CREATE FUNCTION GetTonKho
(	
	-- Add the parameters for the function here
	@ngayct DateTime, 
	@soct nvarchar(50),
	@mavt nvarchar(max)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select a.Data as MaVT, x.MaDVT, x.IsTon, x.TonMin, x.TonMax, y.makho,y.slTon  from 
	Split(@mavt,',') a left join
	(
	(
		select rtrim(Makho) + rtrim(mavt) as stt,mavt, makho, sum(slTon) as slTon from 
		(
			select mavt,makho, sum(isnull(soluong,0)-isnull(soluong_x,0)) as slTon from blvt  
			where NgayCT<= @ngayct and (isnull(@soct,'') = '' or SoCT <> @soct)
			group by mavt,makho
			union all
			select mavt,makho,sum(soluong) as slTon from obvt group by mavt,makho
			union all
			select mavt,makho,sum(soluong) as slTon from obNTXT 
			where NgayCT<= @ngayct and (isnull(@soct,'') = '' or SoCT <> @soct)
			group by mavt,makho
 		) x group by mavt,makho
	) y 
	 inner join dmvt x on x.mavt=y.mavt and x.IsTon = 1-- and x.TonMin > y.slTon
	 ) on a.Data = y.mavt
)