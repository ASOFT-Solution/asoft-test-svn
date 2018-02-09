

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
    },

    ListChoose = {

        "AccountID": function (result) {
            var dataSource = [],
                dataValue = [];
            $.map(result, function (item) {
                dataSource.push({
                    EmployeeID: item["AccountID"],
                    EmployeeName: item["AccountName"]
                })
                dataValue.push(item["AccountID"]);
            });

            var k_MultiSelect_AccountID = $("#AccountID").data("kendoMultiSelect");
            k_MultiSelect_AccountID.setDataSource(dataSource);
            k_MultiSelect_AccountID.value(dataValue);
            k_MultiSelect_AccountID.trigger("change");
        },

        "AssignedToUserID": function (result) {

            $("#AssignedToUserID").val(result["EmployeeID"]);

            $("#AssignedToUserName").val(result["EmployeeName"]).trigger("change");
        },

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
        }
    },

    currentChoose = null,

    loadPartialView = function (arrayObject) {

        if (typeof arrayObject.length > 0 || typeof arrayObject !== "undefined") {

            arrayObject.map(function (obj) {

                var objURL = obj.url,

                    objID = obj.id,

                    objType = obj.type;

                ASOFT.partialView.Load(objURL, objID, objType);
            });
        }
    },
    arrayPartial = function (url, id, type) {
        this.url = url;
        this.id = id;
        this.type = type;
        return this;
    },

    setDefaultValue = function () {
        var $requestStatus = $("#RequestStatus").data("kendoComboBox"),
            dataRequestStatus = $requestStatus.dataSource.data(),
            k_MultiSelect_AccountID = $("#AccountID").data("kendoMultiSelect");

        $requestStatus.value(dataRequestStatus[0]["ID"]);

        $("#TimeRequest").data("kendoDateTimePicker").value(new Date() );

        $("#DeadlineRequest").data("kendoDateTimePicker").value(new Date());

        k_MultiSelect_AccountID.setDataSource("")

        k_MultiSelect_AccountID.value("");

        k_MultiSelect_AccountID.trigger("change");

        $("#AssignedToUserID").val(ASOFTEnvironment.UserID);

        $("#AssignedToUserName").val(ASOFTEnvironment.UserName).trigger("change");

        $("#Attach").val("");

        $(".PriorityID").find("a").eq(0).trigger("click");

        $("#RelatedToTypeID").val(20);

        btnDeleteUpload_click();
    },

    setButtonDeleteDisableWhenObjectChange = function ($Object, $ButtonDelete, buttonEventClick) {

        if (typeof $Object !== "undefined" && typeof $ButtonDelete !== "undefined") {
            if(typeof $Object.val ==="function" && typeof $Object.val() !=="undefined")
            {
                $Object.val() == ""
                ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
                : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
            }
            if (typeof $Object.value === "function" && $Object.value() !== "undefined")
            {
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

    return $resultAfterDelete.length > 0 ? $resultAfterDelete: "";
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

function btnRelatedToID_click(e) {

    var divisionID = $("#EnvironmentDivisionID").val(),

        urlPopup = ["/PopupSelectData/Index/CRM/CRMF9001", "?", "DivisionID=", divisionID, "&Type=1"].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});

    currentChoose = "AccountID";
}

function btnChooseAssignedToUserID_click(e) {

    var divisionID = $("#EnvironmentDivisionID").val(),

        urlPopup2 = ["/PopupSelectData/Index/00/CMNF9003", "?", "DivisionID=", divisionID].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup2, {});

    currentChoose = "AssignedToUserID";
}

function btnUpload_click(e) {

    var urlPopup3 = "/AttachFile?Type=2";

    ASOFT.asoftPopup.showIframe(urlPopup3, {});

    currentChoose = "Attach";
}

function btnDeleteAssignedToUserID_click(e) {
    $("#AssignedToUserID").val("");
    $("#AssignedToUserName").val("").trigger("change");
}

function btnDeleteRelatedToID_click(e) {
    var k_MultiSelect_AccountID = $("#AccountID").data("kendoMultiSelect");
    k_MultiSelect_AccountID.setDataSource([]);
    k_MultiSelect_AccountID.value("");
    k_MultiSelect_AccountID.trigger("change");
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
}

function onAfterInsertSuccess(result, action) {

    $("#RelatedToTypeID").val(20);

    if (action == 1) {
        setDefaultValue();
    }
}

$(document).ready(function () {

    var templeteButton = new templateAsoftButton(),
        form = $("#CRMF2081"),
        parentSysScreenID = parent.$("#sysScreenID").val(),
        k_MultiSelect_AccountID = $("#AccountID").data("kendoMultiSelect");

    $("#AssignedToUserName")
        .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnAssignedToUserID"), btnDeleteAssignedToUserID_click); })
        .focusin(function (e) { $(this).blur(); })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnAssignedToUserID", "", "...", "btnChooseAssignedToUserID_click()") + templeteButton.getDeleteAsoftButton("btnDeleteAssignedToUserID", ""));

    $("#Attach")
        .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

    k_MultiSelect_AccountID
        .wrapper
        .css({ "width": "75%", "float":"left" })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnRelatedToID", "", "...", "btnRelatedToID_click()") + templeteButton.getDeleteAsoftButton("btnDeleteRelatedToID", ""));

    k_MultiSelect_AccountID.bind("change", function () { setButtonDeleteDisableWhenObjectChange(this, $("#btnDeleteRelatedToID"), btnDeleteRelatedToID_click); });

    k_MultiSelect_AccountID.options.autoClose = false;
    //k_MultiSelect_AccountID.tagList.css({
    //    "max-height": "120px",
    //    "overflow": "auto",
    //})
        //.appendTo(k_MultiSelect_AccountID.wrapper.parent())

    form.find(".AccountID").after($(this).find(".AssignedToUserName"));

    if (typeof parentSysScreenID !== "undefined" && parentSysScreenID == "CRMF2080") {

        $("#RequestDescription").css({
            "height": "80px"
        });

        $("#FeedbackDescription").css({
            "height": "80px"
        });

        setDefaultValue();
    }
    else {

        form.find(".TimeRequest").after($(this).find(".DeadlineRequest"));

        $("#RequestDescription").css({
            "height": "90px"
        });

        $("#FeedbackDescription").css({
            "height": "90px"
        });
    }
   
});