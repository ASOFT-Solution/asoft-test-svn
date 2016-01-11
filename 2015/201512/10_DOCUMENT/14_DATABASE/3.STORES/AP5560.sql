/****** Object:  StoredProcedure [dbo].[AP5560]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Create By: Dang Le Bao Quynh; Date 30/03/2009
--Purpose: Ke thua ban hang cho Fei Yueh
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP5560] @Date datetime, @xlsFile as nvarchar (1000) = ''
AS

Declare @sql nvarchar(4000)

If len(@xlsFile) > 0
Begin
	
	if exists (Select srvname From master.dbo.sysservers Where srvname = 'excelsource')
	Begin
		EXEC sp_dropserver 'excelsource',droplogins
	End
	
	EXEC sp_addlinkedserver 'excelsource','Jet 4.0','Microsoft.Jet.OLEDB.4.0',@xlsFile,NULL,'Excel 5.0'
	EXEC sp_addlinkedsrvlogin 'excelsource', 'false', 'sa', 'Admin', NULL


	Set @sql = N'

	BEGIN TRAN
		Insert Into AT5560 (Serial,InvoiceNo,InvoiceDate,ObjectID,TMB,PQL,TKO)	
		Select 	rtrim(ltrim(Serial)),rtrim(ltrim(InvoiceNo)), ltrim(Month(InvoiceDate)) + ''/'' + ltrim(Day(InvoiceDate)) + ''/'' + ltrim(Year(InvoiceDate)) , rtrim(ltrim(ObjectID)),isnull(TMB,0),isnull(PQL,0),isnull(TKO,0) From excelsource...Sheet1$
		Where 	rtrim(ltrim(Serial)) + ''_'' + rtrim(ltrim(InvoiceNo)) not in (Select Serial + ''_'' + InvoiceNo From AT5560) And
			cast(ltrim(Month(InvoiceDate)) + ''/'' + ltrim(Day(InvoiceDate)) + ''/'' + ltrim(Year(InvoiceDate)) as datetime) = ''' + ltrim(@Date) + '''
	IF @@ERROR = 0
		COMMIT TRAN
	ELSE
		ROLLBACK TRAN
	'
	Exec (@sql)
End
GO
