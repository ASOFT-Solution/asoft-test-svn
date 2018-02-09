var oldVoucherNo = "";
var
    templateAttachFile = function (textFileName, templeteClass, textFileID) {
        this.getTemplete = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templeteClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
        return this;
    },

    templateAsoftButton = function () {
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

var currentChoose = null;
var ListChoose = {
    "Attach": function (result) {

        var $templeteParent = $(".templeteAll"),

            templeteAll = result.map(function (obj) {
                var objFileName = obj.AttachName,
                    objFileID = obj.APK;
                return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplete;
            }),

            parentAttach = $("#Attach").parent(),
            templeteAll = templeteAll.join(""),
            $attach = $("#Attach");
        $templeteParent.remove();
        templeteParent = "<div class='templeteAll'>{0}</div>";
        parentAttach.append(kendo.format(templeteParent, templeteAll));
        $attach.val(JSON.stringify(result)).trigger("change");
        $(".x-close").unbind("click").bind("click", function () {
            deleteFile($(this));
        });
    },
    "InheritChoose": function (result) {
        var GridHRMT2051 = $("#GridEditHRMT2051").data("kendoGrid"),
            dtSource = GridHRMT2051.dataSource,
            isExisted = false;

        if (dtSource.data().length == 1) {
            var item = dtSource.get(0);
            if (!item.get("CandidateID")) {
                dtSource.remove(item);
                dtSource.sync();
            }
        }

        for (var i = 0; i < dtSource.data().length; i++) {
            var item = dtSource.get(i);
            if (item.get("CandidateID") && item.get("CandidateID") == result.CandidateID) {
                isExisted = true;
                break;
            }
        }

        if (!isExisted) {
            dtSource.insert({
                CandidateID: result.CandidateID || "",
                CandidateName: result.CandidateName || "",
                RecruitPeriodID: result.RecruitPeriodID || "",
                DepartmentName: result.DepartmentName || "",
                DepartmentID: result.DepartmentID || "",
                DutyID: result.DutyID || "",
                DutyName: result.DutyName || "",
                StatusName: result.StatusName || "",
                RecruitStatus: result.RecruitStatus || "",
                RequireSalary: result.RequireSalary || "",
                DealSalary: result.DealSalary || "",
                TrialFromDate: result.TrialFromDate || "",
                TrialToDate: result.TrialToDate || "",
                WorkTypeName: result.WorkTypeName || "",
                GenderName: result.GenderName || "",
                Birthday: result.Birthday || "",
                MaterialStatus: result.MaterialStatus || ""
            });
        }
        
    }
}

function deleteFile(jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),
        $templeteAll = $(".templeteAll"),
        $apkDelete = $parentXClose.attr("id"),
        $attach = $("#Attach"),
        $result = JSON.parse($attach.val()),
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

    var urlPopup3 = "/AttachFile?Type=2";
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

function getResultAfterDelete(result, apkDelete) {
    var $resultAfterDelete = $.map(result, (function (obj) {
        if (obj.APK != apkDelete)
            return obj;
    }));
    return $resultAfterDelete.length > 0 ? $resultAfterDelete : "";
}

function btnInherit_click(e) {

    var urlPopup = [
        '/PopupSelectData/Index/HRM/HRMF2053?RecruitPeriodID='
        , $('#RecruitPeriodID').val()
        , '&CandidateID='
        , $('#CandidateID').val()
        , '&DepartmentID='
        , $('#DepartmentID').val()
        , '&DutyID='
        , $('#DutyID').val()
        , '&FromDate='
        , $('#FromDate').val()
        , '&ToDate='
        , $('#ToDate').val()
    ].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});

    currentChoose = "InheritChoose";
}


$(document).ready(function () {

    var templeteButton = new templateAsoftButton();

    $("#Attach")
        .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

    if ($(".Attach") && $(".Attach").length > 0) {
        // TODO:  Kế thừa đợt tuyển dụng - không viết chết
        $(".Attach").parent().append(["<tr>", "<td>", templeteButton.getAsoftButton("", "btnInherit", "", "Kế thừa đợt tuyển dụng", "btnInherit_click()"), "</td>", "</tr>"].join(""));
    }
    else {
        $(".DecisionDate").parent().append(["<tr>", "<td>", templeteButton.getAsoftButton("", "btnInherit", "", "Kế thừa đợt tuyển dụng", "btnInherit_click()"), "</td>", "</tr>"].join(""));
    }
    if ($("#isUpdate").val() == 'False') {
        autoCode();
    }
    else
    {
        $("#RecDecisionNo").attr("readonly", true);
    }

    var btnSendMail = '<ul class="empty" style ="float:left;"> ' +
            '<li>' +
                '<a class="k-button k-button-icontext asf-button" id="btnSendMail" style="" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text">{0}</span></a>' +
            '</li>' +
        '</ul>';
    // Add btnSendMail
    $("#HRMF2051 .asf-form-button").append(kendo.format(btnSendMail, ASOFT.helper.getLanguageString("HRMF2041.btnSendMail", "HRMF2041", "HRM")));
    $("#btnSendMail").addClass('asf-disabled-li');
    $("#btnSendMail").bind('click', btnSendMail_Click);

})

/**  
* [Kieu Nga] Create New [13/12/2017]
**/

function autoCode() {
    var url = "/HRM/Common/GetVoucherNoText";
    ASOFT.helper.postTypeJson(url, { tableID: "HRMF2051" }, function (result) {
        if (result) {
            $("#RecDecisionNo").val(result);
            oldVoucherNo = result;
        }
    })
}

/**  
* Process after insert data
*
* [Kieu Nga] Create New [13/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && ($("#isUpdate").val() != "True")) {
        var url = "/HRM/Common/UpdateVoucherNo"
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo, tableID: "HRMF2051" }, null);
        autoCode();
        $("#btnSendMail").removeClass('asf-disabled-li');
    }
}

/**  
* Send email
*
* [Kiều Nga] Create New [23/01/2018]
**/
function btnSendMail_Click(e) {
    var url = "/SendMail";
    ASOFT.asoftPopup.showIframe(url, {});
}
