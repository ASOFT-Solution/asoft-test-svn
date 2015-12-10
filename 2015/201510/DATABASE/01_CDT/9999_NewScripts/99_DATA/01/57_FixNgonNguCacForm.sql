Use CDT
--delete from DevLocalizer
IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'Button_Cancel')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,1 ,N'Button_Cancel' ,N'Bỏ qua')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'Button_Ok')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,2 ,N'Button_Ok' ,N'Chấp nhận')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'Button_Apply')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,4 ,N'Button_Apply' ,N'Áp dụng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PPF_Preview_Caption')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,5 ,N'PPF_Preview_Caption' ,N'Xem trước khi in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PreviewForm_Caption')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,6 ,N'PreviewForm_Caption' ,N'Xem trước khi in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_CustomizeBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,7 ,N'TB_CustomizeBtn_ToolTip' ,N'Điều chỉnh theo nhu cầu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Customize')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,8 ,N'TB_TTip_Customize' ,N'Điều chỉnh theo nhu cầu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_PrintBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,9 ,N'TB_PrintBtn_ToolTip' ,N'In')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Print')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,10 ,N'TB_TTip_Print' ,N'Hiển thị trang in ấn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_PrintDirectBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,11 ,N'TB_PrintDirectBtn_ToolTip' ,N'In trực tiếp')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_PrintDirect')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,12 ,N'TB_TTip_PrintDirect' ,N'In trực tiếp')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_PageSetupBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,13 ,N'TB_PageSetupBtn_ToolTip' ,N'Điều chỉnh trang in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_PageSetup')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,14 ,N'TB_TTip_PageSetup' ,N'Điều chỉnh trang in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_MagnifierBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,15 ,N'TB_MagnifierBtn_ToolTip' ,N'Chọn kính lúp')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Magnifier')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,16 ,N'TB_TTip_Magnifier ' ,N'Chọn kính lúp')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_ZoomInBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,17 ,N'TB_ZoomInBtn_ToolTip' ,N'Phóng to')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_ZoomIn')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,18 ,N'TB_TTip_ZoomIn' ,N'Phóng to')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_ZoomOutBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,19 ,N'TB_ZoomOutBtn_ToolTip' ,N'Thu nhỏ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_ZoomOut')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,20 ,N'TB_TTip_ZoomOut' ,N'Thu nhỏ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_ZoomBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,21 ,N'TB_ZoomBtn_ToolTip' ,N'Chọn tỉ lệ xem')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Zoom')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,22 ,N'TB_TTip_Zoom' ,N'Chọn tỉ lệ xem')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_SearchBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,23 ,N'TB_SearchBtn_ToolTip' ,N'Tìm kiếm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Search')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,24 ,N'TB_TTip_Search' ,N'Tìm kiếm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_FirstPageBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,25 ,N'TB_FirstPageBtn_ToolTip' ,N'Xem trang đầu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_FirstPage')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,26 ,N'TB_TTip_FirstPage' ,N'Xem trang đầu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_PreviousPageBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,27 ,N'TB_PreviousPageBtn_ToolTip' ,N'Xem trang trước')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_PreviousPage')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,28 ,N'TB_TTip_PreviousPage' ,N'Xem trang trước')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_NextPageBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,29 ,N'TB_NextPageBtn_ToolTip' ,N'Xem trang sau')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_NextPage')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,30 ,N'TB_TTip_NextPage' ,N'Xem trang sau')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_LastPageBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,31 ,N'TB_LastPageBtn_ToolTip' ,N'Xem trang cuối')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_LastPage')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,32 ,N'TB_TTip_LastPage' ,N'Xem trang cuối')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_MultiplePagesBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,33 ,N'TB_MultiplePagesBtn_ToolTip' ,N'Xem nhiều trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_MultiplePages')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,34 ,N'TB_TTip_MultiplePages' ,N'Xem nhiều trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_BackGroundBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,35 ,N'TB_BackGroundBtn_ToolTip' ,N'Chọn màu nền trang in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Backgr')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,36 ,N'TB_TTip_Backgr' ,N'Chọn màu nền trang in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_ClosePreviewBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,37 ,N'TB_ClosePreviewBtn_ToolTip' ,N'Thoát')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Close')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,38 ,N'TB_TTip_Close' ,N'Thoát')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_EditPageHFBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,39 ,N'TB_EditPageHFBtn_ToolTip' ,N'Nội dung đầu - cuối trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_EditPageHF')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,40 ,N'TB_TTip_EditPageHF' ,N'Nội dung đầu - cuối trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_HandToolBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,41 ,N'TB_TTip_EditPageHF' ,N'Chọn kéo bằng chuột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_HandTool')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,42 ,N'TB_TTip_HandTool' ,N'Chọn kéo bằng chuột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_ExportBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,43 ,N'TB_ExportBtn_ToolTip' ,N'Kết xuất ra tập tin')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Export')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,44 ,N'TB_TTip_Export' ,N'Kết xuất ra tập tin')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_SendBtn_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,45 ,N'TB_SendBtn_ToolTip' ,N'Kết xuất ra email')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Send')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,46 ,N'TB_TTip_Send' ,N'Kết xuất ra email')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_Watermark_ToolTip')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,50 ,N'TB_Watermark_ToolTip' ,N'In nổi chìm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Watermark')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,51 ,N'TB_TTip_Watermark' ,N'In nổi chìm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Scale')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,52 ,N'TB_TTip_Scale' ,N'Điều chỉnh kích cỡ nội dung')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Open')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,53 ,N'TB_TTip_Open' ,N'Mở')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Save')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,54 ,N'TB_TTip_Save' ,N'Lưu tài liệu in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_PageLayout')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID  ,StringName  ,Content) VALUES(N'PRV' ,57  ,N'MenuItem_PageLayout' ,N'Giao diện In')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'SB_PageOfPages')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,88 ,N'SB_PageOfPages' ,N'Trang {0} /{1}')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'Msg_CreatingDocument')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,110 ,N'Msg_CreatingDocument' ,N'Đang tạo tài liệu...')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_File')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,224 ,N'MenuItem_File' ,N'Tập tin')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'menuItem_View')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,225 ,N'menuItem_View' ,N'Xem')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'menuItem_Bacground')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,226 ,N'menuItem_Bacground' ,N'Nền trang in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_Background')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,226 ,N'MenuItem_Background' ,N'Nền trang in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_PageSetup')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,227 ,N'MenuItem_PageSetup' ,N'Điều chỉnh trang in')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_Print')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,228 ,N'MenuItem_Print' ,N'In (hiển thị hộp thoại in)')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_PrintDirec')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,229 ,N'MenuItem_Print' ,N'In trực tiếp')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_Export')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,230 ,N'MenuItem_Export' ,N'Kết xuất ra tập tin')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_Send')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,231 ,N'MenuItem_Send' ,N'Kết xuất ra email')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_Exit')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,232 ,N'MenuItem_Send' ,N'Thoát')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_ViewToolbar')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,233 ,N'MenuItem_ViewToolbar' ,N'Thanh công cụ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_ViewStatusbar')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,234 ,N'MenuItem_ViewStatusbar' ,N'Thanh trạng thái')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_ViewContinuous')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,235 ,N'MenuItem_ViewContinuous' ,N'Xem liên tiếp')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_ViewFacing')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,236 ,N'MenuItem_ViewFacing' ,N'Xem từng trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_BackgrColor')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,237 ,N'MenuItem_BackgrColor' ,N'Chọn màu nền')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_Watermark')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,238 ,N'MenuItem_Watermark' ,N'In nổi chìm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_ZoomPageWidth')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,239 ,N'MenuItem_ZoomPageWidth' ,N'Vừa trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_ZoomTextWidth')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,240 ,N'MenuItem_ZoomTextWidth' ,N'Vừa nội dung')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_ZoomWholePage ')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,241 ,N'MenuItem_ZoomWholePage ' ,N'Cả trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuItem_ZoomTwoPages')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,242 ,N'MenuItem_ZoomTwoPages' ,N'Hai trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PageInfo_PageNumberOfTotal')
INSERT INTO DevLocalizer (LocalizerTypeID  ,StringID ,StringName  ,Content) VALUES(N'PRV' ,244 ,N'PageInfo_PageNumberOfTotal' ,N'[Trang # trong tổng số #]')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'BarText_Toolbar') 
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID  ,StringName  ,Content) VALUES(N'PRV' ,250 ,N'BarText_Toolbar',N'Thanh công cụ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'BarText_MainMenu')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,251 ,N'BarText_MainMenu' ,N'Menu chính')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'BarText_StatusBar')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,252 ,N'BarText_StatusBar',N'Thanh trạng thái')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'ScalePopup_GroupText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,253 ,N'ScalePopup_GroupText ',N'Điều chỉnh kích cỡ nội dung')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'ScalePopup_AdjustTo')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,254 ,N'ScalePopup_AdjustTo',N'Điều chỉnh bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'ScalePopup_NormalSize')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,255 ,N'ScalePopup_NormalSize',N'Kích cỡ thông thường')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'ScalePopup_FitTo')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,256 ,N'ScalePopup_FitTo',N'Vừa khích với')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'ScalePopup_PagesWide')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,257 ,N'ScalePopup_PagesWide',N'Độ rộng trang')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'RibbonPreview_HandTool_STipTitle ')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,405 ,N'RibbonPreview_HandTool_STipTitle ',N'Chọn kéo bằng chuột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'RibbonPreview_Magnifier_Caption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,380 ,N'RibbonPreview_Magnifier_Caption',N'Chọn kính lúp')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'RibbonPreview_ZoomOut_Caption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,381 ,N'RibbonPreview_ZoomOut_Caption',N'Thu nhỏ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'RibbonPreview_ZoomIn_Caption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,383 ,N'RibbonPreview_ZoomIn_Caption',N'Phóng to')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'RibbonPreview_Scale_Caption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,394 ,N'RibbonPreview_Scale_Caption',N'Điều chỉnh kích cỡ nội dung')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'RibbonPreview_Save_Caption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,399 ,N'RibbonPreview_Save_Caption',N'Lưu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'RibbonPreview_Open_Caption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,400 ,N'RibbonPreview_Open_Caption',N'Mở')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TB_TTip_Open')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'PRV' ,53 ,N'TB_TTip_Open',N'Mở tài liệu in')

---GRD---------

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomizationCaption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,2 ,N'CustomizationCaption',N'Thêm bớt cột bằng cách kéo thả vào đây')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PopupFilterAll')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,6 ,N'PopupFilterAll',N'Tất cả')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PopupFilterCustom')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,7 ,N'PopupFilterCustom',N'Nhập điều kiện tìm kiếm cho cột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PopupFilterBlanks')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,8 ,N'PopupFilterBlanks',N'Tìm theo cột không có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PopupFilterNonBlanks')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,9 ,N'PopupFilterNonBlanks',N'Tìm theo cột có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogFormCaption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,10 ,N'CustomFilterDialogFormCaption',N'Nhập điều kiện tìm kiếm cho cột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogCaption')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,11 ,N'CustomFilterDialogCaption',N'Tìm số liệu có:')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogRadioAnd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,12 ,N'CustomFilterDialogRadioAnd',N'và')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogRadioOr')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,13 ,N'CustomFilterDialogRadioOr',N'hoặc')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogOkButton')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,14 ,N'CustomFilterDialogOkButton',N'Tìm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogClearFilter')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,15 ,N'CustomFilterDialogClearFilter',N'Hủy')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionEQU')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,18 ,N'CustomFilterDialogConditionEQU',N'bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionNEQ')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,19 ,N'CustomFilterDialogConditionNEQ',N'Khác')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionGT')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,20 ,N'CustomFilterDialogConditionGT',N'lớn hơn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionGTE')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,21 ,N'CustomFilterDialogConditionGTE',N'lớn hơn hoặc bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionLT')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,22 ,N'CustomFilterDialogConditionLT',N'nhỏ hơn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionLTE')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,23 ,N'CustomFilterDialogConditionLTE',N'nhỏ hơn hoặc bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionBlanks')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,24 ,N'CustomFilterDialogConditionBlanks',N'không có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionNonBlanks')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,25 ,N'CustomFilterDialogConditionNonBlanks',N'có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionLike')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,26 ,N'CustomFilterDialogConditionLike',N'giống')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogConditionNotLike')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,27 ,N'CustomFilterDialogConditionNotLike',N'không giống')

--IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogEmptyValue')
--INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,28 ,N'CustomFilterDialogEmptyValue',N'không có giá trị')
--
--IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CustomFilterDialogEmptyOperator')
--INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,29 ,N'CustomFilterDialogEmptyOperator',N'không có giá trị')



IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterSum')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,32 ,N'MenuFooterSum',N'Tính tổng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterMin')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,33 ,N'MenuFooterMin',N'Giá trị nhỏ nhất')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterMax')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,34 ,N'MenuFooterMax',N'Giá trị lớn nhất')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterCount')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,35 ,N'MenuFooterCount',N'Đếm số dòng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterAverage')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,36 ,N'MenuFooterAverage',N'Tính trung bình')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterNone')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,37 ,N'MenuFooterNone',N'Xóa')

/*IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterSumFormat')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,38 ,N'MenuFooterSumFormat',N'Tổng cộng=')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterMinFormat')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,39 ,N'MenuFooterMinFormat',N'Nhỏ nhất=')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterMaxFormat')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,40 ,N'MenuFooterMaxFormat',N'Lớn nhất=')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterCountFormat')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,41 ,N'MenuFooterCountFormat',N'Số dòng=')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterAverageFormat')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,42 ,N'MenuFooterAverageFormat',N'Trung bình=')*/

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnSortAscending')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,43 ,N'MenuColumnSortAscending',N'Sắp xếp tăng dần')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnSortDescending')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,44 ,N'MenuColumnSortDescending',N'Sắp xếp giảm dần')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnShowColumn')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,45 ,N'MenuColumnShowColumn',N'Nhóm theo cột này')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnRemoveColumn')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,46 ,N'MenuColumnRemoveColumn',N'Ẩn cột này')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnGroup')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,47 ,N'MenuColumnGroup',N'Nhóm theo cột này')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnUnGroup')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,48 ,N'MenuColumnUnGroup',N'Không nhóm theo cột này')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnColumnCustomization')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,49 ,N'MenuColumnColumnCustomization',N'Thêm bớt cột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnBestFit')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,51 ,N'MenuColumnBestFit',N'Tự động giãn cột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnFilter')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,52 ,N'MenuColumnFilter',N'Lọc theo cột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnClearFilter')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,53 ,N'MenuColumnClearFilter',N'Loại bỏ mọi điều kiện tìm kiếm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnBestFitAllColumns')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,54 ,N'MenuColumnBestFitAllColumns',N'Tự động giãn tất cả cột')


IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnGroupSummaryEditor')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,70 ,N'MenuColumnGroupSummaryEditor',N'Tổng cộng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnFilterMode')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,72 ,N'MenuColumnFilterMode',N'Lọc theo...')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnFilterModeValue')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,73 ,N'MenuColumnFilterModeValue',N'Theo giá trị')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnFilterModeDisplayText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,74 ,N'MenuColumnFilterModeDisplayText',N'Theo chữ hiển thị')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuGroupPanelFullExpand')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,75 ,N'MenuGroupPanelFullExpand',N'Mở rộng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuGroupPanelFullCollapse')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,76 ,N'MenuGroupPanelFullCollapse',N'Thu vào')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuGroupPanelClearGrouping')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,77 ,N'MenuGroupPanelClearGrouping',N'Hủy chế độ nhóm theo cột')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuGroupPanelShow')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,78 ,N'MenuGroupPanelShow',N'Mở bảng nhóm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuGroupPanelHide')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,79 ,N'MenuGroupPanelHide',N'Đóng bảng nhóm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnClearSorting')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,97 ,N'MenuColumnClearSorting',N'Bỏ sắp xếp')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnFilterEditor')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,98 ,N'MenuColumnFilterEditor',N'Tìm kiếm nâng cao')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnAutoFilterRowHide')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,99 ,N'MenuColumnAutoFilterRowHide',N'Ẩn dòng lọc dữ liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnAutoFilterRowShow')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,100 ,N'MenuColumnAutoFilterRowShow',N'Hiển thị dòng lọc dữ liệu')


IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnFindFilterHide')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,101 ,N'MenuColumnFindFilterHide',N'Ẩn tìm kiếm nhanh')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuColumnFindFilterShow')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,102 ,N'MenuColumnFindFilterShow',N'Hiển thị tìm kiếm nhanh')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterBuilderOkButton')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,103 ,N'FilterBuilderOkButton',N'Đồng ý')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterBuilderCancelButton')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,104 ,N'FilterBuilderCancelButton',N'Hủy bỏ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterBuilderApplyButton')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,105 ,N'FilterBuilderApplyButton',N'Chấp nhận')


IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'GroupSummaryEditorSummarySum')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,176 ,N'GroupSummaryEditorSummarySum',N'Tính tổng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FindControlFindButton')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,178 ,N'FindControlFindButton',N'Tìm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FindControlClearButton')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,179 ,N'FindControlClearButton',N'Đóng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterAddSummaryItem')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,182 ,N'MenuFooterAddSummaryItem',N'Thêm thống kê')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'MenuFooterClearSummaryItems')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'GRD' ,183 ,N'MenuFooterClearSummaryItems',N'Xóa thống kê')

--EDT
IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CheckChecked')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,3 ,N'CheckChecked',N'Đánh dấu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CheckUnchecked')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,4 ,N'CheckUnchecked',N'Không đánh dấu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'CheckIndeterminate')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,5 ,N'CheckIndeterminate',N'Chưa xác định')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'DateEditToday')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,6 ,N'DateEditToday',N'Hôm nay')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'DateEditClear')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,7 ,N'DateEditClear',N'Xóa')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'OK')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,8 ,N'OK',N'Chấp nhận')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'Cancel')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,9 ,N'Cancel',N'Hủy bỏ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorFirstButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,10 ,N'NavigatorFirstButtonHint',N'đầu tiên')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorPreviousButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,11 ,N'NavigatorPreviousButtonHint',N'trước')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorPreviousPageButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,12 ,N'NavigatorPreviousPageButtonHint',N'Trang trước')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorNextButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,13 ,N'NavigatorNextButtonHint',N'Tiếp theo')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorNextPageButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,14 ,N'NavigatorNextPageButtonHint',N'Trang sau')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorLastButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,15 ,N'NavigatorLastButtonHint',N'Cuối cùng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorAppendButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,16 ,N'NavigatorAppendButtonHint',N'Mở rộng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorRemoveButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,17 ,N'NavigatorRemoveButtonHint',N'Xóa')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorEditButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,18 ,N'NavigatorEditButtonHint',N'Sửa')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorEndEditButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,19 ,N'NavigatorEndEditButtonHint',N'Lưu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavigatorCancelEditButtonHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,20 ,N'NavigatorCancelEditButtonHint',N'Hủy')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PictureEditMenuCut')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,22 ,N'PictureEditMenuCut',N'Cắt hình')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PictureEditMenuCopy')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,23 ,N'PictureEditMenuCopy',N'Sao chép')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PictureEditMenuPaste')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,24 ,N'PictureEditMenuPaste',N'Dán hình')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PictureEditMenuDelete')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,25 ,N'PictureEditMenuDelete',N'Xóa hình')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PictureEditMenuLoad')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,26 ,N'PictureEditMenuLoad',N'Nạp hình')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PictureEditMenuSave')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,27 ,N'PictureEditMenuSave',N'Lưu hình')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PictureEditOpenFileTitle')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,30 ,N'PictureEditOpenFileTitle',N'Chọn hình ảnh')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'PictureEditSaveFileTitle')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,31 ,N'PictureEditSaveFileTitle',N'Lưu hình ảnh')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TabHeaderButtonPrev')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,56 ,N'TabHeaderButtonPrev',N'Trước')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TabHeaderButtonNext')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,57 ,N'TabHeaderButtonNext',N'Tiếp theo')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TabHeaderButtonClose')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,58 ,N'TabHeaderButtonClose',N'Đóng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'XtraMessageBoxOkButtonText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,59 ,N'XtraMessageBoxOkButtonText',N'Đồng ý')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'XtraMessageBoxCancelButtonText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,60 ,N'XtraMessageBoxCancelButtonText',N'Hủy bỏ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'XtraMessageBoxYesButtonText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,61 ,N'XtraMessageBoxYesButtonText',N'Có')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'XtraMessageBoxNoButtonText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,62 ,N'XtraMessageBoxNoButtonText',N'Không')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'XtraMessageBoxAbortButtonText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,63 ,N'XtraMessageBoxAbortButtonText',N'Bỏ dở')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'XtraMessageBoxRetryButtonText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,64 ,N'XtraMessageBoxRetryButtonText',N'Thử lại')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'XtraMessageBoxIgnoreButtonText')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,65 ,N'XtraMessageBoxIgnoreButtonText',N'Lờ đi')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TextEditMenuUndo')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,66 ,N'TextEditMenuUndo',N'Trở lại')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TextEditMenuCut')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,67 ,N'TextEditMenuCut',N'Cắt')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TextEditMenuCopy')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,68 ,N'TextEditMenuCopy',N'Sao chép')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TextEditMenuPaste')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,69 ,N'TextEditMenuPaste',N'Dán')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TextEditMenuDelete')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,70 ,N'TextEditMenuDelete',N'Xóa')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'TextEditMenuSelectAll')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,71 ,N'TextEditMenuSelectAll',N'Chọn tất cả')


IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterGroupAnd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,75 ,N'FilterGroupAnd',N'Và')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterGroupNotAnd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,76 ,N'FilterGroupNotAnd',N'Và không')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterGroupNotOr')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,77 ,N'FilterGroupNotOr',N'Hoặc không')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterGroupOr')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,78 ,N'FilterGroupOr',N'Hoặc')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseAnyOf')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,79 ,N'FilterClauseAnyOf',N'được chứa trong')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseBeginsWith')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,80 ,N'FilterClauseBeginsWith',N'bắt đầu với')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseBetween')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,81 ,N'FilterClauseBetween',N'trong khoảng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseBetweenAnd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,82 ,N'FilterClauseBetweenAnd',N'trong khoảng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseContains')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,83 ,N'FilterClauseContains',N'và')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseEndsWith')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,84 ,N'FilterClauseEndsWith',N'kết thúc bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseEquals')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,85 ,N'FilterClauseEquals',N'bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseGreater')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,86 ,N'FilterClauseGreater',N'lớn hơn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseGreaterOrEqual')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,87 ,N'FilterClauseGreaterOrEqual',N'lớn hơn hoặc bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseIsNotNull')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,88 ,N'FilterClauseIsNotNull',N'có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseIsNull')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,89 ,N'FilterClauseIsNull',N'không có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseLess')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,90 ,N'FilterClauseLess',N'nhỏ hơn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseLessOrEqual')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,91 ,N'FilterClauseLessOrEqual',N'nhỏ hơn hoặc bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseLike')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,92 ,N'FilterClauseLike',N'giống')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseNoneOf')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,93 ,N'FilterClauseNoneOf',N'không được chứa trong')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseNotBetween')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,94 ,N'FilterClauseNotBetween',N'ngoài khoảng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseDoesNotContain')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,95 ,N'FilterClauseDoesNotContain',N'không bao gồm')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseDoesNotEqual')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,96 ,N'FilterClauseDoesNotEqual',N'khác')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterClauseNotLike')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,97 ,N'FilterClauseNotLike',N'không giống')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterEmptyEnter')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,98 ,N'FilterEmptyEnter',N'nhập giá trị')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterEmptyParameter')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,99 ,N'FilterEmptyParameter',N'Thêm một điều kiện')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterMenuAddNewParameter')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,100 ,N'FilterMenuAddNewParameter',N'Thêm nhóm điều kiện')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterEmptyValue')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,101 ,N'FilterEmptyValue',N'Xóa mọi điều kiện')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterMenuConditionAdd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,102 ,N'FilterMenuConditionAdd',N'Thêm điều kiện')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterMenuGroupAdd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,103 ,N'FilterMenuGroupAdd',N'Thêm nhóm điều kiện')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterMenuClearAll')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,104 ,N'FilterMenuClearAll',N'Xóa mọi  điều kiện')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterMenuRowRemove')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,105 ,N'FilterMenuRowRemove',N'Xóa')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterToolTipNodeAdd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,106 ,N'FilterToolTipNodeAdd',N'Thêm một điều kiện vào nhóm này')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterToolTipNodeRemove')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,107 ,N'FilterToolTipNodeRemove',N'Xóa điều kiện này')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterToolTipKeysAdd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,111 ,N'FilterToolTipKeysAdd',N'Dùng phím Insert hoặc + trên bàn phím')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterToolTipKeysRemove')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,112 ,N'FilterToolTipKeysRemove',N'Dùng phím Delete hoặc - trên bàn phím')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringGroupOperatorAnd')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,114 ,N'FilterCriteriaToStringGroupOperatorAnd',N'và')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringGroupOperatorOr')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,115 ,N'FilterCriteriaToStringGroupOperatorOr',N'hoặc')

--IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringUnaryOperatorBitwise')
--INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,116 ,N'FilterCriteriaToStringUnaryOperatorBitwise',N'có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringUnaryOperatorIsNull')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,117 ,N'FilterCriteriaToStringUnaryOperatorIsNull',N'có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringUnaryOperatorMinus')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,118 ,N'FilterCriteriaToStringUnaryOperatorMinus',N'trừ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringUnaryOperatorNot')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,119 ,N'FilterCriteriaToStringUnaryOperatorNot',N'không')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringUnaryOperatorPlus')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,120 ,N'FilterCriteriaToStringUnaryOperatorPlus',N'cộng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorDivide')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,124 ,N'FilterCriteriaToStringBinaryOperatorDivide',N'chia')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorEqual')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,125 ,N'FilterCriteriaToStringBinaryOperatorEqual',N'bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorGreater')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,126 ,N'FilterCriteriaToStringBinaryOperatorGreater',N'lớn hơn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorGreaterOrEqual')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,127 ,N'FilterCriteriaToStringBinaryOperatorGreaterOrEqual',N'lớn hơn hoặc bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorLess')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,128 ,N'FilterCriteriaToStringBinaryOperatorLess',N'nhỏ hơn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorLessOrEqual')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,129 ,N'FilterCriteriaToStringBinaryOperatorLessOrEqual',N'nhỏ hơn hoặc bằng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorLike')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,130 ,N'FilterCriteriaToStringBinaryOperatorLike',N'giống')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorMinus')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,131 ,N'FilterCriteriaToStringBinaryOperatorMinus',N'trừ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorMultiply')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,133 ,N'FilterCriteriaToStringBinaryOperatorMultiply',N'nhân')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorNotEqual')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,134 ,N'FilterCriteriaToStringBinaryOperatorNotEqual',N'khác')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBinaryOperatorPlus')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,135 ,N'FilterCriteriaToStringBinaryOperatorPlus',N'cộng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringBetween')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,136 ,N'FilterCriteriaToStringBetween',N'trong khoảng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringIn')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,137 ,N'FilterCriteriaToStringIn',N'có trong')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringIsNotNull')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,138 ,N'FilterCriteriaToStringIsNotNull',N'có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringNotLike')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,139 ,N'FilterCriteriaToStringNotLike',N'không giống')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionIsNull')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,141 ,N'FilterCriteriaToStringFunctionIsNull',N'không có số liệu')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionLen')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,142 ,N'FilterCriteriaToStringFunctionLen',N'độ dài')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionLower')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,143 ,N'FilterCriteriaToStringFunctionLower',N'viết thường')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionNone')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,144 ,N'FilterCriteriaToStringFunctionNone',N'không')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionSubstring')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,145 ,N'FilterCriteriaToStringFunctionSubstring',N'chuỗi con')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionTrim')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,146 ,N'FilterCriteriaToStringFunctionTrim',N'loại bỏ khoảng trắng')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionUpper')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,147 ,N'FilterCriteriaToStringFunctionUpper',N'viết hoa')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionCustom')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,174 ,N'FilterCriteriaToStringFunctionCustom',N'tùy chọn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaToStringFunctionCustom')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,174 ,N'FilterCriteriaToStringFunctionCustom',N'tùy chọn')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'ProgressPrinting')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,260 ,N'ProgressPrinting',N'Đang in...')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'ProgressCreateDocument')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,261 ,N'ProgressCreateDocument',N'Tạo tài liệu...')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'ProgressCancel')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,262 ,N'ProgressCancel',N'Hủy bỏ')


IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'FilterCriteriaInvalidExpressionEx')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'EDT' ,247 ,N'FilterCriteriaInvalidExpressionEx',N'So sánh với giá trị nhập/trường số liệu khác')

--NAV
IF NOT EXISTS(SELECT TOP 1 1 FROM LocalizerType WHERE LocalizerTypeID = N'NAV')
INSERT INTO LocalizerType (LocalizerTypeID, [Name])  VALUES(N'NAV' , N'NavBar Controls')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavPaneMenuShowMoreButtons')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'NAV' ,0 ,N'NavPaneMenuShowMoreButtons',N'Hiển thị thêm một nghiệp vụ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavPaneMenuShowFewerButtons')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'NAV' ,1 ,N'NavPaneMenuShowFewerButtons',N'Ẩn một nghiệp vụ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavPaneMenuAddRemoveButtons')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'NAV' ,2 ,N'NavPaneMenuAddRemoveButtons',N'Hiển thị/Ẩn nhiều nghiệp vụ')

IF NOT EXISTS(SELECT TOP 1 1 FROM DevLocalizer WHERE StringName = N'NavPaneChevronHint')
INSERT INTO DevLocalizer (LocalizerTypeID ,StringID ,StringName  ,Content)  VALUES(N'NAV' ,3 ,N'NavPaneChevronHint',N'Cấu hình hiển thị nghiệp vụ')

--select * from devlocalizer --where Content like N'%bằng%'
--where LocalizerTypeID = N'GRD' --and Content like N'%bằng%'
--and Content like N'%Kết%'
--Update devlocalizer set StringID = 1000 where Content = N'Thông số kết xuất excel'

--where LocalizerTypeID = N'PRV'




              