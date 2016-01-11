/****** Object:  View [dbo].[OV9999]    Script Date: 12/16/2010 15:36:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---Created by : Vo Thanh Huong
---Created date: 05/08/2004
---purpose: xác d?nh quý c?a tháng h?ch hoán
--- Modify on 09/06/2015 Bảo Anh: Sửa cách lấy trường Quarter theo niên độ TC được thiết lập

ALTER VIEW [dbo].[OV9999] AS

Select (case When TranMonth <10 then '0'+rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) 
	else rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) end) as MonthYear,
	--('0'+ ltrim(rtrim(case when TranMonth %3 = 0 then TranMonth/3 else TranMonth/3+1 end))+'/'+ltrim(Rtrim(str(TranYear))) ) as Quarter ,
	CASE WHEN ISNULL(AT1101.StartDate,'01/01/1900') = '01/01/1900' THEN
		('0'+ ltrim(rtrim(case when TranMonth %3 = 0 then TranMonth/3 else TranMonth/3+1 end))+'/'+ltrim(Rtrim(str(TranYear))) )
	else
		(case when TranMonth >= Month(AT1101.StartDate) then '0' + ltrim((TranMonth - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear)
		else '0' + ltrim((TranMonth + PeriodNum - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear-1)
		end)
	end as Quarter,
	TranMonth, TranYear, OT9999.DivisionID 
From OT9999
Inner join AT1101 On OT9999.DivisionID = AT1101.DivisionID And AT1101.[Disabled] = 0