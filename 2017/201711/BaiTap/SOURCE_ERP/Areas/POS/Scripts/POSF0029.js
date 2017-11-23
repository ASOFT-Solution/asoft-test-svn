var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
var posViewModel = null;
var action = null;
var isClose = null;

$(document).ready(function () {
    createViewModel();
    $("#ShipQuantity").keyup(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });

    $("#SalePrice").keyup(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });

    $("#SalePrice").val(formatDecimal(kendo.parseFloat($("#SalePrice").val())));
    $("#ShipQuantity").val(formatDecimal(kendo.parseFloat($("#ShipQuantity").val())));
})


function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}

function createViewModel() {
    posViewModel = kendo.observable({
        defaultViewModel: ASOFT.helper.dataFormToJSON("POSF0029"),
        getInfo: function () {
            var dataPost = ASOFT.helper.dataFormToJSON("POSF0029");
            dataPost.SalePrice = kendo.parseFloat(dataPost.SalePrice);
            return dataPost;
        },
        isInvalid: function () {
            //checkgrid
            $("#InventoryID").removeAttr("readonly");
            var check = ASOFT.form.checkRequired('POSF0029');

            return check;
        },
        reset: function () {
            $("#APK").val('');
            $("#InventoryID").val('');
            $("#UnitID").val('');
            $("#UnitName").val('');
            $("#InventoryName").val('');
            $("#Description").val('');
            $("#ShipQuantity").val('');
            $("#SalePrice").val('');
        },
        close: function () {
            //Close form
            if (parent.popupClose
                && typeof (parent.popupClose) === "function") {
                parent.popupClose();
            }
        },
        /**
        * save 
        * action = 1 : saveAndContinue
        * action = 2 : saveAndCopy
        * action = 3 : update
        */
        save: function () {
            if (this.isInvalid()) {
                $("#InventoryID").attr("readonly", "readonly");
                return false;
            }
            $("#InventoryID").attr("readonly", "readonly");
            var that = this;
            var dataPost = this.getInfo();
            var isUpdate = ($("#APK").val() != null
                && $("#APK").val() != ''
                && $("#APK").val() != EMPTY_GUID);
            var action = "/POS/POSF0027/InsertDetail";
            if (isUpdate) {
                action = "/POS/POSF0027/UpdateDetail";
                dataPost.APK = $("#APK").val();
            }
            var dataParent = parent.getDataInsert();
            dataPost.ShopID = dataParent.ShopID;
            dataPost.APKMInherited = dataParent.VoucherID;
            dataPost.APKMaster = dataParent.APKMaster;
            dataPost.DivisionID = dataParent.DivisionID;

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                onInsertSuccess
            );
        }//end save (function)
    });
}

function onInsertSuccess(result) {
    if (result.Status == 0) {
        switch (action) {
            case 1://save new                
                ASOFT.form.displayInfo('#POSF0029', ASOFT.helper.getMessage(result.Message));
                posViewModel.reset();
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#POSF0029', ASOFT.helper.getMessage(result.Message));
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                //refreshModel();
                break;
            case 3:
                ASOFT.form.displayInfo('#POSF0029', ASOFT.helper.getMessage(result.Message));
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                parent.popupClose();
                break;

                //refreshModel();
            case 4:
                ASOFT.form.displayInfo('#POSF0029', ASOFT.helper.getMessage(result.Message));
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                if (isClose == 1)
                    parent.popupClose();
                break;
        }
    }
    else {
        var msg = ASOFT.helper.getMessage(result.Message);
        if (result.Data) {
            msg = kendo.format(msg, result.Data);
        }
        ASOFT.form.displayWarning('#POSF0029', msg);
    }
}


function btnPlus_Click() {
    var ShipQuantity = $("#ShipQuantity").val();
    if (ShipQuantity == "")
        ShipQuantity = 0;
    ShipQuantity = parseInt(ShipQuantity) + 1;
    $("#ShipQuantity").val(ShipQuantity);
}

function btnMinus_Click() {
    var ShipQuantity = $("#ShipQuantity").val();
    if (ShipQuantity == "" || ShipQuantity == 0)
        return;
    ShipQuantity  = parseInt(ShipQuantity) - 1;;
    $("#ShipQuantity").val(ShipQuantity);
}


var isDataChanged = function () {
    var dataPost = getFormData();
    var equal = isRelativeEqual(dataPost, posViewModel.defaultViewModel);
    return !equal;
};
var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON('POSF0029');
    return dataPost;
};

var isRelativeEqual = function (data1, data2) {
    var KENDO_INPUT_SUFFIX = '_input';
    if (data1 && data2
        && typeof data1 === "object"
        && typeof data2 === "object") {
        for (var prop in data1) {
            // So sánh thuộc tính của 2 data
            if (!data2.hasOwnProperty(prop)) {
                return false;
            }
            else {
                if (prop.indexOf(KENDO_INPUT_SUFFIX) != -1) {
                    continue;
                }
                // Nếu giá trị hai thuộc tính không bằng nhau, thì data có khác biệt
                if (data1[prop].valueOf() != data2[prop].valueOf()) {
                    return false;
                }
            }
        }
        return true;
    }
    return undefined;
};

function SaveCopy_Click() {
    action = 2;
    posViewModel.save();
}

function SaveNew_Click() {
    action = 1;
    posViewModel.save();
}

function btnClose_Click() {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                if ($("#APK").val() != null
                && $("#APK").val() != ''
                && $("#APK").val() != EMPTY_GUID) {
                    action = 4;
                    isClose = 1;
                }
                else {
                    action = 3;
                }
                posViewModel.save();
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}

function btnUpdate_Click() {
    action = 4;
    isClose = 0;
    posViewModel.save();
}

function btnChooseInventory_Click() {
    var urlChooseInventory = "/PopupSelectData/Index/POS/CMNF9001?DivisionID=" + parent.returnDivisionID();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventory, {});
}

function receiveResult(result) {
    $("#InventoryID").val(result["InventoryID"]);
    $("#InventoryName").val(result["InventoryName"]);
    $("#UnitID").val(result["UnitID"]);
    $("#UnitName").val(result["UnitName"]);
    $("#InventoryTypeID").val(result["InventoryTypeID"]);
    $("#SalePrice").val(formatDecimal(kendo.parseFloat(result["SalePrice"])));
}
