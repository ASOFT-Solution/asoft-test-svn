/****** Object:  View [dbo].[HV9999]    Script Date: 01/11/2011 14:46:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- Modify on 09/06/2015 Bảo Anh: Sửa cách lấy trường Quarter theo niên độ TC được thiết lập

ALTER  View [dbo].[HV9999] as
Select (Case When  TranMOnth <10 then '0'+rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) 
	Else rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) End) as MonthYear,
	/*
	('0'+ ltrim(rtrim(Case when TranMonth %3 = 0 then TranMonth/3  Else TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(TranYear)))
	)
	  as Quarter ,
	*/
	CASE WHEN ISNULL(AT1101.StartDate,'01/01/1900') = '01/01/1900' THEN
		('0'+ ltrim(rtrim(Case when TranMonth %3 = 0 then TranMonth/3  Else TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(TranYear)))
		)
	else
		(case when TranMonth >= Month(AT1101.StartDate) then '0' + ltrim((TranMonth - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear)
		else '0' + ltrim((TranMonth + PeriodNum - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear-1)
		end)
	END as Quarter,
	TranMonth,
	TranYear,
	HT9999.DivisionID
From HT9999
Inner join AT1101 On HT9999.DivisionID = AT1101.DivisionID And AT1101.[Disabled] = 0