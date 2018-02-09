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
    var lang = ASOFT.helper.getLanguageString("HRMF3006.GroupReport", "HRMF3006", "HRM");
    $("#FormReportFilter .form-content table").after(kendo.format(GroupReport, lang));
    lang = ASOFT.helper.getLanguageString("HRMF3006.GroupFilter", "HRMF3006", "HRM");
    $("#OOR").after(kendo.format(GroupFilter, lang));

    $("#OOR").append(kendo.format(table, 'tblReport'));
    $("#tblReport tbody").append($(".ReportID"));
    $("#tblReport tbody").append($(".ReportName"));
    $("#tblReport tbody").append($(".ReportTitle"));

    $("#OORFilter").append(kendo.format(table, 'tblFilter'));
    $("#tblFilter tbody").append($(".TranYear_Training"));
    $("#tblFilter tbody").append($(".TrainingFieldID"));
    $("#tblFilter tbody").append($(".TrainingType"));
    $("#tblFilter tbody").append($(".DepartmentID_Traning"));    
    $("#ReportTitle").val($("#ReportName").val().toUpperCase());

    var dropdownList = $("#DivisionID").data('kendoDropDownList');
    if (dropdownList) {
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }

    dropdownList = $("#TranYear_Training").data('kendoComboBox');
    if (dropdownList) {
        dropdownList.trigger("open");
        dropdownList.select(0);
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

    dropdownList = $("#DepartmentID_Traning").data('kendoDropDownList');
    if (dropdownList) {
        dropdownList.trigger("open");
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }
});