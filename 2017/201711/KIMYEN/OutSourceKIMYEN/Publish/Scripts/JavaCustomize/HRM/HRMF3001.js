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
    var lang = ASOFT.helper.getLanguageString("HRMF3001.GroupReport", "HRMF3001", "HRM");
    $("#FormReportFilter .form-content table").after(kendo.format(GroupReport, lang));
    lang = ASOFT.helper.getLanguageString("HRMF3001.GroupFilter", "HRMF3001", "HRM");
    $("#OOR").after(kendo.format(GroupFilter, lang));

    $("#OOR").append(kendo.format(table, 'tblReport'));
    $("#tblReport tbody").append($(".ReportID"));
    $("#tblReport tbody").append($(".ReportName"));
    $("#tblReport tbody").append($(".ReportTitle"));

    $("#OORFilter").append(kendo.format(table, 'tblFilter'));    
    $("#tblFilter tbody").append($(".DepartmentID_Traning"));
    $("#tblFilter tbody").append($(".DutyID"));

    $("#OORFilter").prepend(kendo.format(DivTag2block, 'divRecruitPeriod'));
    $("#OORFilter").prepend(kendo.format(DivTag2block, 'divTime'));
    $("#divTime .block-left .asf-filter-label").append($(".FromDate").children()[0]);
    $("#divTime .block-left .asf-filter-input").append($(".FromDate").children()[0]);
    $("#divTime .block-right .asf-filter-label").append($(".ToDate").children()[0]);
    $("#divTime .block-right .asf-filter-input").append($(".ToDate").children()[0]);

    $("#divRecruitPeriod .block-left .asf-filter-label").append($(".FromRecruitPeriodName").children()[0]);
    $("#divRecruitPeriod .block-left .asf-filter-input").append($($(".FromRecruitPeriodName").children()[0]).children());
    $("#divRecruitPeriod .block-left .asf-filter-input").css('position', 'relative');
    $("#divRecruitPeriod .block-right .asf-filter-label").append($(".ToRecruitPeriodName").children()[0]);
    $("#divRecruitPeriod .block-right .asf-filter-input").append($($(".ToRecruitPeriodName").children()[0]).children());
    $("#divRecruitPeriod .block-right .asf-filter-input").css('position', 'relative');

    $("#ReportTitle").val($("#ReportName").val().toUpperCase());

    var dropdownList = $("#DivisionID").data('kendoDropDownList');
    if (dropdownList) {
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }

    dropdownList = $("#DepartmentID_Traning").data('kendoDropDownList');
    if (dropdownList) {
        dropdownList.trigger("open");
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }

    dropdownList = $("#DutyID").data('kendoDropDownList');
    if (dropdownList) {
        dropdownList.trigger("open");
        $($(dropdownList.list.find('li')[0])).trigger("click");
    }
    
    $("#btnFromRecruitPeriodName").click(function () {        
        var urlChoose = "/PopupSelectData/Index/HRM/HRMF2034?ScreenID=HRMF3001";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlChoose, {});
        currentChoose = "from";
    });
    $("#btnToRecruitPeriodName").click(function () {
        var urlChoose = "/PopupSelectData/Index/HRM/HRMF2034?ScreenID=HRMF3001";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlChoose, {});
        currentChoose = "to";
    });
    $("#btnDeleteFromRecruitPeriodName").click(function () {
        $("#FromRecruitPeriod").val('');
        $("#FromRecruitPeriodName").val('');
    });
    $("#btnDeleteToRecruitPeriodName").click(function () {
        $("#ToRecruitPeriod").val('');
        $("#ToRecruitPeriodName").val('');
    });

    //hidden class
    $(".FromRecruitPeriod").css('display', 'none');
    $(".ToRecruitPeriod").css('display', 'none');
    $(".FromRecruitPeriodName").css('display', 'none');
    $(".ToRecruitPeriodName").css('display', 'none');
});
var currentChoose = "";
function receiveResult(result) {
    switch (currentChoose) {
        case "from":
            $("#FromRecruitPeriod").val(result.RecruitPeriodID);
            $("#FromRecruitPeriodName").val(result.RecruitPeriodName);
            break;
        case "to":
            $("#ToRecruitPeriod").val(result.RecruitPeriodID);
            $("#ToRecruitPeriodName").val(result.RecruitPeriodName);
            break;

    }
}