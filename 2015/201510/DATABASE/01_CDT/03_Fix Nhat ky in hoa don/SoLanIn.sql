USE [CDT]

DELETE sysMenu WHERE sysMenuID IN (3203)
DELETE sysReport WHERE sysReportID IN (84)
DELETE sysReportFilter WHERE sysReportFilterID IN (1582, 1583, 1584, 1585)
DELETE sysFormReport WHERE sysFormReportID IN (60)

SET IDENTITY_INSERT sysMenu ON
INSERT INTO sysMenu(sysMenuID, MenuName, MenuName2, sysSiteID, CustomType, sysTableID, sysReportID, MenuOrder, ExtraSql, sysMenuParent, MenuPluginID, PluginName, UIType, Image)
VALUES(3203, N'Tổng hợp nhật ký in hóa đơn', N'Print history', NULL, NULL, NULL, 84, 7, NULL, 381, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT sysMenu OFF

SET IDENTITY_INSERT sysReport ON
INSERT INTO sysReport(sysReportID, ReportName, RpType, mtTableID, dtTableID, Query, ReportFile, ReportName2, ReportFile2, sysReportParentID, LinkField, ColField, ChartField1, ChartField2, ChartField3, sysPackageID, mtAlias, dtAlias, TreeData)
VALUES(84, N'Tổng hợp nhật ký in hóa đơn', 0, 222, NULL, N'SELECT u.UserName AS N''Người in'', m.MenuName AS N''Tên menu'', h.PkValue AS N''Số chứng từ'', COUNT(sysHistoryID) AS N''Số lần in'' FROM sysHistory h INNER JOIN sysUser u ON u.sysUserID = h.sysUserID INNER JOIN sysMenu m ON m.sysMenuID = h.sysMenuID WHERE Action = ''In'' GROUP BY u.UserName, m.MenuName, h.PkValue ORDER BY u.UserName, m.MenuName, h.PkValue ', NULL, N'Tổng hợp nhật ký in hóa đơn E', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, N'h', NULL, NULL)
SET IDENTITY_INSERT sysReport OFF

SET IDENTITY_INSERT sysReportFilter ON
INSERT INTO sysReportFilter(sysReportFilterID, sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
SELECT 1582, 2089, 1, NULL, 84, 1, 0, 1, 1, 0, NULL
UNION ALL
SELECT 1583, 2090, 1, NULL, 84, 0, 0, 1, 1, 0, NULL
UNION ALL
SELECT 1584, 2091, 1, NULL, 84, 0, 0, 1, 1, 0, NULL
UNION ALL
SELECT 1585, 2092, 1, NULL, 84, 0, 0, 1, 1, 0, NULL
SET IDENTITY_INSERT sysReportFilter OFF

SET IDENTITY_INSERT sysFormReport ON
INSERT INTO sysFormReport(sysFormReportID, sysReportID, ReportName, ReportFile, ReportName2, ReportFile2)
VALUES(60, 84, N'Tổng hợp nhật ký in hóa đơn', NULL, N'Tổng hợp nhật ký in hóa đơn E', NULL)
SET IDENTITY_INSERT sysFormReport OFF

-- TEST
--select * from sysMenu WHERE sysMenuID IN (3203)
--select * from sysReport WHERE sysReportID IN (84)
--select * from sysReportFilter WHERE sysReportFilterID IN (1582, 1583, 1584, 1585, 1586)
--select * from sysFormReport WHERE sysFormReportID IN (60)