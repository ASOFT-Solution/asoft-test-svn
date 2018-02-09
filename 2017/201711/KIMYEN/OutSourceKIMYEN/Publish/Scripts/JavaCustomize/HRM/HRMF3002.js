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

    $("#divRecruitPeriod .block-left .asf-filter-label").append($(".FromRecruitPlanName").children()[0]);
    $("#divRecruitPeriod .block-left .asf-filter-input").append($($(".FromRecruitPlanName").children()[0]).children());
    $("#divRecruitPeriod .block-left .asf-filter-input").css('position', 'relative');
    $("#divRecruitPeriod .block-right .asf-filter-label").append($(".ToRecruitPlanName").children()[0]);
    $("#divRecruitPeriod .block-right .asf-filter-input").append($($(".ToRecruitPlanName").children()[0]).children());
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
    
    //hidden class
    $(".FromRecruitPlan").css('display', 'none');
    $(".ToRecruitPlan").css('display', 'none');
    $(".FromRecruitPlanName").css('display', 'none');
    $(".ToRecruitPlanName").css('display', 'none');

    $("#btnFromRecruitPlanName").click(function () {
        var urlChoose = "/PopupSelectData/Index/HRM/HRMF2036?ScreenID=HRMF3002";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlChoose, {});
        currentChoose = "from";
    });

    $("#btnToRecruitPlanName").click(function () {
        var urlChoose = "/PopupSelectData/Index/HRM/HRMF2036?ScreenID=HRMF3002";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlChoose, {});
        currentChoose = "to";
    });
    $("#btnDeleteFromRecruitPlanName").click(function () {
        $("#FromRecruitPlan").val('');
        $("#FromRecruitPlanName").val('');
    });
    $("#btnDeleteToRecruitPlanName").click(function () {
        $("#ToRecruitPlan").val('');
        $("#ToRecruitPlanName").val('');
    });
});

var currentChoose = "";
function receiveResult(result) {
    switch (currentChoose) {
        case "from":
            $("#FromRecruitPlan").val(result.RecruitPlanID);
            $("#FromRecruitPlanName").val(result.Description);
            break;
        case "to":
            $("#ToRecruitPlan").val(result.RecruitPlanID);
            $("#ToRecruitPlanName").val(result.Description);
            break;

    }
}