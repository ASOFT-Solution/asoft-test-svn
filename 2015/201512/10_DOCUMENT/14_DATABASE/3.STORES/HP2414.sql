IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2414]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2414]
GO
/****** Object: StoredProcedure [dbo].[HP2414] Script Date: 11/21/2011 09:58:03 ******/
---- Modified on 06/08/2015 by Thanh Thịnh: Thay Đổi APK là primarykey
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[HP2414] 
    @TimesID NVARCHAR(50), 
    @DivisionID NVARCHAR(50),
    @DepartmentID NVARCHAR(50),
    @TeamID NVARCHAR(50),
    @EmployeeID NVARCHAR(50),
    @TranMonth INT,
    @TranYear INT,
    @CreateUserID NVARCHAR(50),			
    @ProductID NVARCHAR(50),
    @Quantity DECIMAL(28, 8),
    @TrackingDate DATETIME
AS

DECLARE
    @DepartmentID1 NVARCHAR(50),
    @TeamID1 NVARCHAR(50)

-- XÓA CÁC SẢN PHẨM KHI CHẤM CÔNG KHÔNG CÓ TRACKING DATE HAY CÓ TRACKING DATE
IF (ISNULL(@TrackingDate,'1-JAN-1900') = '1-JAN-1900')
	BEGIN
		DELETE FROM HT2403 
			WHERE TimesID = @TimesID 
				AND TranMonth = @TranMonth AND TranYear = @TranYear 
				AND DivisionID = @DivisionID 
				AND TrackingDate IS NOT NULL
	END
ELSE
	BEGIN
		DELETE FROM HT2403 
			WHERE TimesID = @TimesID 
				AND TranMonth = @TranMonth AND TranYear = @TranYear 
				AND DivisionID = @DivisionID 
				AND ISNULL(TrackingDate,'1-JAN-1900') = '1-JAN-1900'
	END

IF NOT EXISTS (SELECT 1 FROM HT2403 WHERE EmployeeID = @EmployeeID AND TimesID = @TimesID AND TranMonth = @TranMonth AND TranYear = @TranYear AND ProductID = @ProductID AND DivisionID = @DivisionID  AND ISNULL(TrackingDate,'1-JAN-1900') = ISNULL(@TrackingDate,'1-JAN-1900'))
    BEGIN
        SELECT @DepartmentID1= DepartmentID, @TeamID1 = TeamID 
        FROM HT1400
        WHERE DivisionID = @DivisionID AND EmployeeID = @EmployeeID 

        INSERT HT2403(TimesID, TranMonth, TranYear, DivisionID, DepartmentID, TeamID, EmployeeID, ProductID, Quantity, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, TrackingDate) 
        VALUES (@TimesID, @TranMonth, @TranYear, @DivisionID, @DepartmentID1, @TeamID1, @EmployeeID, @ProductID, @Quantity, @CreateUserID, GETDATE(), @CreateUserID, GETDATE(), @TrackingDate) 
    END
ELSE
    UPDATE HT2403 SET 
	Quantity = @Quantity, 
	LastModifyUserID = @CreateUserID, 
	LastModifyDate = GETDATE()
    WHERE EmployeeID = @EmployeeID 
		AND TimesID = @TimesID AND TranMonth = @TranMonth 
		AND TranYear = @TranYear AND ProductID = @ProductID 
		AND DivisionID = @DivisionID
		AND ISNULL(TrackingDate,'1-JAN-1900') = ISNULL(@TrackingDate,'1-JAN-1900')
GO


