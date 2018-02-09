$(document).ready(function () {
    var DivTag = "<div class='asf-filter-main' id='{0}'></div>";
    var DivTagblock = "<div class='block-{0}'> <div class='asf-filter-label'></div><div class='asf-filter-input'></div></div>";
    var DivTagblock1 = "<div class='block-{0}'> <div class='asf-filter-input'></div></div>";
    var OrtherInfo = "<fieldset id='OOR'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='OORfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#OOR").prepend(tableOO);
    $("#OORfilter").prepend(tableOO1);
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
    
    $("#TableOO1").append($("#PeriodFilter1"));
    $("#TableOO1").append($("#PeriodFilter2"));

    $("#TableOO1").append(kendo.format(DivTag, 'WareHouse001ID'));
    $("#TableOO1").append(kendo.format(DivTag, 'I02ID'));
    $("#TableOO1").append(kendo.format(DivTag, 'InventoryID'));
    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    $('#WareHouse001ID').append(kendo.format(DivTagblock, "left"));
    $('#WareHouse001ID .block-left').css('width', '100%');
    $('#WareHouse001ID .block-left .asf-filter-label').css('width', '18%');    
    $('#WareHouse001ID .block-left .asf-filter-input').css('width', '80%');
    $('#WareHouse001ID .block-left .asf-filter-label').append($(".WareHouseID").children()[0]);
    $('#WareHouse001ID .block-left .asf-filter-input').append($(".WareHouseID").children()[0]);
    $('#WareHouse001ID .block-left .asf-filter-input .asf-td-field').css('width', '30%');

    $('#I02ID').append(kendo.format(DivTagblock, "left"));
    $('#I02ID .block-left .asf-filter-label').append($(".FromI02ID").children()[0]);
    $('#I02ID .block-left .asf-filter-input').append($(".FromI02ID").children()[0]);

    $('#I02ID').append(kendo.format(DivTagblock, "right"));
    $('#I02ID .block-right .asf-filter-label').append($(".ToI02ID").children()[0]);
    $('#I02ID .block-right .asf-filter-input').append($(".ToI02ID").children()[0]);

    $('#InventoryID').append(kendo.format(DivTagblock, "left"));
    $('#InventoryID .block-left .asf-filter-label').append($(".FromInventoryID_MF0203_WMF3004").children()[0]);
    $('#InventoryID .block-left .asf-filter-input').append($(".FromInventoryID_MF0203_WMF3004").children()[0]);
    $('#InventoryID').append(kendo.format(DivTagblock, "right"));
    $('#InventoryID .block-right .asf-filter-label').append($(".ToInventoryID_MF0203_WMF3004").children()[0]);
    $('#InventoryID .block-right .asf-filter-input').append($(".ToInventoryID_MF0203_WMF3004").children()[0]);

    var cboWareHouseID = $("#WareHouseID").data("kendoComboBox");
    if (cboWareHouseID) {
        cboWareHouseID.select(0);
    }

    var cboFromI02ID = $("#FromI02ID").data("kendoComboBox");
    if (cboFromI02ID) {
        cboFromI02ID.select(0);
    }
    var cboToI02ID = $("#ToI02ID").data("kendoComboBox");
    if (cboToI02ID) {
        cboToI02ID.select(cboToI02ID.dataSource._data.length - 1);
    }

})