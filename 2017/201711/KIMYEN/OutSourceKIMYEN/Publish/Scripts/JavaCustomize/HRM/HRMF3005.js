var GroupReport = "<fieldset id='OOR' style = 'margin-top:20px; margin-bottom:10px;'><legend><label>{0}</label></legend></fieldset>";
var GroupFilter = "<fieldset id='OORFilter' style = 'margin-top:10px; margin-bottom:10px;'><legend><label>{0}</label></legend></fieldset>";
var table = '<table class ="asf-table-view" id = "{0}"><tbody></tbody></table>'
var DivTag2block = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
    "</div>";
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    var lang = ASOFT.helper.getLanguageString("HRMF3005.GroupReport", "HRMF3005", "HRM");
    $("#FormReportFilter .form-content table").after(kendo.format(GroupReport, lang));
    lang = ASOFT.helper.getLanguageString("HRMF3005.GroupFilter", "HRMF3005", "HRM");
    $("#OOR").after(kendo.format(GroupFilter, lang));

    $("#OOR").append(kendo.format(table, 'tblReport'));
    $("#tblReport tbody").append($(".ReportID"));
    $("#tblReport tbody").append($(".ReportName"));
    $("#tblReport tbody").append($(".ReportTitle"));

    $("#OORFilter").append(kendo.format(table, 'tblFilter'));
    $("#tblFilter tbody").append($(".TrainingFieldID"));
    $("#tblFilter tbody").append($(".TrainingType"));
    $("#tblFilter tbody").append($(".TrainingPlanID"));
    $("#tblFilter tbody").append($(".lstTransactionID"));

    $("#OORFilter").prepend(kendo.format(DivTag2block, 'divTime'));
    $("#divTime .block-left .asf-filter-label").append($(".FromDate").children()[0]);
    $("#divTime .block-left .asf-filter-input").append($(".FromDate").children()[0]);
    $("#divTime .block-right .asf-filter-label").append($(".ToDate").children()[0]);
    $("#divTime .block-right .asf-filter-input").append($(".ToDate").children()[0]);
    $(".lstTransactionID").css('display', 'none');
    $("#ReportTitle").val($("#ReportName").val().toUpperCase());

    var dropdownList = $("#DivisionID").data('kendoDropDownList');
    if (dropdownList) {
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }

    dropdownList = $("#TrainingFieldID").data('kendoDropDownList');
    if (dropdownList) {
        dropdownList.trigger("open");
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }

    dropdownList = $("#TrainingType").data('kendoDropDownList');
    if (dropdownList) {
        dropdownList.trigger("open");
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }

    dropdownList = $("#TrainingPlanID").data('kendoDropDownList');
    if (dropdownList) {
        dropdownList.trigger("open");
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }
});