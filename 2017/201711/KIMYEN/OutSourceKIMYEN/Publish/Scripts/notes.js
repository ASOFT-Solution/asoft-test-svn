var isMore = 1;

$(document).ready(function () {
    $("#Description").keydown(function (e) {
        if (e.keyCode == 13) {
            if (e.shiftKey) {
                btnSend_Click();
                e.preventDefault();
            }
        }
    });

    $("#BtnDeleteDetail_CRMF9003_CRMT90031").remove();
})

function btnSend_Click() {
    if ($("#Description").val() == "") return;
    var data = {};
    data.DivisionID = $(".DivisionID").text();
    data.RelatedToTypeID_REL = $("#TypeRELNotes").val();
    data.RelatedToID = $("#PK").val();
    data.NotesSubject = $("#Description").val();
    data.Description = $("#Description").val();
    ASOFT.helper.postTypeJson("/PartialView2/InsertNotes?id=" + $("#sysScreenID").val() + "&table=" + $("#sysTable").val(), data, onInsertSuccess);
}
function onInsertSuccess(result) {
    if (result.Status == 0) {
        var deleteID = result.isDivision ? '<a class="close-x-notes" style="font-size: 20px; margin: -5px 3px 3px 3px" onclick="btnDelete_Click(' + result.NotesID + ',this)">×</a>' : "";
        var notes = kendo.format('<div class="asf-master-content-notes isMoreShow"><div class="form-style-2"><div class="float-left-notes"><img height="62" src="/PartialView2/Avatar?UserID=' + result.UserID + '" width="70"></div>{0}<div class="asf-note-create wrap-text"><span class="user-comment">' + result.UserID + '</span> - <span class="user-create">' + result.CreateDate + '</span></div><br /><div class="asf-note-description">' + result.Description + '</div></div>', deleteID);
        $("#Comment").after(notes);
        $("#Description").val("");
        refreshGrid();
    }
}

function btnViewMore_Click() {
    var hide = $(".isMoreHide");
    var length = hide.length > 4 ? 5 : hide.length;
    for (var i = 0; i < length; i++) {
        $(hide[i]).addClass("isMoreShow");
        $(hide[i]).removeClass("isMoreHide");
    }

    if ($(".isMoreHide").length == 0) {
        $("#viewmore").remove();
    }
}

function btnDelete_Click(notes, e) {
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        var data = {};
        data.NotesID = notes;
        data.RelatedToTypeID_REL = $("#TypeRELNotes").val();
        data.RelatedToID = $("#PK").val();

        ASOFT.helper.postTypeJson("/PartialView2/DeleteNotes", data, function (result) {
            onDeleteSuccess(result, e);
        });
    });
}

function onDeleteSuccess(result, e) {
    if (result.Status == 0) {
        $(e).parent().parent().remove();
    }
    refreshGrid();
}

function btnClear_Click() {
    $("#Description").val("");
}