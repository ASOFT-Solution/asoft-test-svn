//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//#     13/06/2014      Minh Lâm         Thay đổi công thức mới
//####################################################################
//var popup = null;



(function () {
    $("#TotalAmount, #TotalTaxAmount, #TotalDiscountRate, #TotalDiscountAmount, #TotalRedureRate, #TotalRedureAmount, #PaymentObjectAmount01, #PaymentObjectAmount02, #TotalInventoryAmount, #Change").addClass('asf-temporary-hidden');
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
var inventoryIDPOSF00164 = {};

$(document).ready(function () {
    btnReturn = $("#BtnReturn").data("kendoButton");
    btnChangeInventory = $("#BtnChangeInventory").data("kendoButton");

    posGrid = $("#mainGrid").data("kendoGrid");

    $(posGrid.tbody).on("focus", "td", function (e) {
        var row = e.currentTarget.parentElement;
        var dataRow = posGrid.dataItem(row);
        if (dataRow.IsPromotion == 1) {
            posGrid.closeCell();
        }
        if ($("#Status").val() == 2 && dataRow.ID1 != null && dataRow.ID1 != 0) {
            var index = e.currentTarget.cellIndex;
            var th = $($("#mainGrid").find('th')[index]).attr("data-field");
            if (th == 'DiscountRate' || th == 'DiscountAmount' || th == 'Imei01' || th == 'Imei02') {
                posGrid.closeCell();
            }
        }
        if ($("#Status").val() == 1) {
            var index = e.currentTarget.cellIndex;
            var th = $($("#mainGrid").find('th')[index]).attr("data-field");
            if (th != 'ActualQuantity') {
                posGrid.closeCell();
            }
        }
    })

    posGrid.table.on("click", ".asf-checkbox", function(e){
        checkFillUnitPrice(this, e);
    });

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
                if (typeof (overrideClose) === "function") {
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

    $("#arrow-1").click(function () {
        $($("#pos_info").find(".pos_inner")).css("display", "block")
        $("#arrow-3").css("display", "block")
        $("#arrow-1").css("display", "none")
    })

    $("#arrow-3").click(function () {
        $($("#pos_info").find(".pos_inner")).css("display", "none")
        $("#arrow-3").css("display", "none")
        $("#arrow-1").css("display", "block")
    })

    $("#arrow-2").click(function () {
        $($("#payment_container").find(".pos_inner")).css("display", "block")
        $("#arrow-4").css("display", "block")
        $("#arrow-2").css("display", "none")
    })

    $("#arrow-4").click(function () {
        $($("#payment_container").find(".pos_inner")).css("display", "none")
        $("#arrow-4").css("display", "none")
        $("#arrow-2").css("display", "block")
    })

    $("#pos_controls input[type='text']").bind("focusin", function () {
        var witdth = $(document).width();
        if (witdth <= 480) {
            $("#contentMaster").css("padding-bottom", "100px");
            window.scrollTo(0, $(this).offset().top);
        }
    })
    $("#pos_controls input[type='text']").bind("focusout", function () {
        var witdth = $(document).width();
        if (witdth <= 480) {
            $("#contentMaster").css("padding-bottom", "0px");
        }
    })

    setTimeout(function () {
        if ($("#Status").val() != 0) {
            $("#InventoryIDBarCode_input").attr("disabled", "disabled");
            $(".asf-i-search-24").parent().remove();
        }
    }, 200)


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
            if ($('meta[name=customerIndex]').attr('content') == 79) {
                $("#PromoteChangeAmount").html(this.formatMoney(this.convertToNumber(this.PromoteChangeAmount)));
            }
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
        checkKeyNumber: function (e) {
            if (e.keyCode < 48 || (e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105 && ((e.keyCode != 190 && e.keyCode != 110) || ($(this).val()).indexOf('.') != -1)) {
                if (e.keyCode != 13 && e.keyCode != 37 && e.keyCode != 39 && e.keyCode != 8)
                    e.preventDefault()
            }
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
            //var isBuy = (this.IsBuy
            //    || $('#APK').val() == ""
            //    || $('#APK').val() == EMPTY_GUID);
            var isBuy = (this.IsBuy || $("#IsUpdate").val() != "True");
            var check = ASOFT.form.checkRequiredAndInList("POSF00161", ['APKPaymentID', 'CurrencyID']);
            //Bán hàng
            if (!check && isBuy) {
                if (posViewModel.VoucherNo == "") {
                    msg = ASOFT.helper.getMessage("00ML000039");
                    var voucherNoLbl = $("label[for='VoucherNo']").html();
                    $('#VoucherNo').addClass('asf-focus-input-error');
                    msg = kendo.format(msg, voucherNoLbl);
                    ASOFT.form.displayError("#POSF00161", msg);
                    $(".asf-panel-required").css("margin-top", "50px");
                    $(".asf-panel-required").css("padding-top", "0px");
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
                    $(".asf-panel-required").css("margin-top", "50px");
                    $(".asf-panel-required").css("padding-top", "0px");
                    return true;
                } else if (posViewModel.Status == "2" && posViewModel.CVoucherNo == "") {
                    msg = ASOFT.helper.getMessage("00ML000039");
                    var CVoucherNoLbl = $("label[for='PVoucherNo']").html();
                    $('#CVoucherNo').addClass('asf-focus-input-error');
                    msg = kendo.format(msg, CVoucherNoLbl);
                    ASOFT.form.displayError("#POSF00161", msg);
                    $(".asf-panel-required").css("margin-top", "50px");
                    $(".asf-panel-required").css("padding-top", "0px");
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
                            $(".asf-panel-required").css("margin-top", "50px");
                            $(".asf-panel-required").css("padding-top", "0px");
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
                    check = true;
                } else {
                    //show quantity
                    if (ASOFT.asoftGrid.editGridValidate(posGrid, ['DiscountRate', 'DiscountAmount', 'Imei01', 'Imei02'])) {
                        msg = ASOFT.helper.getMessage("00ML000060");
                        ASOFT.form.displayError("#POSF00161", msg);
                        check = true;
                    }
                }
            }

            if (!check && posViewModel.Status == "0") {
                if ($("#PaymentObjectAmount01").val() <= 0) {
                    $('#PaymentObjectAmount01').addClass('asf-focus-input-error');
                    msg = ASOFT.helper.getMessage("00ML000116");
                    ASOFT.form.displayError("#POSF00161", msg);
                    check = true;
                }
            }
            //Check totalAmount
            //if (!check) {
            //    var change = posViewModel.convertToNumber(posViewModel.get('Change'));
            //    if (change < 0) {
            //        var textAmount01 = $("label[for='PaymentObjectAmount01']").html();
            //        var textAmount02 = $("label[for='PaymentObjectAmount02']").html();
            //        var textChange = $("label[for='Change']").html();

            //        if (posViewModel.checkObjectAmount02()) {
            //            msg = ASOFT.helper.getMessage("POSM000022");
            //            msg = kendo.format(msg, textAmount01, textAmount02, textChange);
            //        } else if (!$("#divPaymentID1").hasClass(CSS_HIDDEN)) {
            //            msg = ASOFT.helper.getMessage("POSM000023");
            //            msg = kendo.format(msg, textAmount01, textChange);
            //        } else if (!$("#divPaymentID2").hasClass(CSS_HIDDEN)) {
            //            msg = ASOFT.helper.getMessage("POSM000023");
            //            msg = kendo.format(msg, textAmount02, textChange);
            //        }
            //        ASOFT.form.displayError("#POSF00161", msg);
            //        check = true;
            //    }
            //}
            if (check) {
                $(".asf-panel-required").css("margin-top", "50px");
                $(".asf-panel-required").css("padding-top", "0px");
                resizeGrid();
            }
            return (check || this.gridDataSource.data().length <= 0);
        },
        resetRedure: function () {
            //this.set("TotalDiscountRate", 0);
            //this.set("TotalDiscountAmount", 0);
            this.set("TotalRedureRate", 0);
            this.set("TotalRedureAmount", 0);
        },
        calTaxAmountByInventoryID: function (data, intentory) {
            /* var arr = $.grep(data, function (item, i) {
                 return (intentory.InventoryID === item.InventoryID);
             });*/
            var totalDiscountAmount = this.convertToNumber(this.get("TotalDiscountAmount"));
            var totalReduceAmount = this.convertToNumber(this.get("TotalRedureAmount"));
            var taxAmount = 0;
            var sumAmount = 0;
            $.each(data, function (index, item) {
                // InventoryAmount = Unit * Quanlity - Discount
                sumAmount += item.InventoryAmount;
            });
            if (intentory.Amount != null) {
                // intentory.Amount = Unit * Quanlity
                var amount = parseFloat(intentory.Amount);
                var discountAmount = parseFloat(intentory.DiscountAmount);
                var vatPercent = parseFloat(intentory.VATPercent);
                if (amount > 0) {
                    taxAmount = (amount - discountAmount - ((totalDiscountAmount * amount) / sumAmount) - ((totalReduceAmount * amount) / sumAmount)) * vatPercent;
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
            var totalPromoteChangeAmount = 0;
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
                if ($('meta[name=customerIndex]').attr('content') == 79 && intentory.PromoteChangeUnitPrice != null && $('#Status').val() == 0)
                {
                    totalPromoteChangeAmount += intentory.PromoteChangeUnitPrice;
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
                    totalChangeAmount += changeItems[i].InventoryAmount + changeItems[i].TaxAmount;
                }
                var buyItems = this.getBuyInventories(changeItems);
                for (var i = 0; i < buyItems.length; i++) {
                    totalBuy += buyItems[i].InventoryAmount + buyItems[i].TaxAmount;
                }
                diffAmount = totalChangeAmount - totalBuy;
                this.set("ChangeAmount", this.formatMoney(diffAmount));
            }

            //Tổng tiền
            var totalInventoryAmount = (totalAmount + totalTaxAmount - totalDiscountAmount - totalRedureAmount + totalPromoteChangeAmount);
            this.set("PromoteChangeAmount", this.formatMoney(totalPromoteChangeAmount));
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
            var totalPromoteChangeAmount = 0;
            $.each(data, function (index, intentory) {
                if (intentory.Amount != null) {
                    var taxAmount = that.calTaxAmountByInventoryID(data, intentory);
                    totalTaxAmount += taxAmount;
                    intentory.TaxAmount = taxAmount;
                }
                if ($('meta[name=customerIndex]').attr('content') == 79 && intentory.PromoteChangeUnitPrice != null && $('#Status').val() == 0) {
                    totalPromoteChangeAmount += intentory.PromoteChangeUnitPrice;
                }
            });
            this.set("TotalTaxAmount", this.formatMoney(totalTaxAmount));
            //Tổng tiền
            var totalAmount = this.convertToNumber(this.get("TotalAmount"));
            //totalTaxAmount = this.convertToNumber(this.get("TotalTaxAmount"));
            var totalDiscountAmount = this.convertToNumber(this.get("TotalDiscountAmount"));
            var totalRedureAmount = this.convertToNumber(this.get("TotalRedureAmount"));

            var totalInventoryAmount = (totalAmount + totalTaxAmount - totalDiscountAmount - totalRedureAmount) + totalPromoteChangeAmount;
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
            dataPost.APK = $("#APK").val();
            dataPost.SaleManID = $("#SaleManID").data("kendoComboBox").value();
            if ($('meta[name=customerIndex]').attr('content') == 79) {
                dataPost.PromoteChangeAmount = this.convertToNumber(posViewModel.get("PromoteChangeAmount"));
            }
            dataPost.IsWarehouseExported = $("#IsWarehouseExported").is(':checked');
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
            if (typeof (overrideReset) === "function") {
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
        cancel: function (isNoreload) {
            var defaultValue = this.formatMoney(0);
            this.set("TotalAmount", defaultValue);
            this.set("TotalTaxAmount", defaultValue);
            this.set("TotalDiscountRate", defaultValue);
            this.set("TotalDiscountAmount", defaultValue);
            this.set("TotalRedureRate", defaultValue);
            this.set("TotalRedureAmount", defaultValue);

            this.set("Change", defaultValue);
            this.set("TotalInventoryAmount", defaultValue);
            if($('meta[name=customerIndex]').attr('content') == 79)
            {
                this.set("PromoteChangeAmount", defaultValue);
            }
            if ($('#CustomerIndex').val() != 56) {
                //this.set("MemberID", '');
               // this.set("MemberName", '');
                this.set("APKPaymentID", '');
            }
            this.set("InventoryID", '');
            this.set("CurrencyID", 'VND');

            this.set("PaymentObjectAmount01", defaultValue);
            this.set("PaymentObjectAmount02", defaultValue);

            this.set("AccountNumber01", '');
            this.set("AccountNumber02", '');

            this.set("PaymentObjectID01", '');
            this.set("PaymentObjectID02", '');


            this.set("VoucherNo", '');
            this.set("ReVoucherNo", '');
            //this.set("MemberID", '');
            //btnReturn.enable(false);
            if (btnChangeInventory != undefined) {
                btnChangeInventory.enable(false);
            }

            ASOFT.helper.postTypeJson("/POS/POSF0016/GetMemberOld", {}, function (reMember) {
                $("#MemberID").val(reMember.MemberID);
                $("#MemberName").val(reMember.MemberName);
            })

            $("#APKPaymentID").data("kendoComboBox").select(0)
            $("#SaleManID").data("kendoComboBox").value(ASOFTEnvironment.UserID);
            //remove grid
            $("#MemberName").removeClass('asf-focus-input-error');
            if (!isNoreload) {
                posGrid.dataSource.data([]);
            }
            //$("#APK").val(EMPTY_GUID);
            posGrid.refresh();
            ASOFT.form.clearMessageBox('POSF00161');
            resizeGrid();
        },
        print: function (apk) {
            //var fullPath = null;
            //if ($('#CustomerIndex').val() == 56) {
            //    fullPath = kendo.format(getAbsoluteUrl("POSF0016/PrintCustomTMQ3/{0}"), apk);
            //}
            //else
            //    fullPath = kendo.format(getAbsoluteUrl("POSF0016/Print/{0}"), apk);
            //$("#btnPrint").printPage({
            //    url: fullPath,
            //    attr: "href",
            //    message: $('#PrintMessage').val()
            //});
            //$("#btnPrint").trigger('click');
            ASOFT.helper.postTypeJson("/POS/POSF0016/PrintReportPayment", { id: apk }, function (result) {
                if (result) {
                    window.open(["/POS/POSF0016/ReportPayment?id=", result].join(""), "_blank");
                }
            });

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
            //var isUpdate = ($("#APK").val() != null
            //    && $("#APK").val() != ''
            //    && $("#APK").val() != EMPTY_GUID);
            var isUpdate = $("#IsUpdate").val() == "True";
            var action = getAbsoluteUrl("POSF0016/Insert");
            if (isUpdate) {
                action = getAbsoluteUrl("POSF0016/Update");
                dataPost.APK = $("#APK").val();
                dataPost.APPSuggestID = $("#APPSuggestID").val();
            }
            //dataPost.Cash = 0;
            dataPost.PayScore = 0;

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    //Delete Json
                    ASOFT.helper.showErrorSeverOption(0, data, "POSF00161", function () {
                        if (parent !== window) {
                            parent.refreshGrid();
                        }
                        //reset 
                        posViewModel.cancel(true);
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
                            $("#APK").val(data.Data.APKNew);
                            $("#APPSuggestID").val(data.Data.APPSuggestID);
                            //Print
                            if (isUpdate || data.Data.IsWarehouseExported) {
                                posGrid.dataSource.data([]);
                                posViewModel.print(data.Data.APK);
                            }
                            else {
                                var UrlPOSF00281 = "/POS/POSF0027/POSF00282?APKPOST0016=" + data.Data.APK;
                                ASOFT.asoftPopup.showIframe(UrlPOSF00281, {});
                            }
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
                    if (data[0]) {
                        if (data[0].Status == 1) {
                            $(".asf-panel-required").css("margin-top", "50px");
                            $(".asf-panel-required").css("padding-top", "0px");
                        }
                        if (data[0].Status == 2) {
                            $(".asf-panel-warning").css("margin-top", "50px");
                            $(".asf-panel-warning").css("padding-top", "0px");
                        }
                    }
                    else {
                        if (data.Status == 1) {
                            $(".asf-panel-required").css("margin-top", "50px");
                            $(".asf-panel-required").css("padding-top", "0px");
                        }
                        if (data.Status == 2) {
                            $(".asf-panel-warning").css("margin-top", "50px");
                            $(".asf-panel-warning").css("padding-top", "0px");
                        }
                    }
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
                    if (data.Status == 1) {
                        $(".asf-panel-required").css("margin-top", "50px");
                        $(".asf-panel-required").css("padding-top", "0px");
                    }
                    if (data.Status == 2) {
                        $(".asf-panel-warning").css("margin-top", "50px");
                        $(".asf-panel-warning").css("padding-top", "0px");
                    }
                }
            );
            return false;
        },
        resetIfFrame: function () {
            if (typeof (overrideReset) === "function") {
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
        getChangeInventories: function () {
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
                $(".asf-panel-required").css("margin-top", "50px");
                $(".asf-panel-required").css("padding-top", "0px");
                return true;
            }

            //if (this.convertToNumber(this.ChangeAmount) < 0) {
            //    var msg = ASOFT.helper.getMessage("POSM000055");
            //    ASOFT.form.displayError("#POSF00161", msg);
            //    $(".asf-panel-required").css("margin-top", "50px");
            //    $(".asf-panel-required").css("padding-top", "0px");
            //    return true;
            //}

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
                            setTimeout(function () {
                                if (typeof (overrideReset) === "function") {
                                    //raise event
                                    overrideReset(posViewModel);
                                }
                            }, 600);
                        }
                    }, false);
                    if (data.Status == 1) {
                        $(".asf-panel-required").css("margin-top", "50px");
                        $(".asf-panel-required").css("padding-top", "0px");
                    }
                    if (data.Status == 2) {
                        $(".asf-panel-warning").css("margin-top", "50px");
                        $(".asf-panel-warning").css("padding-top", "0px");
                    }
                }
            );
            return false;
        },
        saveAndPrint: function () {

            switch (posViewModel.Status) {
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

        $(posGrid.tbody).find('td').on("keydown mouseleave", function (e) {
            switch (e.keyCode) {
                case 117:
                    $("#InventoryIDBarCode_input").focus();
                    break;
                case 13:
                    if ($('meta[name=customerIndex]').attr('content') == 56) {
                        $("#PaymentObjectAmount01").focus();
                    }
                    break;
            }
        });
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

function renderChoosePromoted(data) {
    if (data.IsPromotion == 0) {
        return "<a class='asf-button k-button-promote' href='#' onclick='choosePromote(this,1)' data-shopID='" + data.ShopID + "' data-division='" + data.DivisionID + "' data-CA='" + data.CA + "'><span>...</span></a>";
    }

    return "";
}

function renderOptionPromoted(data) {
    if (data.IsPromotion == 0) {
        return "<a class='asf-button k-button-promote' href='#' onclick='choosePromote(this,2)' data-shopID='" + data.ShopID + "' data-division='" + data.DivisionID + "' data-CA='" + data.CA + "'><span>...</span></a>";
    }

    return "";
}

function renderReQuantity(data) {
    return "<a class='asf-button k-button-promote' href='#' onclick='return addReQuantity(this)' ><span>...</span></a>";
}

function addReQuantity(e) {
    var row = $(e).parent().closest('tr');
    var rowChoose = posGrid.dataItem(row);

    var url = kendo.format("/POS/POSF0016/POSF00165?InventoryID={0}&InventoryName={1}", rowChoose.InventoryID, rowChoose.InventoryName);
    ASOFT.asoftPopup.showIframe(url);
}

function renderIsInstallmentPrice(data)
{
    if (data.IsPromotion) {
        return "";
    }
    return kendo.format("<input style='width:20px' type='checkbox' class='asf-checkbox' {0} />", data.IsInstallmentPrice == 1 ? "checked='checked'": '')
}

function checkFillUnitPrice(that, e)
{
    var tr = that.parentElement.parentElement;
    var uid = tr.dataset.uid;
    var item = posGrid.dataItem(tr);
    var checked = that.checked;

    if(checked)
    {
        item.set("IsInstallmentPrice", 1);
        item.set("UnitPrice", item.get("InstallmentPriceHidden"));
    }
    else
    {
        item.set("IsInstallmentPrice", 0);
        item.set("UnitPrice", item.get("UnitPriceHidden"));
    }



    item.set("Amount", item.get("ActualQuantity") * item.get("UnitPrice"));

    item.set("DiscountAmount", Math.round(item.get("Amount") * (item.get("DiscountRate") / 100)));

    item.set("TaxAmount", (item.get("Amount") - item.get("DiscountAmount")) * item.get("VATPercent"));
    item.set("InventoryAmount", item.get("Amount") - item.get("DiscountAmount"));

    posViewModel.resetRedure();
    posGrid.saveChanges();
    posViewModel.callTotal(false);
    posViewModel.fillSaleOff(tr, item.get("InventoryID"), item.get("PromotionList"));

    posGrid.refresh();
}


function choosePromote(e, type) {
    var url = "";
    var row = $(e).parent().closest('tr');
    var rowChoose = posGrid.dataItem(row);
    var element = $(e),
        division = element.attr('data-division'),
        shopID = element.attr('data-shopID'),
        CA = element.attr('data-CA'),
        InventoryID = rowChoose.InventoryID,
        InventoryName = rowChoose.InventoryName,
        UnitPrice = rowChoose.UnitPrice,
        UnitID = rowChoose.UnitID,
        ActualQuantity = rowChoose.ActualQuantity
        ;

    if (type == 1) {
        url = "/POS/POSF0016/POSF00163?DivisionID=" + division + "&ShopID=" + shopID + "&VoucherDate=" + $("#VoucherDate").val() + "&CA=" + CA + "&APK=" + $("#APPSuggestID").val();
    }
    else {
        inventoryIDPOSF00164.UnitID = UnitID;
        inventoryIDPOSF00164.UnitPrice = UnitPrice;
        inventoryIDPOSF00164.InventoryID = InventoryID;
        inventoryIDPOSF00164.InventoryName = InventoryName;
        inventoryIDPOSF00164.EmployeeID = $("#EmployeeID").val();
        inventoryIDPOSF00164.EmployeeName = $("#EmployeeName").val();
        inventoryIDPOSF00164.SalesManName = $("#SaleManID").data("kendoComboBox").text();
        url = "/POS/POSF0016/POSF00164?DivisionID=" + division + "&ShopID=" + shopID + "&VoucherDate=" + $("#VoucherDate").val() + "&CA=" + CA + "&APK=" + $("#APPSuggestID").val();
    }

    ASOFT.asoftPopup.showIframe(url, {});
}

function getInventoyID() {
    return inventoryIDPOSF00164;
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
function AddRow(item, isPromote) {
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
        row.ActualQuantity = isPromote ? item.ActualQuantity : "";
        row.UnitPrice = item.IsPromotion == 1 ? 0 : (item.IsInstallmentPrice ? item.InstallmentPrice: item.UnitPrice);
        row.InstallmentPriceHidden = item.IsPromotion == 1 ? 0: (item.InstallmentPrice || 0);
        row.UnitPriceHidden = item.IsPromotion == 1 ? 0 : (item.UnitPrice || 0);
        row.VATGroupID = item.VATGroupID;
        row.VATPercent = item.VATPercent;
        row.DiscountRate = item.DiscountRate;
        row.ID1 = item.ID1;
        row.ID2 = item.ID2;
        row.ShopID = item.ShopID;
        row.DivisionID = item.DivisionID;
        row.CA = item.CA;
        if (!isPromote)
        {
            row.CAAmount = item.CAAmount;
        }
        row.PromoteChangeUnitPrice = item.PromoteChangeUnitPrice;

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

                //if (model.DiscountAmount != 0) {
                    discountRate = (parseFloat(e.values.DiscountAmount) / amount) * 100;
                //} else {
                //    discountRate = 0;
                //}
                e.model.set("DiscountRate", discountRate);
                e.model.set("InventoryAmount", amount - e.values.DiscountAmount);
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

    if ($('meta[name=customerIndex]').attr('content') == 56) {
        posViewModel.saveAndPrint();
        var iventoryAutoComplete = $("#InventoryID").data("kendoAutoComplete");
        if (iventoryAutoComplete != undefined) {
            iventoryAutoComplete.focus();
        }
    }
    else {
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

        // If locked or expired, do not discount
        if ((item.Locked != null && item.Locked == 1) ||
            item.Expired != null && item.Expired == 1) {
            posViewModel.set('TotalDiscountRate', 0);
        }
        else {
            posViewModel.set('TotalDiscountRate', item.DiscountRate || 0);
        }

        $("#MemberValue").val(item.MemberID);

        posViewModel.changeDiscountRate(posViewModel.convertToNumber(posViewModel.get('TotalDiscountRate')));
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

    $("#TotalDiscountAmount").keydown(function (e) {
        posViewModel.checkKeyNumber(e);
    })

    $("#TotalDiscountAmount").focusout(function (e) {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatMoney(value);
        $(this).val(value);
    });

    $("#TotalRedureAmount").keydown(function (e) {
        posViewModel.checkKeyNumber(e);
    })

    $("#TotalRedureAmount").focusout(function (e) {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatMoney(value);
        $(this).val(value);
    });

    $("#PaymentObjectAmount01").keydown(function (e) {
        posViewModel.checkKeyNumber(e);
    })

    $("#PaymentObjectAmount01").focusout(function (e) {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatMoney(value);
        $(this).val(value);
    });

    $("#PaymentObjectAmount02").keydown(function (e) {
        posViewModel.checkKeyNumber(e);
    })

    $("#PaymentObjectAmount02").focusout(function (e) {
        var value = posViewModel.convertToNumber($(this).val());
        value = posViewModel.formatMoney(value);
        $(this).val(value);
    });

    $("#TotalDiscountRate").keydown(function (e) {
        posViewModel.checkKeyNumber(e);
    })

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

    $("#TotalRedureRate").keydown(function (e) {
        posViewModel.checkKeyNumber(e);
    })

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

//Customer MINHSANG chọn khuyến mãi
function receiveResult(result) {
    result.DiscountRate = 0;
    result.DiscountAmount = 0;
    result.IsPromotion = 1;
    AddRow(result, true);
}

function getMaster() {
    return posViewModel.getInfo();
}

function receiveResultCustom(master, detail) {
    posGrid.dataSource.data([]);
    //$("#APK").val(master.APK);
    $("#APPSuggestID").val(master.APK);
    $("#MemberID").val(master.MemberID);
    $("#MemberName").val(master.MemberName);
    $("#ExchangeRate").val(master.ExchangeRate);
    $("#CurrencyID").data("kendoComboBox").value(master.CurrencyID);
    $("#SaleManID").data("kendoComboBox").value(master.SaleManID);
    $("#PromoteChangeAmount").html(posViewModel.formatMoney(posViewModel.convertToNumber(master.PromoteChangeAmount)));
    for (var i = 0; i < detail.length; i++)
    {
        detail[i].DiscountRate = 0;
        detail[i].APKMInherited = detail[i].APKMaster;
        detail[i].APKDInherited = detail[i].APK;
        detail[i].InstallmentPrice = detail[i].InstallmentPrice | 0;
        AddRow(detail[i], true);
    }
}

function btnSalseOrderAPP_Click() {
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/POS/POSF00162", {});
}

function printPOST00161(APK) {
    if (parent !== window) {
        parent.refreshGrid();
    }
    posGrid.dataSource.data([]);
    posViewModel.print(APK);
}