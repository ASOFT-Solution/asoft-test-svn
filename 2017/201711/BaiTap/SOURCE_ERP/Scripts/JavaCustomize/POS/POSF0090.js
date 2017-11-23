
(function () {
    setInterval(function () {
        if ($('#Grid' + tablecontent).data('kendoGrid')) {
            refreshGrid();
        }
    }, 5000 * 2);
}())

function openPopup(e)
{
    var data = e.dataset
    // if data.id && data.module is not undefined
    if(data.id && data.module)
    {
        urlPopup = "/popupmasterdetail/index/POS/POSF0091?pk="+data.id+"&table=POST00901"+"&key=apk&divisionid="+data.module
        ASOFT.asoftPopup.showIframe(urlPopup, {})
    }
    // else return false
    return false
}

var GridPOST00901 = null;

$(document).ready(function () {
    GridPOST00901 = $("#GridPOST00901").data("kendoGrid");
    var GRID_BUTTON_SELECTOR = "#GridPOST00901 .k-button";
    GridPOST00901.bind('dataBound', function (e) {
        $(GRID_BUTTON_SELECTOR).each(function (index, btn) {
            var element = $(btn);
            element.text($("th[data-field='IsConfirm']").text());
        });
    })
})

function ExportClick() {
    var records = ASOFT.asoftGrid.selectedRecords(GridPOST00901, 'FormFilter');
    if (records.length == 0) return;

    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    var data = {};
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                data[key.split('_')[0]] = value;
            }
        }
    });

    var URLDoPrintorExport = '/POS/POSF0090/DoPrintOrExport';
    var apkList = "";
    
    if (!$("#chkAll").is(':checked')) {
        for (var i = 0; i < records.length - 1; i++) {
            apkList += records[i].APK + ",";
        }
    }

    apkList += records[records.length - 1].APK;

    data.APKList = $("#chkAll").is(':checked') ? null : apkList;
    data.IsCheckAll = $("#chkAll").is(':checked') ? 1 : 0;

    ASOFT.helper.postTypeJson(URLDoPrintorExport, data, ExportSuccessPrint);
}

function ExportSuccessPrint(result) {
    if (result) {
        var urlExcel = '/POS/POSF0090/ExportReport';
        // Tạo path full
        var fullPath = urlExcel + "?id=" + result.apk;

        window.location = fullPath;
    }
}