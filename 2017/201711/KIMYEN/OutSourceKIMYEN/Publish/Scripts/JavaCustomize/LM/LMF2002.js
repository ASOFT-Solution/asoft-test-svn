$(document).ready(function () {
    $('.ToDate').parent().css('display', 'none')
    $('.FromDate').append(' - ' + $('.ToDate').text())

    var isStatus = 0;
    ASOFT.helper.postTypeJson("/LM/LMF2000/LoadStage", {}, function (result) {
        for (var i = 0; i < result.length; i++) {
            var stage = "<a id='StatusNo" + result[i].OrderNo + "'><div class='asf-panel-master-stage-left {0}'><span>" + result[i].Description + "</span><div class='arrow-stage {1}'></div></div></a>";
            if ($(".StatusName").text() == result[i].Description) {
                isStatus = parseInt(result[i].OrderNo);
                stage = kendo.format(stage, "stageSelect", "arrowSelect");
            }
            else {
                stage = kendo.format(stage, "", "");
            }
            $($(".asfbtn")[1]).append(stage);
        }
    });
    $('#tb_LMT2011').before($('#LMF2002_SubTitle4'))
    ASOFT.helper.postTypeJson("/PartialView2/PartialPTLMF2002", { pk: getUrlParameter("PK"), DivisionID: getUrlParameter("DivisionID") }, function (result) {
        $('#LMF2002_SubTitle4-1 div.asf-master-content').html(result)

        if (isStatus == 0) {
            if ($('#IsCheck_PT').val() == 'True') {
                $('a#LockAdvanceAccount').parent().css('display', 'none');
            } else {
                $('a#RelieveAdvanceAccount').parent().css('display', 'none');
            }
            $('a#Payment').parent().css('display', 'none');
            $('a#Adjust').parent().css('display', 'none');
        } else if (isStatus == 1) {
            $('a#LockAdvanceAccount').parent().css('display', 'none');
            $('a#RelieveAdvanceAccount').parent().css('display', 'none');
            $('a#Disburse').parent().css('display', 'none');
            $('a#Adjust').parent().css('display', 'none');
            $('a#Finish').parent().css('display', 'none');
        } else if (isStatus == 2) {
            $('a#LockAdvanceAccount').parent().css('display', 'none');
            $('a#RelieveAdvanceAccount').parent().css('display', 'none');
            $('a#Disburse').parent().css('display', 'none');
            $('a#Payment').parent().css('display', 'none');
        } else if (isStatus == 9) {
            $('a#LockAdvanceAccount').parent().css('display', 'none');
            $('a#RelieveAdvanceAccount').parent().css('display', 'none');
            $('a#Disburse').parent().css('display', 'none');
            $('a#Payment').parent().css('display', 'none');
            $('a#Adjust').parent().css('display', 'none');
            $('a#Finish').parent().css('display', 'none');
        }
    });

    $("#tb_LMT2003").after($("#LMF2002_SubTitle4_1"));
});

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

function LMF2011PT_Click() {
    var urlLink = "/PopupLayout/Index/LM/LMF2011" + window.location.search.replace('LMT2001', 'LMT2011');
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

/**  
* Change Language detail
*
* [Kim Vu] Create New [07/12/2017]
**/
function CustomizePanalSelect(tb, gridDT) {
    if (gridDT.element.context.id == 'GridLMT2003') {
        $($("#GridLMT2003 .k-header")[GetColIndex(gridDT, "ConvertedAmount")]).context.innerText =
            ASOFT.helper.getLanguageString("LMF2001.ConvertedAmount_AssetID", "LMF2001", "LM");
    }
}

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}