$(document).ready(function () {
    $('.ToDate').parent().css('display', 'none')
    $('.FromDate').append(' - ' + $('.ToDate').text())


    ASOFT.helper.postTypeJson("/LM/LMF2000/LoadStage", {}, function (result) {
        for (var i = 0; i < result.length; i++) {
            var stage = "<a onclick=updateStage_Click('" + result[i].OrderNo + "',this)><div class='asf-panel-master-stage-left {0}'><span>" + result[i].Description + "</span><div class='arrow-stage {1}'></div></div></a>";
            if ($(".StatusName").text() == result[i].Description)
                stage = kendo.format(stage, "stageSelect", "arrowSelect");
            else
                stage = kendo.format(stage, "", "");
            $($(".asfbtn")[1]).append(stage);
        }
    });
});