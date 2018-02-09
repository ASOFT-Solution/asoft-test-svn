


$(document).ready(function () {
    $("#GR_LichSu").hide();
    $("#GR_DinhKem").hide();
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": customDelete_Click
    });

    ASOFT.helper.postTypeJson("/CRM/CRMF2080/LoadRequestStatus", {}, function (result) {
        for (var i = 0; i < result.length; i++) {
            var stage = "<a onclick=updateStage_Click('" + result[i].ID + "',this)><div class='asf-panel-master-stage-left {0}'><span>" + result[i].Description + "</span><div class='arrow-stage {1}'></div></div></a>";
            if (parseInt($(".RequestStatus").text()) == result[i].ID)
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
        stgList.push("- 'CRMF2082.RequestStatusName.CRM': " + $(".RequestStatusName").text() + " -> " + $(stgN).find('span').text());
        ASOFT.helper.postTypeJson("/CRM/CRMF2080/UpdateStatus", stgList, function (result) {
            if (result.check) {
                $(".RequestStatus").text(stg);
                $(".RequestStatusName").text($(stgN).find('span').text());
                $(".LastModifyDate").text(result.DateTime);
                $(".LastModifyUserID").text(result.User);
                $(".asf-panel-master-stage-left").remove();
                $("#loading").remove();
                refreshGrid("CRMT00003");

                ASOFT.helper.postTypeJson("/CRM/CRMF2080/LoadRequestStatus", {}, function (result) {
                    for (var i = 0; i < result.length; i++) {
                        var stage = "<a onclick=updateStage_Click('" + result[i].ID + "',this)><div class='asf-panel-master-stage-left {0}'><span>" + result[i].Description + "</span><div class='arrow-stage {1}'></div></div></a>";
                        if ($(".RequestStatus").text() == result[i].ID)
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

function customDelete_Click() {
    var args = [],
        list = [],
        requestID = $(".RequestID").text();
    ASOFT.form.clearMessageBox();
    pk = pk + "," + $(".DivisionID").text();

    if (typeof DeleteViewMasterDetail2 === "function") {
        pk = DeleteViewMasterDetail2(pk);
    }
    args.push(pk);
    list.push(table, key);
    args.push(requestID);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldel, list, args, deleteSuccess);
    });
}

