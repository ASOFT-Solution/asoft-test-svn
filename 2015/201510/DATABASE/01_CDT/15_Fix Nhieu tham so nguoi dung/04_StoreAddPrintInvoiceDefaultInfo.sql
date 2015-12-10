use [CDT]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetDefaultPrintSelfInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetDefaultPrintSelfInfo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SetDefaultPrintSelfInfo] 
	@DbName VARCHAR(50),
	@SiteCode NVARCHAR(128)
AS
declare @SysSiteID int

select @SysSiteID = sysSiteID from sysSite where SiteCode = @SiteCode

-- Gia tri mac dinh hoa don tu in don hang ban
if not exists (select top 1 1 from [sysPrintedInvoiceDt] where [sysSiteID] = @SysSiteID and [sysReportID] = N'HDBHTUIN' and [DbName] = @DbName)
INSERT [dbo].[sysPrintedInvoiceDt] ([sysSiteID], [sysReportID], [ReportName], [ReportName2], [Pages], [Page1], [Background1], [Page2], [Background2], [Page3], [Background3], [Page4], [Background4], [Page5], [Background5], [Page6], [Background6], [Page7], [Background7], [Page8], [Background8], [Page9], [Background9], [Disabled], [DbName]) 
VALUES (@SysSiteID, N'HDBHTUIN', N'Hóa đơn thuế GTGT', N'Hóa đơn thuế GTGT', 3, N'Lưu', NULL, N'Giao khách hàng', NULL, N'Đăng ký quyền sở hữu, quyền sử dụng', NULL, N'Gửi cho thuế vụ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,0, @DbName)

-- Gia tri mac dinh hoa don tu in don hang dich vu 
if not exists (select top 1 1 from [sysPrintedInvoiceDt] where [sysSiteID] = @SysSiteID and [sysReportID] = N'INHDDVUTUIN' and [DbName] = @DbName)
INSERT [dbo].[sysPrintedInvoiceDt] ([sysSiteID], [sysReportID], [ReportName], [ReportName2], [Pages], [Page1], [Background1], [Page2], [Background2], [Page3], [Background3], [Page4], [Background4], [Page5], [Background5], [Page6], [Background6], [Page7], [Background7], [Page8], [Background8], [Page9], [Background9], [Disabled], [DbName]) 
VALUES (@SysSiteID, N'INHDDVUTUIN', N'Hóa đơn thuế GTGT(dịch vụ)', N'Hóa đơn thuế GTGT(dịch vụ)', 3, N'Lưu', NULL, N'Giao khách hàng', NULL, N'Đăng ký quyền sở hữu, quyền sử dụng', NULL, N'Gửi cho thuế vụ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,0, @DbName)