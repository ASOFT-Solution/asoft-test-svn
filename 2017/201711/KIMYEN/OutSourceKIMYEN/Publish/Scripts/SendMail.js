var action = null;
var actionChoose = null;

$(document).ready(function () {

    if ($("#RelatedToTypeID_REL").val() == 6 || $("#RelatedToTypeID_REL").val() == 1) {
        var EmailToReceiver = $("#EmailToReceiver").attr("initvalue");
        $("#EmailToReceiver").val(EmailToReceiver);
    }

    if (typeof parent.customSendMail === "function")
    {
        var dataSet = {};
        dataSet = parent.customSendMail();
        $.each(dataSet, function (key, value) {
            $("#" + key).val(value);
        })
    }
})

function btnSend_Click() {
    ASOFT.form.clearMessageBox();

    if (formIsInvalid()) {
        return;
    }

    if ($("#EmailToReceiver").val() != "") {
        var lToAddress = $("#EmailToReceiver").val().split(';');
        for (var i = 0; i < lToAddress.length; i++) {
            if (!isValidEmailAddress(lToAddress[i])) {
                ASOFT.form.displayError('#CMNF9005', kendo.format(ASOFT.helper.getMessage('00ML000083'), $("label[for='EmailToReceiver']").text()));
                $("#EmailToReceiver").addClass("asf-focus-input-error");
                return;
            }
        }
    }

    if ($("#EmailCCReceiver").val() != "") {
        var lToAddress = $("#EmailCCReceiver").val().split(';');
        for (var i = 0; i < lToAddress.length; i++) {
            if (!isValidEmailAddress(lToAddress[i])) {
                ASOFT.form.displayError('#CMNF9005', kendo.format(ASOFT.helper.getMessage('00ML000083'), $("label[for='EmailCCReceiver']").text()));
                $("#EmailCCReceiver").addClass("asf-focus-input-error");
                return;
            }
        }
    }

    if ($("#EmailBCCReceiver").val() != "") {
        var lToAddress = $("#EmailBCCReceiver").val().split(';');
        for (var i = 0; i < lToAddress.length; i++) {
            if (!isValidEmailAddress(lToAddress[i])) {
                ASOFT.form.displayError('#CMNF9005', kendo.format(ASOFT.helper.getMessage('00ML000083'), $("label[for='EmailBCCReceiver']").text()));
                $("#EmailBCCReceiver").addClass("asf-focus-input-error");
                return;
            }
        }
    }

    
    action = 1;
    var data = ASOFT.helper.dataFormToJSON("CMNF9005");
    data.AssignedToUserID = $("#AssignedToUserID").val();
    data.CountAttachFile = $(".CountAttachFile").text();
    ASOFT.helper.postTypeJson("/SendMail/InsertMail", data, onInsertSuccess);
}

function isValidEmailAddress(emailAddress) {
    var pattern = /^([a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+(\.[a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+)*|"((([ \t]*\r\n)?[ \t]+)?([\x01-\x08\x0b\x0c\x0e-\x1f\x7f\x21\x23-\x5b\x5d-\x7e\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|\\[\x01-\x09\x0b\x0c\x0d-\x7f\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))*(([ \t]*\r\n)?[ \t]+)?")@(([a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.)+([a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.?$/i;
    return pattern.test(emailAddress);
};


function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList("CMNF9005", []);
}

function onInsertSuccess(result) {
    if (result.Status == 0) {
        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#CMNF9005', ASOFT.helper.getMessage(result.Message));
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid('CMNT90051');
                }
                parent.popupClose();
                break;
            case 0://save close, Lưu xong và đóng lại  
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid('CMNT90051');
                }
                parent.popupClose();
        }
    }
    else {
        var msg = ASOFT.helper.getMessage(result.Message);
        if (result.Data) {
            msg = kendo.format(msg, result.Data);
        }
        ASOFT.form.displayWarning('#' + ID, msg);
    }
}

function popupClose_Click() {
    ASOFT.asoftPopup.closeOnly();
}

function btnChooseFile_Click() {
    actionChoose = 1;
    var urlChoose = "/PopupSelectData/Index/CI/CIF1043";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnDelete_Click(e) {
    $(".CountAttachFile").text($(".AttachmentFileName").find('span').length - 1);
    $(e).parent().remove();
}

function btnDeleteAll_Click() {
    $(".CountAttachFile").text(0);
    $(".AttachmentFileName").find('span').remove();
}

function btnAttachFile_Click() {
    actionChoose = 0;
    var urlChoose = "/AttachFile?Type=2";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function receiveResult(result) {
    if (actionChoose == 0) {
        var AttachID = "";
        for (var i = 0 ; i < result.length; i++) {
            if ($(".AttachmentFileName").find('span[class="' + result[i]["AttachID"] + '"]').length == 0) {
                AttachID = AttachID + "<span style='border: 2px solid; border-radius: 25px !important; padding: 3px' class='" + result[i]["AttachID"] + "'><input value = '" + result[i]["AttachID"] + "' type='hidden' id='AttachID' name='AttachID'/><a href='/AttachFile/Download?FileName=" + result[i]["AttachName"] + "&APK=" + result[i]["APK"] + "'>" + result[i]["AttachName"] + "</a><a class='close-x' style='font-size: 20px; padding: 3px' onclick='btnDelete_Click(this)'>×</a></span>";
            }
        }

        $(".AttachmentFileName").append(AttachID);
        $(".CountAttachFile").text($(".AttachmentFileName").find('span').length);
    }
    if (actionChoose == 1) {
        ASOFT.helper.postTypeJson("/SendMail/GetTemplate", { APK: $("#RelatedToID").val(), EmailBody: result["EmailBody"], TemplateID: result["TemplateID"] }, function (template) {
            $("#EmailBody").data('kendoEditor').value(template);
        });
    }
}