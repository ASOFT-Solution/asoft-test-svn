USE [CDT]
GO


/****** Object:  Table [dbo].[sysPrintedInvoiceDt]    Script Date: 05/05/2011 18:07:46 ******/
INSERT [dbo].[sysPrintedInvoiceDt] ([sysSiteID], [sysReportID], [ReportName], [ReportName2], [Pages], [Page1], [Background1], [Page2], [Background2], [Page3], [Background3], [Page4], [Background4], [Page5], [Background5], [Page6], [Background6], [Page7], [Background7], [Page8], [Background8], [Page9], [Background9], [Disabled]) 
select sysSiteID
 , N'HDBHTUIN', N'Hóa đơn thuế GTGT', N'Hóa đơn thuế GTGT', 3, N'Lưu', NULL, N'Giao khách hàng', NULL, N'Đăng ký quyền sở hữu, quyền sử dụng', NULL, N'Gửi cho thuế vụ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,0
 
from sysSite
Where not exists (select top 1 1 from sysPrintedInvoiceDt dt where dt.sysReportID = 'HDBHTUIN' and dt.sysSiteID = sysSite.sysSiteID)

/****** Object:  Table [dbo].[sysPrintedInvoiceDt]    Script Date: 05/05/2011 18:07:46 ******/
INSERT [dbo].[sysPrintedInvoiceDt] ([sysSiteID], [sysReportID], [ReportName], [ReportName2], [Pages], [Page1], [Background1], [Page2], [Background2], [Page3], [Background3], [Page4], [Background4], [Page5], [Background5], [Page6], [Background6], [Page7], [Background7], [Page8], [Background8], [Page9], [Background9], [Disabled]) 
select sysSiteID
 , N'INHDDVUTUIN', N'Hóa đơn thuế GTGT(dịch vụ)', N'Hóa đơn thuế GTGT(dịch vụ)', 3, N'Lưu', NULL, N'Giao khách hàng', NULL, N'Đăng ký quyền sở hữu, quyền sử dụng', NULL, N'Gửi cho thuế vụ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,0
 
from sysSite
Where not exists (select top 1 1 from sysPrintedInvoiceDt dt where dt.sysReportID = 'INHDDVUTUIN' and dt.sysSiteID = sysSite.sysSiteID)
