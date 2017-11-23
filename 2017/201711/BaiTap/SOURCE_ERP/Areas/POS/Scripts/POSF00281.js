var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
var posViewModel = null;
var action = null;
var rowNumber1 = 0;
var posGrid = null;

$(document).ready(function () {
    posGrid = $('#POSF0028Grid').data('kendoGrid');

    if (posGrid != undefined) {
        posGrid.bind('dataBound', function (e) {
            rowNumber1 = 0;
        });
    }

    createViewModel();
    VoucherTypeIDOpen();
    //$("#DivisionID").bind("change", VoucherTypeIDOpen);
    //$("#VoucherTypeID").bind("change", VoucherTypeIDChange);
    //$("#ShopID").bind("change", ShopIDChange);
    //$("#DivisionID").data("kendoComboBox").readonly();
    //$("#WarehouseID").data("kendoComboBox").readonly();
    //$("#VoucherTypeID").data("kendoComboBox").readonly();
    //$("#ShopID").data("kendoComboBox").readonly();
    if ($("#isCLOUD").val() == "True") {
        $("#EmployeeID").attr("readonly", "readonly");
        $("#EmployeeID").css("width", "98%");
        $("#Description").css("width", "98%");
        var log = console.log;
        GRID_AUTOCOMPLETE.config({
            gridName: 'POSF0028Grid',
            inputID: 'autocomplete-box',
            autoSuggest: false,
            serverFilter: true,
            actionName: 'POSF0015',
            controllerName: "GetInventories",
            grid: $('#POSF0028Grid').data('kendoGrid'),
            setDataItem: function (selectedRowItem, dataItem) {
                //log(dataItem);
                selectedRowItem.model.set('InventoryID', dataItem.InventoryID);
                selectedRowItem.model.set('InventoryName', dataItem.InventoryName);
                selectedRowItem.model.set('UnitID', dataItem.UnitID);
                selectedRowItem.model.set('UnitName', dataItem.UnitName);
                selectedRowItem.model.set('InventoryTypeID', dataItem.InventoryTypeID);
                selectedRowItem.model.set('SalePrice', dataItem.UnitPrice);
                if ($('#isPOST0016').length == 0)
                {
                    selectedRowItem.model.set('ShipQuantity', dataItem.ActualQuantity);
                }
            }
        });
    }
    else {
        $("#EmployeeID").attr("readonly", "readonly");
        $("#EmployeeID").css("width", "90%");
    }

    if ($('#isPOST0016').val() == "True" && $("#APKPOST0016").val() != "") {
        $("#POSF0028Grid").attr("AddNewRowDisabled", "false");
    }
})

function createViewModel() {
    posViewModel = kendo.observable({
        gridDataSource: posGrid != undefined ? posGrid.dataSource : null,
        defaultViewModel: ASOFT.helper.dataFormToJSON("POSF00281"),
        getInfo: function () {
            var dataPost = ASOFT.helper.dataFormToJSON("POSF00281");
            dataPost.WarehouseName = $("#ShopID").data("kendoComboBox").dataItem().WarehouseName;
            dataPost.ObjectID = $("#ShopID").data("kendoComboBox").dataItem().ObjectID;
            dataPost.ObjectName = $("#ShopID").data("kendoComboBox").dataItem().ObjectName;
            return dataPost;
        },
        getInfoCLOUD: function () {
            var dataPost = ASOFT.helper.dataFormToJSON('POSF00281');
            dataPost.WarehouseName = $("#ShopID").data("kendoComboBox").dataItem().WarehouseName;
            dataPost.ObjectID = $("#ShopID").data("kendoComboBox").dataItem().ObjectID;
            dataPost.ObjectName = $("#ShopID").data("kendoComboBox").dataItem().ObjectName;
            dataPost.DetailList = this.gridDataSource.data();
            dataPost.IsDataChanged = this.gridDataSource.hasChanges();
            dataPost.isPOSCLOUD = true;
            if ($("#APKPOST0016").val() != "")
            {
                dataPost.APKPOST0016 = $("#APKPOST0016").val();
            }

            return dataPost;
        },
        isInvalid: function () {
            //checkgrid
            $("#EmployeeID").removeAttr("readonly");
            var check = ASOFT.form.checkRequired('POSF00281');
            if (!check && $("#isCLOUD").val() == "True") {
                if (this.gridDataSource.data().length <= 0) {
                    $('#POSF0028Grid').addClass('asf-focus-input-error');
                    //display message
                    msg = ASOFT.helper.getMessage('00ML000061');
                    ASOFT.form.displayError('#POSF00281', msg);
                } else {
                    //show quantity
                    if (ASOFT.asoftGrid.editGridValidate(posGrid, ['Description'])) {
                        msg = ASOFT.helper.getMessage('00ML000060');
                        ASOFT.form.displayError('#POSF00281', msg);
                        check = true;
                    }
                    //[MinhLam - 06/06/2014] : Không kiểm tra chêch lệch số lượng
                    /*else if (this.checkQuantity()) {
                        msg = ASOFT.helper.getMessage('00ML000072');
                        ASOFT.form.displayWarning('#POSF00151', msg);
                        check = true;
                    }*/
                }
            }

            return check;
        },
        reset: function () {
            $("#APK").val('');
            $("#EmployeeID").val('');
            this.gridDataSource.data([]);
            posGrid.addRow();
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
                $("#EmployeeID").attr("readonly", "readonly");
                return false;
            }
            $("#EmployeeID").attr("readonly", "readonly");
            var that = this;
            var dataPost = this.getInfo();
            var isUpdate = ($("#APK").val() != null
                && $("#APK").val() != ''
                && $("#APK").val() != EMPTY_GUID);
            var action = "/POS/POSF0027/Insert";
            if (isUpdate) {
                action = "/POS/POSF0027/Update";
                dataPost.APK = $("#APK").val();
            }

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                onInsertSuccess
            );
        },//end save (function)

        saveCLOUD: function () {
            if (this.isInvalid()) {
                return false;
            }
            if ($('#APKPOST0016').val() != "" && this.customCheck()) {
                return false;
            }

            var that = this;
            var dataPost = this.getInfoCLOUD();
            var isUpdate = ($('#APK').val() != null
                && $('#APK').val() != ''
                && $('#APK').val() != EMPTY_GUID);
            var action = getAbsoluteUrl('POSF0027/InsertCLOUD');
            if (isUpdate) {
                action = getAbsoluteUrl('POSF0027/Update');
                dataPost.APK = $('#APK').val();
            }

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                onInsertSuccess
            );
        },

        customCheck: function () {
            var check = true;
            ASOFT.helper.postTypeJson(
            "/POS/POSF0027/CheckQuatity",
            {
                APKPOST0016: $('#APKPOST0016').val(),
                ldata : posGrid.dataSource.data()
            },
               function (result) {
                   if (result.Status == 2)
                   {
                       var msg = ASOFT.helper.getMessage(result.Message);
                       ASOFT.form.displayError('#POSF00281', kendo.format(msg, result.Data, result.Params));
                       var lError = result.Data.split(',');

                       var columns = posGrid.columns;
                       var data = posGrid.dataSource.data();
                       $(posGrid.tbody).find('td').removeClass('asf-focus-input-error');
                       $(posGrid.tbody).find("td").each(function (index, element) {
                            var cellIndex = $(element).index();
                            var column = columns[cellIndex];
                            if (column.field === "ShipQuantity") {
                                var rowIndex = $(element).parent().index();
                                var row = data[rowIndex];
                                if (lError.indexOf(row["InventoryID"]) != -1) {
                                    $(element).addClass('asf-focus-input-error');
                                }
                            }  
                       });
                   }
                   if (result.Status == 1) {
                       var msg = ASOFT.helper.getMessage(result.Message);
                       ASOFT.form.displayError('#POSF00281', kendo.format(msg, result.Data, result.Params));
                       var lError = result.Data.split(',');

                       var data = posGrid.dataSource.data();
                       $(posGrid.tbody).find('tr').removeClass('asf-focus-input-error');
                       $(posGrid.tbody).find("tr").each(function (index, element) {
                            var rowIndex = $(element).index();
                            var row = data[rowIndex];
                            if (lError.indexOf(row["InventoryID"]) != -1) {
                                $(element).addClass('asf-focus-input-error');
                            }
                       });
                   }
                   if (result.Status == 0) {
                       check = false;
                   }
               }
            );
            return check;
        }
    });
}

function onInsertSuccess(result) {
    if (result.Status == 0) {    
        switch (action) {
            case 1://save new    
                Print(result.Data.id);
                ASOFT.form.displayInfo('#POSF00281', ASOFT.helper.getMessage(result.Message));
                $("#VoucherNo").val(result.Data.newVoucherNo);
                posViewModel.reset();
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                break;
            case 2://save copy
                Print(result.Data.id);
                ASOFT.form.displayInfo('#POSF00281', ASOFT.helper.getMessage(result.Message));
                $("#VoucherNo").val(result.Data.newVoucherNo);
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                //refreshModel();
                break;
            case 3:
                Print(result.Data.id);
                ASOFT.form.displayInfo('#POSF00281', ASOFT.helper.getMessage(result.Message));
                if (typeof parent.printPOST00161 === "function") {
                    parent.printPOST00161($("#APKPOST0016").val());
                    parent.popupClose();
                }
                else {
                    if (typeof parent.refreshGrid === "function") {
                        parent.refreshGrid();
                    }
                    parent.popupClose();
                }
                break;

                //refreshModel();
            case 4:
                ASOFT.form.displayInfo('#POSF00281', ASOFT.helper.getMessage(result.Message));
                window.parent.location.reload();
                break;
            case 5:
                Print(result.Data.id);
                ASOFT.form.displayInfo('#POSF00281', ASOFT.helper.getMessage(result.Message));
                if (typeof parent.printPOST00161 === "function")
                {
                    parent.printPOST00161($("#APKPOST0016").val());
                }
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                parent.popupClose();
                break;
        }
    }
    else {
        var msg = ASOFT.helper.getMessage(result.Message);
        if (result.Data) {
            if (result.Message == "POSFML000066") {
                msg = ASOFT.helper.getMessage(result.Message);
                msg = kendo.format(msg, result.Data.BeginDate, result.Data.VoucherDate)
            }
            else
                msg = kendo.format(msg, result.Data);
        }
        ASOFT.form.displayWarning('#POSF00281', msg);
    }
}

function Print(APK) {
    ASOFT.helper.postTypeJson("/POS/POSF0016/DoPrintOrExport", { apkMaster: APK }, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF0016/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");;
    }
}



var isDataChanged = function () {
    var dataPost = getFormData();
    var equal = isRelativeEqual(dataPost, posViewModel.defaultViewModel);
    return !equal;
};
var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON('POSF00281');
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
    if ($("#isCLOUD").val() == "True") {
        posViewModel.saveCLOUD();
    }
    else
        posViewModel.save();
}

function SaveNew_Click() {
    action = 1;
    if ($("#isCLOUD").val() == "True") {
        posViewModel.saveCLOUD();
    }
    else
        posViewModel.save();
}

function btnClose_Click() {
    //if (isDataChanged()) {
    if (true) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                if ($("#APK").val() != null
                && $("#APK").val() != ''
                && $("#APK").val() != EMPTY_GUID) {
                    action = 4;
                }
                else {
                    action = 3;
                }
                if ($("#isCLOUD").val() == "True") {
                    posViewModel.saveCLOUD();
                }
                else
                    posViewModel.save();
            },
            function () {
                if (typeof parent.printPOST00161 === "function") {
                    parent.printPOST00161($("#APKPOST0016").val());
                }
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}

function btnUpdate_Click() {
    action = 4;
    if ($("#isCLOUD").val() == "True") {
        posViewModel.saveCLOUD();
    }
    else
        posViewModel.save();
}

function btnUpdatePOST0016_Click() {
    action = 5;
    posViewModel.saveCLOUD();
}



function VoucherTypeIDOpen() {
    var combo1 = $("#ShopID").data("kendoComboBox");
    var data = [];
    data.push($("#DivisionID").val());
    ASOFT.helper.postTypeJsonComboBox("/ComboBox/ShopIDNamePOS", data, combo1, onComboSuccess);
}


function onComboSuccess(result, combo) {
    combo.dataSource.data(result);
    if (result.length == 0) {
        combo.value("");
    }
};

//function VoucherTypeIDChange() {
//    GetVoucherID();
//}

//function GetVoucherID() {
//    var data = [];
//    data.push($("#DivisionID").val());
//    data.push($("#VoucherTypeID").val());
//    ASOFT.helper.postTypeJson("/POS/POSF0027/GetVoucherNo", data, function (result) {
//        $("#VoucherNo").val(result.VoucherNo);
//    });
//}

//function ShopIDChange() {
//    $("#WarehouseID").data("kendoComboBox").value($("#ShopID").data("kendoComboBox").dataItem().WarehouseID);
//}

function btnChooseEmployeeID_Click() {
    var urlChooseEmployee = "/PopupSelectData/Index/POS/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
} btnClose_Click

function receiveResult(result) {
    $("#EmployeeID").val(result["EmployeeID"]);
    $("#EmployeeName").val(result["EmployeeName"]);
}

function sendDataFilterEdit() {
    var data = {};
    if ($('#isPOST0016').val() == "True" && $("#APKPOST0016").val() != "") {
        data.APKPOST0016 = $('#APKPOST0016').val();
    }
    else {
        data.APK = $('#APK').val();
    }

    return data;
}

function renderNumber1(data) {
    return ++rowNumber1;
}

function genDeleteBtn(data) {
    return '<a href="\\#" onclick="return deleteVoucher_Click(this);" class="asf-i-delete-24 asf-icon-24"><span>Del</span></a>';
}

function deleteVoucher_Click(e) {
    if (posGrid.dataSource.data().length == 1) {
        posGrid.dataSource.data([]);
        posGrid.addRow();
        $("#POSF0028Grid").removeAttr("AddNewRowDisabled");
        return false;
    }
    var tagA = $(e).parent();
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000024'),
        //yes
        function () {
            ASOFT.asoftGrid.removeEditRow(tagA, $('#POSF0028Grid').data('kendoGrid'), null);
        },
        function () {

        }
    );
    return false;

}
