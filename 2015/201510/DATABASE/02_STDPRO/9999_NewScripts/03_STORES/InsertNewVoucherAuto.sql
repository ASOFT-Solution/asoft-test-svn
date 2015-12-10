IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsertNewVoucherAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InsertNewVoucherAuto]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[InsertNewVoucherAuto]
    @MaCt NVARCHAR(512),
    @Prefix NVARCHAR(512),
    @Value int,
    @LengthOfValue INT
  
AS 
    Insert Into  [dbo].[NewVoucherAuto] ( [MaCT],[Prefix], [BeginValue], [LengthOfValue])
	Values (@MaCt, @Prefix,@Value, @LengthOfValue)
