/****** Object:  View [dbo].[MV9999]    Script Date: 12/16/2010 15:44:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--VIEW CHET
---- Modify on 09/06/2015 Bảo Anh: Sửa cách lấy trường Quarter theo niên độ TC được thiết lập

ALTER VIEW [dbo].[MV9999] AS 
SELECT (CASE WHEN TranMOnth <10 THEN '0'+rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) 
		ELSE rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) END) AS MonthYear,
	/*
		('0'+ ltrim(rtrim(CASE WHEN TranMonth %3 = 0 THEN TranMonth/3 ELSE TranMonth/3+1 END))+
		'/'+ltrim(Rtrim(str(TranYear))) ) AS Quarter ,
	*/
		CASE WHEN ISNULL(AT1101.StartDate,'01/01/1900') = '01/01/1900' THEN
			('0'+ ltrim(rtrim(CASE WHEN TranMonth %3 = 0 THEN TranMonth/3 ELSE TranMonth/3+1 END))+
			'/'+ltrim(Rtrim(str(TranYear))) )
		else
			(case when TranMonth >= Month(AT1101.StartDate) then '0' + ltrim((TranMonth - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear)
			else '0' + ltrim((TranMonth + PeriodNum - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear-1)
			end)
		end as Quarter,

		TranMonth, TranYear, MT9999.DivisionID 
FROM MT9999
Inner join AT1101 On MT9999.DivisionID = AT1101.DivisionID And AT1101.[Disabled] = 0


