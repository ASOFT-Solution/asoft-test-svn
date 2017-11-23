var GridOT2002 = null;
var readIndex = 0;
var vatgroupID = null;
var ana01ID = null;
var ana02ID = null;
var ana03ID = null;
var ana04ID = null;
var ana05ID = null;
var ana06ID = null;
var ana07ID = null;
var ana08ID = null;
var ana09ID = null;
var ana10ID = null;
var DataPROINVENTORY = null;
var CacheAPKofPriceList = null;
var isCheckQuatity = true;

$(document).ready(function () {
    CacheAPKofPriceList = $('#APKofPriceList').val();
    $("#ObjectID").attr("data-val-required", "The field is required.");

    GridOT2002 = $("#GridEditOT2002").data("kendoGrid");
    DataPROINVENTORY = [];
    //ToanThien Sua loi chieu cao tren firefox
    $("#GridEditOT2002 .k-grid-content").css("height", "200px");
    $("#GridEditOT2002").css("max-height", "250px");

    GridOT2002.bind("dataBound", function (e) {
        var dataSource = e.sender._data;

        var TotalOrderQuantity = 0;
        var TotalOriginalAmount = 0;
        var TotalDiscountOriginalAmount = 0;
        var TotalBeforeAmount= 0;
        var TotalVATPercent= 0;
        var TotalAmount = 0;
        var TotalVATOriginalAmount = 0;

        if (dataSource.length > 0) {
            for (var i = 0; i < dataSource.length; i++) {
                //TotalOrderQuantity
                TotalOrderQuantity = (dataSource[i].OrderQuantity && dataSource[i].OrderQuantity > 0) ? TotalOrderQuantity + parseFloat(dataSource[i].OrderQuantity) : TotalOrderQuantity + 0;
                //TotalOriginalAmount
                TotalOriginalAmount = (dataSource[i].OriginalAmount && dataSource[i].OriginalAmount > 0) ? TotalOriginalAmount + parseFloat(dataSource[i].OriginalAmount) : TotalOriginalAmount + 0;
                //TotalDiscountOriginalAmount
                TotalDiscountOriginalAmount = (dataSource[i].DiscountOriginalAmount && dataSource[i].DiscountOriginalAmount > 0) ? TotalDiscountOriginalAmount + parseFloat(dataSource[i].DiscountOriginalAmount) : TotalDiscountOriginalAmount + 0;
                //TotalBeforeAmount
                TotalBeforeAmount = (dataSource[i].TotalBeforeAmount && dataSource[i].TotalBeforeAmount > 0) ? TotalBeforeAmount + parseFloat(dataSource[i].TotalBeforeAmount) : TotalBeforeAmount + 0;
                //TotalAfterAmount
                TotalAmount = (dataSource[i].TotalAfterAmount && dataSource[i].TotalAfterAmount > 0) ? TotalAmount + parseFloat(dataSource[i].TotalAfterAmount) : TotalAmount + 0;
                //TotalVATOriginalAmount
                TotalVATOriginalAmount = (dataSource[i].VATOriginalAmount && dataSource[i].VATOriginalAmount > 0) ? TotalVATOriginalAmount + parseFloat(dataSource[i].VATOriginalAmount) : TotalVATOriginalAmount + 0;
            }
        }
        //TotalOrderQuantity
        $('div#totalFooterOrderQuantity').text(formatDecimal(kendo.parseFloat(TotalOrderQuantity), 2));
        //TotalOriginalAmount
        $('div#totalFooterOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalOriginalAmount), 1));
        //TotalDiscountOriginalAmount
        $('div#totalFooterDiscountOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalDiscountOriginalAmount), 1));
        //TotalBeforeAmount
        $('div#totalFooterTotalBeforeAmount').text(formatDecimal(kendo.parseFloat(TotalBeforeAmount), 1));
        //TotalAfterAmount
        $('div#totalFooterTotalAfterAmount').text(formatDecimal(kendo.parseFloat(TotalAmount), 1));
        //TotalVATOriginalAmount
        $('div#totalFooterVATOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalVATOriginalAmount), 1));


        $('#TotalAmount').val(formatDecimal(kendo.parseFloat(TotalAmount),1));
        $('#PayAmount').val(formatDecimal(kendo.parseFloat(parseFloat(TotalAmount) - ($('#ShipAmount').val() ? kendo.parseFloat($('#ShipAmount').val()) : kendo.parseFloat(0))),1));
    });
    
    if ($("#isUpdate").val() == "False") {
        $("#DiscountSalesAmount").val('0');
        $("#ShipAmount").val('0');
        $("#TotalAmount").val('0');
        $("#PayAmount").val('0');
    }
    else {
        $("#DiscountSalesAmount").val(formatDecimal(kendo.parseFloat($("#DiscountSalesAmount").val() ? $("#DiscountSalesAmount").val() : 0),1));
        $("#ShipAmount").val(formatDecimal(kendo.parseFloat($("#ShipAmount").val() ? $("#ShipAmount").val() : 0),1));
        $("#TotalAmount").val(formatDecimal(kendo.parseFloat($("#TotalAmount").val() ? $("#TotalAmount").val() : 0),1));
        $("#PayAmount").val(formatDecimal(kendo.parseFloat($("#PayAmount").val() ? $("#PayAmount").val() : 0),1));
        
        $("#VoucherNo").attr("readonly", true);

        if ($("#Status").val() == 1) {
            
            $("#OrderDate").attr("readonly", true);
            $("#OrderDate").parent().children()[1].remove();
            $("#VoucherTypeID").data("kendoComboBox").readonly();
            GridOT2002.hideColumn(GridOT2002.columns.length - 1);
        }
    }

    $("#CurrencyID").data("kendoComboBox").readonly();
    $("#OrderStatus").data("kendoComboBox").readonly();
    $("#VoucherTypeID").data("kendoComboBox").select(0);
    

    $("#ObjectName").attr("readonly", true);
    
    $("#DiscountSalesAmount").attr("readonly", true);

    $("#ShipAmount").attr("readonly", true);
    $("#TotalAmount").attr("readonly", true);
    $("#PayAmount").attr("readonly", true);

    $("#Disabled").val(0);
    $("#IsConfirm").val(0);
    $("#OrderType").val(0);

    //OrderDate change----
    var datepicker = $("#OrderDate").data("kendoDatePicker");

    datepicker.bind("change", function () {
        ASOFT.form.clearMessageBox();
        var value = this._oldText;
        var data = {
            ObjectID: $('#ObjectID').val(),
            OrderDate: value,
            CurrencyID: $('#CurrencyID').val(),
            APKofPriceList: $('#APKofPriceList').val(),
            IsClearCache : false
        };

        ASOFT.helper.postTypeJson("/SO/SOF2010/SetOP1302", data);

        getDataPromoteOfOrderDate();
    });
    //-----

    if ($("#isUpdate").val() == "False") {
        $("#DivisionID").change(function () {
            changeDivisionIDSOF2001();
            $("#Disabled").val(0);
            $("#IsConfirm").val(0);
            $("#OrderType").val(0);
        });
        $("#VoucherTypeID").change(function () {
            GetvoucherNo();
        });
        GetvoucherNo();
    }

    if ($('meta[name=customerIndex]').attr('content') == 57) {
        GridOT2002.bind('edit', function (e) {
            if ($("#isUpdate").val() == 'True' && $("#Status").val() == 1) {
                e.sender.closeCell();
            } else {
                var selectitem = GridOT2002.dataItem(GridOT2002.select());
                if (selectitem && selectitem.IsProInventoryID == 1) {
                    var index = e.sender._editContainer.context.cellIndex ? e.sender._editContainer.context.cellIndex : e.sender._editContainer.parent().children()[0].textContent;

                    var columns = e.sender.columns;
                    var array = ["Notes01", "Notes02"];
                    if ($.inArray(columns[index].field, array) == -1) {
                        e.sender.closeCell()
                    }
                }
            }
        });

    }
    $(GridOT2002.tbody).on("focusout", "td", function (e) {
        var column = e.target.name;
        if (column.indexOf("_input") != -1) {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            selectitem.set(column.split('_')[0], e.target.value);
        }
    })

    $(GridOT2002.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        if (column == "cbbAna01ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana01ID", ana01ID);
        }
        if (column == "cbbAna02ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana02ID", ana02ID);
        }
        if (column == "cbbAna03ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana03ID", ana03ID);
        }
        if (column == "cbbAna04ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana04ID", ana04ID);
        }
        if (column == "cbbAna05ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana05ID", ana05ID);
        }
        if (column == "cbbAna06ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana06ID", ana06ID);
        }
        if (column == "cbbAna07ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana07ID", ana07ID);
        }
        if (column == "cbbAna08ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana08ID", ana08ID);
        }
        if (column == "cbbAna09ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana09ID", ana09ID);
        }
        if (column == "cbbAna10ID") {
            var selectitem = GridOT2002.dataItem(GridOT2002.select());
            GetCombobox(e.target.value, "Ana10ID", ana10ID);
        }
        if (column == "OrderQuantity") {  
            var dataSource = GridOT2002.dataSource;
            var dataValue = dataSource._data;

            var selectitem = GridOT2002.dataItem(GridOT2002.select());
           
            var Quality = 0;
            for (var i = 0; i < dataValue.length; i++) {
                if(dataValue[i].InventoryID==selectitem.InventoryID){
                    if(i == GridOT2002.select().index()){
                        Quality = parseInt(Quality)+parseInt(e.target.value);
                    }else{
                        Quality = parseInt(Quality)+parseInt(dataValue[i].OrderQuantity);
                    }
                }
            }

            var data = {
                OrderDate: $('#OrderDate').val(),
                InventoryID: selectitem.InventoryID,
                Quality: Quality
            }

            ASOFT.form.clearMessageBox();
            isCheckQuatity = true;

            ASOFT.helper.postTypeJson("/SO/SOF2010/GetCheckQuality", data, function (result) {
                if (result.status == 1) {                  

                    ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage(result.message).f(result.inventoryID, result.beginQuatity)], null);

                    isCheckQuatity = false;
                }
            })
        }
    })



    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditOT2002',
        inputID: 'autocomplete-box',
        NameColumn: "InventoryID",
        autoSuggest: false,
        serverFilter: true,
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("DivisionID", dataItem.DivisionID);
            selectedRowItem.model.set("InventoryID", dataItem.InventoryID);
            selectedRowItem.model.set("InventoryName", dataItem.InventoryName);
            selectedRowItem.model.set("UnitID", dataItem.UnitID);
            selectedRowItem.model.set("OrderQuantity", dataItem.OrderQuantity);
            selectedRowItem.model.set("SalePrice", dataItem.SalePrice);
            selectedRowItem.model.set("IsProInventoryID", 0);
            selectedRowItem.model.set("OriginalAmount", changeformatDecimal(dataItem.OriginalAmount));
            
            selectedRowItem.model.set("VATOriginalAmount", changeformatDecimal(dataItem.VATOriginalAmount));
            selectedRowItem.model.set("StandardPrice", dataItem.SalePrice);
            selectedRowItem.model.set("VATPercent", dataItem.VATPercent);
            selectedRowItem.model.set("ConvertedAmount", dataItem.ConvertedAmount * $("#ExchangeRate").val());
            selectedRowItem.model.set("VATGroupID", dataItem.VATGroupID);

            if ($('meta[name=customerIndex]').attr('content') == 57) {
                
                var data = [];
                data.push(selectedRowItem.model.DivisionID,
                    $('#ObjectID').val(),
                    $('#InventoryTypeID').val(),
                    selectedRowItem.model.InventoryID,
                    $('#OrderDate').val(),
                    selectedRowItem.model.OrderQuantity);

                var data1 = {
                    InventoryID: selectedRowItem.model.InventoryID,
                    APKofPriceList: $('#APKofPriceList').val(),
                    IsUpdateMaster: false
                }

                ASOFT.helper.postTypeJson("/SO/SOF2010/GetDataSalePrice", data1, function (result) {
                    selectedRowItem.model.set("SalePrice", result.lst[0].SalePrice);
                    selectedRowItem.model.set("DiscountPercent", result.lst[0].DiscountPercent);
                })

                ASOFT.helper.postTypeJson("/SO/SOF2010/GetPromotePercent", data, function (result) {
                    if (selectedRowItem.model.DiscountPercent < result.PromotePercent) {
                        selectedRowItem.model.set("DiscountPercent", result.PromotePercent);
                    }
                })

                selectedRowItem.model.set("DiscountOriginalAmount", changeformatDecimal(selectedRowItem.model.OriginalAmount * (selectedRowItem.model.DiscountPercent / 100)));

                var DiscountAmount = selectedRowItem.model.OriginalAmount * selectedRowItem.model.DiscountPercent / 100;
                selectedRowItem.model.set("DiscountSaleAmountDetail", selectedRowItem.model.DiscountSaleAmountDetail ? changeformatDecimal(selectedRowItem.model.DiscountSaleAmountDetail) : 0);
                selectedRowItem.model.set("TotalBeforeAmount", changeformatDecimal(selectedRowItem.model.OriginalAmount - DiscountAmount - selectedRowItem.model.DiscountSaleAmountDetail));
             
                selectedRowItem.model.set("TotalAfterAmount", changeformatDecimal(selectedRowItem.model.TotalBeforeAmount + selectedRowItem.model.VATOriginalAmount));

                selectedRowItem.model.set("VATConvertedAmount", selectedRowItem.model.VATOriginalAmount * $("#ExchangeRate").val());
                selectedRowItem.model.set("DiscountConvertedAmount", selectedRowItem.model.DiscountOriginalAmount * $("#ExchangeRate").val());
                //load grid khuyến mãi
                getDataPromote(data, $(selectedRowItem.sender.select().children()[0]).text());

                getDataMaster();
            }
        }
    });
})

function GetCombobox(data, column, ana) {
    var selectitem = GridOT2002.dataItem(GridOT2002.select());
    if (data != "" && data != undefined) {
        selectitem.set(column, data);
    }
    else {
        selectitem.set(column, ana);
    }
}

function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }
    if (e.values != null) {

        var OriginalAmount = 0;
        var Parameter03 = 0;
        if (e.values.SalePrice != undefined && e.model.OrderQuantity != undefined) {
            OriginalAmount = e.values.SalePrice * e.model.OrderQuantity;
            var DiscountAmount = OriginalAmount * e.model.DiscountPercent / 100;
            e.model.set("OriginalAmount", changeformatDecimal(OriginalAmount));
            e.model.set("DiscountSaleAmountDetail", e.model.DiscountSaleAmountDetail ? changeformatDecimal(e.model.DiscountSaleAmountDetail) : 0);
            e.model.set("TotalBeforeAmount", changeformatDecimal(OriginalAmount - DiscountAmount - e.model.DiscountSaleAmountDetail));
            
            e.model.set("VATOriginalAmount", changeformatDecimal(e.model.TotalBeforeAmount * (e.model.VATPercent / 100)));
            e.model.set("TotalAfterAmount", changeformatDecimal(e.model.TotalBeforeAmount + e.model.VATOriginalAmount));
            e.model.set("ConvertedAmount", e.model.OriginalAmount * $("#ExchangeRate").val());
            if ($('meta[name=customerIndex]').attr('content') == 57) {
                e.model.set("DiscountOriginalAmount", changeformatDecimal(e.model.OriginalAmount * (e.model.DiscountPercent / 100)));
            }
            e.model.set("VATConvertedAmount",changeformatDecimal( e.model.VATOriginalAmount * $("#ExchangeRate").val()));
            e.model.set("DiscountConvertedAmount", e.model.DiscountOriginalAmount * $("#ExchangeRate").val());

            getDataMaster();
        }
        if (e.model.SalePrice != undefined && e.values.OrderQuantity != undefined) {
            var data = [];
            if ($('meta[name=customerIndex]').attr('content') == 57) {
                data.push(e.model.DivisionID, $('#ObjectID').val(), $('#InventoryTypeID').val(), e.model.InventoryID, $('#OrderDate').val(), e.values.OrderQuantity, $('#PriceListID').val(), $('#CurrencyID').val());

                ASOFT.helper.postTypeJson("/SO/SOF2010/GetPromotePercent", data, function (result) {
                    e.model.set("DiscountPercent", e.model.DiscountPercent > result.PromotePercent ? e.model.DiscountPercent : result.PromotePercent);
                })
            }
            e.model.set("OrderQuantity", e.values.OrderQuantity);
            OriginalAmount = e.model.SalePrice * e.values.OrderQuantity;

            var DiscountAmount = OriginalAmount * e.model.DiscountPercent / 100;

            e.model.set("OriginalAmount", changeformatDecimal(OriginalAmount));
            e.model.set("DiscountSaleAmountDetail", e.model.DiscountSaleAmountDetail ? changeformatDecimal(e.model.DiscountSaleAmountDetail) : 0);
            e.model.set("TotalBeforeAmount",changeformatDecimal( OriginalAmount - DiscountAmount - e.model.DiscountSaleAmountDetail));
            e.model.set("VATOriginalAmount",changeformatDecimal( e.model.TotalBeforeAmount * (e.model.VATPercent / 100)));
            e.model.set("TotalAfterAmount",  changeformatDecimal(e.model.TotalBeforeAmount + e.model.VATOriginalAmount));
            e.model.set("ConvertedAmount", e.model.OriginalAmount * $("#ExchangeRate").val());
            e.model.set("VATConvertedAmount", e.model.VATOriginalAmount * $("#ExchangeRate").val());
            e.model.set("DiscountOriginalAmount", changeformatDecimal(e.model.OriginalAmount * (e.model.DiscountPercent / 100)));
            e.model.set("DiscountConvertedAmount", e.model.DiscountOriginalAmount * $("#ExchangeRate").val());
            if ($('meta[name=customerIndex]').attr('content') == 57) {
                getDataPromote(data, $(e.sender.select().children()[0]).text());
                getDataMaster();
                e.preventDefault();
            }
        }
        if (e.values.Parameter01 != undefined && e.model.Parameter02 != undefined) {
            Parameter03 = e.values.Parameter01 * e.model.Parameter02;
            e.model.set("Parameter03", Parameter03);
        }
        if (e.values.Parameter02 != undefined && e.model.Parameter01 != undefined) {
            Parameter03 = e.model.Parameter01 * e.values.Parameter02;
            e.model.set("Parameter03", Parameter03);
        }
        if (e.values.OriginalAmount != undefined) {
            e.model.set("OriginalAmount", e.values.OriginalAmount);

            var DiscountAmount = e.model.OriginalAmount * e.model.DiscountPercent / 100;

            e.model.set("TotalBeforeAmount", changeformatDecimal(e.model.OriginalAmount - DiscountAmount - e.model.DiscountSaleAmountDetail));
            e.model.set("VATOriginalAmount", changeformatDecimal(e.model.TotalBeforeAmount * (e.model.VATPercent / 100)));
            e.model.set("TotalAfterAmount", changeformatDecimal(e.model.TotalBeforeAmount  + e.model.VATOriginalAmount));
            e.model.set("ConvertedAmount", e.model.OriginalAmount * $("#ExchangeRate").val());

            e.model.set("DiscountOriginalAmount",changeformatDecimal( e.model.OriginalAmount * (e.model.DiscountPercent / 100)));
            e.model.set("VATConvertedAmount", e.model.VATOriginalAmount * $("#ExchangeRate").val());
            e.model.set("DiscountConvertedAmount", e.model.DiscountOriginalAmount * $("#ExchangeRate").val());

            getDataMaster();
        }
        if (e.values.DiscountPercent != undefined) {
            var DiscountAmount = e.model.OriginalAmount * e.values.DiscountPercent / 100;

            e.model.set("DiscountSaleAmountDetail", e.model.DiscountSaleAmountDetail ? changeformatDecimal(e.model.DiscountSaleAmountDetail) : 0);
            e.model.set("TotalBeforeAmount", e.model.OriginalAmount - DiscountAmount - e.model.DiscountSaleAmountDetail);

            e.model.set("VATOriginalAmount", changeformatDecimal(e.model.TotalBeforeAmount * (e.model.VATPercent / 100)));
            e.model.set("TotalAfterAmount",changeformatDecimal( e.model.TotalBeforeAmount + e.model.VATOriginalAmount));
            e.model.set("ConvertedAmount", e.model.OriginalAmount * $("#ExchangeRate").val());
            if ($('meta[name=customerIndex]').attr('content') == 57) {
                e.model.set("DiscountOriginalAmount", changeformatDecimal(e.model.OriginalAmount * (e.values.DiscountPercent / 100)));
                e.model.set("VATConvertedAmount", e.model.VATOriginalAmount * $("#ExchangeRate").val());
                e.model.set("DiscountConvertedAmount", e.model.DiscountOriginalAmount * $("#ExchangeRate").val());
            }
            getDataMaster();
        }
        if (e.values.VATGroupID == "") {
            vatgroupID = e.model.VATGroupID;
        }
        if (e.values.Ana01ID == "") {
            ana01ID = e.model.Ana01ID;
        }
        if (e.values.Ana02ID == "") {
            ana02ID = e.model.Ana02ID;
        }
        if (e.values.Ana03ID == "") {
            ana03ID = e.model.Ana03ID;
        }
        if (e.values.Ana04ID == "") {
            ana04ID = e.model.Ana04ID;
        }
        if (e.values.Ana05ID == "") {
            ana05ID = e.model.Ana05ID;
        }
        if (e.values.Ana06ID == "") {
            ana06ID = e.model.Ana06ID;
        }
        if (e.values.Ana07ID == "") {
            ana07ID = e.model.Ana07ID;
        }
        if (e.values.Ana08ID == "") {
            ana08ID = e.model.Ana08ID;
        }
        if (e.values.Ana09ID == "") {
            ana09ID = e.model.Ana09ID;
        }
        if (e.values.Ana10ID == "") {
            ana10ID = e.model.Ana10ID;
        }        
    }    
}


function changeDivisionIDSOF2001() {
    var data = [];
    var cbo = $("#VoucherTypeID").data("kendoComboBox");
    OpenComboDynamic(cbo);
    var cbo1 = $("#CurrencyID").data("kendoComboBox");
    OpenComboDynamic(cbo1);
    var cbo2 = $("#InventoryTypeID").data("kendoComboBox");
    OpenComboDynamic(cbo2);
    var cbo3 = $("#PaymentTermID").data("kendoComboBox");
    OpenComboDynamic(cbo3);
    var cbo4 = $("#PaymentID").data("kendoComboBox");
    OpenComboDynamic(cbo4);

    data.push($("#ObjectID").val())
    data.push($("#DivisionID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2000/ChangeDivisionID", data, checkSuccessSOF2001);
}

function checkSuccessSOF2001(result) {
    var data = [];
    data.push($("#DivisionID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2000/CheckVoucherTypeID", data, function (result1) {
        if (result1.check) {
            $("#VoucherTypeID").data("kendoComboBox").value(result1.VoucherTypeID);
            GetvoucherNo();
        }
        else {
            $("#VoucherTypeID").data("kendoComboBox").value("");
            $("#VoucherNo").val("");
        }
    });
    if ($("#CurrencyID").data("kendoComboBox").value() == $("#CurrencyID").data("kendoComboBox").text()) {
        $("#CurrencyID").data("kendoComboBox").value("");
    }
    if ($("#InventoryTypeID").data("kendoComboBox").value() == $("#InventoryTypeID").data("kendoComboBox").text()) {
        $("#InventoryTypeID").data("kendoComboBox").value("");
    }
    if ($("#PaymentID").data("kendoComboBox").value() == $("#PaymentID").data("kendoComboBox").text()) {
        $("#PaymentID").data("kendoComboBox").value("");
    }
    if ($("#PaymentTermID").data("kendoComboBox").value() == $("#PaymentTermID").data("kendoComboBox").text()) {
        $("#PaymentTermID").data("kendoComboBox").value("");
    }
    if (result.check) {

        $("#VATObjectID").val(result.Ac.VATAccountID);
        $("#RouteID").removeAttr("disabled");
        $("#RouteID").val(result.Ac.RouteID);
        $("#RouteName").val(result.Ac.RouteName);
        $("#VATAccountName").val(result.VATAccountName);
        $("#VATObjectName").val(result.VATAccountName);

        $("#Address").val(result.Ac.Address);
        $("#Tel").val(result.Ac.Tel);
        $("#VATNo").val(result.Ac.VATNo);
        $("#DeliveryAddress").val(result.Ac.DeliveryAddress);
        $("#Description").val(result.Ac.Description);
        if (result.Ac.IsInvoice == 1) {
            $("#IsInvoice").attr("checked", "checked");
        }
        else {
            $("#IsInvoice").attr("checked", false);
        }

        var datacheck = [];
        datacheck.push($("#DivisionID").val());
        datacheck.push($("#VATObjectID").val());
        datacheck.push($("#RouteID").val());
        datacheck.push($("#EmployeeID").val());
        datacheck.push($("#SalesManID").val());
        ASOFT.helper.postTypeJson("/SO/SOF2000/CheckAllDivision", datacheck, function (result2) {
            if (!result2.checkVATAccountID) {
                $("#VATObjectID").val("");
                $("#VATAccounID").val("");
                $("#VATAccountID").attr("Disabled", true);
                $("#VATAccountName").val("");
            }
            if (!result2.checkRouteID) {
                $("#RouteID").val("");
                $("#RouteID").attr("Disabled", true);
                $("#RouteName").val("");
            }
            if (!result2.checkEmployeeID) {
                $("#EmployeeID").val("");
                $("#EmployeeID").attr("Disabled", true);
                $("#EmployeeName").val("");
            }
            if (!result2.checkSalesManID) {
                $("#SalesManID").val("");
                $("#SalesManID").attr("Disabled", true);
                $("#SalesManName").val("");
            }
        })
        //GridOT2002.dataSource.page(1);
    }
    else {
        ASOFT.form.clearMessageBox();
        ClearMasterSOF2001();
        $(".k-grid-edit-row").appendTo("#grid tbody");
    }

    var listGrid = [];

    for (i = 0; i < GridOT2002.dataSource.data().length ; i++) {
        var item = GridOT2002.dataSource.at(i);
        var dataCheckInventory = [];
        dataCheckInventory.push(item.InventoryID, $("#DivisionID").val());
        ASOFT.helper.postTypeJson("/SO/SOF2000/CheckInventory", dataCheckInventory, function (result3) {
            if (result3.check) {
                item.DivisionID = $("#DivisionID").val();
                listGrid.push(item);
            }
        })
    }

    GridOT2002.dataSource.data([]);
    if (listGrid.length > 0) {
        for (i = 0; i < listGrid.length; i++) {
            GridOT2002.dataSource.add(listGrid[i]);
        }
    }
    else {
        GridOT2002.dataSource.add({ InventoryID: "" });
    }

}

function ClearMasterSOF2001() {
    var args = $('#SOF2001 input');
    for (i = 0; i < args.length; i++) {
        if (args[i].id.indexOf("_input") == -1) {
            if (args[i].id != "item.TypeCheckBox" && args[i].id.indexOf("_Content_DataType") == -1 && args[i].id.indexOf("_Type_Fields") == -1 && args[i].id != "DivisionID" && args[i].id.indexOf("listRequired") == -1 && args[i].id != "tableNameEdit" && args[i].id != "CheckInList" && args[i].id != "VoucherNo" && args[i].id != "OrderDate" && args[i].id != "ExchangeRate" && args[i].id != "ShipDate" && args[i].id != "VoucherTypeID" && args[i].id != "CurrencyID" && args[i].id != "OrderStatus" && args[i].id != "InventoryTypeID" && args[i].id != "PaymentTermID" && args[i].id != "PaymentID") {
                $("#" + args[i].id).val('');
            }
        }
    }
}

function CustomRead() {
    var ct = [];
    ct.push($("#SOrderID").val());
    ct.push($("#DivisionID").val());
    return ct;
}

function GetvoucherNo() {
    var data = [];
    data.push($("#DivisionID").val());
    data.push($("#VoucherTypeID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2010/GetVoucherNo", data, function (result) {
        $("#VoucherNo").val(result.VoucherNo);
    });
}


function genInventoryID(data) {
    if (data && data.InventoryID != null) {
        return data.InventoryID;
    }
    return "";
}

//function genVATGroupID(data) {
//    var selectitem = GridOT2002.dataItem(GridOT2002.select());
//    if (data != null && data.VATGroupID != null && selectitem != null) {
//        if (data.VATGroupID.VATGroupName !== undefined && data.VATGroupID.VATGroupID != "") {
//                selectitem.set("VATGroupID", data.VATGroupID.VATGroupID);
//            return data.VATGroupID.VATGroupID;
//        }
//        if (data.VATGroupID != "") {
//                selectitem.set("VATGroupID", data.VATGroupID);
//        return data.VATGroupID;
//    }
//    return "";
//}


function btnChooseAccount_Click() {
    urlChooseAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseAccount, {});
    action = 1;
}

function btnChooseRoute_Click() {
    urlChooseRoute = "/PopupSelectData/Index/CRM/CMNF9002?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseRoute, {});
    action = 2;
}

function btnDeleteRoute_Click() {
    $("#RouteID").val("");
    $("#RouteID").attr("Disabled", true);
    $("#RouteName").val("");
}

function btnChooseVATAccount_Click() {
    urlChooseVATAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseVATAccount, {});
    action = 3;
}


function btnDeleteVATAccount_Click() {
    $("#VATObjectID").val("");
    $("#VATAccounID").val("");
    $("#VATAccountID").attr("Disabled", true);
    $("#VATAccountName").val("");
}

function btnChooseEmployee_Click() {
    urlChooseEmployee = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
    action = 5;
}

function btnDeleteEmployee_Click() {
    $("#EmployeeID").val("");
    $("#EmployeeID").attr("Disabled", true);
    $("#EmployeeName").val("");
}

function btnChooseSalesMan_Click() {
    urlChooseSalesMan = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseSalesMan, {});
    action = 6;
}

function btnDeleteSalesMan_Click() {
    $("#SalesManID").val("");
    $("#SalesManID").attr("Disabled", true);
    $("#SalesManName").val("");
}

function ChooseInventory_Click(e) {
    $(e.parentElement.parentElement).addClass("k-state-selected");
    urlChooseInventoryID = "/PopupSelectData/Index/00/CMNF9001";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    action = 4;
}


function receiveResult(result) {
    if (action == 2) {
        $("#RouteID").removeAttr("disabled");
        $("#RouteID").val(result["RouteID"]);
        $("#RouteName").val(result["RouteName"]);
    }
    if (action == 1) {
        $("#ObjectID").val(result["AccountID"]);
        $("#ObjectName").val(result["AccountName"]);
        $("#AccountName").val(result["AccountName"]);
        $("#Tel").val(result["Tel"]);
        $("#Address").val(result["Address"]);
        $("#VATNo").val(result["VATNo"]);
        $("#VATObjectID").val(result["VATAccountID"]);
        $("#RouteID").removeAttr("disabled");
        $("#RouteID").val(result["RouteID"]);
        $("#RouteName").val(result["RouteName"]);
        $("#Notes").val(result["Description"]);

        if (result["IsInvoice"] == 1) {
            $("#IsInvoice").attr("checked", "checked");
        }
        else {
            $("#IsInvoice").attr("checked", false);
        }

        $("#DeliveryAddress").val(result["DeliveryAddress"]);
        getVATAccountID(result["VATAccountID"]);
    }
    if (action == 3) {
        $("#VATObjectID").val(result["AccountID"]);
        $("#VATObjectName").val(result["AccountName"]);
        $("#VATAccountName").val(result["AccountName"]);
    }
    if (action == 5) {
        $("#EmployeeID").removeAttr("disabled");
        $("#EmployeeID").val(result["EmployeeID"]);
        $("#EmployeeName").val(result["EmployeeName"]);
    }
    if (action == 6) {
        $("#SalesManID").removeAttr("disabled");
        $("#SalesManID").val(result["EmployeeID"]);
        $("#SalesManName").val(result["EmployeeName"]);
    }
    if (action == 4) {
        var selectedItem = GridOT2002.dataItem(GridOT2002.select());
        selectedItem.set("DivisionID", result["DivisionID"])
        selectedItem.set("InventoryID", result["InventoryID"])
        selectedItem.set("InventoryName", result["InventoryName"])
        selectedItem.set("UnitID", result["UnitID"])
        selectedItem.set("SalePrice", 0)
        selectedItem.set("OrderQuantity", 0)
        selectedItem.set("OriginalAmount", 0)
        selectedItem.set("Notes", "")
        selectedItem.set("Notes01", "")
        selectedItem.set("Notes02", "")
    }
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        var cboVoucherTypeID = $('#VoucherTypeID').data("kendoComboBox");
        cboVoucherTypeID.select(0);

        var cboOrderStatus = $('#OrderStatus').data("kendoComboBox");
        cboOrderStatus.select(0);

        var cboCurrencyID = $('#CurrencyID').data("kendoComboBox");
        cboCurrencyID.select(0);

        $("#IsConfirm").val(0);
        $("#OrderType").val(0);
        $("#OrderDate").data("kendoDatePicker").value(new Date());
        $("#ShipDate").val($("#OrderDate").val());
        $("#DueDate").val($("#OrderDate").val());
        $("#DiscountSalesAmount").val('0');
        $("#ShipAmount").val('0');
        $("#ExchangeRate").val('0');
        $("#InventoryTypeID").val('%');
        $('#APKofPriceList').val(CacheAPKofPriceList);
        GetvoucherNo();

        var data = [];
        ASOFT.helper.postTypeJson("/SO/SOF2010/GetDataMaster", data, function (result) {
            $("#DivisionID").val(result.DivisionID);
            $("#ObjectID").val(result.ObjectID);
            
            $("#ObjectName").val(result.ObjectName);
            $("#Contact").val(result.Contact);
            $("#DeliveryAddress").val(result.DeliveryAddress);
        });
        GridOT2002.dataSource.data([]);
        GridOT2002.dataSource.add({ InventoryID: null });

        
    }
    if (result.Status == 0 && action1 == 2) {
        $('#APKofPriceList').val(CacheAPKofPriceList);
        GetvoucherNo();
    }
    if (result.Status == 0 && action1 == 3) {
        var data = {
            APKofPriceList: $('#APKofPriceList').val(),
            IsClearCache: true
        };
        ASOFT.helper.postTypeJson("/SO/SOF2010/SetOP1302", data);
    }
}

function getVATAccountID(VATAccountID) {
    var data = [];
    data.push(VATAccountID);
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetVATAccountID", data, function (result) {
        $("#VATAccountName").val(result.VATAccountName);
        $("#VATObjectName").val(result.VATAccountName);
    });
}

//-- sửa cho Customer Angel --- Quang Chiến


//Ctrl K trên lưới
function getDataPromote(data, dataindex) {
    var dataSource = GridOT2002.dataSource;
    var dataValue = dataSource._data;
    if(dataindex){
        for (var j = dataindex; j < dataValue.length; j++) {
            if (dataValue[j] && dataValue[j].IsProInventoryID == 1) {
                dataSource.remove(dataSource.at(j));
            }

            if ((dataValue[parseInt(j) + 1] != undefined || (dataValue[parseInt(j) + 1] != undefined && dataValue[parseInt(j) + 1].IsProInventoryID != undefined && dataValue[parseInt(j) + 1].IsProInventoryID == 0)))
                break;
        }
        
        if (isCheckQuatity) {
            ASOFT.helper.postTypeJson("/SO/SOF2010/GetDataPromote", data, function (result) {
                if (result.data) {
                    for (var i = 0; i < result.data.length; i++) {
                        if (result.data[i].OrderQuantity > 0) {
                            dataSource.insert(dataindex, result.data[i]);
                        }
                    }
                }
            });
        }       
    }
}

//su kien change orderDate load lai don gia, khuyen mai
function getDataPromoteOfOrderDate() {

    var dataSource = GridOT2002.dataSource;
    var dataValue = dataSource._data;
    if (dataValue && dataValue.length > 0 && dataValue[0].InventoryID) {
        var array = [];
        var length = dataValue.length;

        for (var i = 0; i < dataValue.length; i++) {
            if (dataValue[i].IsProInventoryID == 0) {
                array.push(dataValue[i].InventoryID);
            } else {
                dataSource.remove(dataSource.at(i));
            }
        }

      

        var data1 = {
            InventoryID: array,
            APKofPriceList: $('#APKofPriceList').val(),
            IsUpdateMaster: true
        }

        ASOFT.helper.postTypeJson("/SO/SOF2010/GetDataSalePrice", data1, function (result) {
            if (result.lst.length > 0) {
                for (var j = 0; j < dataValue.length; j++) {
                    for (var i = 0; i < result.lst.length; i++) {
                        if (result.lst[i].InventoryID == dataValue[j].InventoryID) {
                            dataValue[j].SalePrice = result.lst[i].SalePrice;
                            dataValue[j].DiscountPercent = result.lst[i].DiscountPercent;

                            var data = [];
                            data.push(dataValue[i].DivisionID,
                                $('#ObjectID').val(),
                                $('#InventoryTypeID').val(),
                                dataValue[j].InventoryID,
                                $('#OrderDate').val(),
                                dataValue[j].OrderQuantity);

                            ASOFT.helper.postTypeJson("/SO/SOF2010/GetPromotePercent", data, function (result) {
                                if (dataValue[j].DiscountPercent < result.PromotePercent) {
                                    dataValue[j].DiscountPercent = result.PromotePercent;
                                }
                            })

                            dataValue[j].OriginalAmount = changeformatDecimal(dataValue[j].SalePrice * dataValue[j].OrderQuantity);
                            var DiscountAmount = dataValue[j].OriginalAmount * dataValue[j].DiscountPercent / 100;

                            dataValue[j].TotalBeforeAmount =changeformatDecimal( dataValue[j].OriginalAmount - DiscountAmount - dataValue[j].DiscountSaleAmountDetail);
                            dataValue[j].VATOriginalAmount = changeformatDecimal(dataValue[j].TotalBeforeAmount * (parseInt(dataValue[j].VATPercent) / 100));
                            dataValue[j].TotalAfterAmount = changeformatDecimal(dataValue[j].TotalBeforeAmount + dataValue[j].VATOriginalAmount);
                            dataValue[j].ConvertedAmount = dataValue[j].OriginalAmount * $("#ExchangeRate").val();
                            break;
                        }
                    }
                }
            }
        });

        length = dataValue.length;

        for (var i = length - 1 ; i >= 0; i--) {
            var data = [];
            data.push(dataValue[i].DivisionID,
                $('#ObjectID').val(),
                $('#InventoryTypeID').val(),
                dataValue[i].InventoryID,
                $('#OrderDate').val(),
                dataValue[i].OrderQuantity);

            ASOFT.helper.postTypeJson("/SO/SOF2010/GetDataPromote", data, function (result) {
                if (result.data) {
                    for (var j = 0; j < result.data.length; j++) {
                        if (result.data[j].OrderQuantity > 0) {
                            dataSource.insert(length, result.data[j]);
                        }
                    }
                }
            });
            length = length - 1;
        }

        var message=[];
        var dataIsCheck = [];
        for (var i = 0; i < dataValue.length; i++) {
                var index=null;
                if (dataIsCheck.some(function (item) {
                    return item.InventoryID === dataValue[i].InventoryID
                })) {
                    var index = dataIsCheck.map((o) => o.InventoryID).indexOf(dataValue[i].InventoryID);
                    dataIsCheck[index].Quality = parseInt(dataIsCheck[index].Quality) + parseInt(dataValue[i].OrderQuantity);
                } else {
                    var datalistCheck = {
                        OrderDate: $('#OrderDate').val(),
                        InventoryID: dataValue[i].InventoryID,
                        Quality: dataValue[i].OrderQuantity
                    }
                    dataIsCheck.push(datalistCheck);
                }
        }

        for (var j = 0 ; j<dataIsCheck.length ; j++){      
            ASOFT.helper.postTypeJson("/SO/SOF2010/GetCheckQuality", dataIsCheck[j], function (result) {
                if (result.status == 1) {                
                    message.push(ASOFT.helper.getMessage(result.message).f(result.inventoryID, result.beginQuatity))
                }
            })
        }
        if(message.length>0){
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message, null);
        }

        var TotalOrderQuantity = 0;
        var TotalOriginalAmount = 0;
        var TotalDiscountOriginalAmount = 0;
        var TotalBeforeAmount = 0;
        var TotalVATPercent = 0;
        var TotalVATOriginalAmount = 0;
        var TotalAmount = 0;

        if (dataValue.length > 0) {
            for (var i = 0; i < dataValue.length; i++) {
                //TotalOrderQuantity
                TotalOrderQuantity = (dataValue[i].OrderQuantity && dataValue[i].OrderQuantity > 0) ? TotalOrderQuantity + parseFloat(dataValue[i].OrderQuantity) : TotalOrderQuantity + 0;
                //TotalOriginalAmount
                TotalOriginalAmount = (dataValue[i].OriginalAmount && dataValue[i].OriginalAmount > 0) ? TotalOriginalAmount + parseFloat(dataValue[i].OriginalAmount) : TotalOriginalAmount + 0;
                //TotalDiscountOriginalAmount
                TotalDiscountOriginalAmount = (dataValue[i].DiscountOriginalAmount && dataValue[i].DiscountOriginalAmount > 0) ? TotalDiscountOriginalAmount + parseFloat(dataValue[i].DiscountOriginalAmount) : TotalDiscountOriginalAmount + 0;
                //TotalBeforeAmount
                TotalBeforeAmount = (dataValue[i].TotalBeforeAmount && dataValue[i].TotalBeforeAmount > 0) ? TotalBeforeAmount + parseFloat(dataValue[i].TotalBeforeAmount) : TotalBeforeAmount + 0;
                //TotalAfterAmount
                TotalAmount = (dataValue[i].TotalAfterAmount && dataValue[i].TotalAfterAmount > 0) ? TotalAmount + dataValue[i].TotalAfterAmount : TotalAmount + 0;
                //TotalVATOriginalAmount
                TotalVATOriginalAmount = (dataSource[i].VATOriginalAmount && dataSource[i].VATOriginalAmount > 0) ? TotalVATOriginalAmount + parseFloat(dataSource[i].VATOriginalAmount) : TotalVATOriginalAmount + 0;
            }
        }
        //TotalOrderQuantity
        $('div#totalFooterOrderQuantity').text(formatDecimal(kendo.parseFloat(TotalOrderQuantity), 2));
        //TotalOriginalAmount
        $('div#totalFooterOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalOriginalAmount), 1));
        //TotalDiscountOriginalAmount
        $('div#totalFooterDiscountOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalDiscountOriginalAmount), 1));
        //TotalBeforeAmount
        $('div#totalFooterTotalBeforeAmount').text(formatDecimal(kendo.parseFloat(TotalBeforeAmount), 1));
        //TotalAfterAmount
        $('div#totalFooterTotalAfterAmount').text(formatDecimal(kendo.parseFloat(TotalAmount), 1));
        //TotalVATOriginalAmount
        $('div#totalFooterVATOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalVATOriginalAmount), 1));

        $('#TotalAmount').val(formatDecimal(kendo.parseFloat(TotalAmount),1));
        $('#PayAmount').val(formatDecimal(kendo.parseFloat(parseFloat(TotalAmount) - ($('#ShipAmount').val() ? kendo.parseFloat($('#ShipAmount').val()) : kendo.parseFloat(0))),1));
    }
}

function getDataMaster() {
    var dataSource = GridOT2002.dataSource._data;

    var TotalOrderQuantity = 0;
    var TotalOriginalAmount = 0;
    var TotalDiscountOriginalAmount = 0;
    var TotalBeforeAmount = 0;
    var TotalVATPercent = 0;
    var TotalAmount = 0;
    var TotalVATOriginalAmount = 0;

    if (dataSource.length > 0) {
        for (var i = 0; i < dataSource.length; i++) {
            //TotalOrderQuantity
            TotalOrderQuantity = (dataSource[i].OrderQuantity && dataSource[i].OrderQuantity > 0) ? TotalOrderQuantity + parseFloat(dataSource[i].OrderQuantity) : TotalOrderQuantity + 0;
            //TotalOriginalAmount
            TotalOriginalAmount = (dataSource[i].OriginalAmount && dataSource[i].OriginalAmount > 0) ? TotalOriginalAmount + parseFloat(dataSource[i].OriginalAmount) : TotalOriginalAmount + 0;
            //TotalDiscountOriginalAmount
            TotalDiscountOriginalAmount = (dataSource[i].DiscountOriginalAmount && dataSource[i].DiscountOriginalAmount > 0) ? TotalDiscountOriginalAmount + parseFloat(dataSource[i].DiscountOriginalAmount) : TotalDiscountOriginalAmount + 0;
            //TotalBeforeAmount
            TotalBeforeAmount = (dataSource[i].TotalBeforeAmount && dataSource[i].TotalBeforeAmount > 0) ? TotalBeforeAmount + parseFloat(dataSource[i].TotalBeforeAmount) : TotalBeforeAmount + 0;
            //TotalAfterAmount
            TotalAmount = (dataSource[i].TotalAfterAmount && dataSource[i].TotalAfterAmount > 0) ? TotalAmount + dataSource[i].TotalAfterAmount : TotalAmount + 0;
            //TotalVATOriginalAmount
            TotalVATOriginalAmount = (dataSource[i].VATOriginalAmount && dataSource[i].VATOriginalAmount > 0) ? TotalVATOriginalAmount + parseFloat(dataSource[i].VATOriginalAmount) : TotalVATOriginalAmount + 0;
        }
    }
    //TotalOrderQuantity
    $('div#totalFooterOrderQuantity').text(formatDecimal(kendo.parseFloat(TotalOrderQuantity), 2));
    //TotalOriginalAmount
    $('div#totalFooterOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalOriginalAmount), 1));
    //TotalDiscountOriginalAmount
    $('div#totalFooterDiscountOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalDiscountOriginalAmount), 1));
    //TotalBeforeAmount
    $('div#totalFooterTotalBeforeAmount').text(formatDecimal(kendo.parseFloat(TotalBeforeAmount), 1));
    //TotalAfterAmount
    $('div#totalFooterTotalAfterAmount').text(formatDecimal(kendo.parseFloat(TotalAmount), 1));
    //TotalVATOriginalAmount
    $('div#totalFooterVATOriginalAmount').text(formatDecimal(kendo.parseFloat(TotalVATOriginalAmount), 1));

    $('#TotalAmount').val(formatDecimal(kendo.parseFloat(TotalAmount),1));
    $('#PayAmount').val(formatDecimal(kendo.parseFloat(parseFloat(TotalAmount) - ($('#ShipAmount').val() ? kendo.parseFloat($('#ShipAmount').val()) : kendo.parseFloat(0))),1));
    
}

function ChooseInventoryID_Click() {
    url = '/PopupSelectData/Index/SO/SOF2014';
    ASOFT.asoftPopup.showIframe(url, {});
}

function receiveResult(result) {
    var grid = $('#GridEditOT2002').data('kendoGrid');
    var index = $(grid.select().children()[0]).text();
    var selectedItem = grid.dataItem(grid.select());
    selectedItem.DivisionID= result["DivisionID"];
    selectedItem.InventoryID= result["InventoryID"];
    selectedItem.InventoryName= result["InventoryName"];
    selectedItem.UnitID = result["UnitID"];
    selectedItem.OrderQuantity = result["OrderQuantity"];
    selectedItem.SalePrice= result["SalePrice"];
    selectedItem.IsProInventoryID= parseInt(result["IsProInventoryID"]);
    selectedItem.OriginalAmount= result["OriginalAmount"];
    selectedItem.VATOriginalAmount= result["VATOriginalAmount"];
    selectedItem.StandardPrice= result["SalePrice"];
    selectedItem.VATPercent= result["VATPercent"];
    selectedItem.VATGroupID = result["VATGroupID"];

    var data = [];
    data.push(selectedItem.DivisionID,
        $('#ObjectID').val(),
        $('#InventoryTypeID').val(),
        selectedItem.InventoryID,
        $('#OrderDate').val(),
        selectedItem.OrderQuantity);

    var data1 = {
        InventoryID: selectedItem.InventoryID,
        APKofPriceList: $('#APKofPriceList').val(),
        IsUpdateMaster : false
    }
    ASOFT.helper.postTypeJson("/SO/SOF2010/GetDataSalePrice", data1, function (result) {
        selectedItem.SalePrice = result.lst[0].SalePrice;
        selectedItem.DiscountPercent = result.lst[0].DiscountPercent;
    })

    ASOFT.helper.postTypeJson("/SO/SOF2010/GetPromotePercent", data, function (result) {
        selectedItem.DiscountPercent = selectedItem.DiscountPercent > result.PromotePercent ? selectedItem.DiscountPercent : result.PromotePercent;
        //selectedItem.DiscountPercent = result.PromotePercent;
    })
    selectedItem.OriginalAmount = changeformatDecimal(selectedItem.SalePrice * selectedItem.OrderQuantity);
    selectedItem.DiscountOriginalAmount = changeformatDecimal(selectedItem.OriginalAmount * (selectedItem.DiscountPercent / 100));
    
    var DiscountAmount = selectedItem.OriginalAmount * selectedItem.DiscountPercent / 100;

    selectedItem.DiscountSaleAmountDetail = selectedItem.DiscountSaleAmountDetail ? changeformatDecimal(selectedItem.DiscountSaleAmountDetail) : 0;

    selectedItem.TotalBeforeAmount = changeformatDecimal(selectedItem.OriginalAmount - DiscountAmount - selectedItem.DiscountSaleAmountDetail);
    selectedItem.VATOriginalAmount = changeformatDecimal(selectedItem.TotalBeforeAmount * (selectedItem.VATPercent / 100));
    selectedItem.TotalAfterAmount=changeformatDecimal(selectedItem.TotalBeforeAmount + selectedItem.VATOriginalAmount);

    selectedItem.VATConvertedAmount = selectedItem.VATOriginalAmount * $("#ExchangeRate").val();
    selectedItem.DiscountConvertedAmount = selectedItem.DiscountOriginalAmount * $("#ExchangeRate").val();
    
    //load grid khuyến mãi
    getDataPromote(data, index);
    getDataMaster();
    grid.refresh();
}

function formatDecimal(value, num) {
    var format = null;
    switch (num) {
        case 1:
            format = ASOFTEnvironment.NumberFormat.KendoOriginalDecimalsFormatString;
            break;
        case 2:
            format = ASOFTEnvironment.NumberFormat.KendoQuantityDecimalsFormatString;
            break;
    }
    return kendo.toString(value, format);

}

function changeformatDecimal(value) {
    return parseFloat(parseFloat(value).toFixed(ASOFTEnvironment.NumberFormat.OriginalDecimals));
}

function CustomerCheck() {
    ASOFT.form.clearMessageBox();
    var check = false;
    var message = [];

    var grid = $('#GridEditOT2002').data('kendoGrid');

    var rowList = grid.tbody.children();
    $(rowList).removeAttr('style');
    var dataLst = grid.dataSource.data();
    var columnIndexOrderQuantity = grid.wrapper.find(".k-grid-header [data-field=" + "OrderQuantity" + "]").index();
    var columnIndexIsProInventoryID = grid.wrapper.find(".k-grid-header [data-field=" + "IsProInventoryID" + "]").index();

    var dataIsCheck = [];
    for (var i = 0; i < dataLst.length; i++) {
            var index=null;
            if (dataIsCheck.some(function (item) {
                return item.InventoryID === dataLst[i].InventoryID
            })) {
                var index = dataIsCheck.map((o) => o.InventoryID).indexOf(dataLst[i].InventoryID);
                dataIsCheck[index].Quality = parseInt(dataIsCheck[index].Quality) + parseInt(dataLst[i].OrderQuantity);
            } else {
                var datalistCheck = {
                    OrderDate: $('#OrderDate').val(),
                    InventoryID: dataLst[i].InventoryID,
                    Quality: dataLst[i].OrderQuantity
                }
                dataIsCheck.push(datalistCheck);
            }
    }

    for (var j = 0 ; j<dataIsCheck.length ; j++){      
        ASOFT.helper.postTypeJson("/SO/SOF2010/GetCheckQuality", dataIsCheck[j], function (result) {
            if (result.status == 1) {                
                message.push(ASOFT.helper.getMessage(result.message).f(result.inventoryID, result.beginQuatity))
                check=true;
            }
        })
    }

    if (check) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message, null);
    }

    return check;
}