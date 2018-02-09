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

    var list = [
        "POSR0007",
        "POSR00711",
        "POSR30091",
        "POSR30101",
        "POSR30111",
        "POSR30121",
        "POSR30141",
        "POSR30161",
        "POSR30181",
        "POSR30171",
        "POSR30151",
        "POSR30201",
        "POSR30191",
        "POSR30211",
        "POSR30221",
        "POSR30241"
    ];

    if (list.indexOf(selectedRecord.ReportID) == -1)
        postUrl = ASOFT.helper.renderUrl('/POS/' + selectedRecord.FormID, data);
    else {
        data = { ReportID: selectedRecord.ReportID, Area: "AsoftPOS", ScreenID: selectedRecord.FormID };
        postUrl = ASOFT.helper.renderUrl('/ReportLayout/GetFilterScreen', data);
    }

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}

