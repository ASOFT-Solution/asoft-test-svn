IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0305]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0305]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Lưu dữ liệu chấm công hiệu chỉnh (chấm công san phẩm theo ca - PPCĐ)
-- Create by Thanh Sơn on 11/10/2013
-- EXEC HP0305 'LAN01','CTY','PQS','BAOBI','VR.0001',10,2013,'','',10,'2013-10-11 09:13:29.000','ca 1'

CREATE PROCEDURE HP0305
(
    @TimesID VARCHAR(50), 
    @DivisionID VARCHAR(50),
    @DepartmentID VARCHAR(50),
    @TeamID VARCHAR(50),
    @EmployeeID VARCHAR(50),
    @TranMonth INT,
    @TranYear INT,
    @CreateUserID VARCHAR(50),			
    @ProductID VARCHAR(50),
    @Quantity DECIMAL(28, 8),
    @TrackingDate DATETIME,
    @ShiftID VARCHAR (50)
)
AS
INSERT HT0287(TimesID, TranMonth, TranYear, DivisionID, DepartmentID, TeamID, EmployeeID, ProductID, Quantity, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, TrackingDate, ShiftID) 
VALUES (@TimesID, @TranMonth, @TranYear, @DivisionID, @DepartmentID, @TeamID, @EmployeeID, @ProductID, @Quantity, @CreateUserID, GETDATE(), @CreateUserID, GETDATE(), @TrackingDate, @ShiftID) 


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

