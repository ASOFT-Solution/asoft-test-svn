$(document)
    .ready(function() {
        $("#FormReportFilter").prepend("<table id='tableDivision' style='width:93%;'>" + "</table>");
        $("#tableDivision").append($(".DivisionID"));
        $(".DivisionID").attr("style", "margin:auto");
        $("#tableDivision")
            .after("<fieldset id = 'report' class = 'asf-form-container container_12 pagging_bottom' style = 'width:600px;'><legend>Báo cáo</legend><table id = 'tableHeader' class='asf-table-view' ></table></fieldset>");

        $("#report")
            .after("<fieldset id = 'report' class = 'asf-form-container container_12 pagging_bottom' style = 'width:600px;'><legend>Tiêu chí chon lọc</legend><table id = 'tableFooter' class='asf-table-view' ></table></fieldset>");
        $("#tableHeader").append($(".ReportID"), $(".ReportName"), $(".ReportTitle"));
        $("#tableFooter")
            .append($(".DivisionID"),
                $(".DepartmentID"),
                $(".RecruitPeriodName"),
                $(".RecruitPeriodID"),
                $(".DutyID"),
                $(".CandidateName"),
                $(".CandidateID"),
                $(".InterviewLevelName"));
        $("#btnDeleteCandidateName").css('right', '70px');
        $("#btnCandidateName").css('right', '100px');
        $("#btnDeleteRecruitPeriodName").css('right', '70px');
        $("#btnRecruitPeriodName").css('right', '100px');
        $(".RecruitPeriodID").css('display', 'none');
        $(".CandidateID").css('display', 'none');
        $("#ReportTitle").val($("#ReportName").val().toUpperCase());

        $("#btnCandidateName")
            .bind('click',
                function() {
                    currentChoose = "CandidateID";
                    var urlChoose = "/PopupSelectData/Index/HRM/HRMF2035?ScreenID=HRMF3011&RecruitPeriodID=" + $("#RecruitPeriodID").val();
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftPopup.showIframe(urlChoose, {});
                });
        $("#btnRecruitPeriodName")
            .bind('click',
                function() {
                    currentChoose = "RecruitPeriodName";
                    var urlChoose = "/PopupSelectData/Index/HRM/HRMF2034?ScreenID=HRMF3011";
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftPopup.showIframe(urlChoose, {});
                });

    });

var currentChoose = "";
function receiveResult(result) {
    switch (currentChoose) {
        case "CandidateID":
            $("#CandidateID").val(result.CandidateID);
            $("#CandidateName").val(result.CandidateName);
            break;
        case "RecruitPeriodName":
            $("#RecruitPeriodID").val(result.RecruitPeriodID);
            $("#RecruitPeriodName").val(result.RecruitPeriodName);
            break;
    }
}
