$(document).ready(function () {
    LMF2052.LMF2052_Load();
});

/**
* Class LMF2052
*
* [Kim Vu] Create New [04/12/2017]
**/
var LMF2052 = new function () {

    this.isStatus = 0;

    /** 
    * layout viewmasterdetail 2
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.LayoutControl = function () {
        // FromDate - toDate
        $('.ToDate').parent().css('display', 'none');
        $('.FromDate').append(' - ' + $('.ToDate').text());
        $("#LMF2052_SubTitle1").after($("#tb_LMT2052"));
        $("#tb_LMT2052").after($("#tb_LMT2053"));
        $("#tb_LMT2053").after($("#LMF2052_SubTitle4"));
        $("#LMF2052_SubTitle4").after($("#LMF2052_SubTitle5"));
        $("#LMF2052_SubTitle5").after($("#LMF2052_SubTitle6"));
    };

    /**
    * Get view phong toa
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.GetDataSubTitle5 = function () {
        ASOFT.helper.postTypeJson("/PartialView2/PartialPTLMF2002", { pk: LMF2052.getUrlParameter("PK"), DivisionID: LMF2052.getUrlParameter("DivisionID"), screenID: "LMF2052" }, function (result) {
            $('#LMF2052_SubTitle5-1 div.asf-master-content').html(result)

            if (LMF2052.isStatus == 0) {
                if ($('#IsCheck_PT').val() == 'True') {
                    $('a#LockAdvanceAccount').parent().css('display', 'none');
                } else {
                    $('a#RelieveAdvanceAccount').parent().css('display', 'none');
                }
            } else if (LMF2052.isStatus == 1) {
                $('a#LockAdvanceAccount').parent().css('display', 'none');
                $('a#RelieveAdvanceAccount').parent().css('display', 'none');
            } else if (LMF2052.isStatus == 2) {
                $('a#LockAdvanceAccount').parent().css('display', 'none');
                $('a#RelieveAdvanceAccount').parent().css('display', 'none');
            } else if (LMF2052.isStatus == 9) {
                $('a#LockAdvanceAccount').parent().css('display', 'none');
                $('a#RelieveAdvanceAccount').parent().css('display', 'none');
            }
        });
    };

    /**  
    * Fill Color for status
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.LoadStatus = function () {
        ASOFT.helper.postTypeJson("/LM/LMF2050/LoadStage", {}, function (result) {
            for (var i = 0; i < result.length; i++) {
                var stage = "<a id='StatusNo" + result[i].OrderNo + "'><div class='asf-panel-master-stage-left {0}'><span>" + result[i].Description + "</span><div class='arrow-stage {1}'></div></div></a>";
                if ($(".Status").text() == result[i].OrderNo) {
                    LMF2052.isStatus = parseInt(result[i].OrderNo);
                    stage = kendo.format(stage, "stageSelect", "arrowSelect");
                }
                else {
                    stage = kendo.format(stage, "", "");
                }
                $($(".asfbtn")[1]).append(stage);
            }
        });
    };

    /**  
    * Load page
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.LMF2052_Load = function () {
        this.LoadStatus();
        this.LayoutControl();
        this.GetDataSubTitle5();

        $("#BtnEdit").unbind('click');
        $("#BtnEdit").bind('click', LMF2052.CheckEdit);
    };

    /**  
    * Get data of param
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.getUrlParameter = function (param) {
        var url = new URL(window.location.href);
        var result = url.searchParams.get(param);
        return result;
    }

    /**  
    * Check Edit
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.CheckEdit = function () {
        // Kiem tra sua data
        ASOFT.helper.postTypeJson("/LM/LMF2050/CheckEdit?voucherID=" + LMF2052.getUrlParameter("PK"), {}, function (result) {
            if (result && result.length > 0) {
                if (result[0].Status == 3) {
                    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage(result[0].Message), function () {
                        BtnEdit_Click();
                    });
                } else {
                    BtnEdit_Click();
                }
            } else {
                BtnEdit_Click();
            }
        });
    }

    /**  
    * Get Col Index
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.GetColIndex = function (grid, columnName) {
        var columns = grid.columns;
        for (var i = 0; i < columns.length; i++) {
            if (columns[i].field == columnName)
                return i;
        }
        return 0;
    }
};

/**  
* Call form LMF2011
*
* [Kim Vu] Create New [04/12/2017]
**/
function LMF2011PT_Click() {
    var urlLink = "/PopupMasterDetail/Index/LM/LMF2011" + window.location.search.replace('LMT2051', 'LMT2011');
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

/**  
* Change Language detail
*
* [Kim Vu] Create New [07/12/2017]
**/
function CustomizePanalSelect(tb, gridDT) {
    if (gridDT.element.context.id == 'GridLMT2052') {
        $($("#GridLMT2052 .k-header")[LMF2052.GetColIndex(gridDT, "ConvertedAmount")]).context.innerText =
            ASOFT.helper.getLanguageString("LMF2052.ConvertedAmount_LMT2052", "LMF2052", "LM");
    }
    //else if (gridDT.element.context.id == 'GridLMT2053') {
    //    $($("#GridLMT2053 .k-header")[LMF2052.GetColIndex(gridDT, "ConvertedAmount")]).context.innerText =
    //        ASOFT.helper.getLanguageString("LMF2052.ConvertedAmount_LMT2053", "LMF2052", "LM");
    //}

}