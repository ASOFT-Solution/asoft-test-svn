-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7420]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7420](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[LineID] [int] NOT NULL,
	[IsIn] [tinyint] NOT NULL,
	[IsShow] [tinyint] NOT NULL,
	[IsTurnOver] [tinyint] NOT NULL,
	[IsTax] [tinyint] NOT NULL,
	[IsAccumulated] [tinyint] NOT NULL,
	[Sign] [int] NULL,
	[AccumulateLineID1] [int] NULL,
	[AccumulateLineID2] [int] NULL,
	[TurnOverCode] [nvarchar](50) NULL,
	[TaxCode] [nvarchar](50) NULL,
	[IsBold] [tinyint] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Note] [nvarchar](250) NULL,
	[TOAccountID1From] [nvarchar](50) NULL,
	[TOAccountID1To] [nvarchar](50) NULL,
	[TOAccountID2From] [nvarchar](50) NULL,
	[TOAccountID2To] [nvarchar](50) NULL,
	[TOAccountID3From] [nvarchar](50) NULL,
	[TOAccountID3To] [nvarchar](50) NULL,
	[TOAccountID4From] [nvarchar](50) NULL,
	[TOAccountID4To] [nvarchar](50) NULL,
	[TOAccountID5From] [nvarchar](50) NULL,
	[TOAccountID5To] [nvarchar](50) NULL,
	[TOInvoiceTypeFrom] [nvarchar](50) NULL,
	[TOInvoiceTypeTo] [nvarchar](50) NULL,
	[TOVATGroupFrom] [nvarchar](50) NULL,
	[TOVATGroupTo] [nvarchar](50) NULL,
	[TOVoucherTypeFrom] [nvarchar](50) NULL,
	[TOVoucherTypeTo] [nvarchar](50) NULL,
	[VATAccountID1From] [nvarchar](50) NULL,
	[VATAccountID1To] [nvarchar](50) NULL,
	[VATAccountID2From] [nvarchar](50) NULL,
	[VATAccountID2To] [nvarchar](50) NULL,
	[VATAccountID3From] [nvarchar](50) NULL,
	[VATAccountID3To] [nvarchar](50) NULL,
	[VATInvoiceTypeFrom] [nvarchar](50) NULL,
	[VATInvoiceTypeTo] [nvarchar](50) NULL,
	[VATGroupFrom] [nvarchar](50) NULL,
	[VATGroupTo] [nvarchar](50) NULL,
	[VATVoucherTypeFrom] [nvarchar](50) NULL,
	[VATVoucherTypeTo] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT7420] PRIMARY KEY CLUSTERED 
(
	[LineID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
