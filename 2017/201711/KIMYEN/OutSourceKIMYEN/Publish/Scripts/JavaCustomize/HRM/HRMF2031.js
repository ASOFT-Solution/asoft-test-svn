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
    "ChooseRecruitPeriod": function (result) {
        $("#RecruitPeriodID").val(result.RecruitPeriodID || "");
        $("#RecruitPeriodName").val(result.RecruitPeriodName || "");
        $("#InterviewLevel").val(result.InterviewLevel || "");
        $("#DepartmentID").val(result.DepartmentID || "");
        $("#DepartmentName").val(result.DepartmentName || "");
        $("#InterviewAddress").val(result.InterviewAddress || "");
        $("#DutyID").val(result.DutyID || "");
        $("#DutyName").val(result.DutyName || "");

    },
    "ChooseCandidate": function (result) {

        var GridHRMT2031 = $("#GridEditHRMT2031").data("kendoGrid"),
            dtSource = GridHRMT2031.dataSource;

        if (dtSource.data().length == 1) {
            var item = dtSource.get(0);
            if (!item.get("CandidateID")) {
                dtSource.remove(item);
                dtSource.sync();
            }
        }

        dtSource.insert({
            CandidateID: result.CandidateID || "",
            CandidateName: result.CandidateName || ""
        });


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

$(document)
    .ready(function() {
        var templeteButton = new templateAsoftButton();
        var GridHRMT2031 = $("#GridEditHRMT2031").data("kendoGrid");

        $("#Attach")
        .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

        $("#RecruitPeriodName")
            .focusin(function(e) { $(this).blur(); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnRecruitPeriod", "", "...", "btnChooseRecruitPeriod_click()") +
                templeteButton.getDeleteAsoftButton("btnDeleteRecruitPeriod", "btnDeleteRecruitPeriod_click()"));

        $("#InterviewAddress")
            .focusin(function(e) { $(this).blur(); })
            .prop("readonly", true);

        $("#InterviewLevel")
            .focusin(function(e) { $(this).blur(); })
            .prop("readonly", true);

        $("#DepartmentName")
            .focusin(function(e) { $(this).blur(); })
            .prop("readonly", true);

        $("#DutyName")
            .focusin(function(e) { $(this).blur(); })
            .prop("readonly", true);

        if ($(".Attach") && $(".Attach").length > 0) {
            $(".Attach")
                .parent()
                .append([
                    "<tr>", "<td>", templeteButton
                    .getAsoftButton("", "btnChooseCandidate", "", "Chọn ứng viên", "btnChooseCandidate_click()"),
                    "</td>",
                    "</tr>"
                ].join(""));
        } else {
            $(".DutyName")
                .parent()
                .append([
                    "<tr>", "<td>", templeteButton
                    .getAsoftButton("", "btnChooseCandidate", "", "Chọn ứng viên", "btnChooseCandidate_click()"),
                    "</td>",
                    "</tr>"
                ].join(""));
        }

        layoutCustom();

        $(GridHRMT2031.tbody)
            .on("change",
                "td",
                function(e) {
                    var data = null;
                    var column = e.target.id;
                    var selectitem = GridHRMT2031.dataItem(e.currentTarget.parentElement);
                    var cbb = $("#" + column).data("kendoComboBox");
                    if (cbb) {
                        data = cbb.dataItem(cbb.select());
                    }
                    if (column === 'cbbConfirmName') {
                        if (data) {
                            selectitem.set('ConfirmName', data.Description);
                            selectitem.set('ConfirmID', data.ID);
                        }
                    }

                })

        if ($("#isUpdate").val() == 'False') {
            autoCode();
        }

        var btnSendMail = '<ul class="empty" style ="float:left;"> ' +
            '<li>' +
                '<a class="k-button k-button-icontext asf-button" id="btnSendMail" style="" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text">{0}</span></a>' +
            '</li>' +
        '</ul>';

        // Add btnSendMail
        $("#HRMF2031 .asf-form-button").append(kendo.format(btnSendMail, ASOFT.helper.getLanguageString("HRMF2041.btnSendMail", "HRMF2041", "HRM")));
        $("#btnSendMail").addClass('asf-disabled-li');
        $("#btnSendMail").bind('click', btnSendMail_Click);
    });

function btnChooseRecruitPeriod_click(e) {

    var urlPopup = '/PopupSelectData/Index/HRM/HRMF2034?ScreenID=' + $('#sysScreenID').val();

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});

    currentChoose = "ChooseRecruitPeriod";
}

function btnChooseCandidate_click(e) {

    if (checkBeforeOpenCandidateSelectPopup()) {

        var urlPopup = ['/PopupSelectData/Index/HRM/HRMF2035?ScreenID=', $('#sysScreenID').val(), '&RecruitPeriodID=', $('#RecruitPeriodID').val(), '&InterviewLevel=', $('#InterviewLevel').val()].join("");

        ASOFT.form.clearMessageBox();

        ASOFT.asoftPopup.showIframe(urlPopup, {});

        currentChoose = "ChooseCandidate";
    }
}

function btnDeleteRecruitPeriod_click(e) {

    $("#RecruitPeriodID").val("");

    $("#RecruitPeriodName").val("");

    $("#InterviewLevel").val("");

    $("#DepartmentID").val("");

    $("#DepartmentName").val("");

    $("#DutyID").val("");

    $("#DutyName").val("");

    $("#InterviewAddress").val("");
}

function layoutCustom() {

    var trClassList = ["DepartmentName", "InterviewLevel"];

    trClassList.reverse().forEach(function (item, index) {
        $("." + item).prependTo($(".InterviewAddress").parent());
    });

}

function checkBeforeOpenCandidateSelectPopup() {
    var dataItem = [
        "RecruitPeriodID",
        "RecruitPeriodName",
        "InterviewLevel",
        "DepartmentID",
        "DepartmentName",
        "DutyID",
        "DutyName"
    ];

    var dataError = [];
    var messageError = [];

    dataItem.forEach(function (item, index) {
        var $item = $("#" + item);

        $item.removeClass("asf-focus-input-error");

        if (!$item || typeof $item.val() === "undefined" || $item.val() == null || $item.val() == "")
        {
            dataError.push(item);
            $item.addClass("asf-focus-input-error");
        }
    })

    if (dataError.length > 0) {
        messageError.push(ASOFT.helper.getMessage("HRMFML000022"));
        ASOFT.form.displayMessageBox("form#HRMF2031", messageError);
        return false;
    }

    return true;
}

/**  
* Process after insert data
*
* [Kieu Nga] Create New [12/12/2017]
**/

function autoCode() {
    var url = "/HRM/Common/GetVoucherNoText";
    ASOFT.helper.postTypeJson(url,
        { tableID: "HRMF2031" },
        function(result) {
            if (result) {
                $("#InterviewScheduleID").val(result);
                oldVoucherNo = result;
            }
        });
}

/**  
* Process after insert data
*
* [Kieu Nga] Create New [12/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 ) {
        $("#btnSendMail").removeClass('asf-disabled-li');

        if (($("#isUpdate") != "True")) {
            var url = "/HRM/Common/UpdateVoucherNo"
            ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo, tableID: "HRMF2031" }, null);
            autoCode();
        }
    }
}

/**  
* Send email
*
* [Kiều Nga] Create New [19/01/2018]
**/
function btnSendMail_Click(e) {
    var url = "/SendMail";
    ASOFT.asoftPopup.showIframe(url, {});
}
