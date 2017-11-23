//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/08/2014      Chánh Thi        Tạo mới
//####################################################################
var isPeriod = 0;
var isPrint = false;
var selectedRows = {};
var selectedKeys = [];
var btnChooseText = "";

$(document).ready(function () {
    var script = $('#POSF0076');
    fromPeriod = ASOFT.asoftComboBox.castName("FromPeriod");
    toPeriod = ASOFT.asoftComboBox.castName("ToPeriod");
    fromDate = ASOFT.asoftDateEdit.castName("FromDate");
    toDate = ASOFT.asoftDateEdit.castName("ToDate");
    comboShop = ASOFT.asoftComboBox.castName("ShopID");
    btnChooseText = $($('#btnPOSF0076Choose').find('span')[0]).text();
    

    // Display message from cache
    ASOFT.helper.showErrorSeverOptionFromRedirecting();

    //Sự kiện cho radio button kì kế toán và ngày
    $("form#POSF0076 #rdoPeriod").change(function () {
        if ($(this).prop('checked')) {
            isPeriod = 1;
            fromPeriod.enable(true);
            toPeriod.enable(true);
            fromDate.enable(false);
            toDate.enable(false);
        }
    });

    $("form#POSF0076 #rdoDate").change(function () {
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
    var dataDropdownShop = $("#ShopID").data("kendoDropDownList");
    var isAllCheck = (dataDropdownShop.list.find('input:checked').length == dataDropdownShop.list.find(".check-input").length);

    //Lấy dữ liệu từ form post lên
    var data = ASOFT.helper.dataFormToJSON("POSF0076");
    data.IsPeriod = isPeriod;
    data.FromMonth = !dataFromPeriod ? '' : dataFromPeriod.TranMonth;
    data.FromYear = !dataFromPeriod ? '' : dataFromPeriod.TranYear;
    data.ToMonth = !dataToPeriod ? '' : dataToPeriod.TranMonth;
    data.ToYear = !dataToPeriod ? '' : dataToPeriod.TranYear;
    data.ShopID = !isAllCheck ? dataDropdownShop.value() : '%';
    return data;
}

//Sự kiện đóng popup
function btnPOSF0076Choose_Click(e) {
    var data = {};
    var postUrl = ASOFT.helper.renderUrl('/POS/POSF0076/POSF00761', data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}

function btnPOSF0076UnChoose_Click(e) {
    recieveResult({});
}

//Sự kiện đóng popup
function btnPOSF0076Close_Click(e) {
    ASOFT.asoftPopup.hideIframe(true);
}

function ObjectLength(object) {
    var length = 0;
    var arr = [];
    for (var key in object) {
        if (object.hasOwnProperty(key)) {
            arr.push(key);
            ++length;
        }
    }
    selectedKeys = arr;

    return length;
};

function ToArrayKey(object) {
    var length = 0;
    var arr = [];
    for (var key in object) {
        if (object.hasOwnProperty(key)) {
            arr.push(key);
        }
    }
    return arr;
};

function recieveResult(data) {
    selectedRows = data || {};

    if (selectedRows) {
        var length = ObjectLength(selectedRows);
        if (length > 0) {
            $($('#btnPOSF0076Choose').find('span')[0]).text(
                "( " + length + " ) " + btnChooseText);
        } else {
            $($('#btnPOSF0076Choose').find('span')[0]).text(btnChooseText);
        }
    }

    console.log(selectedKeys);
}

//sự kiện in
function btnPOSF0076Print_Click() {
    isPrint = true;
    var data = getData();
    data.Keys = selectedKeys;

    var url = $('#UrlDoPrint').val();
    ASOFT.helper.postTypeJson(url, data, function (result) {
        ASOFT.ExportSuccessCommon.Load(result, "POS", "POSF0076", true);
    });
}

//Sự kiện xuất excel
function btnPOSF0076Export_Click() {
    isPrint = false;
    var data = getData();
    data.Keys = selectedKeys;

    var url = $('#UrlDoPrint').val();
    ASOFT.helper.postTypeJson(url, data, function (result) {
        ASOFT.ExportSuccessCommon.Load(result, "POS", "POSF0076", false);
    });
}

//function POSF0076ExportSuccess(result) {
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