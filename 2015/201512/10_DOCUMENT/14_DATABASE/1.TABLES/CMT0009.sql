-- <Summary>
---- 
-- <History>
---- Create on 26/12/2014 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CMT0009]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[CMT0009]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [CommissionMethodID] VARCHAR(50) NOT NULL,
      [InventoryID] VARCHAR(50) NOT NULL,
      [ObjectID] VARCHAR(50) NOT NULL,
      [AmountUnit] DECIMAL(28,8) NULL,
      [Notes] NVARCHAR(1000) NULL
     )
 ON [PRIMARY]
END