IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateNewVoucherAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateNewVoucherAuto]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[UpdateNewVoucherAuto]
    @MaCt NVARCHAR(512),
    @Prefix NVARCHAR(512),
    @Value int,
    @LengthOfValue INT
  
AS 
 	
    UPDATE  [dbo].[NewVoucherAuto]
    SET     [Prefix] = @Prefix,
            [BeginValue] = @Value,
            [LengthOfValue] = @LengthOfValue
    WHERE   [MaCT] = @MaCt
