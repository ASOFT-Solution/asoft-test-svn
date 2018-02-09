$(document).ready(function () {
    LMF2072.LMF2072_Load();
});

/**
* Class LMF2072
*
* [Kim Vu] Create New [04/12/2017]
**/
var LMF2072 = new function () {

    /** 
    * layout viewmasterdetail 2
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.LayoutControl = function () {
        // FromDate - toDate
        $('.ToDate').parent().css('display', 'none');
        $('.FromDate').append(' - ' + $('.ToDate').text());
        $("#LMF2072_SubTitle1").after($("#tb_LMT2052"));
        $("#tb_LMT2052").after($("#LMF2072_SubTitle4"));
    };

    /**  
    * Load page
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.LMF2072_Load = function () {        
        this.LayoutControl();
        $("#BtnEdit").unbind('click');
        $("#BtnEdit").bind('click', LMF2072.CheckEdit);
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
        ASOFT.helper.postTypeJson("/LM/LMF2070/CheckEdit?voucherID=" + LMF2072.getUrlParameter("PK"), {}, function (result) {
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
* Change Language detail
*
* [Kim Vu] Create New [07/12/2017]
**/
function CustomizePanalSelect(tb, gridDT) {
    if (gridDT.element.context.id == 'GridLMT2052') {
        $($("#GridLMT2052 .k-header")[LMF2072.GetColIndex(gridDT, "ConvertedAmount")]).context.innerText =
            ASOFT.helper.getLanguageString("LMF2072.ConvertedAmount_LMT2052", "LMF2072", "LM");        
    }
}