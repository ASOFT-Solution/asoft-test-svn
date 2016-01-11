IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CSV9999]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[CSV9999]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Đổ nguồn kỳ kế toán
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/04/2012 by Lê Thị Thu Hiền
---- Modify on 09/06/2015 Bảo Anh: Sửa cách lấy trường Quarter theo niên độ TC được thiết lập
-- <Example>
---- SELECT * FROM CSV9999

CREATE VIEW CSV9999

AS 
SELECT (CASE WHEN  TranMonth <10 THEN '0'+rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) 
		ELSE rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) END) AS MonthYear,

		--('0'+ ltrim(rtrim(CASE WHEN TranMonth %3 = 0 THEN TranMonth/3  ELSE TranMonth/3+1  END))+'/'+ltrim(Rtrim(str(TranYear)))) AS Quarter ,
		CASE WHEN ISNULL(AT1101.StartDate,'01/01/1900') = '01/01/1900' THEN
			('0'+ ltrim(rtrim(CASE WHEN TranMonth %3 = 0 THEN TranMonth/3  ELSE TranMonth/3+1  END))+'/'+ltrim(Rtrim(str(TranYear))))
		else
			(case when TranMonth >= Month(AT1101.StartDate) then '0' + ltrim((TranMonth - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear)
			else '0' + ltrim((TranMonth + PeriodNum - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear-1)
			end)
		end as Quarter,

		TranMonth,
		TranYear,
		CST9999.DivisionID
FROM	CST9999
Inner join AT1101 On CST9999.DivisionID = AT1101.DivisionID And AT1101.[Disabled] = 0
WHERE	CST9999.Disabled <> 1
UNION ALL
SELECT (CASE WHEN  TranMOnth <10 THEN '0'+rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) 
		ELSE rtrim(ltrim(str(TranMonth)))+'/'+ltrim(Rtrim(str(TranYear))) END) AS MonthYear,

		--('0'+ ltrim(rtrim(CASE WHEN TranMonth %3 = 0 THEN TranMonth/3  ELSE TranMonth/3+1  END))+'/'+ltrim(Rtrim(str(TranYear)))) AS Quarter ,
		CASE WHEN ISNULL(AT1101.StartDate,'01/01/1900') = '01/01/1900' THEN
			('0'+ ltrim(rtrim(CASE WHEN TranMonth %3 = 0 THEN TranMonth/3  ELSE TranMonth/3+1  END))+'/'+ltrim(Rtrim(str(TranYear))))
		else
			(case when TranMonth >= Month(AT1101.StartDate) then '0' + ltrim((TranMonth - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear)
			else '0' + ltrim((TranMonth + PeriodNum - Month(AT1101.StartDate))/3+1) + '/' + ltrim(TranYear-1)
			end)
		end as Quarter,

		TranMonth,
		TranYear,
		'%' AS DivisionID
FROM	CST9999
Inner join AT1101 On CST9999.DivisionID = AT1101.DivisionID And AT1101.[Disabled] = 0

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON