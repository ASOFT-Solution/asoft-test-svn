var check = false;
var num = 0;
$(document).ready(function () {
    var id = $("#sysScreenID").val();

    var OrtherInfo = "<fieldset id='OOR'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='OORfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#OOR").prepend(tableOO);
    $("#OORfilter").append($("#FromToDate"));
    $("#OORfilter").append(tableOO1);
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
    $("#TableOO1").append($(".DepartmentID"));
    $("#TableOO1").append($(".SectionID"));
    $("#TableOO1").append($(".SubsectionID"));
    $("#TableOO1").append($(".ProcessID"));
    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

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

    function startChange() {
        var startDate = start.value(),
        endDate = end.value();
        check = false;
        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate());
            end.min(startDate);
            if (!endDate) {
                check = true;
                num = 2;
            }
        } else if (endDate) {
            check = true;
            num = 1;
            start.max(new Date(endDate));
        } else {
            check = true;
            num = 3;
            //endDate = new Date();
            //start.max(endDate);
            //end.min(endDate);
        }
    }

    function endChange() {
        var endDate = end.value(),
        startDate = start.value();
        check = false;
        if (endDate) {
            endDate = new Date(endDate);
            endDate.setDate(endDate.getDate());
            start.max(endDate);
            if (!startDate) {
                check = true;
                num = 1;
            }
        } else if (startDate) {
            check = true;
            num = 2;
            end.min(new Date(startDate));
        } else {
            check = true;
            num = 3;
            //endDate = new Date();
            //start.max(endDate);
            //end.min(endDate);
        }
    }
    var beginDate = changeDate($("#BeginDate").val());
    var endDate = changeDate($("#EndDate").val());

    var start = $("#FromDate").kendoDatePicker({
        format: "dd/MM/yyyy",
        value: new Date(beginDate),
        min: new Date(beginDate),
        max: new Date(endDate),
        change: startChange
    }).data("kendoDatePicker");

    var end = $("#ToDate").kendoDatePicker({
        format: "dd/MM/yyyy",
        value: new Date(endDate),
        min: new Date(beginDate),
        max: new Date(endDate),
        change: endChange
    }).data("kendoDatePicker");

    start.max(end.value());
    end.min(start.value());
})

function CustomerCheck() {
    var divMessage = $('#FormReportFilter').find('div.asf-message');
    if (divMessage)
        divMessage.remove();

    $('#FromDate').removeClass('asf-focus-input-error');
    $('#ToDate').removeClass('asf-focus-input-error');

    if (check) {
        if (num == 1) {
            $('#FromDate').addClass('asf-focus-input-error');
        }
        if (num == 2) {
            $('#ToDate').addClass('asf-focus-input-error');
        }
        if (num == 3) {
            $('#FromDate').addClass('asf-focus-input-error');
            $('#ToDate').addClass('asf-focus-input-error');
        }

        ASOFT.form.displayMessageBox('#FormReportFilter', [ASOFT.helper.getMessage('OOFML000030')], null);
    }

    return check;
}

function changeDate(data) {
    var date = data.split(" ");
    var dateformat = date[0].split("/");
    var dateformat = dateformat[2] + "/" + dateformat[1] + "/" + dateformat[0] + " " + date[1];
    return dateformat;
}