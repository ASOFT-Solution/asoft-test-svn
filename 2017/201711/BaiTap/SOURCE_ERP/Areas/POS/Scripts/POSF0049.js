//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/07/2014      Đức Quý         Tạo mới
//####################################################################
var isPeriod = 0;
var isPrint = false;
$(document).ready(function () {
    var script = $('#POSF0046');
    fromPeriod = ASOFT.asoftComboBox.castName("FromPeriod");
    toPeriod = ASOFT.asoftComboBox.castName("ToPeriod");
    fromDate = ASOFT.asoftDateEdit.castName("FromDate");
    toDate = ASOFT.asoftDateEdit.castName("ToDate");
    comboShop = ASOFT.asoftComboBox.castName("ShopID");

    // Display message from cache
    ASOFT.helper.showErrorSeverOptionFromRedirecting();

    //Sự kiện cho radio button kì kế toán và ngày
    $("form#POSF0049 #rdoPeriod").change(function () {
        if ($(this).prop('checked')) {
            isPeriod = 1;
            fromPeriod.enable(true);
            toPeriod.enable(true);
            fromDate.enable(false);
            toDate.enable(false);
        }
    });

    $("form#POSF0049 #rdoDate").change(function () {
        if ($(this).prop('checked')) {
            isPeriod = 0;
            fromPeriod.enable(false);
            toPeriod.enable(false);
            fromDate.enable(true);
            toDate.enable(true);
        }
    });
});

function getData() {
    var data = [];
    var dataFromPeriod = fromPeriod.dataItem(fromPeriod.selectedIndex);
    var dataToPeriod = toPeriod.dataItem(toPeriod.selectedIndex);
    var dataComboShop = comboShop.dataItem(comboShop.selectedIndex);

    //Lấy dữ liệu từ form post lên
    var data = ASOFT.helper.getFormData(null, "POSF0049");
    data.push({ name: 'IsPeriod', value: isPeriod });
    data.push({ name: 'FromMonth', value: !dataFromPeriod ? '' : dataFromPeriod.TranMonth });
    data.push({ name: 'FromYear', value: !dataFromPeriod ? '' : dataFromPeriod.TranYear });
    data.push({ name: 'ToMonth', value: !dataToPeriod ? '' : dataToPeriod.TranMonth });
    data.push({ name: 'ToYear', value: !dataToPeriod ? '' : dataToPeriod.TranYear });
    data.push({ name: 'ShopName', value: !dataComboShop ? '' : dataComboShop.ShopName });
    return data;
}

//Sự kiện đóng popup
function btnPOSF0049Close_Click(e) {
    ASOFT.asoftPopup.hideIframe(true);
}

//sự kiện in
function btnPOSF0049Print_Click() {
    isPrint = true;
    var data = getData();
    var url = $('#UrlDoPrint').val();
    ASOFT.helper.post(url, data, function (result) {
        ASOFT.ExportSuccessCommon.Load(result, "POS", "POSF0049", true);
    });
}

//Sự kiện xuất excel
function btnPOSF0049Export_Click() {
    isPrint = false;
    var data = getData();
    var url = $('#UrlDoPrint').val();
    ASOFT.helper.post(url, data, function (result) {
        ASOFT.ExportSuccessCommon.Load(result, "POS", "POSF0049", false);
    });
}

//function posf0049ExportSuccess(result) {
//    if (result) {
//        var urlPrint = $('#UrlReportViewer').val();
//        var urlExcel = $('#UrlExportReport').val();
//        var urlPost = isPrint ? urlPrint : urlExcel;
//        var options = isPrint ? '&viewer=pdf' : '';

//        // Tạo path full
//        var fullPath = urlPost + "?id=" + result.apk + options;

//        // Getfile hay in báo cáo
//        if (options) {
//            window.open(fullPath, "_blank");
//        } else {
//            window.location = fullPath;
//        }
//    }
//}