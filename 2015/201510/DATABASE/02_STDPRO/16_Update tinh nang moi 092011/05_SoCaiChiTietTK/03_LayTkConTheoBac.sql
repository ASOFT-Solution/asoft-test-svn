IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LayTkConTheoBac]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[LayTkConTheoBac]
GO

CREATE FUNCTION [dbo].[LayTkConTheoBac]
(	
	@TK varchar(16),
	@Bac int
)
RETURNS @RtnValue TABLE 
(
    [TK] varchar(16) NOT NULL,	
	[TKMe] varchar(16) NULL,
	[GradeTK] int null
) 
AS
BEGIN
	WITH TK_CTE(TK,TKMe,GradeTK)
	AS
	(
	SELECT TK, TKMe, GradeTK
	FROM DMTK
	WHERE TK = @TK

	UNION ALL

	SELECT dm.TK, dm.TKMe, dm.GradeTK AS GradeTK
	FROM DMTK AS dm INNER JOIN TK_CTE AS cte ON dm.TKMe = cte.TK
	)
	insert into @RtnValue(TK,TKMe,GradeTK)
	SELECT TK, TKMe, GradeTK
	FROM TK_CTE where GradeTK = @Bac
	RETURN
END