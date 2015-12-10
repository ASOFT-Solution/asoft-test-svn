USE [CDT]

--1--Update new report
Update sysTable 
set [Report] = N'HDBHDATIN,HDBHTUIN,HDXKDATIN,HDXK,HDBLE,INPXK-GB,INPXK-GV,BKHH-DVTHEOHD,HDBH-BBBG,HDBH-PXH'
where TableName = N'DT32' 
--2-- Insert row default for HDXK
--Check exits
if not exists (select top 1 1 from [sysPrintedInvoiceDt] where [sysReportID] = N'HDXK')
BEGIN
	declare @sysSiteID int,
		@DbName varchar(128)
			
	declare cur_invoicedt cursor for 
	SELECT distinct [sysSiteID],[DbName] FROM [sysPrintedInvoiceDt]

	open cur_invoicedt 
	fetch cur_invoicedt into @sysSiteID, @DbName

	--inserting
	while @@FETCH_STATUS = 0
	BEGIN
		INSERT [dbo].[sysPrintedInvoiceDt] 
		([sysSiteID],
		 [sysReportID], 
		 [ReportName], 
		 [ReportName2], 
		 [Pages], 
		 [Page1],
		 [Page1Eng], 
		 [Background1], 
		 [Page2], 
		 [Page2Eng], 
		 [Background2], 
		 [Disabled], 
		 [DbName]
		) 
		VALUES 
		(@sysSiteID, 
		N'HDXK', 
		N'Hóa đơn xuất khẩu tự in', 
		N'Export Invoice', 
		2, 
		N'Liên 1 : Lưu', 
		N'Copy 1 : File', 
		NULL, 
		N'Liên 2 : Giao người mua', 
		N'Copy 2 : Customer', 
		NULL, 
		0, 
		@DbName)
		
	fetch cur_invoicedt into @sysSiteID, @DbName
	END
	close cur_invoicedt
	deallocate cur_invoicedt
END	

