
$(document).ready(function () {
    LayoutView();
    LoadPartialView();
});

function LayoutView() {

    for (var i = 0; i < 5; i++) {
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.first").css('width', '30%');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.middle").css('width', '60%');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.last").css('width', '94%');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.middle").css('border', '0px');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.middle .content-label").css('width', '15%');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.middle .dot").css('width', '15%');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.middle .content-text").css('width', '80%');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.last .content-label").css('width', '15%');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.last .dot").css('width', '2%');
        $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-content-block.last .content-text").css('width', '80%');
    }
}

function LoadPartialView() {
    var url = new URL(window.location.href);
    var pk = url.searchParams.get("PK");
    $.ajax({
        url: '/HRM/HRMF2040/LoadInterviewRound?pk=' + pk,
        type: "GET",
        async: false,
        success: function (result) {
            $("#ViewMaster").append(result);

            var total = $("#TotalLevel").val();
            // Layout into group
            for (var i = 0; i < 5; i++) {
                if (i < total) {
                    $("#HRMF2042_TabInfoRound" + (i + 1) + "-1 .asf-master-content").append($('#tblDetailTypeID0' + (i + 1)));
                } else {
                    $("#HRMF2042_TabInfoRound" + (i + 1)).kendoTabStrip().hide();
                }
            }
        }
    });
}

/**  
* Get data Send Mail
*
* [Kim Vu] Create New [11/12/2017]
**/
function customSendMail() {
    var dataSet = {};
    var url = "/HRM/Common/GetUsersSendMailRecruit"
    ASOFT.helper.postTypeJson(url, { formID: 'HRMF2041', recruitPeriodID: $(".RecruitPeriodID").html() }, function (result) {
        dataSet.EmailToReceiver = result;
    });
    return dataSet;
}