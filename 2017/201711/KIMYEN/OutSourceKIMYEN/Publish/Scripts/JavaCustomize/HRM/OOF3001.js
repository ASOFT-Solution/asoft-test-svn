$(document).ready(function () {
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
    $("#TableOO1").append($(".Day"));
    $("#TableOO1").append($(".Mode"));
    $("#TableOO1").append($(".DepartmentID"));
    $("#TableOO1").append($(".SectionID"));
    $("#TableOO1").append($(".SubsectionID"));
    $("#TableOO1").append($(".ProcessID"));
    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    $("#Mode").data("kendoComboBox").select(0);
    var cboDepartmentID = $("#DepartmentID").data("kendoComboBox");
    var cboSectionID = $("#SectionID").data("kendoComboBox");
    var cboSubsectionID = $("#SubsectionID").data("kendoComboBox");
    var cboProcessID = $("#ProcessID").data("kendoComboBox");
    cboSectionID.sender = cboSectionID;
    cboSubsectionID.sender = cboSubsectionID;
    cboProcessID.sender = cboProcessID;
    cboDepartmentID.select(0);
    OpenComboDynamic(cboSectionID);
    OpenComboDynamic(cboSubsectionID);
    OpenComboDynamic(cboProcessID);
})