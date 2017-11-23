//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     16/07/2014      Đức Quý         Tạo mới
//####################################################################
$(document).ready(function () {

});

//Sự kiện hiển thị các màn hình in
function getFilter_Click(e) {
    var gridElement = $(e).closest('.asf-grid');
    grid = ASOFT.asoftGrid.castName(gridElement.attr('id'));

    var selectedRecord = ASOFT.asoftGrid.selectedRecord(grid);

    var data = {};
    var postUrl = "";
    if (selectedRecord.ReportID != "POSR0007" && selectedRecord.ReportID != "POSR00711" && selectedRecord.ReportID != "POSR30091" && selectedRecord.ReportID != "POSR30101" && selectedRecord.ReportID != "POSR30111" && selectedRecord.ReportID != "POSR30121" && selectedRecord.ReportID != "POSR30131")
        postUrl = ASOFT.helper.renderUrl('/POS/' + selectedRecord.FormID, data);
    else {
        data = { ReportID: selectedRecord.ReportID, Area: "AsoftPOS", ScreenID: selectedRecord.FormID };
        postUrl = ASOFT.helper.renderUrl('/ReportLayout/GetFilterScreen', data);
    }

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}

