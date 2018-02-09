$(document).ready(function () {
    setTimeout(function () {
        $(".k-window-actions").html("<button onclick='btnClose_Click()' style='background-color: rgba(0, 0, 0, 0);border:0'><img src='/Areas/CRM/Content/images/close.png'></button>");
        $("#TxtBarcode").focus();
    }, 500);


});

$("#TxtBarcode").keypress(function (e) {
    var key = e.which;
    if (key == 13) {
        if ($("#TxtBarcode").val() == "") {
            return;
        }
        ASOFT.form.clearMessageBox();
        //var regex = /^[{]?[0-9a-fA-F]{8}[-]?([0-9a-fA-F]{4}[-]?){3}[0-9a-fA-F]{12}[}]?$/;
        //var match = regex.exec($("#TxtBarcode").val());
        //if (match == null)
        //{
        //ASOFT.form.displayError("#popupInnerIframe", kendo.format(ASOFT.helper.getMessage("00ML000059"), "Barcode"));
        //return;
        //}
        ASOFT.helper.postTypeJson("/SO/SOF2031/CheckDivision", GetBarcodeData(), function (Check) {
            if (Check.Status == 1) {
                CheckBarcodeExist();//Check barcode đã quét
            }
            else {
                ASOFT.form.displayError("#popupInnerIframe", kendo.format(ASOFT.helper.getMessage("00ML000050"), "Barcode"));//Xuất thông báo lỗi 00ML000050 lên form
            }
        });
    }
});

function CheckBarcodeExist() {
    ASOFT.helper.postTypeJson("/SO/SOF2031/CheckExist", GetBarcodeData(), function (Check) {
        if (Check.Status == 1) {
            UpdateConfirmOut();//Tiến hành update
        }
        else {
            PopupQuestion();//Xuất popup hỏi SOFML000004
        }
    });
};

function PopupQuestion() {
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage("SOFML000004"), function () {
        UpdateConfirmOut();
    }, function () {
        InsertSuccess();
    })
};

function UpdateConfirmOut() {
    ASOFT.helper.postTypeJson("/SO/SOF2031/UpdateConfirmOut", GetBarcodeData(), function (Check) {
        if (Check.Status != -1) {
            InsertSuccess();
        }
        else {
            ASOFT.form.displayError("#popupInnerIframe", "Something went wrong");//Xuất thông báo lỗi
        }
    });
};

function InsertSuccess() {
    ASOFT.form.displayInfo("#popupInnerIframe", ASOFT.helper.getMessage("00ML000015"));//Xuất thông báo thành công 00ML000015
    $("#TxtBarcode").val("");
    $("#TxtBarcode").focus();
}

function btnClose_Click() {
    ASOFT.asoftPopup.closeOnly();
};

function GetBarcodeData() {
    return { Barcode: $("#TxtBarcode").val() };
};