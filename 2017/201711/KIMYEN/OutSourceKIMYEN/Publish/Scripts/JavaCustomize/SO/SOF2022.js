var IsConfirm = 0;
var acChoose = null;
var QuotationStatusName = null;
var isPrint = false;
$(document).ready(function () {
    $("#refLinkCRMT90031").val("NotesSubject");
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();

    //$("#BtnEdit").unbind();
    //$("#BtnEdit").kendoButton({
    //    "click": CustomEdit_Click
    //});

    ASOFT.helper.postTypeJson("/SO/SOF2020/LoadStatus", {}, function (result) {
        for (var i = 0; i < result.length; i++) {
            var QuotationStatus = "<a onclick=updateStage_Click('" + result[i].QuotationStatus + "',this)><div class='asf-panel-master-stage-left {0}'><span>" + result[i].QuotationStatusName + "</span><div class='arrow-stage {1}'></div></div></a>";
            if ($(".QuotationStatus").text() == result[i].QuotationStatus) {
                QuotationStatusName = result[i].QuotationStatusName;
                QuotationStatus = kendo.format(QuotationStatus, "stageSelect", "arrowSelect");
            }
            else
                QuotationStatus = kendo.format(QuotationStatus, "", "");
            $($(".asfbtn")[1]).append(QuotationStatus);
        }
    });
})

function GetCheckConfirm() {
    return IsConfirm;
}


//function CustomEdit_Click() {
//    var data = [];
//    data.push($(".DivisionID").text());
//    data.push($(".TranMonth").text());
//    data.push($(".TranYear").text());
//    data.push($(".QuotationID").text());
//    ASOFT.helper.postTypeJson("/SO/SOF2000/CheckConfirm", data, function (result) {
//        if (result.Message != null && result.Message != "") {
//            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage(result.Message),
//            function () {
//                IsConfirm = 1;
//                ASOFT.form.clearMessageBox();
//                ASOFT.asoftPopup.showIframe($("#urlEdit").val(), {});
//            },
//            function () {   
//                IsConfirm = 0;
//                return false;
//            });
//        }
//        else {
//            IsConfirm = 0;
//            ASOFT.form.clearMessageBox();
//            ASOFT.asoftPopup.showIframe($("#urlEdit").val(), {});
//        }
//    });
//}

function updateStage_Click(stg,stgN) {
    $("#contentMaster").after('<div id="loading" style="position: absolute;top: 50%;left: 50%;"><img src="/Content/Images/BlueOpal/loading-image.gif"/></div>');
    setTimeout(function () {
        var stgList = [];
        stgList.push(stg);
        stgList.push($("#PK").val());
        stgList.push("- 'SOF2022.QuotationStatus.SO': " + QuotationStatusName + " -> " + $(stgN).find('span').text());
        ASOFT.helper.postTypeJson("/SO/SOF2020/UpdateStatus", stgList, function (result) {
            if (result.check) {
                $(".QuotationStatus").text(stg)
                $(".LastModifyDate").text(result.DateTime);
                $(".LastModifyUserID").text(result.User);
                $(".asf-panel-master-stage-left").remove();
                $("#loading").remove();

                ASOFT.helper.postTypeJson("/SO/SOF2020/LoadStatus", {}, function (result) {
                    for (var i = 0; i < result.length; i++) {
                        var QuotationStatus = "<a onclick=updateStage_Click('" + result[i].QuotationStatus + "')><div class='asf-panel-master-stage-left {0}'><span>" + result[i].QuotationStatusName + "</span><div class='arrow-stage {1}'></div></div></a>";
                        if ($(".QuotationStatus").text() == result[i].QuotationStatus) {
                            QuotationStatusName = result[i].QuotationStatusName;
                            QuotationStatus = kendo.format(QuotationStatus, "stageSelect", "arrowSelect");
                        }
                        else
                            QuotationStatus = kendo.format(QuotationStatus, "", "");
                        $($(".asfbtn")[1]).append(QuotationStatus);
                    }
                });
            }
        })
    }, 500);
}

function BtnChoose_Custom(tb) {
    var urlChoose = "/PopupSelectData/Index/CRM/{0}?DivisionID=" + $("#EnvironmentDivisionID").val();
    if (tb == "CRMT90051") {
        urlChoose = kendo.format(urlChoose, "CRMF9010");
        acChoose = 1;
    }
    if (tb == "CRMT90041") {
        urlChoose = kendo.format(urlChoose, "CRMF9011");
        acChoose = 2;
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
        dtSave.TypeREL = 5;
        dtSave.Table = "CRMT90051";
        dtSave.TableParent = "OT2101";
        dtSave.ColumnHistory = "EventSubject";
    }
    if (acChoose == 2) {
        tableReset = "CRMT90041";
        dtSave.TableREL = "CRMT90041_REL";
        dtSave.ColumnREL = "RelatedToID";
        dtSave.ColumnREAL = "TaskID";
        dtSave.ValueREAL = result["TaskID"];
        dtSave.ValueHistory = result["Title"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.TypeREL = 5;
        dtSave.Table = "CRMT90041";
        dtSave.TableParent = "OT2101";
        dtSave.ColumnHistory = "Title";
    }

    ASOFT.helper.postTypeJson("/PopupSelectData/SaveREL", dtSave, function (result1) {
        if (result1)
        {
            refreshGrid(tableReset);
        }
    })
}


function CustomerPrint() {
    var URLDoPrintorExport = '/SO/SOF2020/DoPrintOrExport';
    var dataFilter = {};
    dataFilter.DivisionID = $(".DivisionID").text();
    dataFilter.QuotationID = $("#PK").val();
    var url = URLDoPrintorExport;
    isPrint = true;
    ASOFT.helper.postTypeJson(url, dataFilter, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/SO/SOF2020/ReportViewer';
        var urlExcel = '/SO/SOF2020/ExportReport';
        //var urlPost = isPrint ? urlPrint : urlExcel;
        //var options = isPrint ? '&viewer=pdf' : '';
        var urlPost;
        var options = '';

        if (isPrint) {
            urlPost = !isMobile ? urlPrint : urlExcel;
            options = !isMobile ? '&viewer=pdf' : '&viewer=pdf&mobile=mobile';
        }
        else
            urlPost = urlExcel;

        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        if (isPrint)
            if (!isMobile)
                window.open(fullPath, "_blank");
            else
                window.location = fullPath;
        else {
            window.location = fullPath;
        }
    }
}
