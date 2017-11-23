//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/01/2016     Quang Chiến       Tạo mới
//####################################################################
var URL_INSERTORUPDATE = '/HRM/HF0403';
$(document).ready(function () {
    $("#btnImport").kendoButton({
        "click": btnImport_Click,
    });
})

function CustomerChangedData() {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    datamaster.DepartmentID_HF0402 = datamaster.DepartmentID_HF0402.split(',').join("','");
    return datamaster;
}


// Add new button events
function btnImport_Click() {
    // [2] Url load dữ liệu lên form
    var postUrl = "/Import/Index";

    // [3] Data load dữ liệu lên form
    var data = {
        type: "FirstVacationDays"
    };

    // [4] Hiển thị popup
    showPopup(postUrl, data);
};

function showPopup (url, data) {
    // [1] Format url with object data
    var postUrl = ASOFT.helper.renderUrl(url, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}

function ShowEditorFrame() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(URL_INSERTORUPDATE+"?FormStatus=1", {});
}

function ShowUpdateFrame() {
    ASOFT.form.clearMessageBox();

    var grid = $('#GridHT1420').data('kendoGrid');
        var args = [];
        if (grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].EmployeeID);
            }
        }

        ASOFT.asoftPopup.showIframe(URL_INSERTORUPDATE + "?FormStatus=2&LstEmployeeID="+args.join(","), {});
}