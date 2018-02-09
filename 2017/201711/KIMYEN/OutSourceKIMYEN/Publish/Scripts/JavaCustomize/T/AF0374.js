$(document).ready(function () {
    var DivTag = "<div class='asf-filter-main' id='{0}'></div>";
    var DivTagblock = "<div class='block-{0}'> <div class='asf-filter-label'></div><div class='asf-filter-input'></div></div>";

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
    $("#TableOO1").append($("#FromToDate").parent().parent());

    $("#TableOO1").append(kendo.format(DivTag,'ObjectID'));
    $("#TableOO1").append(kendo.format(DivTag, 'Ana03ID'));
    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");


    $('#ObjectID').append(kendo.format(DivTagblock, "left"));
    $('#ObjectID .block-left .asf-filter-label').append($(".FromObjectID").children()[0]);
    $('#ObjectID .block-left .asf-filter-input').append($(".FromObjectID").children()[0]);

    $('#ObjectID').append(kendo.format(DivTagblock, "right"));
    $('#ObjectID .block-right .asf-filter-label').append($(".ToObjectID").children()[0]);
    $('#ObjectID .block-right .asf-filter-input').append($(".ToObjectID").children()[0]);

    $('#Ana03ID').append(kendo.format(DivTagblock, "left"));
    $('#Ana03ID .block-left .asf-filter-label').append($(".FromAna03ID").children()[0]);
    $('#Ana03ID .block-left .asf-filter-input').append($(".FromAna03ID").children()[0]);
    $('#Ana03ID').append(kendo.format(DivTagblock, "right"));
    $('#Ana03ID .block-right .asf-filter-label').append($(".ToAna03ID").children()[0]);
    $('#Ana03ID .block-right .asf-filter-input').append($(".ToAna03ID").children()[0]);

    var cboFromObjectID = $("#FromObjectID").data("kendoComboBox");
    if (cboFromObjectID) {
        cboFromObjectID.select(0);
    }
    var cboToObjectID = $("#ToObjectID").data("kendoComboBox");
    if (cboToObjectID) {
        cboToObjectID.select(cboToObjectID.dataSource._data.length - 1);
    }

    var cboFromAna03ID = $("#FromAna03ID").data("kendoComboBox");
    if (cboFromAna03ID) {
        cboFromAna03ID.select(0);
    }
    var cboToAna03ID = $("#ToAna03ID").data("kendoComboBox");
    if (cboToAna03ID) {
        cboToAna03ID.select(cboToAna03ID.dataSource._data.length - 1);
    }
   
})