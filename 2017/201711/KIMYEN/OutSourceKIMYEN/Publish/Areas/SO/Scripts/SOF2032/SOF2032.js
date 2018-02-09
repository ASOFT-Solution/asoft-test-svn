$(document).ready(function () {
    setTimeout(function () {
        $(".k-window-actions").html("<button onclick='btnClose_Click()' style='background-color: rgba(0, 0, 0, 0);border:0'><img src='/Areas/CRM/Content/images/close.png'></button>");
        $("#TxtBarcode").focus();
    }, 500);
});

$("#TxtBarcode").keypress(function (e) {
    var key = e.which;
    if (key == 13)  // the enter key code
    {
        if ($("#TxtBarcode").val() == "")
            return;
        ASOFT.form.clearMessageBox();
        //var regex = /^[{]?[0-9a-fA-F]{8}[-]?([0-9a-fA-F]{4}[-]?){3}[0-9a-fA-F]{12}[}]?$/;
        //var match = regex.exec($("#TxtBarcode").val());
        //if (match == null) {
        //    ASOFT.form.displayError("#popupInnerIframe", kendo.format(ASOFT.helper.getMessage("00ML000059"), "Barcode"));
        //    return;
        //}
        ASOFT.helper.postTypeJson("/SO/SOF2032/CheckInput", GetBarcodeData(), function (Check) {
            if (Check.Status == 1) {
                CheckBarcodeConfirmOut();//Check barcode đã quét đi
            }
            else {
                ASOFT.form.displayError("#popupInnerIframe", kendo.format(ASOFT.helper.getMessage(Check.Message), $("#TxtBarcode").val()));//Xuất thông báo lỗi 00ML000050 lên form
            }
        });
    }
});

function CheckBarcodeConfirmOut() {
    ASOFT.helper.postTypeJson("/SO/SOF2032/CheckConfirmOut", GetBarcodeData(), function (Check) {
        if (Check.Status == 1) {
            CheckCustomHT();//Check barcode đã quét về
        }
        else {
            PopupSaveConfirmOut();//Xuất popup hỏi xác nhận lưu
        }
    });
};

function CheckCustomHT() {
    ASOFT.helper.postTypeJson("/SO/SOF2032/CheckCustomHT", GetBarcodeData(), function (Check) {
        if (Check.Status == 1) {
            ASOFT.form.displayError("#popupInnerIframe", kendo.format(ASOFT.helper.getMessage("SOFML000010"), $("#TxtBarcode").val()));
        }
        else {
            CheckBarcodeConfirmIn();
        }
    })
}

function PopupSaveConfirmOut() {
    ASOFT.dialog.confirmDialog(kendo.format(ASOFT.helper.getMessage("SOFML000006"), $("#TxtBarcode").val()), function () {
        LoadFormSOF2033Type3();//Load form SOF2033 TH 3
    }, function () {
        $("#TxtBarcode").val("");
        $("#TxtBarcode").focus();
    })
};

function LoadFormSOF2033Type3() {
    ASOFT.asoftPopup.showIframe("/SO/SOF2033?Type=3&Data=" + $("#TxtBarcode").val(), {});
}

//function UpdateConfirmOut() {
//    ASOFT.helper.postTypeJson("/SO/SOF2031/UpdateConfirmOut", GetBarcodeData(), function (Check) {
//        Check.Status = 1;
//        if (Check.Status == 1) {
//            CheckBarcodeConfirmIn();//Check barcode đã quét về
//        }
//        else {
//            ASOFT.form.displayError("#popupInnerIframe", "Không thành công");//Báo lỗi
//            $("#TxtBarcode").val("");
//            $("#TxtBarcode").focus();
//        }
//    });
//};

function CheckBarcodeConfirmIn() {
    ASOFT.helper.postTypeJson("/SO/SOF2032/CheckConfirmIn", GetBarcodeData(), function (Check) {
        if (Check.Status == 1) {
            ASOFT.asoftPopup.showIframe("/SO/SOF2033?Type=1&Data=" + $("#TxtBarcode").val(), {});//mở form 2033 loai 2
        }
        else {
            ASOFT.asoftPopup.showIframe("/SO/SOF2033?Type=2&Data=" + $("#TxtBarcode").val(), {});//mở form 2033 loai 1
        }
    });
};

function btnClose_Click() {
    ASOFT.asoftPopup.closeOnly();
};

function GetBarcodeData() {
    return { Barcode: $("#TxtBarcode").val() };
};

function ReloadSuccess() {
    ASOFT.form.displayInfo("#SOF2032Message", ASOFT.helper.getMessage("00ML000015"));
    $("#TxtBarcode").val("");
    $("#TxtBarcode").focus();
};