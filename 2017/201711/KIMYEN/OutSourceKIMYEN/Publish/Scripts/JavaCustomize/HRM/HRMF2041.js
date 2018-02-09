
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
var DivTag1block = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left' style = 'width: 100%'>" +
            "<div class='asf-filter-label' style = 'width: 20%'></div>" +
            "<div class='asf-filter-input' style = 'width: 80%'></div>" +
        "</div>" +
    "</div>";
var DivTagmain = "<div class='asf-filter-main' id='{0}'>" +
                    "</div>";
var GroupReport = "<fieldset id='OOR' style = 'margin-top:35px; margin-bottom:10px;'><legend><label>" + $("#GroupInfo").val() + "</label></legend></fieldset>";

var CurrentChoose = "";

var btnSendMail = '<ul class="empty" style ="float:left;"> ' +
            '<li>' +
                '<a class="k-button k-button-icontext asf-button" id="btnSendMail" style="" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text">{0}</span></a>' +
            '</li>' +
        '</ul>';

var templateAttachFile = function (textFileName, templateClass, textFileID) {
    this.getTemplate = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templateClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
};

var templateAsoftButton = function () {
    this.getAsoftButton = function (buttonClass, buttonID, spanClass, buttonCaption, onclickFunction) {
        return kendo.format("<a onclick='{4}' class='k-button k-button-icontext asf-button {0}' id='{1}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='asf-button-text {2}'>{3}</span></a>",
            buttonClass,
            buttonID,
            spanClass,
            buttonCaption,
            onclickFunction);
    };

    this.getDeleteAsoftButton = function (buttonID, onclickFunction) {
        return kendo.format("<a id='{0}' onclick='{1}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton'></span></a>",
            buttonID,
            onclickFunction);
    };

    return this;
};

setButtonDeleteDisableWhenObjectChange = function ($Object, $ButtonDelete, buttonEventClick) {

    if (typeof $Object !== "undefined" && typeof $ButtonDelete !== "undefined") {
        if (typeof $Object.val === "function" && typeof $Object.val() !== "undefined") {
            $Object.val() == ""
            ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
            : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
        }
        if (typeof $Object.value === "function" && $Object.value() !== "undefined") {
            $Object.value() == ""
            ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
            : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
        }
    }
    return false;
}

function getResultAfterDelete(result, apkDelete) {

    var $resultAfterDelete = $.map(result, (function (obj) {

        if (obj.APK != apkDelete)
            return obj;
    }));

    return $resultAfterDelete.length > 0 ? $resultAfterDelete : "";
}

function deleteFile(jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll"),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#Attach"),

        $result = $attach.val().split(','),

        $resultAfterDelete = getResultAfterDelete($result, $apkDelete);

    $attach.val(JSON.stringify($resultAfterDelete));

    $parentXClose.remove();

    typeof $templeteAll !== "undefined"
        ? ($templeteAll.find(".file-templete").length == 0
            ? ($templeteAll.remove(), $attach.val("").trigger("change"))
            : false)
        : false;
}

function btnUpload_click(e) {

    var urlPopup3 = "/AttachFile?Type=5";

    ASOFT.asoftPopup.showIframe(urlPopup3, {});

    CurrentChoose = "Attach";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

$(document).ready(function () {
    var templeteButton = new templateAsoftButton(),
     form = $("#sysScreenID"),
     parentSysScreenID = parent.$("#sysScreenID").val();

    LayoutPopup();
    addEventControl();
    $("#DutyName").attr('readonly', 'readonly');
    $("#DepartmentName").attr('readonly', 'readonly');
    $("#RecruitPeriodID").attr('readonly', 'readonly');

    $('#Attach').css('display', 'none');
    $("#Attach")
    .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
    .parent()
    .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
    $($(".Attach").children()[0]).css("width", "20%");

    if ($("#isUpdate").val() == 'True') {
        cboCandidateID_change(null);
        $("#CandidateID").attr('readonly', 'readonly');
        defaultValue = getDataInsert(ASOFT.helper.dataFormToJSON(id));
        $("#btnRecruitPeriodName").parent().addClass('asf-disabled-li');
        $('.Attach').css('display', 'none');
    } else {
        // An control Vong
        $("#Tabs").kendoTabStrip().hide();
    }

    setTimeout(function () {
        $("#BtnNext").remove();
    }, 200);

    $("#btnDeleteRecruitPeriodName").kendoButton({ "click": btnDeleteRecruitPeriodName_Click });

    $("#Startdate").change(function () {
        var Startdate = $("#Startdate").val(), date1 = Startdate.split("/");
        var TrialTime = $("#TrialTime").val();
        var month = Number(TrialTime) + Number(date1[1]);
        var todate = new Date(date1[2], month - 1, date1[0]);
        $("#TrialFromDate").data("kendoDatePicker").value(Startdate);
        $("#TrialToDate").data("kendoDatePicker").value(todate);
    });

    $("#TrialTime").change(function () {
        var Startdate = $("#Startdate").val(), date1 = Startdate.split("/");
        var TrialTime = $("#TrialTime").val();
        var month = Number(TrialTime) + Number(date1[1]);
        var todate = new Date(date1[2], month - 1, date1[0]);
        $("#TrialFromDate").data("kendoDatePicker").value(Startdate);
        $("#TrialToDate").data("kendoDatePicker").value(todate);
    });
});

function LayoutPopup() {
    $("#GridEditHRMT20401").css('display', 'none');
    $("#GridEditHRMT20402").css('display', 'none');
    $("#GridEditHRMT20403").css('display', 'none');
    $("#GridEditHRMT20404").css('display', 'none');
    $("#GridEditHRMT20405").css('display', 'none');

    // hidden table
    $("#HRMF2041 .grid_6").css('display', 'none');
    $("#HRMF2041 .grid_6_1").css('display', 'none');

    // RecruitPeriodID
    $("#HRMF2041").prepend(kendo.format(DivTag2block, "divRecruitPeriodID"));
    $('#divRecruitPeriodID .block-left .asf-filter-label').append($(".RecruitPeriodID").children()[0]);
    $('#divRecruitPeriodID .block-left .asf-filter-input').append($($(".RecruitPeriodID").children()[0]).children());
    $('#divRecruitPeriodID .block-right .asf-filter-input').append($($(".RecruitPeriodName").children()[1]).children());
    $('#divRecruitPeriodID .block-right .asf-filter-label').css('width', '0%');
    $('#divRecruitPeriodID .block-right .asf-filter-input').css('width', '100%');
    $('#divRecruitPeriodID .block-right .asf-filter-input').css('position', 'relative');

    // DepartmentID And DutyID
    $("#divRecruitPeriodID").after(kendo.format(DivTag2block, "divDepartmentAndDuty"));
    $('#divDepartmentAndDuty .block-left .asf-filter-label').append($(".DepartmentName").children()[0]);
    $('#divDepartmentAndDuty .block-left .asf-filter-input').append($($(".DepartmentName").children()[0]).children());
    $('#divDepartmentAndDuty .block-right .asf-filter-label').append($(".DutyName").children()[0]);
    $('#divDepartmentAndDuty .block-right .asf-filter-input').append($($(".DutyName").children()[0]).children());

    // CandidateID
    $("#divDepartmentAndDuty").after(kendo.format(DivTag2block, "divCandidateID"));
    $('#divCandidateID .block-left .asf-filter-label').append($(".CandidateID").children()[0]);
    $('#divCandidateID .block-left .asf-filter-input').append($($(".CandidateID").children()[0]).children());
    $('#divCandidateID .block-right .asf-filter-input').append($($(".CandidateName").children()[1]).children());
    $('#divCandidateID .block-right .asf-filter-label').css('width', '0%');
    $('#divCandidateID .block-right .asf-filter-input').css('width', '100%');

    // Thông tin tuyển dụng
    $("#divCandidateID").after(GroupReport);
    $("#OOR").append(kendo.format(DivTag2block, "divSalary"));
    $("#OOR").append(kendo.format(DivTag2block, "divStartdate"));
    $("#OOR").append(kendo.format(DivTag2block, "divTrialTime"));
    $("#OOR").append(kendo.format(DivTag2block, "divFromToDate"));
    $("#OOR").after($(".Attach"));

    // Salary
    $('#divSalary .block-left .asf-filter-label').append($(".RequireSalary").children()[0]);
    $('#divSalary .block-left .asf-filter-input').append($($(".RequireSalary").children()[0]).children());
    $('#divSalary .block-right .asf-filter-label').append($(".DealSalary").children()[0]);
    $('#divSalary .block-right .asf-filter-input').append($($(".DealSalary").children()[0]).children());

    // StartDate
    $('#divStartdate .block-left .asf-filter-label').append($(".Startdate").children()[0]);
    $('#divStartdate .block-left .asf-filter-input').append($($(".Startdate").children()[0]).children());

    // TrialTime
    $('#divTrialTime .block-left .asf-filter-label').append($(".TrialTime").children()[0]);
    $('#divTrialTime .block-left .asf-filter-input').append($($(".TrialTime").children()[0]).children());
    $('#divTrialTime .block-right .asf-filter-label').append($("#Month_HRMF2040").val());

    // Salary
    $('#divFromToDate .block-left .asf-filter-label').append($(".TrialFromDate").children()[0]);
    $('#divFromToDate .block-left .asf-filter-input').append($($(".TrialFromDate").children()[0]).children());
    $('#divFromToDate .block-right .asf-filter-label').append($(".TrialToDate").children()[0]);
    $('#divFromToDate .block-right .asf-filter-input').append($($(".TrialToDate").children()[0]).children());

    // Process Tab
    processControlTab(1);
    processControlTab(2);
    processControlTab(3);
    processControlTab(4);
    processControlTab(5);

    // load language tab
    var value = ASOFT.helper.getLanguageString("HRMF2041.TabHRMT20401", "HRMF2041", "HRM");
    $("#HRMT20401 a").html(value);

    value = ASOFT.helper.getLanguageString("HRMF2041.TabHRMT20402", "HRMF2041", "HRM");
    $("#HRMT20402 a").html(value);

    value = ASOFT.helper.getLanguageString("HRMF2041.TabHRMT20403", "HRMF2041", "HRM");
    $("#HRMT20403 a").html(value);

    value = ASOFT.helper.getLanguageString("HRMF2041.TabHRMT20404", "HRMF2041", "HRM");
    $("#HRMT20404 a").html(value);

    value = ASOFT.helper.getLanguageString("HRMF2041.TabHRMT20405", "HRMF2041", "HRM");
    $("#HRMT20405 a").html(value)

    // Add btnSendMail
    $("#HRMF2041 .asf-form-button").append(kendo.format(btnSendMail, ASOFT.helper.getLanguageString("HRMF2041.btnSendMail", "HRMF2041", "HRM")));
    $("#btnSendMail").addClass('asf-disabled-li');
    $("#btnSendMail").bind('click', btnSendMail_Click);
}

function processControlTab(index) {
    var idControl = "InterViewDate0" + index;
    var idDivTag = "divTab" + index + idControl;

    // InterViewDate
    $("#Tabs-" + index).append(kendo.format(DivTag2block, idDivTag));
    $('#' + idDivTag + ' .block-left .asf-filter-label').append($(".InterviewDate0" + index).children()[0]);
    $('#' + idDivTag + ' .block-left .asf-filter-input').append($($(".InterviewDate0" + index).children()[0]).children());

    // InterViewAddress
    idControl = "InterviewAddress0" + index;
    idDivTag = "divTab" + index + idControl;
    $("#Tabs-" + index).append(kendo.format(DivTag1block, idDivTag));
    $('#' + idDivTag + ' .block-left .asf-filter-label').append($(".InterviewAddress0" + index).children()[0]);
    $('#' + idDivTag + ' .block-left .asf-filter-input').append($($(".InterviewAddress0" + index).children()[0]).children());

    //InterviewTypeID
    idControl = "InterviewTypeName0" + index;
    idDivTag = "divTab" + index + idControl;
    $("#Tabs-" + index).append(kendo.format(DivTag1block, idDivTag));
    $('#' + idDivTag + ' .block-left .asf-filter-label').append($(".InterviewTypeName0" + index).children()[0]);
    $('#' + idDivTag + ' .block-left .asf-filter-input').append($($(".InterviewTypeName0" + index).children()[0]).children());

    // Create DivTag PartialView
    idControl = "DetailTypeID0" + index;
    idDivTag = "divTab" + index + idControl;
    $("#Tabs-" + index).append(kendo.format(DivTagmain, idDivTag));

    // InterviewStatus
    idControl = "InterviewStatus0" + index;
    idDivTag = "divTab" + index + idControl;
    $("#Tabs-" + index).append(kendo.format(DivTag2block, idDivTag));
    $('#' + idDivTag + ' .block-left .asf-filter-label').append($(".InterviewStatus0" + index).children()[0]);
    $('#' + idDivTag + ' .block-left .asf-filter-input').append($($(".InterviewStatus0" + index).children()[0]).children());

    //Comment
    idControl = "Comment0" + index;
    idDivTag = "divTab" + index + idControl;
    $("#Tabs-" + index).append(kendo.format(DivTag1block, idDivTag));
    $('#' + idDivTag + ' .block-left .asf-filter-label').append($(".Comment0" + index).children()[0]);
    $('#' + idDivTag + ' .block-left .asf-filter-input').append($($(".Comment0" + index).children()[0]).children());
}

// Load partialView
function LoadPatialView() {
    var pk = "";
    if ($("#isUpdate").val() == 'True') {
        var url = new URL(window.location.href);
        pk = url.searchParams.get("Pk");
    }
    $.ajax({
        url: '/Partial/PartialHRMF2041?apk=' + pk + '&RecruitPeriodID=' + $("#RecruitPeriodID").val() + '&CandidateID=' + $("#CandidateID").val(),
        type: "GET",
        async: false,
        success: function (result) {
            $("#HRMF2041 .grid_6").before(result);
            var ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });
        }
    });
};

function LoadInfoInterview() {
    var pk = "";
    if ($("#isUpdate").val() == 'True') {
        var url = new URL(window.location.href);
        pk = url.searchParams.get("Pk");
    }
    $.ajax({
        url: '/HRM/HRMF2041/GetInfoInterviewType?apk=' + pk + '&RecruitPeriodID=' + $("#RecruitPeriodID").val() + '&CandidateID=' + $("#CandidateID").val(),
        type: "GET",
        async: false,
        success: function (result) {
            FillDataInterview(result.data);
        }
    });
}

function FillDataInterview(result) {
    for (var i = 0; i < result.length; i++) {
        $("#InterviewAddress0" + (i + 1)).val(result[i].InterviewAddress);
        $("#InterviewTypeName0" + (i + 1)).val(result[i].InterviewTypeName);
        $("#InterviewDate0" + (i + 1)).data("kendoDateTimePicker").value(result[i].InterviewDate);
        $("#InterviewTypeID0" + (i + 1)).val(result[i].InterviewTypeID);
        $("#InterviewStatus0" + (i + 1)).data("kendoComboBox").value(result[i].InterviewStatus);
        $("#Comment0" + (i + 1)).val(result[i].Comment);
    }
}

// Move control into Tab
function MoveControlPartialView() {
    var idContent;
    var idDivtag;
    for (var i = 1; i <= 5; i++) {
        idContent = "divDetailTypeID0" + i;
        idDivtag = "divTab" + i + "DetailTypeID0" + i;
        $("#" + idDivtag).append($("#" + idContent));
    }
    $("#Tabs").kendoTabStrip().show();
    var TabStrip = $("#Tabs").kendoTabStrip().data("kendoTabStrip");
    var totalLevel = $("#TotalLevel").val();
    for (var i = totalLevel; i < 5; i++) {
        $(TabStrip.items()[i]).hide();
    }
}

// Add Event for controls
function addEventControl() {
    var cboCandidateID = $("#CandidateID").data("kendoComboBox");
    if (cboCandidateID && $("#isUpdate").val() != 'True') {
        cboCandidateID.bind('change', cboCandidateID_change);
    }

    $("#btnRecruitPeriodName").click(function () {
        $("#CandidateID").data("kendoComboBox").value("");
        $("#Tabs").kendoTabStrip().hide();
        CurrentChoose = "RecruitPeriod";
        url = '/PopupSelectData/Index/HRM/HRMF2034?ScreenID=' + $('#sysScreenID').val();
        ASOFT.asoftPopup.showIframe(url, {});
    });

    $("#btnDeleteRecruitPeriodName").click(function () {
        $("#RecruitPeriodID").val('');
        $("#RecruitPeriodName").val('');
    });
}

function receiveResult(result) {
    this[ListChoose[CurrentChoose](result)];
};

var ListChoose = {
    "Attach": function (result) {

        var $templeteParent = $(".templeteAll"),

            templeteAll = result.map(function (obj) {

                var objFileName = obj.AttachName,

                    objFileID = obj.APK;

                return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
            }),

            parentAttach = $("#Attach").parent(),

            templeteAll = templeteAll.join(""),

            $attach = $("#Attach");

        $templeteParent.remove();

        templeteParent = "<div class='templeteAll'>{0}</div>";

        parentAttach.append(kendo.format(templeteParent, templeteAll));

        var objFileID = result.map(function (obj) {
            return obj.AttachID;
        });

        $attach.val(objFileID.join(',')).trigger("change");

        $(".x-close").unbind("click").bind("click", function () {
            deleteFile($(this));
        });
    },
    "RecruitPeriod": function (result) {
        $("#RecruitPeriodID").val(result.RecruitPeriodID);
        $("#RecruitPeriodName").val(result.RecruitPeriodName);
        $("#DepartmentName").val(result.DepartmentName);
        $("#DutyName").val(result.DutyName);
    }
};

// Combo CandidateID change
function cboCandidateID_change(e) {
    
    ASOFT.asoftLoadingPanel.show();
    if (e && e.sender) {
        $("#CandidateName").val(e.sender.dataItem().CandidateName);        
    }

    // Load PatialView
    LoadPatialView();

    // Clear Old Value
    var idDivtag;
    for (var i = 1; i <= 5; i++) {        
        idDivtag = "divTab" + i + "DetailTypeID0" + i;
        $("#" + idDivtag).html('');
    }
    // Move PartialView to Tab
    MoveControlPartialView();

    // Load info Interview
    LoadInfoInterview();

    ASOFT.asoftLoadingPanel.hide();
}

function CustomInsertPopupDetail(data) {
    return data;
}

/**  
* Process after insert data
*
* [Kim Vu] Create New [11/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        $("#btnSendMail").removeClass('asf-disabled-li');
    }
}

/**  
* Send email
*
* [Kim Vu] Create New [12/12/2017]
**/
function btnSendMail_Click(e) {
    var url = "/SendMail";
    ASOFT.asoftPopup.showIframe(url, {});
}

/**  
* Get data Send Mail
*
* [Kim Vu] Create New [11/12/2017]
**/
function customSendMail() {
    var dataSet = {};
    var url = "/HRM/Common/GetUsersSendMailRecruit"
    ASOFT.helper.postTypeJson(url, { formID: 'HRMF2041', recruitPeriodID: $("#RecruitPeriodID").val() }, function (result) {
        dataSet.EmailToReceiver = result;
    });
    return dataSet;
}

function CustomerCheck() {
    var message = [];
    var fromdatestr = $("#TrialFromDate").val(), date1 = fromdatestr.split("/");
    var todatestr = $("#TrialToDate").val(), date2 = todatestr.split("/");
    var fromdate = new Date(date1[2], date1[1] - 1, date1[0]);
    var todate = new Date(date2[2], date2[1] - 1, date2[0]);
    if (fromdate > todate) {
        message.push(ASOFT.helper.getMessage('OOFML000022'));
    }

    var RequireSalary = $("#RequireSalary").val();
    var msgRequireSalary = "{0} không được là số âm";
    if (RequireSalary < 0) {
        message.push(msgRequireSalary.f(ASOFT.helper.getLanguageString("HRMF2041.RequireSalary", "HRMF2041", "HRM")));
    }

    if (message.length > 0) {
        ASOFT.form.displayError("#HRMF2041", message);
        return true;
    }
    return false;
}

function btnDeleteRecruitPeriodName_Click() {
    $("#CandidateID").data("kendoComboBox").value("");
    $("#DepartmentName").val('');
    $("#DutyName").val('');
    $("#Tabs").kendoTabStrip().hide();
}