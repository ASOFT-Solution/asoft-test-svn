
// #region --- Foreign Methods ---

var templateFromToDate = "<div id=\"FromToDate\"></div>"
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
    "1": function (result) {
        $("#AssignedToUserID").val(result.EmployeeID);
        $('#AssignedToUserName').val(result.EmployeeName);
    }
};

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

    currentChoose = "Attach";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

// #endregion --- Foreign Methods ---

var oldVoucherNo = "";
var oldDeparmentID = "";

$(document).ready(function () {
    var templeteButton = new templateAsoftButton(),
       form = $("#sysScreenID"),
       parentSysScreenID = parent.$("#sysScreenID").val();
    $("#Description1").css("height", "90px");
    $("#Description2").css("height", "90px");

    $('.TrainingToDate').css('display', 'none');
    $('#Attach').css('display', 'none');
    $($('#TrainingFromDate').parent().parent()).css('width', '46%');
    $($('#TrainingToDate').parent().parent()).css('width', '46%');
    $($('.TrainingFromDate').children()[1]).append(templateFromToDate);
    $('div#FromToDate').append($($('#TrainingFromDate').parent().parent()));
    $('div#FromToDate').append("<span style=\"padding-left:3px ;padding-right:3px\">---</span>");
    $('div#FromToDate').append($($('#TrainingToDate').parent().parent()));
    $('.NumberEmployee').after($('.TrainingFromDate'));

    $("#Attach")
    .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
    .parent()
    .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

    $('.TrainingFromDate').after($(".Attach"))
    $($(".Attach").children()[0]).css("width", "14%");

    if ($('#isUpdate').val() != "True") {
        autoCode();
    } else {
        $("#TrainingRequestID").attr("readonly", true);
        $('.Attach').css('display', 'none');
    }
    // Check required AssignedToUserName
    $("#AssignedToUserName").attr("data-val-required", "The field is required").attr("requaird", "0");
    $("#AssignedToUserName").removeAttr("disabled").attr("readonly", true).css("background-color", "#dddddd");;

    $("#btnAssignedToUserName").bind('click', btnChooseUserName_Click);
    $("#btnDeleteAssignedToUserName").bind('click', btnDeleteUserNameD_Click);

    $("#DepartmentID").bind('change',cboDepartmentID_ValueChange);
});

function btnChooseUserName_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    currentChoose = "1";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
    
}

function btnDeleteUserNameD_Click() {
    $("#AssignedToUserID").val('');
    $('#AssignedToUserName').val('');
}

/**  
* Process auto Code
*
* [Kim Vu] Create New [11/12/2017]
**/
function autoCode() {
    var url = "/HRM/HRMF2080/GetVoucherNoText"
    ASOFT.helper.postTypeJson(url, {}, function (result) {
        if (result) {
            $("#TrainingRequestID").val(result)
            oldVoucherNo = result;
        }
    })
}

/**  
* DepartmentID change value
*
* [Kim Vu] Create New [12/12/2017]
**/
function cboDepartmentID_ValueChange(e){    
    oldDeparmentID = e.target.value;
}

/**  
* Process after insert data
*
* [Kim Vu] Create New [11/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && ($("#isUpdate").val() != "True")) {
        var url = "/HRM/HRMF2080/UpdateVoucherNo"
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo }, null);
        if (action == 1) {
            $("#HRMF2081")[0].reset();
            $(".file-templete").each(function () {
                deleteFile($(this));
            });
        }
        this.autoCode();
        this.ProcessSendEmail();
    }
}

/**  
* Call Form Send Email
*
* [Kim Vu] Create New [11/12/2017]
**/
function ProcessSendEmail() {
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
    var url = "/HRM/Common/GetUsersSendMail"
    ASOFT.helper.postTypeJson(url, { formID: 'HRMF2081', departmentID: oldDeparmentID }, function (result) {
        dataSet.EmailToReceiver = result;
    });
    return dataSet;
}

function CustomerCheck() {
    var message = [];
    if ($("#AssignedToUserName").val() == 'undefined' || $("#AssignedToUserName").val() == '') {
        message.push(kendo.format(ASOFT.helper.getMessage('00ML000039'), $(".AssignedToUserName .asf-td-caption label").html()));
        $("#AssignedToUserName").addClass('asf-focus-input-error');
    }
    else {
        $("#AssignedToUserName").removeClass('asf-focus-input-error');
    }

    var fromdatestr = $("#TrainingFromDate").val(), date1 = fromdatestr.split("/");
    var todatestr = $("#TrainingToDate").val(), date2 = todatestr.split("/");
    var fromdate = new Date(date1[2], date1[1] - 1, date1[0]);
    var todate = new Date(date2[2], date2[1] - 1, date2[0]);
    if (fromdate > todate) {
        message.push(ASOFT.helper.getMessage('OOFML000022'));
    }

    var msgg = "{0} không được là số âm";
    if ($("#NumberEmployee").val() < 0) {
        message.push(msgg.f(ASOFT.helper.getLanguageString("HRMF2081.NumberEmployee", "HRMF2081", "HRM")))
    }

    if (message.length > 0) {
        ASOFT.form.displayError("#HRMF2081", message);
        return true;
    }
    return false;
}
