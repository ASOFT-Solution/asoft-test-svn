IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5561]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5561]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Purpose: Import dữ liệu từ hệ thống AMS
--Customize theo khách hàng MVI
/********************************************
'* Created by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP5561] 
 @xml XML
,@DivisionID nvarchar(50), @TranMonth int , 
@TranYear int, @EmployeeID nvarchar(50), 
@FileName nvarchar(50)
AS

if(@FileName like '01_Template_BillingInfo%')
	Exec AP5562 @xml, @DivisionID, @TranMonth, @TranYear, @EmployeeID
else if(@FileName like '01_Template_GeneralEntry%')
	Exec AP5563 @xml, @DivisionID, @TranMonth, @TranYear, @EmployeeID
else if(@FileName like '02_Template_ReceiptEntry%')
	Exec AP5564 @xml, @DivisionID, @TranMonth, @TranYear, @EmployeeID
else if(@FileName like '03_Template_PayableEntry%')
	Exec AP5565 @xml, @DivisionID, @TranMonth, @TranYear, @EmployeeID
else if(@FileName like '04_Salary-PIT%')
	Exec AP5569 @xml, @DivisionID, @TranMonth, @TranYear, @EmployeeID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

