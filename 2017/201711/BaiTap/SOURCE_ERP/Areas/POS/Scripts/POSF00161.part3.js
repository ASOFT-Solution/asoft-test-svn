//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//#     13/06/2014      Minh Lâm         Thay đổi công thức mới
//####################################################################
//var popup = null;

(function(){
    $("#TotalAmount, #TotalTaxAmount, #TotalDiscountRate, #TotalDiscountAmount, #TotalRedureRate, #TotalRedureAmount, #PaymentObjectAmount01, #PaymentObjectAmount02, #TotalInventoryAmount, #Change").addClass('asf-temporary-disable');
}());

var posGrid = null;
var gridData = [];
var posViewModel = null;
var rowNumber = 0;
var barcode = "";
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
var CSS_HIDDEN = 'hidden';
var isBardcode = false;
var btnReturn = null;
var btnChangeInventory = null;

$(document).ready(function () {
    btnReturn = $("#BtnReturn").data("kendoButton");
    btnChangeInventory = $("#BtnChangeInventory").data("kendoButton");

    posGrid = $("#mainGrid").data("kendoGrid");
    //resize grid
    resizeGrid();
    //create viewmodel
    createViewModel();
    //addevent
    addEventNumberic();
    $("#closeWindow").click(function (event) {
        var btnPay = $("#btnSave").data("kendoButton");
        if (btnPay.options != null && btnPay.options.enable) {
            ASOFT.dialog.confirmDialog(
            ASOFT.helper.getMessage('00ML000016'),
            //yes
            function () {
                posViewModel.save();
            }, function () {
                if (typeof(overrideClose) === "function") {
                    //raise event
                    overrideClose();
                    return;
                } else {
                    parent.detailPopup_Close(event);
                }
            });
        } else {
            if (typeof (overrideClose) === "function") {
                //raise event
                overrideClose();
                return;
            } else {
                parent.detailPopup_Close(event);
            }
        }
    });

    var iventoryAutoComplete = $("#InventoryID").data("kendoAutoComplete");
    if (iventoryAutoComplete != undefined) {
        iventoryAutoComplete.focus();

        $(iventoryAutoComplete.element).scannerDetection(function (data) {
            isBardcode = true;
        });
    }

    

    var MemberIDAutoComplete = $("#MemberID").data("kendoAutoComplete");
    $(MemberIDAutoComplete.element).scannerDetection(function (data) {
        isBardcode = true;
    });
    /*$("#MemberID").kendoAutoComplete({
        delay: 150
    });*/
    //membername 
    $("#MemberName").keypress(function (e) {
        e.preventDefault();
        return false;
    });

    //show combox
    /*if ($("#APK").val() != EMPTY_GUID) {
        var paymentID = posViewModel.toString("APKPaymentID");
        $("#APKPaymentID").data("kendoComboBox").value(paymentID);
    }*/

});

/******************************************************************************
                            ViewModel
*******************************************************************************/

/**
* Create viewmodel for MVVM
*/
function createViewModel() {
    posViewModel = kendo.observable({
        IsBuy: ($("#IsBuy").val() == "True"),
        isAutoCalAmount: false,
        MemberID: '',
        Status: $("#Status").val(),
        ChangeAmount: $("#ChangeAmount").val(),
        MemberName: $("#MemberName").val(),
        CurrencyID: $("#CurrencyID").data("kendoComboBox").value(),
        VoucherNo: $("#VoucherNo").val(),
        PVoucherNo: $("#PVoucherNo").val(),
        CVoucherNo: $("#CVoucherNo").val(),
        ReVoucherNo: $("#ReVoucherNo").val(),
        TotalAmount: $("#TotalAmount").html(),
        TotalTaxAmount: $("#TotalTaxAmount").html(),
        TotalDiscountRate: $("#TotalDiscountRate").val(),
        TotalDiscountAmount: $("#TotalDiscountAmount").val(),
        TotalRedureRate: $("#TotalRedureRate").val(),
        TotalRedureAmount: $("#TotalRedureAmount").val(),
        PaymentObjectAmount01: $("#PaymentObjectAmount01").val(),
        PaymentObjectAmount02: $("#PaymentObjectAmount02").val(),
        AccountNumber01: $("#AccountNumber01").val(),
        AccountNumber02: $("#AccountNumber02").val(),
        PaymentObjectID01: $("#PaymentObjectID01").data("kendoComboBox").value(),
        PaymentObjectID02: $("#PaymentObjectID02").data("kendoComboBox").value(),
        Change: $("#Change").html(),
        gridDataSource: posGrid.dataSource,
        APKPaymentID: $("#APKPaymentID").data("kendoComboBox").value(),
        GetObjectName: function (cboID) {
            var combo = $(cboID).data("kendoComboBox");
            var item = combo.dataItem();
            if (item != undefined) {
                return item.ObjectName;
            }
            return "";
        },
        dataFilter: function () {
            return { APK: $('#APK').val() };
        },
        formatNumbers: function () {
            $("#TotalAmount").html(this.formatMoney(this.convertToNumber(this.TotalAmount)));
            $("#TotalTaxAmount").html(this.formatMoney(this.convertToNumber(this.TotalTaxAmount)));
            $("#TotalDiscountRate").val(this.formatPercent(this.convertToNumber(this.TotalDiscountRate)));
            $("#TotalDiscountAmount").val(this.formatMoney(this.TotalDiscountAmount));
            $("#TotalRedureRate").val(this.formatPercent(this.convertToNumber(this.TotalRedureRate)));
            $("#TotalRedureAmount").val(this.formatMoney(this.TotalRedureAmount));
            $("#PaymentObjectAmount01").val(this.formatMoney(this.convertToNumber(this.PaymentObjectAmount01)));
            $("#PaymentObjectAmount02").val(this.formatMoney(this.convertToNumber(this.PaymentObjectAmount02)));
            $("#TotalInventoryAmount").html(this.formatMoney(this.convertToNumber(this.TotalInventoryAmount)));
            $("#Change").html(this.formatMoney(this.convertToNumber(this.Change)));            

        },
        //Lấy dữ liệu của lưới
        getData: function () {
            return posGrid.dataSource.data();
        },
        formatMoney: function (value) {
            var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
            return kendo.toString(value, format);
        },
        formatDecimal: function (value) {
            var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
            return kendo.toString(value, format);
        },
        formatPercent: function (value) {
            var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
            return kendo.toString(value, format);
        },
        fillSaleOff: function (tr, inventoryID, promotionList) {
            //Chương trình khuyến mãi
            if (tr != null) {
                var currentDataItem = posGrid.dataItem(tr);
                if (currentDataItem != null) {
                    $("#Gifts").html(currentDataItem.PromotionProgram);
                }
            }

            //Add promotion
            if (inventoryID
                && promotionList
                && promotionList.length > 0) {
                posViewModel.addPromotion(inventoryID, promotionList);
            }
        },
        addPromotion: function (inventoryID, promotionList) {
            var promotions = posViewModel.getPromotionInvalid(inventoryID, promotionList);
            if (promotions.length > 0) {
                $.each(promotions, function (index, item) {
                    //addrowItem
                    AddRow(item);
                });
            }
        },
        sumQuantityDuplicate: function (inventoryID) {
            var gridData = posGrid.dataSource.data();
            var quantity = 0;
            var arrInventoryID = $.grep(gridData, function (a) {
                return (a.InventoryID == inventoryID);
            });
            $.each(arrInventoryID, function (index, value) {
                quantity += value.ActualQuantity;
            });

            return quantity;
        },
        getPromotionInvalid: function (inventoryID, promotionList) {
            var promotions = [];
            if (promotionList != null) {
                var quantity = posViewModel.sumQuantityDuplicate(inventoryID);
                $.each(promotionList, function (index, item) {
                    if (quantity >= item.FromQuantity && quantity <= item.ToQuantity) {
                        item.ActualQuantity = (item.UnitQuantity * quantity);
                        promotions.push(item);
                    }
                });
            }
            return promotions;
        },
        //Kiểm tra dữ liệu nhập
        isInvalid: function () {
            var msg = "";
            //checkgrid
            posGrid.element.removeClass('asf-focus-input-error');
            ASOFT.asoftGrid.editGridRemmoveValidate(posGrid);
            var isBuy = (this.IsBuy
                || $('#APK').val() == ""
                || $('#APK').val() == EMPTY_GUID);
            var check = ASOFT.form.checkRequiredAndInList("POSF00161", ['APKPaymentID', 'CurrencyID']);
            //Bán hàng
            if (!check && isBuy) {
                if (posViewModel.VoucherNo == "") {
                    msg = ASOFT.helper.getMessage("00ML000039");
                    var voucherNoLbl = $("label[for='VoucherNo']").html();
                    $('#VoucherNo').addClass('asf-focus-input-error');
                    msg = kendo.format(msg, voucherNoLbl);
                    ASOFT.form.displayError("#POSF00161", msg);
                    return true;
                }
                //Trả hàng
            } else if (!check && !isBuy) {
                if (posViewModel.Status == "1" && posViewModel.PVoucherNo == "") {
                    msg = ASOFT.helper.getMessage("00ML000039");
                    var reVoucherNoLbl = $("label[for='PVoucherNo']").html();
                    $('#PVoucherNo').addClass('asf-focus-input-error');
                    msg = kendo.format(msg, reVoucherNoLbl);
                    ASOFT.form.displayError("#POSF00161", msg);
                    return true;
                } else if (posViewModel.Status == "2" && posViewModel.CVoucherNo == "") {
                    msg = ASOFT.helper.getMessage("00ML000039");
                    var CVoucherNoLbl = $("label[for='PVoucherNo']").html();
                    $('#CVoucherNo').addClass('asf-focus-input-error');
                    msg = kendo.format(msg, CVoucherNoLbl);
                    ASOFT.form.displayError("#POSF00161", msg);
                    return true;
                }
                //Nếu phiếu đổi hàng thì return false
                if (posViewModel.Status != "2") {
                    //Check inventoryIds
                    var data = this.gridDataSource.data();
                    if (data.length >= 0) {
                        var arrInventoryIds = [];
                        $.each(data, function (index, item) {
                            if (item.APK == null) {
                                arrInventoryIds.push(item.InventoryID);
                            }
                        });
                        if (arrInventoryIds.length > 0) {
                            //border red
                            ASOFT.asoftGrid.borderGridValidate(
                                posGrid,
                                ['Imei01', 'Imei02'],
                                function (row, fieldName, element, rowIndex, cellIndex, value) {
                                    if (fieldName == "InventoryID") {
                                        var isCheck = $.inArray(row.InventoryID, arrInventoryIds);
                                        if (isCheck >= 0 && row.APK == null) {
                                            element.addClass('asf-focus-input-error');
                                        }
                                    }
                                });
                            //display message
                            msg = ASOFT.helper.getMessage("POSM000020");
                            ASOFT.form.displayError("#POSF00161", msg);
                            return true;
                        }
                    }
                }
            }

            //Check grid
            if (!check) {
                if (this.gridDataSource.data().length <= 0) {
                    posGrid.element.addClass('asf-focus-input-error');
                    //display message
                    msg = ASOFT.helper.getMessage("00ML000061");
                    ASOFT.form.displayError("#POSF00161", msg);
                } else {
                    //show quantity
                    if (ASOFT.asoftGrid.editGridValidate(posGrid, ['DiscountRate', 'DiscountAmount', 'Imei01', 'Imei02'])) {
                        msg = ASOFT.helper.getMessage("00ML000060");
                        ASOFT.form.displayError("#POSF00161", msg);
                        check = true;
                    }
                }
            }
            //Check totalAmount
            if (!check) {
                var change = posViewModel.convertToNumber(posViewModel.get('Change'));
                if (change < 0) {
                    var textAmount01 = $("label[for='PaymentObjectAmount01']").html();
                    var textAmount02 = $("label[for='PaymentObjectAmount02']").html();
                    var textChange = $("label[for='Change']").html();

                    if (posViewModel.checkObjectAmount02()) {
                        msg = ASOFT.helper.getMessage("POSM000022");
                        msg = kendo.format(msg, textAmount01, textAmount02, textChange);
                    } else if (!$("#divPaymentID1").hasClass(CSS_HIDDEN)) {
                        msg = ASOFT.helper.getMessage("POSM000023");
                        msg = kendo.format(msg, textAmount01, textChange);
                    } else if (!$("#divPaymentID2").hasClass(CSS_HIDDEN)) {
                        msg = ASOFT.helper.getMessage("POSM000023");
                        msg = kendo.format(msg, textAmount02, textChange);
                    }
                    ASOFT.form.displayError("#POSF00161", msg);
                    check = true;
                }
            }
            if (check) {
                resizeGrid();
            }
            return (check || this.gridDataSource.data().length <= 0);
        },
        resetRedure: function () {
            this.set("TotalDiscountRate", 0);
            this.set("TotalDiscountAmount", 0);
            this.set("TotalRedureRate", 0);
            this.set("TotalRedureAmount", 0);
        },
        calTaxAmountByInventoryID: function (data, inventory) {
            /* var arr = $.grep(data, function (item, i) {
                 return (inventory.InventoryID === item.InventoryID);
             });*/
            var totalDiscountAmount = this.convertToNumber(this.get("TotalDiscountAmount"));
            var totalReduceAmount = this.convertToNumber(this.get("TotalRedureAmount"));
            var taxAmount = 0;
            var sumAmount = 0;
            $.each(data, function (index, item) {
                sumAmount += item.InventoryAmount;
            });
            if (inventory.APK) {
                if (inventory.Amount != null) {
                    var amount = inventory.Amount;
                    var discountAmount = inventory.DiscountAmount;
                    var vatPercent = inventory.VATPercent;
                    taxAmount = inventory.taxAmount;
                }
            } else {
                if (inventory.Amount != null) {
                    var amount = parseFloat(inventory.Amount);
                    var discountAmount = parseFloat(inventory.DiscountAmount);
                    var vatPercent = parseFloat(inventory.VATPercent);
                    if (amount > 0) {
                        taxAmount = (amount - discountAmount - ((totalDiscountAmount * amount) / sumAmount) - ((totalReduceAmount * amount) / sumAmount)) * vatPercent;
                    }
                }
            }
            return taxAmount || 0;
        },
        //Tính tổng 
        callTotal: function (addNewDetail) {
            var totalAmount = 0;
            var totalTaxAmount = 0;
            var totalDiscountAmount = 0;
            var totalRedureAmount = 0;
            var data = this.getData();

            var that = this;

            $.each(data, function (index, intentory) {
                if (intentory.Amount != null) {
                    totalAmount += parseFloat(intentory.InventoryAmount);
                    var taxAmount = that.calTaxAmountByInventoryID(data, intentory);
                    totalTaxAmount += taxAmount;
                    intentory.TaxAmount = taxAmount;
                    totalDiscountAmount += parseFloat(intentory.DiscountAmount);
                }
            });
            this.set("TotalAmount", this.formatMoney(totalAmount));
            this.changeDiscountRate(this.convertToNumber(this.get("TotalDiscountRate")));
            this.changeRedureRate(this.convertToNumber(this.get("TotalRedureRate")));
            this.set("TotalTaxAmount", this.formatMoney(totalTaxAmount));

            if (addNewDetail) {
                //Thanh toán 1 & 2
                this.set("PaymentObjectAmount01", this.formatMoney(0));
                this.set("PaymentObjectAmount02", this.formatMoney(0));

            } else {
                totalDiscountAmount = this.convertToNumber(this.get("TotalDiscountAmount"));
                totalRedureAmount = this.convertToNumber(this.get("TotalRedureAmount"));
            }
            var diffAmount = 0;
            //Chenh lech doi hang
            if (this.Status == "2") {
                var totalBuy = 0;
                var totalChangeAmount = 0;
                var changeItems = this.getChangeInventories();
                
                for (var i = 0; i < changeItems.length; i++) {
                    totalChangeAmount += changeItems[i].InventoryAmount;
                }
                var buyItems = this.getBuyInventories(changeItems);
                for (var i = 0; i < buyItems.length; i++) {
                    totalBuy += buyItems[i].InventoryAmount;
                }
                diffAmount = totalChangeAmount - totalBuy;
                this.set("ChangeAmount", this.formatMoney(diffAmount));
            }
            
            //Tổng tiền
            var totalInventoryAmount = (totalAmount + totalTaxAmount - totalDiscountAmount - totalRedureAmount);
            this.set("TotalInventoryAmount", this.formatMoney(totalInventoryAmount));
            //Tiền thừa
            this.calChange();
           
        },
        changeDiscountRate: function (value) {
            var totalAmount = this.convertToNumber(this.get("TotalAmount"));
            var totalDiscountRate = this.convertToNumber(value);
            var totalDiscountAmount = totalAmount * (totalDiscountRate / 100);
            this.set("TotalDiscountAmount", this.formatMoney(totalDiscountAmount));
            //Tổng tiền
            this.calChange();
        },
        changeDiscountAmount: function (value) {
            var totalAmount = this.convertToNumber(this.get("TotalAmount"));
            var totalDiscountAmount = this.convertToNumber(value);
            var totalDiscountRate = 0;
            if (totalDiscountAmount != 0) {
                totalDiscountRate = this.convertToNumber((totalDiscountAmount / totalAmount) * 100);
            }

            this.set("TotalDiscountRate", this.formatPercent(totalDiscountRate));
            //Tổng tiền
            this.calChange();
        },
        changeRedureRate: function (value) {
            var totalAmount = this.convertToNumber(this.get("TotalAmount"));
            var totalRedureRate = this.convertToNumber(value);
            var totalRedureAmount = totalAmount * (totalRedureRate / 100);
            this.set("TotalRedureAmount", this.formatMoney(totalRedureAmount));
            //Tổng tiền
            this.calChange();
        },
        changeRedureAmount: function (value) {
            var totalAmount = this.convertToNumber(this.get("TotalAmount"));
            var totalRedureAmount = this.convertToNumber(value);
            var totalRedureRate = 0;
            if (totalRedureAmount != 0) {
                totalRedureRate = this.convertToNumber((totalRedureAmount / totalAmount) * 100);
            }
            this.set("TotalRedureRate", this.formatPercent(totalRedureRate));
            //Tổng tiền
            this.calChange();
        },
        checkObjectAmount02: function () {
            /*var cbo = $("#APKPaymentID").data("kendoComboBox");
            var item = cbo.dataItem();
            if (item != undefined) {
                if (item.PaymentObjectID01 == null && item.PaymentObjectID02 == null) {
                    return false;
                } 
            }*/
            var payment1 = $("#divPaymentID1").hasClass(CSS_HIDDEN);
            var payment2 = $("#divPaymentID2").hasClass(CSS_HIDDEN);
            if (!payment1 && !payment2) {
                return true;
            }
            return true;
        },
        changeObjectAmount01: function (value) {
            var totalInventoryAmount = this.convertToNumber(this.get("TotalInventoryAmount"));
            this.set("PaymentObjectAmount01", this.formatMoney(value));
            value = (totalInventoryAmount - value);
            if (value > 0 && this.checkObjectAmount02()) {
                this.set("PaymentObjectAmount02", this.formatMoney(value));
            } else {
                this.set("PaymentObjectAmount02", this.formatMoney(0));
            }

            //Tổng tiền
            this.calChange();
        },
        changeObjectAmount02: function (value) {
            var totalInventoryAmount = this.convertToNumber(this.get("TotalInventoryAmount"));
            this.set("PaymentObjectAmount02", this.formatMoney(value));
            value = (totalInventoryAmount - value);
            if (value > 0 && this.checkObjectAmount02()) {
                this.set("PaymentObjectAmount01", this.formatMoney(value));
            } else {
                this.set("PaymentObjectAmount01", this.formatMoney(0));
            }
            //Tổng tiền
            this.calChange();
        },

        calChange: function () {
            //Tính lại taxAmount cho từng dòng và TotalTaxAmount
            var data = this.getData();
            var that = this;
            var totalTaxAmount = 0;
            $.each(data, function (index, intentory) {
                if (intentory.Amount != null) {
                    var taxAmount = that.calTaxAmountByInventoryID(data, intentory);
                    totalTaxAmount += taxAmount;
                    intentory.TaxAmount = taxAmount;
                }
            });
            this.set("TotalTaxAmount", this.formatMoney(totalTaxAmount));
            //Tổng tiền
            var totalAmount = this.convertToNumber(this.get("TotalAmount"));
            //totalTaxAmount = this.convertToNumber(this.get("TotalTaxAmount"));
            var totalDiscountAmount = this.convertToNumber(this.get("TotalDiscountAmount"));
            var totalRedureAmount = this.convertToNumber(this.get("TotalRedureAmount"));

            var totalInventoryAmount = (totalAmount + totalTaxAmount - totalDiscountAmount - totalRedureAmount);
            this.set("TotalInventoryAmount", this.formatMoney(totalInventoryAmount));
            //Tiền thừa
            var paymentObjectAmount01 = this.convertToNumber(this.get("PaymentObjectAmount01"));
            var paymentObjectAmount02 = this.convertToNumber(this.get("PaymentObjectAmount02"));
            var value = 0;
            if (this.Status == "2") {
                value = (paymentObjectAmount01 + paymentObjectAmount02) - this.convertToNumber(this.get("ChangeAmount"));
            } else {
                value = (paymentObjectAmount01 + paymentObjectAmount02) - totalInventoryAmount;
            }
            
            this.set("Change", this.formatMoney(value));
        },
        getPaymentAPK: function () {
            var cbo = $("#APKPaymentID").data("kendoComboBox");
            var item = cbo.dataItem();
            if (item != null) {
                return item.APK;
            }
        },
        getInfo: function () {
            var dataPost = ASOFT.helper.dataFormToJSON("POSF00161");
            dataPost.DetailList = posGrid.dataSource.data();
            dataPost.MemberID = $("#MemberValue").val();
            dataPost.MemberName = $("#MemberName").val();
            dataPost.APKPaymentID = this.getPaymentAPK();
            dataPost.PaymentObjectAmount01 = this.convertToNumber(posViewModel.get("PaymentObjectAmount01"));
            dataPost.PaymentObjectAmount02 = this.convertToNumber(posViewModel.get("PaymentObjectAmount02"));

            dataPost.CurrencyID = $("#CurrencyID").data("kendoComboBox").value();
            dataPost.TotalAmount = this.convertToNumber(posViewModel.get("TotalAmount"));
            dataPost.TotalTaxAmount = this.convertToNumber(posViewModel.get("TotalTaxAmount"));
            //Chiec khau
            dataPost.TotalDiscountRate = this.convertToNumber(posViewModel.get("TotalDiscountRate"));
            dataPost.TotalDiscountAmount = this.convertToNumber(posViewModel.get("TotalDiscountAmount"));
            //Giam gia
            dataPost.TotalRedureRate = this.convertToNumber(posViewModel.get("TotalRedureRate"));
            dataPost.TotalRedureAmount = this.convertToNumber(posViewModel.get("TotalRedureAmount"));
            //Tong tien
            dataPost.TotalInventoryAmount = this.convertToNumber(posViewModel.get("TotalInventoryAmount"));
            //Thanh toan 1 & 2
            if (!$('#divPaymentObjectID1').hasClass(CSS_HIDDEN)) {
                dataPost.PaymentObjectName01 = this.GetObjectName('#PaymentObjectID01');
                dataPost.AccountNumber01 = this.get('AccountNumber01');
            }
            //Change payment
            if (!$('#divPaymentID1').hasClass(CSS_HIDDEN)) {
                dataPost.PaymentObjectAmount01 = this.convertToNumber(posViewModel.get("PaymentObjectAmount01"));
            }

            if (!$('#divPaymentObjectID2').hasClass(CSS_HIDDEN)) {
                dataPost.PaymentObjectName02 = this.GetObjectName('#PaymentObjectID02');
                dataPost.AccountNumber02 = this.get('AccountNumber02');
            }

            if (!$('#divPaymentID2').hasClass(CSS_HIDDEN)) {
                dataPost.PaymentObjectAmount02 = this.convertToNumber(posViewModel.get("PaymentObjectAmount02"));
            }

            dataPost.Change = this.convertToNumber(posViewModel.get("Change"));
            //dataChange
            dataPost.IsBuy = $("#IsBuy").val();
            dataPost.APKMInherited = $("#APKMInherited").val();
            dataPost.IsDataChanged = this.gridDataSource.hasChanges();
            return dataPost;

        },
        convertToNumber: function (str) {
            var value = kendo.parseFloat(str);
            return (value == null ? 0 : value);
        },
        addMember: function () {
            var data = {};
            ASOFT.asoftPopup.showIframe(getAbsoluteUrl("POSF0011/POSF00111"), data);
            return false;
        },
        showChangeInventory: function (e) {
            var row = $(e).closest("tr");
            var inventory = posGrid.dataItem(row);
            if (row.APKDInherited == null) {
                var url = kendo.format("POSF0016/POSF0065?apkDetail={0}", inventory.APKDInherited);
                ASOFT.asoftPopup.showIframe(getAbsoluteUrl(url));
            }
            
            return false;
        },
        //Khởi tạo giá trị ban đầu
        reset: function (e) {
            if (typeof(overrideReset) === "function") {
                //raise event
                overrideReset(posViewModel);
                return;
            } else {
                //return false;
                switch (posViewModel.Status) {
                    case "2":
                    case "1":
                        var ifFrameSector = $(parent.externalIframe);
                        ifFrameSector.attr('src', function (i, val) { return val; });
                        break;
                    default:
                        var dataPost = posViewModel.getInfo();
                        ASOFT.helper.postTypeJson(
                            getAbsoluteUrl("POSF0016/GetVoucherNo"),
                            dataPost,
                            function (data) {
                                if (data.Status == 0) {
                                    posViewModel.cancel();
                                    posViewModel.set('VoucherNo', data.Data);
                                }
                            }
                        );
                        break;
                }
            }
        },
        //Hủy hóa đơn
        cancel: function (e) {
            var defaultValue = this.formatMoney(0);
            this.set("TotalAmount", defaultValue);
            this.set("TotalTaxAmount", defaultValue);
            this.set("TotalDiscountRate", defaultValue);
            this.set("TotalDiscountAmount", defaultValue);
            this.set("TotalRedureRate", defaultValue);
            this.set("TotalRedureAmount", defaultValue);

            this.set("Change", defaultValue);
            this.set("TotalInventoryAmount", defaultValue);
            this.set("MemberID", '');
            this.set("InventoryID", '');
            this.set("CurrencyID", 'VND');

            this.set("PaymentObjectAmount01", defaultValue);
            this.set("PaymentObjectAmount02", defaultValue);

            this.set("AccountNumber01", '');
            this.set("AccountNumber02", '');

            this.set("PaymentObjectID01", '');
            this.set("PaymentObjectID02", '');

            this.set("APKPaymentID", '');

            this.set("VoucherNo", '');
            this.set("ReVoucherNo", '');
            this.set("MemberID", '');
            this.set("MemberName", '');
            //btnReturn.enable(false);
            if (btnChangeInventory != undefined) {
                btnChangeInventory.enable(false);
            }
            
            //remove grid
            $("#MemberName").removeClass('asf-focus-input-error');
            posGrid.dataSource.data([]);
            $("#APK").val(EMPTY_GUID);
            posGrid.refresh();
            ASOFT.form.clearMessageBox('POSF00161');
            resizeGrid();
        },
        print: function (apk) {
            var fullPath = kendo.format(getAbsoluteUrl("POSF0016/Print/{0}"), apk);
            $("#btnPrint").printPage({
                url: fullPath,
                attr: "href",
                message: $('#PrintMessage').val()
            });
            $("#btnPrint").trigger('click');
        },
        //Lưu
        save: function () {
            /*var isBuy = (this.IsBuy || $('#APK').val() == ""
                || $('#APK').val() == EMPTY_GUID);

            //Trả hàng
            if (!isBuy) {
                this.repay();
                return false;
            }
            */
            //return false;
            var dataPost = this.getInfo();

            if (this.isInvalid(true)) {
                return false;
            }
            resizeGrid();
            var isUpdate = ($("#APK").val() != null
                && $("#APK").val() != ''
                && $("#APK").val() != EMPTY_GUID);
            var action = getAbsoluteUrl("POSF0016/Insert");
            if (isUpdate) {
                action = getAbsoluteUrl("POSF0016/Update");
                dataPost.APK = $("#APK").val();
            }
            //dataPost.Cash = 0;
            dataPost.PayScore = 0;

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    //Delete Json
                    ASOFT.helper.showErrorSeverOption(0, data, "POSF00161", function () {
                        parent.refreshGrid();
                        //reset 
                        posViewModel.cancel();
                        if (data.Data != null) {
                            if (data.Data.LastModifyDateValue != null) {
                                $("#LastModifyDateValue").val(data.Data.LastModifyDateValue);
                                posViewModel.set("VoucherNo", data.Data.VoucherNo);
                            } else {
                                posViewModel.set("VoucherNo", data.Data.VoucherNo);
                            }
                        } else {
                            posViewModel.set("VoucherNo", "");
                        }
                        //Reset phiếu bán hàng
                        $("#IsBuy").val(true);
                        $("#APKMInherited").val(EMPTY_GUID);

                        if (data.Data.APK) {
                            //Print
                            posViewModel.print(data.Data.APK);
                        }

                    }, null, function () {
                        //Grid
                        var inventoryIds = [];
                        if (data.Message == "POSM000016" || data.Mesage == "POSM000021") {
                            inventoryIds = data.Data;
                            ASOFT.asoftGrid.editGridValidate(
                                posGrid,
                                ['DiscountRate', 'DiscountAmount', 'Imei01', 'Imei02'],
                                function (row, fieldName, element, rowIndex, cellIndex, value) {
                                    if (fieldName == "ActualQuantity") {
                                        var isCheck = $.inArray(row.InventoryID, inventoryIds);
                                        if (isCheck >= 0) {
                                            element.addClass('asf-focus-input-error');
                                        }
                                    }
                                });
                        }
                    }, false);
                }
            );
            //e.preventDefault();
        },
        repay: function () {
            //return false;
            var dataPost = this.getInfo();

            if (this.isInvalid(false)) {
                return false;
            }
            //resize screen
            resizeGrid();
            var isUpdate = ($("#APKMInherited").val() != null
                && $("#APKMInherited").val() != ''
                && $("#APKMInherited").val() != EMPTY_GUID);
            var action = getAbsoluteUrl("POSF0016/RePayInsert");
            if (isUpdate) {
                action = getAbsoluteUrl("POSF0016/RePayUpdate");
                dataPost.APK = $("#APK").val();
                dataPost.APKMInherited = $("#APKMInherited").val();
            }
            dataPost.PayScore = 0;

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    //Delete Json
                    ASOFT.helper.showErrorSeverOption(0, data, "POSF00161", function () {
                        parent.refreshGrid();
                        //reset 
                        posViewModel.resetIfFrame();

                    }, null, function () {
                        //Grid
                        if (data.Message == "POSM000016" || data.Message == "POSM000021") {
                            var inventoryIds = data.Data;
                            ASOFT.asoftGrid.editGridValidate(
                                posGrid,
                                ['Imei01', 'Imei02'],
                                function (row, fieldName, element, rowIndex, cellIndex, value) {
                                    if (fieldName == "ActualQuantity") {
                                        var isCheck = $.inArray(row.InventoryID, inventoryIds);
                                        if (isCheck >= 0) {
                                            element.addClass('asf-focus-input-error');
                                        }
                                    }
                                });
                        }
                    }, false);
                }
            );
            return false;
        },
        resetIfFrame: function () {
            if (typeof(overrideReset) === "function") {
                //raise event
                overrideReset(posViewModel);
                return;
            } else {
                var url = getAbsoluteUrl("POSF0016/POSF00161");
                url = kendo.format("{0}?status={1}", url, 0);
                var ifFrameSector = $(parent.externalIframe);
                ifFrameSector.attr('src', url);
            }
        },
        getChangeInventories: function() {
            var inventories = posGrid.dataSource.data();
            //posViewModel.getParentInventory(item.APK)

            var changeItems = $.grep(inventories, function (item, j) {
                return (item.ID1 == null || item.ID1 == 0);
            });
            return changeItems;
        },
        getBuyInventories: function (changeItems) {
            var inventories = posGrid.dataSource.data();
            var buyItems = $.grep(inventories, function (item, j) {
                var hasChangeItems = $.grep(changeItems, function (subitem, k) {
                    return (subitem.ID2 != 0 && subitem.ID2 == item.ID1);
                }).length > 0;
                return ((item.ID2 == null || item.ID2 == 0) && hasChangeItems);
            });
            
            return buyItems;
        },
        changePay: function () {
            //return false;
            var dataPost = this.getInfo();
            var detailList = [];
            var changeItems = this.getChangeInventories();
            for (var i = 0; i < changeItems.length; i++) {
               var item = changeItems[i];
               item.IsKindVoucherID = 1;
               detailList.push(item);
            }
            
            if (changeItems.length == 0) {
                var msg = ASOFT.helper.getMessage("POSM000054");
                ASOFT.form.displayError("#POSF00161", msg);
                return true;
            }
            
            if (this.convertToNumber(this.ChangeAmount) < 0) {
                var msg = ASOFT.helper.getMessage("POSM000055");
                ASOFT.form.displayError("#POSF00161", msg);
                return true;
            }
           
            var buyItems = this.getBuyInventories(changeItems);
            for (var i = 0; i < buyItems.length; i++) {
                var item = buyItems[i];
               item.IsKindVoucherID = 2;
               detailList.push(item);
            }

            dataPost.DetailList = detailList;
            
            if (this.isInvalid(false)) {
               return false;
            }

            //resize screen
            resizeGrid();
            var isUpdate = ($("#APKMInherited").val() != null
                && $("#APKMInherited").val() != ''
                && $("#APKMInherited").val() != EMPTY_GUID);
            var action = getAbsoluteUrl("POSF0016/ChangePayInsert");
            if (isUpdate) {
                action = getAbsoluteUrl("POSF0016/ChangePayUpdate");
                dataPost.APK = $("#APK").val();
                dataPost.APKMInherited = $("#APKMInherited").val();
            }
            dataPost.PayScore = 0;

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    //Delete Json
                    ASOFT.helper.showErrorSeverOption(0, data, "POSF00161", function () {
                        //parent.refreshGrid();
                        //reset 
                        posViewModel.resetIfFrame();
                    }, null, function () {
                        //Grid
                        if (data.Message == "POSM000016" || data.Message == "POSM000021") {
                            var inventoryIds = data.Data;
                            ASOFT.asoftGrid.editGridValidate(
                                posGrid,
                                ['Imei01', 'Imei02'],
                                function (row, fieldName, element, rowIndex, cellIndex, value) {
                                    if (fieldName == "ActualQuantity") {
                                        var isCheck = $.inArray(row.InventoryID, inventoryIds);
                                        if (isCheck >= 0) {
                                            element.addClass('asf-focus-input-error');
                                        }
                                    }
                                });
                        } else if (data.Message == "POSM000045" && ASOFTEnvironment.CustomerIndex.PhucLong) {
                            setTimeout(function() {
                                if (typeof (overrideReset) === "function") {
                                    //raise event
                                    overrideReset(posViewModel);
                                }
                            } , 600);
                        }
                    }, false);
                }
            );
            return false;
        },
        saveAndPrint: function () {
            
            switch (posViewModel.Status) 
            {
                case "0":
                    this.save();
                    break;
                case "1":
                    this.repay();
                    break;
                case "2":
                    this.changePay();
                break;
            }
            
        },
        //Xóa mặt hàng trên dòng
        deleteInventory: function (tagA) {
            if (POSF00161.isPromotionRow(tagA)) {
                ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('POSM000046'));
                return;
            }

            var row = $(tagA).closest("tr");
            var that = this;
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
                var inventory = posGrid.dataItem(row);
                var inventories = posGrid.dataSource.data();

                var index = inventories.indexOf(inventory);
                if (index >= 0) {
                    if (inventory.APKDInherited == null) {
                        var compositeArr = posViewModel.getParentInventory(inventory.APK);
                        for (var i = 0; i < compositeArr.length; i++) {
                            posGrid.removeRow(compositeArr[i]);
                        }
                        posGrid.removeRow(row);
                    } else {
                        posGrid.removeRow(row);
                    }
                    
                    posGrid.refresh();
                    
                    posViewModel.callTotal(true);
                    // Xử lý khuyến mãi 
                    POSF00161.btnDeleteRow_Click(row);
                    return false;
               }
            });
        },
        getParentInventory: function (inventoryID) {
            var inventories = posGrid.dataSource.data();
            var arr = $.grep(inventories, function (item, i) {
                return (item.APKDInherited == inventoryID);
            });
            return arr;
        },
        //Chọn tên hội viên
        objectIdSelect: function (e) {

        }
    });
    kendo.bind($("#POSF00161"), posViewModel);
    posViewModel.formatNumbers();
    //Lưu sau khi nhập cột 
    posGrid.bind("dataBound", function (e) {
        rowNumber = 0;
        posViewModel.callTotal(false);
    });

}
/******************************************************************************
                            Function
*******************************************************************************/
/**
* Send data to with grid
*/
function sendDataFilter() {
    if (posViewModel != null) {
        return posViewModel.dataFilter();
    } else {
        var isUpdate = ($("#APKMInherited").val() != null
                && $("#APKMInherited").val() != ''
                && $("#APKMInherited").val() != EMPTY_GUID);
        return {
            APK: $('#APK').val(),
            status: $('#Status').val(),
            isUpdate: isUpdate
        };
    }
    return null;
}

/**
* Gen rowNumber
*/
function renderChangeInventory(data) {
    if (data.ID1 != null && data.ID1 != 0) {
        return "<a href='#' onclick='return addRepayInventory(this);' class='asf-i-add-32'><span>Add</span></a>";
    }
        
    return "";
}

/**
* Gen rowNumber
*/
function renderDeleteInventory(data) {
    if (data.ID2 != null && data.ID2 != 0) {
        return "<a href='#' onclick='return deleteInventory(this)' class='asf-i-delete-32'><span>del</span></a>";
    }

    return "";
}

/**
* Gen rowNumber
*/
function renderNumber(data) {
    return ++rowNumber;
}

/**
* Add row
*/
function AddRow(item) {
    if (item != undefined) {
        var gridDataSource = posGrid.dataSource;

        //fill source
        var row = {}; 
        row.APK = null;
        row.RowNum = (gridDataSource.data().length + 1);
        row.InventoryID = item.InventoryID;
        row.InventoryName = item.InventoryName;
        row.UnitID = item.UnitID;
        row.UnitName = item.UnitName;
        row.ActualQuantity = item.ActualQuantity;
        row.UnitPrice = item.UnitPrice;
        row.VATGroupID = item.VATGroupID;
        row.VATPercent = item.VATPercent;
        row.DiscountRate = item.DiscountRate;
        row.ID1 = item.ID1;
        row.ID2 = item.ID2;
        
        row.Amount = (row.ActualQuantity * row.UnitPrice);

        row.DiscountAmount = Math.round(row.Amount * (item.DiscountRate / 100));

        row.TaxAmount = (row.Amount - row.DiscountAmount) * row.VATPercent;
        row.InventoryAmount = (row.Amount - row.DiscountAmount);
        row.PromotionProgram = item.PromotionProgram;
        row.PromotionList = item.PromotionList;
        row.IsPromotion = item.IsPromotion;

        row.APKMInherited = item.APKMInherited;
        row.APKDInherited = item.APKDInherited;
        
        posViewModel.resetRedure();
        //Thêm vào source
        posGrid.dataSource.add(row);
        posGrid.saveChanges();
        posViewModel.callTotal(true);
        var tr = kendo.format("tr:eq({0})", (gridDataSource.data().length - 1));
        posViewModel.fillSaleOff(tr, row.InventoryID, row.PromotionList);

        if (posViewModel.Status == "0") {
            POSF00161.addRowItem(tr, item);
        }
    }
}

/**
*Resize grid
*/
function resizeGrid() {
    var giftTop = $('#pos_controls').height();
    var gridTop = $("#pos_grid").offset().top;
    var newGridHeight = $(window).height() - (giftTop + gridTop + 20);
    if (newGridHeight < 120) {
        newGridHeight = 120;
    }
    var newDataAreaHeight = newGridHeight - 65;


    var gridElement = $("#mainGrid");
    var dataArea = gridElement.find(".k-grid-content");
    dataArea.height(newDataAreaHeight);
    gridElement.height(newGridHeight);

    //posGrid.refresh();

    /*$("#pos_info").css("padding-bottom", 0);
    //resize payment container
    var infoCurrentHeight = ($("#pos_info").offset().top + $("#pos_info").height());
    var paddingBottom = $(window).height() - infoCurrentHeight - $("#posButton").height() - 20;
    if (paddingBottom < 0) {
        paddingBottom = 0;
    }
    $("#pos_info").css("padding-bottom", paddingBottom);

    //Grid
    var gift = $('.gift_container');
    var gridElement = $("#mainGrid");
    var dataArea = gridElement.find(".k-grid-content");
    var newGridHeight = $("#post_right").height() - gift.height() - 45;
    var newDataAreaHeight = newGridHeight - 65;

    dataArea.height(newDataAreaHeight);
    gridElement.height(newGridHeight);

    posGrid.refresh();*/
}
/**
* Change payment
*/
function filterPaymentObjectID1() {
    var item = $("#APKPaymentID").data("kendoComboBox").dataItem();
    var type = -1;
    if (item != null) {
        type = item.ObjectTypeID01;
    }
    return {
        type: type
    };
}
/**
* Change payment 2
*/
function filterPaymentObjectID2() {
    var item = $("#APKPaymentID").data("kendoComboBox").dataItem();
    var type = -1;
    if (item != null) {
        type = item.ObjectTypeID02;
    }
    return {
        type: type
    };
}
/******************************************************************************
                            EVENTS
*******************************************************************************/
/**
* Resize grid
*/
$(window).resize(function () {
    resizeGrid();
});

/**
* Grid Save
*/
function Grid_Save(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }
    if (e.values != null) {
        var model = e.model;
        var amount = 0;
        var discountAmount = 0;
        var discountRate = 0;
        var taxAmount = 0;
        var inventoryAmount = 0;
        posViewModel.resetRedure();
        if (e.values.ActualQuantity != undefined) {
            // the user changed the name field
            if (e.values.ActualQuantity != e.model.ActualQuantity) {                
                discountRate = model.DiscountRate;
                //Set để chạy hàm total Inventory
                if (discountRate == 0) {
                    e.model.set("DiscountRate", -1);
                } else {
                    e.model.set("DiscountRate", 0);
                }

                discountAmount = amount * parseFloat((model.DiscountRate / 100));
                amount = e.values.ActualQuantity * parseFloat(model.UnitPrice);
                //+taxAmount;
                e.model.set("Amount", amount);
                e.model.set("DiscountRate", discountRate);

                posViewModel.fillSaleOff(e.container.parent(), model.InventoryID, model.PromotionList);

            }
        } else if (e.values.DiscountRate != undefined) {
            if (e.values.DiscountRate != e.model.DiscountRate) {
                amount = model.Amount;
                discountAmount = amount * parseFloat((e.values.DiscountRate / 100));

                e.model.set("DiscountAmount", discountAmount);
                e.model.set("InventoryAmount", amount - discountAmount);
                posViewModel.callTotal(false);
            } else {
                e.model.set("InventoryAmount", model.Amount - model.DiscountAmount);
            }
        } else if (e.values.DiscountAmount != undefined) {
            if (e.values.DiscountAmount != e.model.DiscountAmount) {
                amount = model.Amount;

                if (model.DiscountAmount != 0) {
                    discountRate = (parseFloat(e.values.DiscountAmount) / amount) * 100;
                } else {
                    discountRate = 0;
                }
                e.model.set("DiscountRate", discountRate);
                posViewModel.callTotal(false);
            } else {
                e.model.set("InventoryAmount", model.Amount - model.DiscountAmount);
            }
        } else if (e.values.InventoryAmount != undefined) {
            if (e.values.InventoryAmount != e.model.InventoryAmount) {
                taxAmount = e.values.InventoryAmount * model.VATPercent;
                e.model.set("TaxAmount", taxAmount);
                posViewModel.callTotal(false);
                
            }
        }
    }

    POSF00161.grid_Save(e);
}

/**
* Grid change
*/
function Grid_Change(e) {
    var tr = this.select();
    posViewModel.fillSaleOff(tr, null, null);
}

/**
* Xóa enventory
*/
function deleteInventory(e) {
    posViewModel.deleteInventory(e);
}

/**
* Xóa enventory
*/
function addRepayInventory(e) {
    posViewModel.showChangeInventory(e);
}


/**
* Nhập số tiền trả
*/
function Cash_Change(event) {
    this.value = posViewModel.formatMoney(this.value);
    posViewModel.callTotal(false);
}


/******************************************************************************
                            INVENTORY EVENTS
*******************************************************************************/
/**
*  Chọn mã hàng
*/
function InventoryID_Change(e) {
    var item = this.dataItem(e.item.index());
    AddRow(item);
    posViewModel.set("InventoryID", '');
}

/**
*  Quét barcode
*/
function InventoryID_DataBound(e) {
    if (isBardcode) {
        var data = e.sender.dataSource.data();
        if (data.length > 0) {
            e.sender.close();
            AddRow(data[0]);
        } else {
            posViewModel.set("InventoryID", '');
        }
        e.sender.focus();
        isBardcode = false;
    }
    posViewModel.set("InventoryID", '');
}

/**
*  Đóng mã hàng
*/
function InventoryID_Close(event) {
    //Xóa mặt hàng
    posViewModel.set("InventoryID", '');
}
/******************************************************************************
                            ButtonEvent
*******************************************************************************/
/**
*  Trả hàng
*/
function btnReturn_Click(event) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('POSM000038'),
    //yes
    function () {
        posViewModel.repay();
        var iventoryAutoComplete = $("#InventoryID").data("kendoAutoComplete");
        if (iventoryAutoComplete != undefined) {
            iventoryAutoComplete.focus();
        }
        
    }, null);
}

/**
*  Đổi hàng
*/
function btnChangeInventory_Click(event) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('POSM000037'),
    //yes
    function () {
        posViewModel.repay();
        var iventoryAutoComplete = $("#InventoryID").data("kendoAutoComplete");
        if (iventoryAutoComplete != undefined) {
            iventoryAutoComplete.focus();
        }
        
        
    }, null);
}


/**
* Thanh toán 
*/
function btnSave_Click(event) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('POSM000036'),
    //yes
    function () {
        posViewModel.saveAndPrint();
        var iventoryAutoComplete = $("#InventoryID").data("kendoAutoComplete");
        if (iventoryAutoComplete != undefined) {
            iventoryAutoComplete.focus();
        }
        
    }, null);
}

/**
*  Làm mới
*/
function btnReset_Click(event) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('POSM000039'),
    //yes
    function () {
        posViewModel.reset();
        var iventoryAutoComplete = $("#InventoryID").data("kendoAutoComplete");
        if (iventoryAutoComplete != undefined) {
            iventoryAutoComplete.focus();
        }
    }, null);
}
/******************************************************************************
                            MEMBER EVENTS
*******************************************************************************/
/**
*  Chọn tên hội viên
*/
function MemberID_Change(e) {
    var item = this.dataItem(e.item.index());
    if (item != undefined) {
        posViewModel.set("MemberName", item.MemberName);
        posViewModel.set("MemberID", item.MemberID);
        $("#MemberValue").val(item.MemberID);

    }
    return false;
}

/**
*  Quét barcode
*/
function MemberID_DataBound(e) {
    if (isBardcode) {
        var data = e.sender.dataSource.data();
        if (data.length > 0) {
            e.sender.close();
            posViewModel.set("MemberName", data[0].MemberName);
            posViewModel.set("MemberID", data[0].MemberID);
        } else {
        }
        e.sender.focus();
        isBardcode = false;
    }
}

/**
* add detail popup
*/
function btnChoose_Click(apkDetail, list) {
    if (list != null && list.length > 0) {
        var data = posGrid.dataSource.data();
        var arrInventoryID = $.grep(data, function (a) {
            return (a.APKDInherited == apkDetail);
        });
        
        if (arrInventoryID.length > 0) {
            var currentRow = arrInventoryID[0];
            for (var i = 0; i < list.length; i++) {
                var item = list[i];
                item.ID2 = currentRow.ID1;
                item.ID1 = null;
                item.DiscountAmount = 0;
                if (item.UnitPrice == null) {
                    item.UnitPrice = 0;
                }
                item.InventoryAmount = item.ActualQuantity * item.UnitPrice;
                item.APKMInherited = $("#APK").val();
                AddRow(item);
            }
        }
    }
    
    ASOFT.asoftPopup.hideIframe();
}

/**
* Thêm thành viên
*/
function MemberID_Click() {
    posViewModel.addMember();
}

/**
* Add event for numberic
*/
function addEventNumberic() {
    $(".numberic").keypress(function (e) { return ASOFT.form.isNumberKey(e); });
    $(".numberic").blur(function () {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatPercent(value);
        $(this).val(value);
    });
    $(".numberic").focus(function () {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatPercent(value);
        $(this).val(value);
        $(this).select();
    });

    $("#TotalDiscountAmount").keyup(function (e) {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatMoney(value);
        $(this).val(value);
    });

    $("#TotalRedureAmount").keyup(function (e) {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatMoney(value);
        $(this).val(value);
    });

    $("#PaymentObjectAmount01").keyup(function (e) {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatMoney(value);
        $(this).val(value);
    });

    $("#PaymentObjectAmount02").keyup(function (e) {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatMoney(value);
        $(this).val(value);
    });


    $("#TotalDiscountRate").change(function (e) {
        var value = $(this).val();
        value = posViewModel.convertToNumber(value);
        posViewModel.changeDiscountRate(value);

    });
    $("#TotalDiscountAmount").change(function (e) {
        var value = $(this).val();
        value = posViewModel.convertToNumber(value);
        posViewModel.changeDiscountAmount(value);
    });
    $("#TotalRedureRate").change(function (e) {
        var value = $(this).val();
        value = posViewModel.convertToNumber(value);
        posViewModel.changeRedureRate(value);
    });
    $("#TotalRedureAmount").change(function (e) {
        var value = $(this).val();
        value = posViewModel.convertToNumber(value);
        posViewModel.changeRedureAmount(value);
    });
    $("#PaymentObjectAmount01").change(function (e) {
        /*var value = $(this).val();
        value = posViewModel.convertToNumber(value);
        posViewModel.changeObjectAmount01(value);*/
        posViewModel.calChange();
    });
    $("#PaymentObjectAmount02").change(function (e) {
        /*var value = $(this).val();
        value = posViewModel.convertToNumber(value);
        posViewModel.changeObjectAmount02(value);*/
        posViewModel.calChange();
    });
}

/**
*  Chọn tên hội viên
*/
function APKPaymentID_Cascade(e) {
    var item = this.dataItem();
    if (item != undefined) {
        if (item.ObjectTypeID01 != null) {
            $("label[for='PaymentObjectID01']").html(item.ObjectTypeName01);
            $("#divPaymentObjectID1").removeClass(CSS_HIDDEN);

        } else {
            $("#divPaymentObjectID1").addClass(CSS_HIDDEN);
        }
        if (item.ObjectTypeID02 != null) {
            $("label[for='PaymentObjectID02']").html(item.ObjectTypeName02);
            $("#divPaymentObjectID2").removeClass(CSS_HIDDEN);
        } else {
            $("#divPaymentObjectID2").addClass(CSS_HIDDEN);
        }

        if (item.PaymentID01 != null) {
            $("label[for='PaymentObjectAmount01']").html(item.PaymentName01);
            $("#divPaymentID1").removeClass(CSS_HIDDEN);
        } else {
            $("#divPaymentID1").addClass(CSS_HIDDEN);
        }

        if (item.PaymentID02 != null) {
            $("label[for='PaymentObjectAmount02']").html(item.PaymentName02);
            $("#divPaymentID2").removeClass(CSS_HIDDEN);
        } else {
            $("#divPaymentID2").addClass(CSS_HIDDEN);
        }

        if (posViewModel != null) {
            resizeGrid();
            //posViewModel.set("APKPaymentID", item.APK);
            posViewModel.set("PaymentObjectID01", '');
            posViewModel.set("PaymentObjectID02", '');
            posViewModel.set("PaymentObjectAmount01", 0);
            posViewModel.set("PaymentObjectAmount02", 0);
        }
    }
    return false;
}

//Change
function Combobox_Change(e) {
    var check = ASOFT.form.checkItemInListFor(this, 'POSF00161');
    if (!check) {
        e.sender.focus();
    }
}

/**
* Đóng form member
*/
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

