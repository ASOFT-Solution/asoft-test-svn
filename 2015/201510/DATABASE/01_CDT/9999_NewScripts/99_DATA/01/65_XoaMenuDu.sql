USE [CDT]
GO

DECLARE @sysSiteIDPRO AS INT
DECLARE @sysSiteIDSTD AS INT
DECLARE @sysMenuModuleID INT
DECLARE @sysMenuParentID INT
DECLARE @sysMenuID INT
DECLARE @menuName nvarchar (250)

SELECT @sysSiteIDPRO = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'PRO'

IF Isnull(@sysSiteIDPRO, '') <> ''
BEGIN
--Quản lý kho
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Quản lý kho' and sysSiteID = @sysSiteIDPRO
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Danh Mục' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID
set @menuName = N'Vật tư lắp ráp, tháo dỡ'
----Xóa dữ liệu
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

--Tổng hợp
---Phiếu kế toán
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Tổng hợp' and sysSiteID = @sysSiteIDPRO
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Chứng từ' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID

set @menuName = N'Đăng ký chứng từ ghi sổ'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

---Quản lý nghiệp vụ
set @menuName = N'Quản lý nghiệp vụ'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

---Số dư
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Số dư' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID
----Số dư tài khoản
set @menuName = N'Số dư tài khoản'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

--Công nợ phải thu
----Số dư
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Công nợ phải thu' and sysSiteID = @sysSiteIDPRO
set @menuName = N'Số dư'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuModuleID,@menuName --Menu này phải xóa bằng moduleID
----Vào số dư đầu kỳ công nợ phải thu
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Số dư' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID
set @menuName = N'Vào số dư đầu kỳ công nợ phải thu'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

--Công nợ phải trả
----Số dư
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Công nợ phải trả' and sysSiteID = @sysSiteIDPRO
set @menuName = N'Số dư'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuModuleID,@menuName --Menu này phải xóa bằng moduleID

----Vào số dư đầu kỳ công nợ phải thu
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Số dư' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID
set @menuName = N'Vào số dư đầu kỳ công nợ phải trả'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

--Thuế GTGT
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Thuế GTGT' and sysSiteID = @sysSiteIDPRO
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Báo cáo' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID

----Bảng kê chứng từ thuế GTGT mua vào
set @menuName = N'Bảng kê chứng từ thuế GTGT mua vào'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

---Bảng kê chứng từ thuế GTGT bán ra
set @menuName = N'Bảng kê chứng từ thuế GTGT bán ra'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

---Tờ khai thuế GTGT
set @menuName = N'Tờ khai thuế GTGT'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

--Thuế Khác
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Thuế khác' and sysSiteID = @sysSiteIDPRO
---Tạo tờ khai thuế TNDN
set @menuName = N'Tờ khai thuế GTGT'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuModuleID,@menuName --Menu này xóa bằng module

---Bảng kê chứng từ thuế TTĐB mua vào
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Báo cáo' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID

set @menuName = N'Bảng kê chứng từ thuế TTĐB mua vào'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName 

---Bảng kê chứng từ thuế TTĐB bán ra
set @menuName = N'Bảng kê chứng từ thuế TTĐB bán ra'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

---Tờ khai thuế TTDB
set @menuName = N'Tờ khai thuế TTDB'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

---Tờ khai Quyết toán thuế TNDN 03 - TT28
set @menuName = N'Tờ khai Quyết toán thuế TNDN 03 - TT28'
exec DeleteMenuDu @sysSiteIDPRO,@sysMenuParentID,@menuName

END


------------------------------------------------STD--------------------------
SELECT @sysSiteIDSTD = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'STD'

IF Isnull(@sysSiteIDSTD, '') <> ''
BEGIN
--Quản lý kho
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Quản lý kho' and sysSiteID = @sysSiteIDSTD
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Danh Mục' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID
set @menuName = N'Vật tư lắp ráp, tháo dỡ'
----Xóa dữ liệu
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

--Tổng hợp
---Phiếu kế toán
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Tổng hợp' and sysSiteID = @sysSiteIDSTD
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Chứng từ' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID

set @menuName = N'Đăng ký chứng từ ghi sổ'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

---Quản lý nghiệp vụ
set @menuName = N'Quản lý nghiệp vụ'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

---Số dư
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Số dư' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID
----Số dư tài khoản
set @menuName = N'Số dư tài khoản'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

--Công nợ phải thu
----Số dư
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Công nợ phải thu' and sysSiteID = @sysSiteIDSTD
set @menuName = N'Số dư'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuModuleID,@menuName --Menu này phải xóa bằng moduleID
----Vào số dư đầu kỳ công nợ phải thu
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Số dư' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID
set @menuName = N'Vào số dư đầu kỳ công nợ phải thu'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

--Công nợ phải trả
----Số dư
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Công nợ phải trả' and sysSiteID = @sysSiteIDSTD
set @menuName = N'Số dư'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuModuleID,@menuName --Menu này phải xóa bằng moduleID

----Vào số dư đầu kỳ công nợ phải thu
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Số dư' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID
set @menuName = N'Vào số dư đầu kỳ công nợ phải trả'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

--Thuế GTGT
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Thuế GTGT' and sysSiteID = @sysSiteIDSTD
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Báo cáo' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID

----Bảng kê chứng từ thuế GTGT mua vào
set @menuName = N'Bảng kê chứng từ thuế GTGT mua vào'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

---Bảng kê chứng từ thuế GTGT bán ra
set @menuName = N'Bảng kê chứng từ thuế GTGT bán ra'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

---Tờ khai thuế GTGT
set @menuName = N'Tờ khai thuế GTGT'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

--Thuế Khác
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Thuế khác' and sysSiteID = @sysSiteIDSTD
---Tạo tờ khai thuế TNDN
set @menuName = N'Tờ khai thuế GTGT'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuModuleID,@menuName --Menu này xóa bằng module

---Bảng kê chứng từ thuế TTĐB mua vào
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Báo cáo' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID

set @menuName = N'Bảng kê chứng từ thuế TTĐB mua vào'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName 

---Bảng kê chứng từ thuế TTĐB bán ra
set @menuName = N'Bảng kê chứng từ thuế TTĐB bán ra'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

---Tờ khai thuế TTDB
set @menuName = N'Tờ khai thuế TTDB'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName

---Tờ khai Quyết toán thuế TNDN 03 - TT28
set @menuName = N'Tờ khai Quyết toán thuế TNDN 03 - TT28'
exec DeleteMenuDu @sysSiteIDSTD,@sysMenuParentID,@menuName
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteMenuDu]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteMenuDu]