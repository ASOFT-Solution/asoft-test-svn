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
    var lang = ASOFT.helper.getLanguageString("HRMF3003.GroupReport", "HRMF3003", "HRM");
    $("#FormReportFilter .form-content table").after(kendo.format(GroupReport, lang));
    lang = ASOFT.helper.getLanguageString("HRMF3003.GroupFilter", "HRMF3003", "HRM");
    $("#OOR").after(kendo.format(GroupFilter, lang));

    $("#OOR").append(kendo.format(table, 'tblReport'));
    $("#tblReport tbody").append($(".ReportID"));
    $("#tblReport tbody").append($(".ReportName"));
    $("#tblReport tbody").append($(".ReportTitle"));

    $("#OORFilter").append(kendo.format(table, 'tblFilter'));
    $("#tblFilter tbody").append($(".TrainingFieldID"));
    $("#tblFilter tbody").append($(".EmployeeID"));
    $("#tblFilter tbody").append($(".EmployeeName"));

    $("#OORFilter").prepend(kendo.format(DivTag2block, 'divTime'));
    $("#divTime .block-left .asf-filter-label").append($(".FromDate").children()[0]);
    $("#divTime .block-left .asf-filter-input").append($(".FromDate").children()[0]);
    $("#divTime .block-right .asf-filter-label").append($(".ToDate").children()[0]);
    $("#divTime .block-right .asf-filter-input").append($(".ToDate").children()[0]);

    $("#btnDeleteEmployeeName").css('right', '30px');
    $("#btnEmployeeName").css('right', '60px');
    $(".EmployeeID").css('display', 'none');
    $("#btnDeleteEmployeeName").bind('click', function () {
        $("#EmployeeID").val('');
        $("#EmployeeName").val('');
    });

    $("#ReportTitle").val($("#ReportName").val().toUpperCase());

    $("#btnEmployeeName").bind('click', function () {
        currentChoose = "EmployeeID";
        var urlChoose = "/PopupSelectData/Index/HRM/OOF2004?ScreenID=HRMF2101";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlChoose, {});
    });

    var dropdownList = $("#DivisionID").data('kendoDropDownList');
    if (dropdownList) {
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }

    dropdownList = $("#TrainingFieldID").data('kendoDropDownList');
    if (dropdownList) {
        dropdownList.trigger("open");
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }
    
});

function receiveResult(result) {
    $("#EmployeeID").val(result.EmployeeID);
    $("#EmployeeName").val(result.EmployeeName);
}