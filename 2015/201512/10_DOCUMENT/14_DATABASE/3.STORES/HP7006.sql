
/****** Object:  StoredProcedure [dbo].[HP7006]    Script Date: 08/05/2010 10:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create Date: 20/09/2005
---Purpose: In bao cao luong theo thiet lap cua nguoi dung
--Code written by : Luong Bao Anh

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP7006]
       @DivisionID nvarchar(50) ,
       @ReportCode nvarchar(50) ,
       @FromDepartmentID nvarchar(50) ,
       @ToDepartmentID nvarchar(50) ,
       @TeamID nvarchar(50) ,
       @FromEmployeeID nvarchar(50) ,
       @ToEmployeeID nvarchar(50) ,
       @FromMonth int ,
       @FromYear int ,
       @ToMonth int ,
       @ToYear int ,
       @lstPayrollMethodID AS nvarchar(50) , -----phuong phap tinh luong
       @IsGroup tinyint , ----- 1 la tong hop, 0 la chi tiet
       @GroupFactor nvarchar(50)----tong hop theo phong ban hay to nhom

AS
DECLARE @sSQL varchar(8000)





IF @IsGroup = 1
   BEGIN
         IF @GroupFactor = 'Dept'
            BEGIN
                  EXEC HP7010 @DivisionID , @ReportCode , @FromDepartmentID , @ToDepartmentID , @TeamID , @FromEmployeeID , @ToEmployeeID , @FromMonth , @FromYear , @ToMonth , @ToYear , @lstPayrollMethodID
            END
         ELSE
            BEGIN
                  EXEC HP7009 @DivisionID , @ReportCode , @FromDepartmentID , @ToDepartmentID , @TeamID , @FromEmployeeID , @ToEmployeeID , @FromMonth , @FromYear , @ToMonth , @ToYear , @lstPayrollMethodID
            END

   END
ELSE
   BEGIN----KHONG NHOM
         EXEC HP7008 @DivisionID , @ReportCode , @FromDepartmentID , @ToDepartmentID , @TeamID , @FromEmployeeID , @ToEmployeeID , @FromMonth , @FromYear , @ToMonth , @ToYear , @lstPayrollMethodID
   END