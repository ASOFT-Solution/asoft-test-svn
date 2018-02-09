$(document).ready(function () {
    LMF2062.LMF2062_Load();
});

/**
* Class LMF2062
*
* [Kim Vu] Create New [04/12/2017]
**/
var LMF2062 = new function () {

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
    };

    /**  
    * Load page
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.LMF2062_Load = function () {        
        this.LayoutControl();
        $("#BtnEdit").unbind('click');
        $("#BtnEdit").bind('click', LMF2062.CheckEdit);
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
        ASOFT.helper.postTypeJson("/LM/LMF2060/CheckEdit?voucherID=" + LMF2062.getUrlParameter("PK"), {}, function (result) {
            if (result && result.length > 0) {
                if (result[0].Status != 0) {
                    ASOFT.dialog.messageDialog(ASOFT.helper.getMessage(result[0].Message));                                            
                } else {
                    BtnEdit_Click();
                }
            } else {
                BtnEdit_Click();
            }
        });
    }

};
