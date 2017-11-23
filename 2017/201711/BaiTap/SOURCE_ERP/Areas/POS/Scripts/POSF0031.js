
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     19/06/2014     Chánh Thi        tạo mới
//####################################################################

var entityGrid = null;
var entityGrid2 = null;
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
var rowNumber = 0;
var rowNumber2 = 0;
var tableID = null;
var dataFromController = null;
var dataFromController2 = null;
var count = 0;
var count2 = 0;
var firstTime = 0;
var firstTime2 = 0;
var quantityNew = 1;
var totalRow = 0;
var apkMaster = window.parent.posViewModel && window.parent.posViewModel.TempAPKMaster;
//var apkMaster = "9b969f83-2da3-41fa-a23c-1e6476c8238a";
var countMemberGrid = 0;
var countMemberGrid2 = 0;

$(document).ready(function () {

    var firstBound = true;
    var nt = $('#NewTable').data('kendoComboBox');
    var nz = $('#NewZone').data('kendoComboBox');

    nt.bind('dataBound', function (e) {
        if (!firstBound) {
            return;
        }
        firstBound = false;
        var i = 0, item, backup = [];

        while (item = (nt.dataSource.at(i++))) {
            backup.push(item);
        }
        console.log(1)
        nz.bind('change', function (e) {
            while (nt.dataSource.data().length > 0) {
                nt.dataSource.remove(nt.dataSource.at(0));
            }
            i = 0;
            while (item = backup[i++]) {
                if (item.AreaID === this.dataItem().AreaID) {
                    nt.dataSource.add(item)
                }
            }
        });

        nz.trigger('change');
    });

    entityGrid = $("#POSF0031AGrid").data("kendoGrid");
    console.log(entityGrid.dataSource.data().length);
    entityGrid2 = $("#POSF0031BGrid").data("kendoGrid");
    $('#APK').val(apkMaster);

    entityGrid.bind('dataBound', function (e) {
        rowNumber = 0;
        // Set màu cho dòng trong grid thứ 1
        for (var i = 0; i < entityGrid.dataSource.data().length ; i++) {
            dataFromController = entityGrid.dataSource.at(i);
            count = i + 1;
            if (dataFromController != null) {
                if (dataFromController.StatusRecordID == 1 || dataFromController.StatusRecordID == 0) {
                    $("#POSF0031AGrid tr").eq(count).css("color", "black");
                }
                else {
                    if (dataFromController.StatusRecordID == 2) {
                        $("#POSF0031AGrid tr").eq(count).css("color", "red");
                    }
                    else {
                        if (dataFromController.StatusRecordID == 3) {
                            $("#POSF0031AGrid tr").eq(count).css("color", "blue");
                        }
                    }
                }

            }
        }
    });
    entityGrid2.bind('dataBound', function (e) {
         rowNumber2 = 0;
            //Set màu cho dòng trong grid thứ 2
         for (var i = 0; i < entityGrid2.dataSource.data().length ; i++) {
             entityGrid2.dataSource.data()[i].RowNum = i;
                dataFromController2 = entityGrid2.dataSource.at(i);
                count2 = i + 1;
                if (dataFromController2 != null) {
                    if (dataFromController2.StatusRecordID == 1) {
                        $("#POSF0031BGrid tr").eq(count2).css("color", "black");
                    }
                    else {
                        if (dataFromController2.StatusRecordID == 2) {
                            $("#POSF0031BGrid tr").eq(count2).css("color", "red");
                        }
                        else {
                            if (dataFromController2.StatusRecordID == 3) {
                                $("#POSF0031BGrid tr").eq(count2).css("color", "blue");
                            }
                        }
                    }

                }
         }

         entityGrid2.dataSource.total = function () {
             entityGrid2.dataSource._total = entityGrid2.dataSource.data().length;
             return entityGrid2.dataSource._total;
         };
         if (typeof entityGrid2.dataSource.data()[0] !== 'undefined'
             && entityGrid2.dataSource.data()[0].InventoryID == null) {
             entityGrid2.dataSource.data().remove(0);
         }
     });
});

function btnSaveNew() {
    saveActionType = 1;
    saveData();
}

function saveData() {
    var data = ASOFT.helper.dataFormToJSON("POSF0031");
    data.ListCurrentTable = entityGrid.dataSource.data();
    data.ListNewTable = entityGrid2.dataSource.data();

    urlInsert = $('#UrlInsert').val();
    // Post data
    ASOFT.helper.postTypeJson(urlInsert, data, SaveSuccess);
}

function SaveSuccess(result) {
    var data = ASOFT.helper.dataFormToJSON("POSF0031");
    if (result.Status == 0) {
        // Chuyển hướng xử lý nghiệp vụ
        switch (saveActionType) {
            case 1: // Trường hợp lưu & nhập tiếp
                formStatus = 1;
                ASOFT.form.displayInfo('#POSF0031', ASOFT.helper.getMessage(result.Message))
                //window.parent.location.reload();

                // Nếu grid bên trái có dữ liệu => load POSF0040 là bên trái 
                //window.parent.ASOFTCORE.triggerEvent({
                //    type: 'refetch-master-details-by-apk-master',
                //    data: {
                //        apk: data.APK,
                //        AreaName: data.AreaName
                //    }
                //});


                // Nếu grid bên trái chuyển qua hết dữ liệu  => load POSF0040 là bên phải
                break;
            default: break;
        }
    }
    window.parent.ASOFTCORE.triggerEvent({
        type: 'refetch-master-details-by-apk-master',
        data: {
            apk: data.APK,
            AreaName: data.CurrentTable
        }
    });
}

function changeSingle() {
    var data = ASOFT.helper.dataFormToJSON("POSF0031");
    totalDiscountRateCurrentTable = data.TotalDiscountRateCurrentTable;
    totalDiscountAmountCurrentTable = data.TotalDiscountAmountCurrentTable;
    totalRedureRateCurrentTable = data.TotalRedureRateCurrentTable;
    totalRedureAmountCurrentTable = data.TotalRedureAmountCurrentTable;
  
    var ds = entityGrid.dataSource;
    var ds2 = entityGrid2.dataSource;

     // Biến kiểm tra lần đầu 
    entityGrid.select().each(function () {
        if (data.NewZone == '' || data.NewTable == '') {
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('POSM000047'));
            return false;
        }

        var _item = entityGrid.dataItem($(this));
        // neu tim thay item
        if (_item) {
            // neu so luong item la 1, thi chuyen item sang ben trai
            if (_item.ActualQuantity === 1) {
                // xoa item khoi luoi ben phai
                ds.remove(_item);
                // them item vao luoi ben trai
                addItemToDataSource(_item, ds2);
            }
                // neu so luong nhieu hon 1
            else {
                _item.ActualQuantity -= 1;
                _item.Amount = _item.UnitPrice * _item.ActualQuantity;
                var newItem = $.extend({}, _item);
                newItem.ActualQuantity = 1;
                _item.Amount = _item.UnitPrice;
                addItemToDataSource(newItem, ds2);
            }
        }

        entityGrid.refresh();
        entityGrid2.refresh();
        return;      
        //}
    });
    // Set màu cho dòng trong grid thứ 1
    for (var i = 0; i < entityGrid.dataSource.data().length ; i++) {
        dataFromController = entityGrid.dataSource.at(i);
        count = i + 1;
        console.log(dataFromController);
        if (dataFromController != null) {
            if (dataFromController.StatusRecordID == 1 || dataFromController.StatusRecordID == 0) {
                $("#POSF0031AGrid tr").eq(count).css("color", "black");
            }
            else {
                if (dataFromController.StatusRecordID == 2) {
                    $("#POSF0031AGrid tr").eq(count).css("color", "red");
                }
                else {
                    if (dataFromController.StatusRecordID == 3) {
                        $("#POSF0031AGrid tr").eq(count).css("color", "blue");
                    }
                }
            }

        }
    }

    //Set màu cho dòng trong grid thứ 2
    for (var i = 0; i < entityGrid2.dataSource.data().length ; i++) {
        dataFromController2 = entityGrid2.dataSource.at(i);
        count2 = i + 1;
        if (dataFromController2 != null) {
            if (dataFromController2.StatusRecordID == 1) {
                $("#POSF0031BGrid tr").eq(count2).css("color", "black");
            }
            else {
                if (dataFromController2.StatusRecordID == 2) {
                    $("#POSF0031BGrid tr").eq(count2).css("color", "red");
                }
                else {
                    if (dataFromController2.StatusRecordID == 3) {
                        $("#POSF0031BGrid tr").eq(count2).css("color", "blue");
                    }
                }
            }

        }
    }

    //// Tính toán các giá trị để lưu xuống.

    // Tính tổng Amount
    //if (entityGrid2.dataSource.data().length > 0) {
        var totalAmount = entityGrid2.dataSource.at(0).ActualQuantity * entityGrid2.dataSource.at(0).UnitPrice;
        var countTotalAmount = 0;
        for (var i = 1 ; i < entityGrid2.dataSource.data().length ; i++) {
            totalAmount = totalAmount + (entityGrid2.dataSource.at(i).ActualQuantity * entityGrid2.dataSource.at(i).UnitPrice);
        }
    //}
    //if (entityGrid.dataSource.data()[0].InventoryID == null) {
    //    entityGrid.dataSource.data().remove(0);
    //}

    //if (entityGrid2.dataSource.data()[0].InventoryID == null) {
    //    entityGrid2.dataSource.data().remove(0);
    //}
}

function RemoveArrayElement( array, element ){ 
    var pos = array.indexOf(element);
    pos > -1 && array.splice(pos, 1);
}

function changeAll() {
    var data = ASOFT.helper.dataFormToJSON("POSF0031");
    if (data.NewZone == '' || data.NewTable == '') {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('POSM000047'));
        return false;
    }
    var data = entityGrid.dataSource.data();
    var data2 = entityGrid2.dataSource.data();
    var totalNumber = data.length;
    var totalNumber2 = data2.length;

    for (var i = 0 ; i < totalNumber ; i++) {
        var currentDataItem = data[i];
        if (currentDataItem != null) {
            for (var j = 0 ; j < totalNumber2 ; j++) {
                if (currentDataItem.InventoryID == data2[j].InventoryID &&
                    currentDataItem.InventoryName == data2[j].InventoryName) {
                    currentDataItem.RowNumber = data2[j].RowNumber;
                    currentDataItem.InventoryID = data2[j].InventoryID;
                    currentDataItem.InventoryName = data2[j].InventoryName;
                    currentDataItem.ActualQuantity = currentDataItem.ActualQuantity + data2[j].ActualQuantity;
                    currentDataItem.UnitPrice = currentDataItem.UnitPrice;
                    currentDataItem.DiscountRate = currentDataItem.DiscountRate;
                    currentDataItem.DiscountAmount = currentDataItem.DiscountAmount + data2[j].DiscountAmount;

                    amountNewTable = currentDataItem.ActualQuantity * currentDataItem.UnitPrice;

                    discountAmountNewTable = amountNewTable * (currentDataItem.DiscountRate / 100);
                    currentDataItem.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                    inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                    currentDataItem.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable

                    currentDataItem.VATPercent = currentDataItem.VATPercent;
                    currentDataItem.TaxAmount = currentDataItem.TaxAmount + data2[j].TaxAmount;
                    entityGrid2.dataSource.remove(data2[j]);
                  
                }
            }
            entityGrid2.dataSource.add(currentDataItem);
            entityGrid.dataSource.remove(currentDataItem);
        }
    }
    var currentDataItem = data[0];
    if (currentDataItem != null) {
        for (var j = 0 ; j < totalNumber2 ; j++) {
            if (currentDataItem.InventoryID == data2[j].InventoryID &&
                currentDataItem.InventoryName == data2[j].InventoryName) {
                currentDataItem.RowNumber = data2[j].RowNumber;
                currentDataItem.InventoryID = data2[j].InventoryID;
                currentDataItem.InventoryName = data2[j].InventoryName;
                currentDataItem.ActualQuantity = currentDataItem.ActualQuantity + data2[j].ActualQuantity;
                currentDataItem.UnitPrice = currentDataItem.UnitPrice;
                currentDataItem.DiscountRate = currentDataItem.DiscountRate;
                currentDataItem.DiscountAmount = currentDataItem.DiscountAmount + data2[j].DiscountAmount;
              
                amountNewTable = currentDataItem.ActualQuantity * currentDataItem.UnitPrice;

                discountAmountNewTable = amountNewTable * (currentDataItem.DiscountRate / 100);
                currentDataItem.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                currentDataItem.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable


                currentDataItem.VATPercent = currentDataItem.VATPercent;
                currentDataItem.TaxAmount = currentDataItem.TaxAmount + data2[j].TaxAmount;

                entityGrid2.dataSource.remove(data2[j]);
                break;
            }
        }
        entityGrid2.dataSource.add(currentDataItem);
        entityGrid.dataSource.remove(currentDataItem);
    }
    var currentDataItem = data[0];
    if (currentDataItem != null) {
        for (var j = 0 ; j < totalNumber2 ; j++) {
            if (currentDataItem.InventoryID == data2[j].InventoryID &&
                currentDataItem.InventoryName == data2[j].InventoryName) {
                currentDataItem.RowNumber = data2[j].RowNumber;
                currentDataItem.InventoryID = data2[j].InventoryID;
                currentDataItem.InventoryName = data2[j].InventoryName;
                currentDataItem.ActualQuantity = currentDataItem.ActualQuantity + data2[j].ActualQuantity;
                currentDataItem.UnitPrice = currentDataItem.UnitPrice;
                currentDataItem.DiscountRate = currentDataItem.DiscountRate;
                currentDataItem.DiscountAmount = currentDataItem.DiscountAmount + data2[j].DiscountAmount;
                //var Amount = selectedItem.Quantity * selectedItem.UnitPrice;

                //selectedItem.DiscountAmount = Amount * (selectedItem.DiscountRate / 100);

                amountNewTable = currentDataItem.ActualQuantity * currentDataItem.UnitPrice;

                discountAmountNewTable = amountNewTable * (currentDataItem.DiscountRate / 100);
                currentDataItem.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                currentDataItem.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable


                currentDataItem.VATPercent = currentDataItem.VATPercent;
                currentDataItem.TaxAmount = currentDataItem.TaxAmount + data2[j].TaxAmount;
                //currentDataItem.InventoryAmount = currentDataItem.DiscountRate + data2[j].InventoryAmount;
                entityGrid2.dataSource.remove(data2[j]);
                break;
            }
        }
        entityGrid2.dataSource.add(currentDataItem);
        entityGrid.dataSource.remove(currentDataItem);
    }

}
// Xử lý sự kiện khi click nút Lưu và sao chép
function posf00201SaveCopy_Click() {

}

function sendDataFilter() {
    var apk = window.parent.posViewModel
        && window.parent.posViewModel.TempAPKMaster;
    if (apk) {
        var data = { apk31: apk };
        return data;
    } else {
        return {};
    }
}
function sendDataFilter2() {
    var data = {
        tableID: $("#NewTable").data("kendoComboBox").value(),
        areaID: $("#NewZone").data("kendoComboBox").value()
    };
    return data;
}


function table_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    entityGrid2.dataSource.page(0);
}

//Change
function Combobox_Change(e) {
    var check = ASOFT.form.checkItemInListFor(this, 'POSF0031');
    if (check) {
        e.sender.focus();
        entityGrid2.dataSource.page(0);
    }
}

function filterNewTable() {
    var item = apkMaster;
    var apk = -1;
    if (item != null) {
        apk = item;
    }
    return {
        apk: apk, areaID: $("#NewZone").val()
    };
}

function renderNumber(data) {
    return ++rowNumber;
}

function renderNumber2(data) {
       return ++rowNumber2;
}

function Grid_Save(e) {
   
}

function addItemToDataSource(newItem, ds) {
    var i = 0, item = null;
    // tim trong ds, neu tim thay item co id, va status giong voi item moi,
    // thi cap nhat so luong cua item da co    
    while (item = ds.at(i++)) {
        if (item.InventoryID === newItem.InventoryID
            && item.StatusRecordID === newItem.StatusRecordID) {
            item.ActualQuantity += newItem.ActualQuantity;
            item.Amount = item.UnitPrice * item.ActualQuantity;
            return;
        }
    }
    // neu khong tim thay, thi them item moi
    ds.add($.extend({}, newItem));
}

function returnSingle() {
    var data = ASOFT.helper.dataFormToJSON("POSF0031");
    var ds = entityGrid.dataSource;
    var ds2 = entityGrid2.dataSource;
    entityGrid2.select().each(function () {
        var selectedItem2 = entityGrid2.dataItem($(this));
        var _item = selectedItem2;
        // neu tim thay item
        if (_item) {
            // neu so luong item la 1, thi chuyen item sang ben trai
            if (_item.ActualQuantity === 1) {
                // xoa item khoi luoi ben phai
                ds2.remove(_item);
                // them item vao luoi ben trai
                addItemToDataSource(_item, ds);
            }
            // neu so luong nhieu hon 1
            else {
                _item.ActualQuantity -= 1;
                _item.Amount = _item.UnitPrice * _item.ActualQuantity;
                var newItem = $.extend({}, _item);
                newItem.ActualQuantity = 1;
                _item.Amount = _item.UnitPrice;
                addItemToDataSource(newItem, ds);
            }
        }
        entityGrid.refresh();
        entityGrid2.refresh();
        return;
    });
}

function returnAll() {
}