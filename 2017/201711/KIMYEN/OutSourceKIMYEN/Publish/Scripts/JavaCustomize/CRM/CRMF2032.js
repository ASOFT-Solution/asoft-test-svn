$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();

    $("#refLinkCRMT90031").val("NotesSubject");

    ASOFT.helper.postTypeJson("/CRM/CRMF2050/LoadStage", { type: "0,2" }, function (result) {
        for (var i = 0; i < result.length; i++) {
            var stage = "<a onclick=updateStage_Click('" + result[i].StageID + "',this)><div class='asf-panel-master-stage-left {0}'><span>" + result[i].StageName + "</span><div class='arrow-stage {1}'></div></div></a>";
            if ($(".LeadStatusID").text() == result[i].StageID)
                stage = kendo.format(stage, "stageSelect", "arrowSelect");
            else
                stage = kendo.format(stage, "", "");
            $($(".asfbtn")[1]).append(stage);
        }
    });
});

function updateStage_Click(stg, stgN) {
    $("#contentMaster").after('<div id="loading" style="position: absolute;top: 50%;left: 50%;"><img src="/Content/Images/BlueOpal/loading-image.gif"/></div>');
    setTimeout(function () {
        var stgList = [];
        stgList.push(stg);
        stgList.push($("#PK").val());
        stgList.push("- 'CRMF2032.LeadStatusID.CRM': " + $(".LeadStatusName").text() + " -> " + $(stgN).find('span').text());
        ASOFT.helper.postTypeJson("/CRM/CRMF2030/UpdateStage", stgList, function (result) {
            if (result.check) {
                $(".LeadStatusID").text(stg);
                $(".LeadStatusName").text($(stgN).find('span').text());
                $(".LastModifyDate").text(result.DateTime);
                $(".LastModifyUserID").text(result.User);
                $(".asf-panel-master-stage-left").remove();
                $("#loading").remove();
                refreshGrid("CRMT00003");

                ASOFT.helper.postTypeJson("/CRM/CRMF2050/LoadStage", { type: "0,2" }, function (result) {
                    for (var i = 0; i < result.length; i++) {
                        var stage = "<a onclick=updateStage_Click('" + result[i].StageID + "',this)><div class='asf-panel-master-stage-left {0}'><span>" + result[i].StageName + "</span><div class='arrow-stage {1}'></div></div></a>";
                        if ($(".LeadStatusID").text() == result[i].StageID)
                            stage = kendo.format(stage, "stageSelect", "arrowSelect");
                        else
                            stage = kendo.format(stage, "", "");
                        $($(".asfbtn")[1]).append(stage);
                    }
                });
            }
        })
    }, 200);
}


function DeleteViewMasterDetail2(pk) {
    pk = $(".LeadID").text();
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
    if (tb == "CRMT20501") {
        urlChoose = kendo.format(urlChoose, "CRMF9013", "CRM");
        acChoose = 3;
    }
    if (tb == "CRMT20401") {
        urlChoose = kendo.format(urlChoose, "CRMF9008", "CRM");
        acChoose = 4;
    }
    if (tb == "CRMT10001") {
        urlChoose = kendo.format(urlChoose, "CRMF9002", "CRM");
        acChoose = 5;
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
        dtSave.TypeREL = 1;
        dtSave.Table = "CRMT90051";
        dtSave.TableParent = "CRMT20301";
        dtSave.ColumnHistory = "EventSubject";
    }
    if (acChoose == 3) {
        tableReset = "CRMT20501";
        dtSave.TableREL = "CRMT20501_CRMT20301_REL";
        dtSave.ColumnREL = "LeadID";
        dtSave.ColumnHistory = dtSave.ColumnREAL = "OpportunityID";
        dtSave.ValueHistory = result["OpportunityID"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT20501";
        dtSave.TableParent = "CRMT20301";
    }

    if (acChoose == 2) {
        tableReset = "CRMT90041";
        dtSave.TableREL = "CRMT90041_REL";
        dtSave.ColumnREL = "RelatedToID";
        dtSave.ColumnREAL = "TaskID";
        dtSave.ValueREAL = result["TaskID"];
        dtSave.ValueHistory = result["Title"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.TypeREL = 1;
        dtSave.Table = "CRMT90041";
        dtSave.TableParent = "CRMT20301";
        dtSave.ColumnHistory = "Title";
    }

    if (acChoose == 4) {
        tableReset = "CRMT20401";
        dtSave.TableREL = "CRMT20301_CRMT20401_REL";
        dtSave.ColumnREL = "LeadID";
        dtSave.ColumnHistory = dtSave.ColumnREAL = "CampaignID";
        dtSave.ValueHistory = result["CampaignID"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT20401";
        dtSave.TableParent = "CRMT20301";
    }

    if (acChoose == 5) {
        tableReset = "CRMT10001";
        dtSave.TableREL = "CRMT20301_CRMT10001_REL";
        dtSave.ColumnREL = "LeadID";
        dtSave.ColumnHistory = dtSave.ColumnREAL = "ContactID";
        dtSave.ValueHistory = result["ContactID"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT10001";
        dtSave.TableParent = "CRMT20301";
    }

    ASOFT.helper.postTypeJson("/PopupSelectData/SaveREL", dtSave, function (result1) {
        if (result1) {
            refreshGrid(tableReset);
        }
    })
}