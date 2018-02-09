
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     19/06/2014     Chánh Thi        tạo mới
//####################################################################

var rowNumber = 0;
var rowNumber2 = 0;
var entityGrid = null;
var entityGrid2 = null;
var totalDiscountRate = 0;
var totalDiscoutnAmount = 0;
var totalRedureRate = 0;
var totalRedureAmount = 0;
var countTotalAmount = 0;
var totalDiscountRateCurrentTable = 0;
var totalDiscountAmountCurrentTable = 0;
var totalRedureRateCurrentTable = 0;
var totalRedureAmountCurrentTable = 0;
var totalDiscountRateNewTable = 0;
var totalDiscountAmountNewTable = 0;
var totalRedureRateNewTable = 0;
var totalRedureAmountNewTable = 0;
var apkMaster = window.parent.posViewModel && window.parent.posViewModel.TempAPKMaster;
$(document).ready(function () {
    entityGrid = $("#POSF0032AGrid").data("kendoGrid");
    entityGrid2 = $("#POSF0032BGrid").data("kendoGrid");

    entityGrid.bind('dataBound', function (e) {
        rowNumber = 0;
        for (var i = 0; i < entityGrid.dataSource.data().length ; i++) {
            dataFromController = entityGrid.dataSource.at(i);
            count = i + 1;
            console.log(dataFromController);
            if (dataFromController != null) {
                if (dataFromController.StatusRecordID == 1 || dataFromController.StatusRecordID == 0) {
                    $("#POSF0032AGrid tr").eq(count).css("color", "black");
                }
                else {
                    if (dataFromController.StatusRecordID == 2) {
                        $("#POSF0032AGrid tr").eq(count).css("color", "red");
                    }
                    else {
                        if (dataFromController.StatusRecordID == 3) {
                            $("#POSF0032AGrid tr").eq(count).css("color", "green");
                        }
                    }
                }

            }
        }
    });

    entityGrid2.bind('dataBound', function (e) {
        rowNumber2 = 0;
        for (var i = 0; i < entityGrid2.dataSource.data().length ; i++) {
            entityGrid2.dataSource.data()[i].RowNum = i;
            dataFromController2 = entityGrid2.dataSource.at(i);
            count2 = i + 1;
            if (dataFromController2 != null) {
                if (dataFromController2.StatusRecordID == 1) {
                    $("#POSF0032BGrid tr").eq(count2).css("color", "black");
                }
                else {
                    if (dataFromController2.StatusRecordID == 2) {
                        $("#POSF0032BGrid tr").eq(count2).css("color", "red");
                    }
                    else {
                        if (dataFromController2.StatusRecordID == 3) {
                            $("#POSF0032BGrid tr").eq(count2).css("color", "green");
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

function posf00201SaveNew_Click() {
    var dataPost = ASOFT.helper.dataFormToJSON('POSF0032');
    dataPost.ListCurrentTable = entityGrid.dataSource.data();
    dataPost.ListNewTable = entityGrid2.dataSource.data();
    $("#POSF0032BGrid tr").css("color", "green");
    var actionFlg = 1;
    var action = '/POS/POSF0032/CallBillHub';
    ASOFT.helper.postTypeJson(
              action,
              dataPost,
              function (data) {

                  if (data.Status == 0) {
                      switch (actionFlg) {
                          case 1:
                              ASOFT.form.displayInfo('#POSF0033', ASOFT.helper.getMessage(data.Message));
                              entityGrid.dataSource.read();
                              entityGrid2.dataSource.read();                              
                              break;
                      }
                  }
                  else {
                      if (data.Params == 1) {
                          ASOFT.dialog.messageDialog(ASOFT.helper.getMessage(data.MessageID));
                          entityGrid.dataSource.page(1);
                          entityGrid2.dataSource.page(1);
                          $('#CountTotalAmount').val(0);
                      }
                      else {
                          var msg = ASOFT.helper.getMessage(data.MessageID);
                          ASOFT.form.displayWarning('#POSF0032', msg);
                          entityGrid.dataSource.page(1);
                          entityGrid2.dataSource.page(1);
                          $('#CountTotalAmount').val(0);
                      }
                      
                      
                  }
                  window.parent.ASOFTCORE.triggerEvent({
                      type: 'refetch-master-details-by-apk-master',
                      data: {
                          apk: dataPost.APK,
                          AreaName: data.CurrentTable
                      }
                  });
              }
          );
}//end save (function)



// Xử lý sự kiện khi click nút Lưu và sao chép
function posf00201SaveCopy_Click() {
}
// Tách Bill 
//function changeSingle() {
//    var data = ASOFT.helper.dataFormToJSON("POSF0032");
//    totalDiscountRateCurrentTable = data.TotalDiscountRateCurrentTable;
//    totalDiscountAmountCurrentTable = data.TotalDiscountAmountCurrentTable;
//    totalRedureRateCurrentTable = data.TotalRedureRateCurrentTable;
//    totalRedureAmountCurrentTable = data.TotalRedureAmountCurrentTable;
//    // Chọn một dòng rồi tính toán lại số liệu dòng đó.
//    entityGrid.select().each(function () {
//        var selectedItem = entityGrid.dataItem($(this));
//        var newAmount = 0;
//        var newDiscountAmount = 0;
//        var newInventoryAmount = 0;
//        var newtotalAmount = 0;
//        var newAmount2 = 0;
//        var newDiscountAmount2 = 0;
//        var newInventoryAmount2 = 0;
//        var newtotalAmount2 = 0;
//        var total = entityGrid2.dataSource.total();
//        var dataCopy = selectedItem;
//        var countArray = 0;
//        var dataItem2 = null;
//        var rightObject = $.extend({}, selectedItem);
//        var actualQuantity = selectedItem.ActualQuantity;
//        // Nếu trong grid đã có dữ liệu
//            if (actualQuantity == 1) {// Nếu số lượng của dòng dc chọn <= 1 thực hiện xóa dòng đó bên grid 1
//                for (i = 0 ; i <= entityGrid2.dataSource.data().length ; i++) {
//                    dataItem = entityGrid2.dataSource.at(i);
//                    if (dataItem != null) {
//                        if (selectedItem.InventoryID == dataItem.InventoryID
//                            && selectedItem.InventoryName == dataItem.InventoryName) { // Nếu có dòng trùng

//                            if (selectedItem.StatusRecordID != dataItem.StatusRecordID) { // nếu trạng thái món mà khác nhau (khác màu)  
//                                break;
//                            }
//                            else { // nếu trạng thái món giống nhau

//                                rightObject.ActualQuantity = selectedItem.ActualQuantity + dataItem.ActualQuantity;
//                                // Tính toán lại ở đây........
//                                amountNewTable = selectedItem.ActualQuantity * selectedItem.UnitPrice;
//                                rightObject.Amount = amountNewTable; // tạo mới amount.

//                                discountAmountNewTable = amountNewTable * (selectedItem.DiscountRate / 100);
//                                rightObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

//                                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
//                                rightObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable

//                                entityGrid2.dataSource.remove(dataItem);
//                                break;
//                            }
//                        }
//                    }
//                }
//                entityGrid2.dataSource.add(rightObject);
//                entityGrid.dataSource.remove(selectedItem);
//                rowNumber = 0;
//                rowNumber2 = 0;

//            }
//            else
//            { // Nếu số lượng lớn hơn 1 thì số lượng của dòng đó bên grid 1 - 1 update lại số liệu
//                for (i = 0 ; i <= entityGrid2.dataSource.data().length ; i++) {
//                    dataItem = entityGrid2.dataSource.at(i);
//                    //var quantity = dataItem.ActualQuantity;
//                    if (dataItem != null) {
//                        if (selectedItem.InventoryID == dataItem.InventoryID
//                        && selectedItem.InventoryName == dataItem.InventoryName) { // Nếu có dòng trùng
                     
//                            selectedItem.ActualQuantity = dataItem.ActualQuantity + 1; // chuyển số lượng chỉ có 1 qua.
//                            // Tính toán các số lượng từng dòng.
//                            newAmount = selectedItem.ActualQuantity * selectedItem.UnitPrice;
//                            newDiscountAmount = newAmount * (selectedItem.DiscountRate / 100);
//                            newInventoryAmount = newAmount - newDiscountAmount;


//                            // Gán các giá trị mới vào;
//                            selectedItem.Amount = newAmount;
//                            selectedItem.DiscountAmount = newDiscountAmount;
//                            selectedItem.InventoryAmount = newInventoryAmount;

//                            entityGrid2.dataSource.remove(dataItem); // Grid2 remove dòng cũ.
//                            entityGrid.dataSource.remove(selectedItem);
//                            entityGrid2.dataSource.add(selectedItem);

//                            dataCopy.ActualQuantity = dataCopy.ActualQuantity - 1;

//                            newAmount2 = dataCopy.ActualQuantity * dataCopy.UnitPrice;
//                            newDiscountAmount2 = newAmount2 * (dataCopy.DiscountRate / 100);
//                            newInventoryAmount2 = newAmount2 - newDiscountAmount2;

//                            dataCopy.Amount = newAmount2;
//                            dataCopy.DiscountAmount = newDiscountAmount2;
//                            dataCopy.InventoryAmount = newInventoryAmount2;

//                            entityGrid.dataSource.add(dataCopy);
//                            rowNumber = 0;
//                            rowNumber2 = 0;
//                            break;
//                        }
//                        else {// Nếu không có dòng trùng
//                            countArray = countArray + 1;
//                        }
//                    }
//                    //else {// Nếu không có dòng trùng
//                    //    countArray = countArray + 1;
//                    //}
//                }

//                if (countArray == entityGrid2.dataSource.data().length) {// Nếu đi hết mảng rồi mà hok có dòng trùng thì insert một dòng mới.
//                    var dataItemCopy = selectedItem;
//                    var quantity = 1;
//                    var quantityGrid1 = selectedItem.ActualQuantity;

//                    selectedItem.ActualQuantity = quantity; // Nếu chưa có dữ liệu thì dòng dữ liệu dc fill qua lần đầu cũng bằng 1.
//                    // Tính toán grid 2
//                    newAmount = selectedItem.ActualQuantity * selectedItem.UnitPrice;
//                    newDiscountAmount = newAmount * (selectedItem.DiscountRate / 100);
//                    newInventoryAmount = newAmount - newDiscountAmount;

//                    selectedItem.Amount = newAmount;
//                    selectedItem.DiscountAmount = newDiscountAmount;
//                    selectedItem.InventoryAmount = newInventoryAmount;

//                    entityGrid.dataSource.remove(selectedItem);
//                    entityGrid2.dataSource.add(selectedItem);

//                    dataItemCopy.ActualQuantity = quantityGrid1 - 1;
//                    // Tính toán grid 1
//                    newAmount2 = dataItemCopy.ActualQuantity * dataItemCopy.UnitPrice;
//                    newDiscountAmount2 = newAmount2 * (dataItemCopy.DiscountRate / 100);
//                    newInventoryAmount2 = newAmount2 - newDiscountAmount2;

//                    // Tính toán giá trị mới cho grid1
//                    dataItemCopy.Amount = newAmount2;
//                    dataItemCopy.DiscountAmount = newDiscountAmount2;
//                    dataItemCopy.InventoryAmount = newInventoryAmount2;

                    
//                    entityGrid.dataSource.add(dataItemCopy);
//                    rowNumber = 0;
//                    rowNumber2 = 0;
//                } 
//        }
//        //else { // Nếu Grid chưa có dữ liệu 
//        //    var dataItemCopy = $.extend({}, selectedItem);
//        //    selectedItem.ActualQuantity = 1; // Nếu chưa có dữ liệu thì dòng dữ liệu dc fill qua lần đầu cũng bằng 1.
//        //    newAmount = selectedItem.ActualQuantity * selectedItem.UnitPrice;
//        //    newDiscountAmount = newAmount * (selectedItem.DiscountRate / 100);
//        //    newInventoryAmount = newAmount - newDiscountAmount;

//        //    dataItemCopy.ActualQuantity = dataItemCopy.ActualQuantity - 1;
//        //    newAmount2 = dataItemCopy.ActualQuantity * dataItemCopy.UnitPrice;
//        //    newDiscountAmount2 = newAmount * (dataItemCopy.DiscountRate / 100);
//        //    newInventoryAmount2 = newAmount - newDiscountAmount;

//        //    // Gán các giá trị mới vào;
//        //    selectedItem.Amount = newAmount;
//        //    selectedItem.DiscountAmount = newDiscountAmount;
//        //    selectedItem.InventoryAmount = newInventoryAmount;

//        //    // Tính toán giá trị mới cho grid1
//        //    dataItemCopy.Amount = newAmount2;
//        //    dataItemCopy.DiscountAmount = newDiscountAmount2;
//        //    dataItemCopy.InventoryAmount = newInventoryAmount2;


//        //    entityGrid2.dataSource.add(selectedItem);
//        //    entityGrid.dataSource.remove(selectedItem);
//        //    entityGrid.dataSource.add(dataItemCopy);
//        //}

       
//    });
//    for (var i = 0; i < entityGrid2.dataSource.data().length ; i++) {
//        dataFromController2 = entityGrid2.dataSource.at(i);
//        count2 = i + 1;
//        if (dataFromController2 != null) {
//            if (dataFromController2.StatusRecordID == 1) {
//                $("#POSF0032BGrid tr").eq(count2).css("color", "black");
//            }
//            else {
//                if (dataFromController2.StatusRecordID == 2) {
//                    $("#POSF0032BGrid tr").eq(count2).css("color", "red");
//                }
//                else {
//                    if (dataFromController2.StatusRecordID == 3) {
//                        $("#POSF0032BGrid tr").eq(count2).css("color", "green");
//                    }
//                }
//            }

//        }
//    }

//    // Tính toán Tổng Amount cho Grid2 các giá trị 
//    var totalAmount = entityGrid2.dataSource.at(0).ActualQuantity * entityGrid2.dataSource.at(0).UnitPrice;
//    var countTotalAmount = 0;
//    for (var i = 1 ; i < entityGrid2.dataSource.data().length ; i++) {
//        totalAmount = totalAmount + (entityGrid2.dataSource.at(i).ActualQuantity * entityGrid2.dataSource.at(i).UnitPrice);
//    }
//    // Tính toán TotalTaxAmount 
//    var amount = entityGrid2.dataSource.at(0).ActualQuantity * entityGrid2.dataSource.at(0).UnitPrice;
//        // Kiểm tra lại tại sao null ??
//    if (entityGrid2.dataSource.at(0).VATPercent == null) {
//        entityGrid2.dataSource.at(0).VATPercent = 0;
//    }
//    // Tính toán Total Tax Amount
//    var taxAmount = (amount - (amount * (entityGrid2.dataSource.at(0).DiscountRate / 100)) - ((parseFloat(totalDiscountAmountCurrentTable) * amount) / totalAmount) - ((parseFloat(totalRedureAmountCurrentTable) * amount) / totalAmount)) * entityGrid2.dataSource.at(0).VATPercent;
//    var countTotalInventoryAmount = entityGrid2.dataSource.at(0).InventoryAmount;
//    for (var i = 1 ; i < entityGrid2.dataSource.data().length ; i++) {
//        // Kiểm tra lại tại sao null ??
//        if (entityGrid2.dataSource.at(i).VATPercent == null) {
//            entityGrid2.dataSource.at(i).VATPercent = 0;
//        }
//        amount = amount + entityGrid2.dataSource.at(i).ActualQuantity * entityGrid2.dataSource.at(i).UnitPrice;;
//        taxAmount = taxAmount + (amount - (amount * (entityGrid2.dataSource.at(i).DiscountRate / 100)) - ((parseFloat(totalDiscountAmountCurrentTable) * amount) / totalAmount) - ((parseFloat(totalRedureAmountCurrentTable) * amount) / totalAmount)) * entityGrid2.dataSource.at(i).VATPercent;
//        countTotalInventoryAmount = entityGrid2.dataSource.at(i).InventoryAmount;
//    }

//    // Tính thành tiền
//    countTotalAmount = countTotalInventoryAmount + taxAmount - parseFloat(totalDiscountAmountCurrentTable) - parseFloat(totalRedureAmountCurrentTable);

//    $('#CountTotalAmount').val(countTotalAmount);
//}

function changeSingle() { // New from POSF0031

    var ds = entityGrid.dataSource;
    var ds2 = entityGrid2.dataSource;

    // Biến kiểm tra lần đầu 
    entityGrid.select().each(function () {        
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
        var totalAmount = entityGrid2.dataSource.at(0).ActualQuantity * entityGrid2.dataSource.at(0).UnitPrice;
        var countTotalAmount = 0;
        for (var i = 1 ; i < entityGrid2.dataSource.data().length ; i++) {
            totalAmount = totalAmount + (entityGrid2.dataSource.at(i).ActualQuantity * entityGrid2.dataSource.at(i).UnitPrice);
        }

        $('#CountTotalAmount').val(totalAmount);
        return;

    });

    var data = ASOFT.helper.dataFormToJSON("POSF0032");
    totalDiscountRateCurrentTable = data.TotalDiscountRateCurrentTable;
    totalDiscountAmountCurrentTable = data.TotalDiscountAmountCurrentTable;
    totalRedureRateCurrentTable = data.TotalRedureRateCurrentTable;
    totalRedureAmountCurrentTable = data.TotalRedureAmountCurrentTable;
    //var amountCurrentTable = 0;
    //    totalDiscountRateCurrentTable = 0;
    //    totalDiscountAmountCurrentTable = 0;
    //    totalRedureRateCurrentTable = 0;
    //    totalRedureAmountCurrentTable = 0;
    //    taxAmountCurrentTable = 0;
    //    discountAmountCurrentTable = 0;
    //    inventoryAmountCurrentTable = 0;
    //    totalAmountCurrentTable = 0;
    //    totalDiscountAmountCurrentTable = 0;
    //    sumAmountCurrentTable = 0;
    //    sumDiscountAmountCurrentTable = 0;
    //var amountNewTable = 0;
    //    totalDiscountRateNewTable = 0;
    //    totalDiscountAmountNewTable = 0;
    //    totalRedureRateNewTable = 0;
    //    totalRedureAmountNewTable = 0;
    //    taxAmountNewTable = 0;
    //    discountAmountNewTable = 0;
    //    inventoryAmountNewTable = 0;
    //    totalAmountNewTable = 0;
    //    totalDiscountAmountNewTable = 0;
    //    sumAmountNewTable = 0;
    //    sumDiscountAmountNewTable = 0;
    // Biến kiểm tra lần đầu 
    entityGrid.select().each(function () {
        //if (data.NewZone == '' || data.NewTable == '') {
        //    ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('POSM000047'));
        //    return false;
        //}
        var selectedItem = entityGrid.dataItem($(this));
        var selectItemCopy = entityGrid.dataItem($(this)); // Tạo bản sao
        var selectItemCopy2 = entityGrid.dataItem($(this)); // Tạo bản sao thứ hai
        var quantityGrid2 = selectItemCopy2.ActualQuantity;
        var selectedGrid = null;
        var rightObject = $.extend({}, selectedItem); // nhân bản 
        var countInFor = 0; // dùng để đếm trong vòng For
        countMemberGrid = 0;
        firstTime = 0;
        // Kiểm tra xem dòng được chọn có số lượng nhỏ hơn 1 thì xóa dòng cũ bên Grid bên trái vào insert qua bên mới.
        if (selectedItem.ActualQuantity <= 1) {
            // Kiểm tra xem dòng được chọn có trong Grid bên phải chưa
            for (i = 0 ; i <= entityGrid2.dataSource.data().length ; i++) {
                dataItem = entityGrid2.dataSource.at(i);
                if (dataItem != null) {
                    if (selectedItem.InventoryID == dataItem.InventoryID
                        && selectedItem.InventoryName == dataItem.InventoryName) { // Nếu có dòng trùng

                        if (selectedItem.StatusRecordID != dataItem.StatusRecordID) { // nếu trạng thái món mà khác nhau (khác màu)  
                            break;
                        }
                        else { // nếu trạng thái món giống nhau

                            rightObject.ActualQuantity = selectedItem.ActualQuantity + dataItem.ActualQuantity;
                            // Tính toán lại ở đây........
                            amountNewTable = selectedItem.ActualQuantity * selectedItem.UnitPrice;
                            rightObject.Amount = amountNewTable; // tạo mới amount.

                            discountAmountNewTable = amountNewTable * (selectedItem.DiscountRate / 100);
                            rightObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                            inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                            rightObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable

                            entityGrid2.dataSource.remove(dataItem);
                            countInFor = countInFor + 1;
                            break;
                        }
                    }
                }
            }
            entityGrid2.dataSource.add(rightObject);
            entityGrid.dataSource.remove(selectedItem);
            countInFor = countInFor + 1;

            //ASOFT.asoftGrid.totalRow = entityGrid2.dataSource.data().length;
            //entityGrid2.dataSource.total = ASOFT.asoftGrid.setTotalRow;
            //if (entityGrid2.dataSource.data()[0].InventoryID == null) {
            //    entityGrid2.dataSource.data().remove(0);
            //}
        }
        else {// Dòng được chọn số lượng lớn hơn 1
            for (i = 0 ; i <= entityGrid2.dataSource.data().length ; i++) {
                dataItem = entityGrid2.dataSource.at(i);
                if (dataItem != null) {
                    if (selectedItem.InventoryID == dataItem.InventoryID
                        && selectedItem.InventoryName == dataItem.InventoryName) {// Nếu có dòng trùng
                        if (selectedItem.StatusRecordID != dataItem.StatusRecordID) {// nếu khác màu
                            entityGrid.dataSource.remove(selectItemCopy); // Xóa dòng cũ ở lưới 1
                            if (firstTime == 0) { // nếu mà insert dòng mới lần đầu vào grid
                                rightObject.ActualQuantity = 1;
                                // tính toán số liệu Grid 2 tại đây...........
                                firstTime = firstTime + 1;
                                amountNewTable = rightObject.ActualQuantity * rightObject.UnitPrice;
                                rightObject.Amount = amountNewTable; // tạo mới amount.

                                discountAmountNewTable = amountNewTable * (rightObject.DiscountRate / 100);
                                rightObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                                rightObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                                entityGrid2.dataSource.add(rightObject);
                                countInFor = countInFor + 1;
                                break;
                            }
                            else { // Insert không phải lần đầu
                                rightObject.ActualQuantity = dataItem.ActualQuantity + 1;

                                // tính toán số liệu Grid 2 tại đây..........
                                amountNewTable = rightObject.ActualQuantity * rightObject.UnitPrice;
                                rightObject.Amount = amountNewTable; // tạo mới amount.

                                discountAmountNewTable = amountNewTable * (rightObject.DiscountRate / 100);
                                rightObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                                rightObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                                entityGrid2.dataSource.add(rightObject);
                                countInFor = countInFor + 1;
                                break;
                            }
                        }
                        else { //Cùng màu
                            rightObject.ActualQuantity = 1 + dataItem.ActualQuantity;
                            // Tính toán lại ở đây........
                            amountNewTable = rightObject.ActualQuantity * rightObject.UnitPrice;
                            rightObject.Amount = amountNewTable; // tạo mới amount.

                            discountAmountNewTable = amountNewTable * (rightObject.DiscountRate / 100);
                            rightObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                            inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                            rightObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable

                            entityGrid2.dataSource.remove(dataItem);
                            entityGrid.dataSource.remove(selectItemCopy);

                            entityGrid2.dataSource.add(rightObject);
                            countInFor = countInFor + 1;
                            break;
                        }
                    }
                    else {
                        countMemberGrid = countMemberGrid + 1;
                    }
                }
                else {
                    countMemberGrid = countMemberGrid + 1;
                }
            }
        }
        if (countMemberGrid != 0 && countInFor == 0) {
            if (firstTime == 0) { // nếu mà insert dòng mới lần đầu vào grid
                entityGrid.dataSource.remove(selectItemCopy);
                rightObject.ActualQuantity = 1;

                // Tính Toán số lượng tổng cộng của Grid 2 tại đây
                amountNewTable = selectedItem.ActualQuantity * selectedItem.UnitPrice;
                rightObject.Amount = amountNewTable; // tạo mới amount.

                discountAmountNewTable = amountNewTable * (selectedItem.DiscountRate / 100);
                rightObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                rightObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                firstTime++;
                //console.log(firstTime);
                entityGrid2.dataSource.add(rightObject);
                selectedGrid = rightObject;
                countInFor = countInFor + 1;
            }
            else {
                //quantityNew = 1;
                entityGrid2.dataSource.remove(selectedItem);
                entityGrid.dataSource.remove(selectItemCopy);
                //rightObject.ActualQuantity = quantityNew + 1;
                rightObject.ActualQuantity = quantityNew;

                amountNewTable = rightObject.ActualQuantity * rightObject.UnitPrice;

                discountAmountNewTable = amountNewTable * (rightObject.DiscountRate / 100);
                rightObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                rightObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                firstTime++;

                entityGrid2.dataSource.add(rightObject);
                quantityNew++;
            }
        }
        selectItemCopy2.ActualQuantity = quantityGrid2 - 1;
        // tính toán số liệu Grid 1 tại đây
        amountNewTable = selectItemCopy2.ActualQuantity * selectItemCopy2.UnitPrice;
        selectItemCopy2.Amount = amountNewTable; // tạo mới amount.

        discountAmountNewTable = amountNewTable * (selectItemCopy2.DiscountRate / 100);
        selectItemCopy2.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

        inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
        selectItemCopy2.InventoryAmount = inventoryAmountNewTable;
        if (quantityGrid2 > 1) {
            entityGrid.dataSource.add(selectItemCopy2);// Add dòng mới cập nhật số lượng lị vào Grid1
            // Add dòng mới vào lưới 2.
        }

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
                        $("#POSF0031AGrid tr").eq(count).css("color", "green");
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
                $("#POSF0032BGrid tr").eq(count2).css("color", "black");
            }
            else {
                if (dataFromController2.StatusRecordID == 2) {
                    $("#POSF0032BGrid tr").eq(count2).css("color", "red");
                }
                else {
                    if (dataFromController2.StatusRecordID == 3) {
                        $("#POSF0032BGrid tr").eq(count2).css("color", "green");
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

    $('#CountTotalAmount').val(totalAmount);
    
}

//function returnSingle() {

//    entityGrid2.select().each(function () {
//        var selectedItem2 = entityGrid2.dataItem($(this));
//        var newAmount3 = 0;
//        var newDiscountAmount3 = 0;
//        var newInventoryAmount3 = 0;
//        var newtotalAmount3 = 0;
//        var newAmount4 = 0;
//        var newDiscountAmount4 = 0;
//        var newInventoryAmount4 = 0;
//        var newtotalAmount4 = 0;
//        var countArray2 = 0;
//        var rightObject2 = $.extend({}, selectedItem2);
//        var dataCopy2 = selectedItem2;
//        var actualQuantity2 = selectedItem2.ActualQuantity;
//        if (actualQuantity2 == 1) {// Nếu số lượng của dòng dc chọn <= 1 thực hiện xóa dòng đó bên grid 1
//            for (i = 0 ; i <= entityGrid.dataSource.data().length ; i++) {
//                dataItem = entityGrid.dataSource.at(i);
//                if (dataItem != null) {
//                    if (selectedItem2.InventoryID == dataItem.InventoryID
//                        && selectedItem2.InventoryName == dataItem.InventoryName) { // Nếu có dòng trùng

//                        if (selectedItem2.StatusRecordID != dataItem.StatusRecordID) { // nếu trạng thái món mà khác nhau (khác màu)  
//                            break;
//                        }
//                        else { // nếu trạng thái món giống nhau

//                            rightObject2.ActualQuantity = selectedItem2.ActualQuantity + dataItem.ActualQuantity;
//                            // Tính toán lại ở đây........
//                            amountNewTable = selectedItem2.ActualQuantity * selectedItem2.UnitPrice;
//                            rightObject2.Amount = amountNewTable; // tạo mới amount.

//                            discountAmountNewTable = amountNewTable * (selectedItem2.DiscountRate / 100);
//                            rightObject2.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

//                            inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
//                            rightObject2.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable

//                            entityGrid.dataSource.remove(dataItem);
//                            break;
//                        }
//                    }
//                }
//            }
//            entityGrid.dataSource.add(rightObject2);
//            entityGrid2.dataSource.remove(selectedItem2);
//        }
//        else { // Nếu số lượng lớn hơn 1 thì số lượng của dòng đó bên grid 1 - 1 update lại số liệu
//            for (i = 0 ; i <= entityGrid.dataSource.data().length ; i++) {
//                dataItem = entityGrid.dataSource.at(i);
//                //var quantity = dataItem.ActualQuantity;
//                if (dataItem != null) {
//                    if (selectedItem2.InventoryID == dataItem.InventoryID
//                    && selectedItem2.InventoryName == dataItem.InventoryName) { // Nếu có dòng trùng

//                        selectedItem.ActualQuantity = dataItem.ActualQuantity + 1; // chuyển số lượng chỉ có 1 qua.
//                        // Tính toán các số lượng từng dòng.
//                        newAmount3 = selectedItem2.ActualQuantity * selectedItem2.UnitPrice;
//                        newDiscountAmount3 = newAmount3 * (selectedItem2.DiscountRate / 100);
//                        newInventoryAmount3 = newAmount3 - newDiscountAmount3;


//                        // Gán các giá trị mới vào;
//                        selectedItem2.Amount = newAmount4;
//                        selectedItem2.DiscountAmount = newDiscountAmount4;
//                        selectedItem2.InventoryAmount = newInventoryAmount4;

//                        entityGrid2.dataSource.remove(dataItem); // Grid2 remove dòng cũ.
//                        entityGrid.dataSource.remove(selectedItem2);
//                        entityGrid2.dataSource.add(selectedItem2);

//                        dataCopy2.ActualQuantity = dataCopy2.ActualQuantity - 1;

//                        newAmount4 = dataCopy2.ActualQuantity * dataCopy2.UnitPrice;
//                        newDiscountAmount4 = newAmount4 * (dataCopy2.DiscountRate / 100);
//                        newInventoryAmount4 = newAmount4 - newDiscountAmount2;

//                        dataCopy2.Amount = newAmount4;
//                        dataCopy2.DiscountAmount = newDiscountAmount4;
//                        dataCopy2.InventoryAmount = newInventoryAmount4;

//                        entityGrid.dataSource.add(dataCopy2);
//                        break;
//                    }
//                    else {// Nếu không có dòng trùng
//                        countArray2 = countArray2 + 1;
//                    }
//                }
//            }

//            if (countArray2 == entityGrid.dataSource.data().length) {// Nếu đi hết mảng rồi mà hok có dòng trùng thì insert một dòng mới.
//                var dataItemCopy2 = selectedItem2;
//                var quantity2 = 1;
//                var quantityGrid2 = selectedItem2.ActualQuantity;

//                selectedItem2.ActualQuantity = quantity2; // Nếu chưa có dữ liệu thì dòng dữ liệu dc fill qua lần đầu cũng bằng 1.
//                // Tính toán grid 2
//                newAmount3 = selectedItem2.ActualQuantity * selectedItem2.UnitPrice;
//                newDiscountAmount3 = newAmount3 * (selectedItem.DiscountRate / 100);
//                newInventoryAmount3 = newAmount3 - newDiscountAmount3;

//                selectedItem2.Amount = newAmount3;
//                selectedItem2.DiscountAmount = newDiscountAmount3;
//                selectedItem2.InventoryAmount = newInventoryAmount3;

//                entityGrid.dataSource.remove(selectedItem2);
//                entityGrid2.dataSource.add(selectedItem2);

//                dataItemCopy2.ActualQuantity = quantityGrid2 - 1;
//                // Tính toán grid 1
//                newAmount2 = dataItemCopy2.ActualQuantity * dataItemCopy2.UnitPrice;
//                newDiscountAmount2 = newAmount2 * (dataItemCopy2.DiscountRate / 100);
//                newInventoryAmount2 = newAmount2 - newDiscountAmount2;

//                // Tính toán giá trị mới cho grid1
//                dataItemCopy2.Amount = newAmount2;
//                dataItemCopy2.DiscountAmount = newDiscountAmount2;
//                dataItemCopy2.InventoryAmount = newInventoryAmount2;
//                entityGrid.dataSource.add(dataItemCopy2);
//            }
        
//        }
//    });

//    entityGrid2.bind('dataBound', function (e) {
//        rowNumber = 0;
//        for (var i = 0; i < entityGrid2.dataSource.data().length ; i++) {
//            dataFromController = entityGrid2.dataSource.at(i);
//            count = i + 1;
//            console.log(dataFromController);
//            if (dataFromController != null) {
//                if (dataFromController.StatusRecordID == 1 || dataFromController.StatusRecordID == 0) {
//                    $("#POSF0032BGrid tr").eq(count).css("color", "black");
//                }
//                else {
//                    if (dataFromController.StatusRecordID == 2) {
//                        $("#POSF0032BGrid tr").eq(count).css("color", "red");
//                    }
//                    else {
//                        if (dataFromController.StatusRecordID == 3) {
//                            $("#POSF0032BGrid tr").eq(count).css("color", "green");
//                        }
//                    }
//                }

//            }
//        }
//    });
//}

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

    var ds = entityGrid.dataSource;
    var ds2 = entityGrid2.dataSource;

    entityGrid2.select().each(function () {
        $('#CountTotalAmount').val(0);
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
        var totalAmount = ds2.at(0).ActualQuantity * ds2.at(0).UnitPrice;
        var countTotalAmount = 0;
        for (var i = 1 ; i < entityGrid2.dataSource.data().length ; i++) {
            totalAmount = totalAmount + (entityGrid2.dataSource.at(i).ActualQuantity * entityGrid2.dataSource.at(i).UnitPrice);
        }

        $('#CountTotalAmount').val(totalAmount);
        return;
    });

    var data = ASOFT.helper.dataFormToJSON("POSF0032");
    entityGrid2.select().each(function () {
        var selectedItem2 = entityGrid2.dataItem($(this));
        var selectItemCopy3 = entityGrid2.dataItem($(this)); // Tạo bản sao
        var selectItemCopy4 = entityGrid2.dataItem($(this)); // Tạo bản sao thứ hai
        var quantityGrid3 = selectItemCopy4.ActualQuantity;
        var selectedGrid = null;
        var countGrid2 = 0;
        var leftObject = $.extend({}, selectedItem2); // nhân bản 
        var countInfo = 0;
        countMemberGrid2 = 0;
        checkSame = 0;
        $('#CountTotalAmount').val(0);
        if (selectedItem2.ActualQuantity <= 1) {
            for (i = 0 ; i <= entityGrid.dataSource.data().length ; i++) {
                dataItem2 = entityGrid.dataSource.at(i);
                if (dataItem2 != null) {
                    if (selectedItem2.InventoryID == dataItem2.InventoryID
                        && selectedItem2.InventoryName == dataItem2.InventoryName) {
                        if (selectedItem2.StatusRecordID != dataItem2.StatusRecordID) { // nếu trạng thái món mà khác nhau (khác màu)  
                            break;
                        }
                        else { // nếu trạng thái món giống nhau
                            checkSame = 1;
                            leftObject.ActualQuantity = selectedItem2.ActualQuantity + dataItem2.ActualQuantity;
                            // Tính toán lại ở đây........
                            amountNewTable = selectedItem2.ActualQuantity * selectedItem2.UnitPrice;
                            leftObject.Amount = amountNewTable; // tạo mới amount.

                            discountAmountNewTable = amountNewTable * (selectedItem2.DiscountRate / 100);
                            leftObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                            inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                            leftObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable

                            entityGrid.dataSource.remove(dataItem2);
                            break;
                        }
                    }
                    else {
                        countGrid2 = countGrid2 + 1;
                    }
                }
            }

            if (countGrid2 == entityGrid.dataSource.data().length && checkSame == 0) {
                leftObject.ActualQuantity = selectedItem2.ActualQuantity;
                // Tính toán lại ở đây........
                amountNewTable = selectedItem2.ActualQuantity * selectedItem2.UnitPrice;
                leftObject.Amount = amountNewTable; // tạo mới amount.

                discountAmountNewTable = amountNewTable * (selectedItem2.DiscountRate / 100);
                leftObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                leftObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                entityGrid.dataSource.add(leftObject);
                entityGrid2.dataSource.remove(selectedItem2);
            }
            else {
                entityGrid.dataSource.add(leftObject);
                entityGrid2.dataSource.remove(selectedItem2);
            }

        }
        else {
            if (entityGrid.dataSource.data().length != 0) { // nếu màn hình bên trái có giá trị
                for (i = 0 ; i <= entityGrid.dataSource.data().length ; i++) {
                    dataItem2 = entityGrid.dataSource.at(i);
                    if (dataItem2 != null) {
                        if (selectedItem2.InventoryID == dataItem2.InventoryID
                               && selectedItem2.InventoryName == dataItem2.InventoryName) {// Nếu có dòng trùng
                            if (selectedItem2.StatusRecordID != dataItem2.StatusRecordID) {// nếu khác màu
                                entityGrid2.dataSource.remove(selectItemCopy3); // Xóa dòng cũ ở lưới 1
                                if (firstTime2 == 0) { // nếu mà insert dòng mới lần đầu vào grid
                                    leftObject.ActualQuantity = 1;
                                    // tính toán số liệu Grid 2 tại đây...........
                                    firstTime2 = firstTime2 + 1;
                                    break;
                                }
                                else { // Insert không phải lần đầu
                                    leftObject.ActualQuantity = dataItem2.ActualQuantity + 1;
                                    // tính toán số liệu Grid 2 tại đây..........
                                    break;
                                }

                            }
                            else {
                                if (countInfo == 0) {
                                    leftObject.ActualQuantity = 1 + dataItem2.ActualQuantity;
                                    // Tính toán lại ở đây........
                                    amountNewTable = leftObject.ActualQuantity * leftObject.UnitPrice;
                                    leftObject.Amount = amountNewTable; // tạo mới amount.

                                    discountAmountNewTable = amountNewTable * (leftObject.DiscountRate / 100);
                                    leftObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                                    inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                                    leftObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable

                                    entityGrid.dataSource.remove(dataItem2);
                                    entityGrid2.dataSource.remove(selectItemCopy3);

                                    entityGrid.dataSource.add(leftObject);
                                    break;
                                }
                            }
                        }
                        else {
                            //countMemberGrid2 = countMemberGrid2 + 1;
                            if (countInfo == 0) {
                                if (selectedItem2.InventoryID != dataItem2.InventoryID
                                    && selectedItem2.InventoryName != dataItem2.InventoryName
                                    && entityGrid.dataSource.data().length == 0) {
                                    entityGrid2.dataSource.remove(selectItemCopy3);
                                    leftObject.ActualQuantity = 1;

                                    // Tính Toán số lượng tổng cộng của Grid 2 tại đây
                                    amountNewTable = selectedItem2.ActualQuantity * selectedItem2.UnitPrice;
                                    leftObject.Amount = amountNewTable; // tạo mới amount.

                                    discountAmountNewTable = amountNewTable * (selectedItem2.DiscountRate / 100);
                                    leftObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                                    inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                                    leftObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                                    firstTime++;
                                    //console.log(firstTime);
                                    entityGrid.dataSource.add(leftObject);
                                    selectedGrid = leftObject;
                                    countInfo = countInfo + 1;
                                }
                                else {
                                    countMemberGrid2 = countMemberGrid2 + 1;
                                }
                            }
                        }
                    }
                    else {
                        countMemberGrid2 = countMemberGrid2 + 1;
                    }
                }
            }
            else { // Nếu grid bên trái chưa có dòng nào 
                //entityGrid2.dataSource.remove(selectItemCopy3);
                //leftObject.ActualQuantity = 1;

                //// Tính Toán số lượng tổng cộng của Grid 2 tại đây
                //amountNewTable = selectedItem2.ActualQuantity * selectedItem2.UnitPrice;
                //leftObject.Amount = amountNewTable; // tạo mới amount.

                //discountAmountNewTable = amountNewTable * (selectedItem2.DiscountRate / 100);
                //leftObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                //inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                //leftObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                //firstTime++;
                ////console.log(firstTime);
                //entityGrid.dataSource.add(leftObject);
                //selectedGrid = leftObject;
                //countInfo = countInfo + 1;

            }

        }
        if (countMemberGrid2 == entityGrid.dataSource.data().length) {
            if (firstTime2 == 0) { // nếu mà insert dòng mới lần đầu vào grid
                entityGrid2.dataSource.remove(selectItemCopy3);
                leftObject.ActualQuantity = 1;

                // Tính Toán số lượng tổng cộng của Grid 2 tại đây
                amountNewTable = selectedItem2.ActualQuantity * selectedItem2.UnitPrice;
                leftObject.Amount = amountNewTable; // tạo mới amount.

                discountAmountNewTable = amountNewTable * (selectedItem2.DiscountRate / 100);
                leftObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                leftObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                firstTime++;
                //console.log(firstTime);
                entityGrid.dataSource.add(leftObject);
                selectedGrid = leftObject;
            }
            else {
                //quantityNew = 1;
                entityGrid.dataSource.remove(selectedItem2);
                entityGrid2.dataSource.remove(selectItemCopy3);
                //leftObject.ActualQuantity = quantityNew + 1;
                leftObject.ActualQuantity = quantityNew;

                amountNewTable = leftObject.ActualQuantity * leftObject.UnitPrice;

                discountAmountNewTable = amountNewTable * (leftObject.DiscountRate / 100);
                leftObject.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

                inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
                leftObject.InventoryAmount = inventoryAmountNewTable; // tạo mới inventoryAmountNewTable
                firstTime++;

                entityGrid2.dataSource.add(leftObject);
                quantityNew++;
            }
        }
        selectItemCopy4.ActualQuantity = quantityGrid3 - 1;
        // tính toán số liệu Grid 1 tại đây
        amountNewTable = selectItemCopy4.ActualQuantity * selectItemCopy4.UnitPrice;
        selectItemCopy4.Amount = amountNewTable; // tạo mới amount.
        discountAmountNewTable = amountNewTable * (selectItemCopy4.DiscountRate / 100);
        selectItemCopy4.DiscountAmount = discountAmountNewTable;// tạo mới discountAmount

        inventoryAmountNewTable = amountNewTable - discountAmountNewTable;
        selectItemCopy4.InventoryAmount = inventoryAmountNewTable;
        if (quantityGrid3 > 1) {
            entityGrid2.dataSource.add(selectItemCopy4);// Add dòng mới cập nhật số lượng lị vào Grid1
            // Add dòng mới vào lưới 2.
        }

        // Set màu cho dòng trong grid thứ 1
        for (var i = 0; i < entityGrid.dataSource.data().length ; i++) {
            dataFromController = entityGrid.dataSource.at(i);
            count = i + 1;
            console.log(dataFromController);
            if (dataFromController != null) {
                if (dataFromController.StatusRecordID == 1 || dataFromController.StatusRecordID == 0) {
                    $("#POSF0032AGrid tr").eq(count).css("color", "black");
                }
                else {
                    if (dataFromController.StatusRecordID == 2) {
                        $("#POSF0032AGrid tr").eq(count).css("color", "red");
                    }
                    else {
                        if (dataFromController.StatusRecordID == 3) {
                            $("#POSF0032AGrid tr").eq(count).css("color", "green");
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
                    $("#POSF0032BGrid tr").eq(count2).css("color", "black");
                }
                else {
                    if (dataFromController2.StatusRecordID == 2) {
                        $("#POSF0032BGrid tr").eq(count2).css("color", "red");
                    }
                    else {
                        if (dataFromController2.StatusRecordID == 3) {
                            $("#POSF0032BGrid tr").eq(count2).css("color", "green");
                        }
                    }
                }

            }
        }

        var totalAmount = entityGrid2.dataSource.at(0).ActualQuantity * entityGrid2.dataSource.at(0).UnitPrice;
        var countTotalAmount = 0;
        for (var i = 1 ; i < entityGrid2.dataSource.data().length ; i++) {
            totalAmount = totalAmount + (entityGrid2.dataSource.at(i).ActualQuantity * entityGrid2.dataSource.at(i).UnitPrice);
        }

        $('#CountTotalAmount').val(totalAmount);

    });

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
    var data = {};
    return data;
}

function renderNumber(data) {
    return ++rowNumber;
}

function renderNumber2(data) {
    return ++rowNumber2;
}