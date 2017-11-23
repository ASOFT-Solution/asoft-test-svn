var acChoose = null;

$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
    $("#refLinkCRMT90031").val("NotesSubject");

    ASOFT.helper.postTypeJson("/CRM/CRMF2050/LoadStage", {type : "1,2"}, function (result) {
        for (var i = 0; i < result.length; i++) {
            var stage = "<a onclick=updateStage_Click('" + result[i].StageID + "'," + result[i].Rate + ",this)><div class='asf-panel-master-stage-left {0}'><span>" + result[i].StageName + "</span><div class='arrow-stage {1}'></div></div></a>";
            if ($(".StageID").text() == result[i].StageID)
                stage = kendo.format(stage, "stageSelect", "arrowSelect");
            else
                stage = kendo.format(stage, "", "");
            $($(".asfbtn")[1]).append(stage);
        }
    });

    $(".Rate").text(formatDecimal(kendo.parseFloat($(".Rate").text())))
});


function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}


function DeleteViewMasterDetail2(pk) {
    pk = $(".OpportunityID").text();
    return pk;
}

function updateStage_Click(stg, rate, stgN)
{
    $("#contentMaster").after('<div id="loading" style="position: absolute;top: 50%;left: 50%;"><img src="/Content/Images/BlueOpal/loading-image.gif"/></div>');
    setTimeout(function () {
        var stgList = [];
        stgList.push(stg);
        stgList.push($("#PK").val());
        stgList.push(rate);
        stgList.push("- 'CRMF2052.StageID.CRM': " + $(".StageName").text() + " -> " + $(stgN).find('span').text() + "</br> - 'CRMF2052.Rate.CRM': " + $(".Rate").text() + " -> " + rate);
        ASOFT.helper.postTypeJson("/CRM/CRMF2050/UpdateStage", stgList, function (result) {
            if (result.check) {
                $(".StageID").text(stg);
                $(".Rate").text(formatDecimal(rate));
                $(".StageName").text($(stgN).find('span').text());
                $(".LastModifyDate").text(result.DateTime);
                $(".LastModifyUserID").text(result.User);
                $(".asf-panel-master-stage-left").remove();
                $("#loading").remove();
                refreshGrid("CRMT00003");

                ASOFT.helper.postTypeJson("/CRM/CRMF2050/LoadStage", { type: "1,2" }, function (result) {
                    for (var i = 0; i < result.length; i++) {
                        var stage = "<a onclick=updateStage_Click('" + result[i].StageID + "'," + result[i].Rate + ",this)><div class='asf-panel-master-stage-left {0}'><span>" + result[i].StageName + "</span><div class='arrow-stage {1}'></div></div></a>";
                        if ($(".StageID").text() == result[i].StageID)
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

function BtnChoose_Custom(tb) {
    var urlChoose = "/PopupSelectData/Index/{1}/{0}?DivisionID=" + ($(".DivisionID").val() == "" ? $("#EnvironmentDivisionID").val() : $(".DivisionID").text());
    if (tb == "CRMT90051") {
        urlChoose = kendo.format(urlChoose, "CRMF9010", "CRM");
        acChoose = 1;
    }
    if (tb == "CRMT90041") {
        urlChoose = kendo.format(urlChoose, "CRMF9011", "CRM");
        acChoose = 2;
    }
    if (tb == "CRMT20301") {
        urlChoose = kendo.format(urlChoose, "CRMF9014", "CRM");
        acChoose = 3;
    }
    if (tb == "CRMT10001") {
        urlChoose = kendo.format(urlChoose, "CRMF9002", "CRM");
        acChoose = 4;
    }
    if (tb == "OT2101") {
        urlChoose = kendo.format(urlChoose, "SOF2024", "SO");
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
        dtSave.TypeREL = 4;
        dtSave.Table = "CRMT90051";
        dtSave.TableParent = "CRMT20501";
        dtSave.ColumnHistory = "EventSubject";
    }
    if (acChoose == 3) {
        tableReset = "CRMT20301";
        dtSave.TableREL = "CRMT20501_CRMT20301_REL";
        dtSave.ColumnREL = "OpportunityID";
        dtSave.ColumnHistory = dtSave.ColumnREAL = "LeadID";
        dtSave.ValueHistory = result["LeadID"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT20301";
        dtSave.TableParent = "CRMT20501";
    }

    if (acChoose == 2) {
        tableReset = "CRMT90041";
        dtSave.TableREL = "CRMT90041_REL";
        dtSave.ColumnREL = "RelatedToID";
        dtSave.ColumnREAL = "TaskID";
        dtSave.ValueHistory = result["Title"];
        dtSave.ValueREAL = result["TaskID"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.TypeREL = 4;
        dtSave.Table = "CRMT90041";
        dtSave.TableParent = "CRMT20501";
        dtSave.ColumnHistory = "Title";
    }

    if (acChoose == 4) {
        tableReset = "CRMT10001";
        dtSave.TableREL = "CRMT20501_CRMT10001_REL";
        dtSave.ColumnREL = "OpportunityID";
        dtSave.ColumnHistory = dtSave.ColumnREAL = "ContactID";
        dtSave.ValueHistory = result["ContactID"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT10001";
        dtSave.TableParent = "CRMT20501";
    }

    if (acChoose == 5) {
        tableReset = "OT2101";
        dtSave.TableREL = "CRMT20501_OT2101_REL";
        dtSave.ColumnREL = "OpportunityID";
        dtSave.ColumnREAL = "QuotationID";
        dtSave.ValueHistory = result["QuotationNo"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "OT2101";
        dtSave.TableParent = "CRMT20501";
        dtSave.ColumnHistory = "QuotationNo"
    }

    ASOFT.helper.postTypeJson("/PopupSelectData/SaveREL", dtSave, function (result1) {
        if (result1) {
            refreshGrid(tableReset);
        }
    })
}