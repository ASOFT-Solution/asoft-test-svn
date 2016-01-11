-- <Summary>
---- 
-- <History>
---- Create on 08/01/2014 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ATT9000]') AND type in (N'U'))
CREATE TABLE [dbo].[ATT9000]
(
	ColID [nvarchar](100) NOT NULL, 
	ColSQLDataType [nvarchar](100) NOT NULL,
	OrderNum [int] not null
)ON [PRIMARY]
