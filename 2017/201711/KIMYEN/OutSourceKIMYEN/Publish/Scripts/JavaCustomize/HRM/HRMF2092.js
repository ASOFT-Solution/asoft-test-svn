$(document).ready(function () {

    SwapControls();

});

function CustomizePanalSelect(tb, gridDT) {
    if (gridDT.element.context.id == 'GridHRMT2091') {
        gridDT.hideColumn(1);
        gridDT.hideColumn(2);
        gridDT.bind('dataBound', function (e) {
            var data = gridDT.dataSource.data();
            for (var i = 0; i < data.length; i++) {
                if (data[i].InheritID && data[i].ID != "") {
                    gridDT.showColumn(2);
                    break;
                }
            }
        });
    }
}

function ChooseEmployeeID_Click() {
}

/**
 * Thay đổi vị trí các controls
 * @returns {} 
 * @since [Văn Tài] Created [21/11/2017]
 */
function SwapControls() {
  
    $(".FromDate").parent().before($(".TrainingCourseName").parent());
    $(".ToDate").parent().before($(".FromDate").parent());
};

/**
 * Export Success
 * @returns {} 
 * @since [Thanh Trong] Created [14/12/2017]
 */
function ExportSuccess(result) {
    if (result) {
        var urlPost = '/ContentMaster/ReportViewer';
        var options = '&viewer=pdf';
        var RM = '&Module=HRM&ScreenID=HRMF2092';
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options + RM;
        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}

/**
 * Click Button Print
 * @returns {} 
 * @since [Thanh Trong] Created [14/12/2017]
 */
function CustomerPrint() {
    var urlview = new URL(window.location.href);
    var pk = urlview.searchParams.get("PK");
    var URLDoPrintorExport = '/HRM/Common/DoPrintOrExport?sceenid=HRMF2092&pk=' + pk;
    ASOFT.helper.postTypeJson(URLDoPrintorExport, {}, ExportSuccess);
}