$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
    $("#refLinkCRMT90031").val("NotesSubject");
});

function DeleteViewMasterDetail2(pk) {
    pk = $(".CampaignID").text();
    return pk;
}


function BtnChoose_Custom(tb) {
    var urlChoose = "/PopupSelectData/Index/{1}/{0}?DivisionID=" + $("#EnvironmentDivisionID").val();
    if (tb == "CRMT90051") {
        urlChoose = kendo.format(urlChoose, "CRMF9010", "CRM");
        acChoose = 1;
    }
    if (tb == "CRMT90041") {
        urlChoose = kendo.format(urlChoose, "CRMF9011", "CRM");
        acChoose = 2;
    }
    if (tb == "CRMT10301") {
        urlChoose = kendo.format(urlChoose, "CRMF9017", "CRM");
        acChoose = 3;
    }

    ASOFT.asoftPopup.showIframe(urlChoose, {});
}


function receiveResult(result) {
    var tableReset = "";
    var dtSave = {};
    if (acChoose == 1) {
        tableReset = "CRMT90051";
        dtSave.TableREL = "CRMT90051_REL";
        dtSave.ColumnREL = "RelatedToID";
        dtSave.ColumnREAL = "EventID";
        dtSave.ValueREAL = result["EventID"];
        dtSave.ValueHistory = result["EventSubject"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.TypeREL = 6;
        dtSave.Table = "CRMT90051";
        dtSave.TableParent = "CRMT20401";
        dtSave.ColumnHistory = "EventSubject";
    }
    if (acChoose == 3) {
        tableReset = "CRMT10301";
        dtSave.TableREL = "CRMT20401_CRMT10301_REL";
        dtSave.ColumnREL = "CampaignID";
        dtSave.ValueHistory = result["GroupReceiverID"];
        dtSave.ColumnHistory = dtSave.ColumnREAL = "GroupReceiverID";
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT10301";
        dtSave.TableParent = "CRMT20401";
    }

    if (acChoose == 2) {
        tableReset = "CRMT90041";
        dtSave.TableREL = "CRMT90041_REL";
        dtSave.ColumnREL = "RelatedToID";
        dtSave.ColumnREAL = "TaskID";
        dtSave.ValueREAL = result["TaskID"];
        dtSave.ValueHistory = result["Title"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.TypeREL = 6;
        dtSave.Table = "CRMT90041";
        dtSave.TableParent = "CRMT20401";
        dtSave.ColumnHistory = "Title";
    }

    ASOFT.helper.postTypeJson("/PopupSelectData/SaveREL", dtSave, function (result1) {
        if (result1) {
            refreshGrid(tableReset);
        }
    })
}