-- <Summary>
---- 
-- <History>
---- Create on 22/12/2010 by Vĩnh Phong
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[A00007]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[A00007](
	[SPID] [int] NULL,
	[DivisionID] [nvarchar](50) NULL
) ON [PRIMARY]
END


