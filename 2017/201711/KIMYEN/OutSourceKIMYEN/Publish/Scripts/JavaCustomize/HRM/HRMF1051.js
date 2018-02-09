function onAfterInsertSuccess(result, action) {
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
}


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

var currentChoose = null;
var ListChoose = {
    "ChooseObject": function (result) {
        $("#ObjectID").val(result.ObjectID);
        $("#ObjectName").val(result.ObjectName);
    }
}


function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};


$(document).ready(function () {
    if ($("#isUpdate").val() == "True") {
            $("#TrainingCourseID").attr("readonly", true);
    }
    $(".asf-td-caption").css("width", "30%");

    var templeteButton = new templateAsoftButton();

    $("#ObjectName")
        .prop("disabled", true)
        .css({
            "width": "75%",
            "background-color": "#d0c9c9",
            "cursor": "not-allowed"
        })
        .focusin(function (e) { $(this).blur(); })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnObject", "", "...", "btnChoosebtnObject_click()") + templeteButton.getDeleteAsoftButton("btnDeleteObject", "btnDeleteObject_click()"));

})

function btnChoosebtnObject_click(e) {

    var urlPopup = '/PopupSelectData/Index/00/CMNF9004?DivisionID=' + ASOFTEnvironment.DivisionID;

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});

    currentChoose = "ChooseObject";
}

function btnDeleteObject_click(e) {

    $("#ObjectID").val("");

    $("#ObjectName").val("");
}

