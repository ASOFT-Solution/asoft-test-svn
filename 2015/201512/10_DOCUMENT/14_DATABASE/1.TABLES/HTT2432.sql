-- <Summary>
---- 
-- <History>
---- Create on 09/12/2013 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HTT2432]') AND type in (N'U'))
CREATE TABLE [dbo].[HTT2432]
(
	[APK] [uniqueidentifier] NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](100) NULL,
	[ShiftID] [nvarchar](100)  NULL,
)
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HTT2432_APK]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HTT2432] ADD  CONSTRAINT [DF_HTT2432_APK]  DEFAULT (newid()) FOR [APK]
END

