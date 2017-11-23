var msgDebts = null;
$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
    $(".DiscountSalesAmount").text(formatDecimal(kendo.parseFloat($(".DiscountSalesAmount").text() ? $(".DiscountSalesAmount").text() : 0)));
    $(".ShipAmount").text(formatDecimal(kendo.parseFloat($(".ShipAmount").text() ? $(".ShipAmount").text() : 0)));
    GridOT2002 = $("#GridOT2002").data("kendoGrid");
    GridOT2002.bind("dataBound", function (e) {
        var dataSource = e.sender._data;
        var TotalOrderQuantity = 0;
        var TotalOriginalAmount = 0;
        var TotalDiscountOriginalAmount = 0;
        var TotalBeforeAmount = 0;
        var TotalVATPercent = 0;
        var TotalAmount = 0;
        var TotalVATOriginalAmount = 0;

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

        $('.TotalAmount').text(formatDecimal(kendo.parseFloat(TotalAmount),1));
        $('.PayAmount').text(formatDecimal(kendo.parseFloat(parseFloat(TotalAmount) - ($('.ShipAmount').text() ? kendo.parseFloat($('.ShipAmount').text()) : kendo.parseFloat(0))),1));

    });
})


function CustomerConfirm() {
    var data = [];
    var dt = getDetail("OT2002").Detail;
    var OriginalAmount = 0;
    for (i = 0; i < dt.length; i++) {
        OriginalAmount = parseFloat(OriginalAmount) + parseFloat(dt[i]["OriginalAmount"]);
    }
    data.push($("#DivisionID").val(), $("#ObjectID").val(), $("#OrderDate").val(), OriginalAmount);
    ASOFT.helper.postTypeJson("/SO/SOF2010/CheckDebts", data, CheckDebtsSOF2000);
    return msgDebts;
}

function CheckDebtsSOF2000(result) {
    msgDebts = result;
}

function DeleteViewMasterDetail(pk) {
    var divisionID = $(".DivisionID").text();
    return pk + "," + divisionID;
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