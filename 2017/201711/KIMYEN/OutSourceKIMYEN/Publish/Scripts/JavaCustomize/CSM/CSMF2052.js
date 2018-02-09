$(document).ready(function () {
    CSMF2052.Layout();
    CSMF2052.CustomEvent();
});

/**  
* Object CSMF2052
*
* [Kim Vu] Create New [30/01/2018]
**/
var CSMF2052 = new function () {

    /**  
    * Block control
    *
    * [Kim Vu] Create New [19/01/2018]
    **/
    this.block = '<div class="{0}" style="width:46.5%"><fieldset id="{1}"><legend style="padding:10px"><label>{2}</label></legend><div class="asf-table-view"></div></fieldset></div>';

    /**  
    * Layout control
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.Layout = function () {
        var divNotes = $(".Notes").parent().parent().parent();
        // Add Block right thông tin bên giao
        var text = ASOFT.helper.getLanguageString("CSMF2051.Group2", "CSMF2051", "CSM");
        $(divNotes).after(kendo.format(this.block, "asf-content-block last", "Group2", text));

        // Nạp control vào group2
        $("#Group2 .asf-table-view").append(
            $($(".ReceiveName").parent()),
            $($(".ReceiveAddress").parent()),
            $($(".ReceiveContact").parent()),
            $($(".ReceiveTel").parent()),
            $($(".ReceiveEmail").parent()))

        // Add Block left thông tin bên giao
        text = ASOFT.helper.getLanguageString("CSMF2051.Group1", "CSMF2051", "CSM");
        $(divNotes).after(kendo.format(this.block, "asf-content-block first", "Group1", text));

        // Nạp control vào group1
        $("#Group1 .asf-table-view").append(
            $($(".SenderName").parent()),
            $($(".SenderAddress").parent()),
            $($(".SenderContact").parent()),
            $($(".SenderTel").parent()),
            $($(".SenderEmail").parent()))

        $("#tb_CSMT2051").after($("#CSMF2052_GroupCheckOrderReturn"));
    }

    /**  
    * Custom Event control
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.CustomEvent = function () {
        $("#BtnAddNew_CSMF2053_CSMT2051").unbind('click');
        $("#BtnAddNew_CSMF2053_CSMT2051").bind('click', CSMF2052.btnAdd_Click);
        $("#BtnDelete_CSMF2053_CSMT2051").unbind('click');
        $("#BtnDelete_CSMF2053_CSMT2051").bind('click', CSMF2052.btnDeleteCSMF2053);
    }

    /**  
    * Reload grid
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.ReLoadGridCSMT2051 = function () {
        var grid = $("#GridCSMT2051").data('kendoGrid');
        if (grid) {
            grid.dataSource.page(1);
        }
    }

    // #region  --- Event Handle ---

    /**  
    * Call CSMF2053 
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.btnAdd_Click = function (e) {
        var url = "/PopupMasterDetail/Index/CSM/CSMF2053?Pk=" + $("#PK").val() + "&Table=CSMT2050&key=APK&DivisionID=VF";
        ASOFT.asoftPopup.showIframe(url, {});
    }

    /**  
    * Xác nhận gửi hàng
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.ConfirmSendOrder_Click = function (e) {
        var url = "/PopupLayout/Index/CSM/CSMF2055?Pk=" + $("#PK").val() + "&Table=CSMT2050&key=APK&DivisionID=VF";
        ASOFT.asoftPopup.showIframe(url, {});
    }

    /**  
    * Hoàn tất gửi hàng
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.CompletedSendOrder_Click = function (e) {
        var url = "/CSM/CSMF2050/ConfirmCompletedOrder";
        ASOFT.helper.postTypeJson(url, { apk: $("#PK").val() }, function (result) {
            if (result) {
                ASOFT.dialog.showMessage('00ML000015');
            } else {
                ASOFT.dialog.showMessage('00ML000062');
            }
        });
    }

    /**  
    * Xác nhận biên bản trả hàng
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.ConfirmReturnOrder_Click = function (e) {
        var url = "/PopupMasterDetail/Index/CSM/CSMF2054";
        ASOFT.asoftPopup.showIframe(url, {});
    }

    /**  
    * Xoa du lieu detail
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.btnDeleteCSMF2053 = function (e) {
        var url = "/CSM/CSMF2050/DoDeleteCSMF2053";
        var APKList = [];
        var GridKendo = $('#GridCSMT2051').data('kendoGrid');
        var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
        if (records.length == 0) return;
        records.forEach(function (row) {
            APKList.push(row.APK);
        });
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            ASOFT.helper.postTypeJson(url, { APKList: APKList, APKMaster: $("PK").val() }, function (result) {
                if (result.length > 0 && result[0].MessageID != "") {
                    ASOFT.dialog.showMessage(result[0].MessageID)
                } else {
                    ASOFT.dialog.showMessage('00ML000057')
                }
                GridKendo.dataSource.page(1);
            });
        });

    }

    // #endregion  --- Event Handle ---
}