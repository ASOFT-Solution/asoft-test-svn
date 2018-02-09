$(document).ready(function () {
    CSMF2053.Layout();
    CSMF2053.CustomEvent();
});

/**  
* Object CSMF2053
*
* [Kim Vu] Create New [30/01/2018]
**/
var CSMF2053 = new function () {

    /**  
    * Barcode control
    *
    * [Kim Vu] Create New [19/01/2018]
    **/
    // this.btnBarcode = '<a class="asf-i-find-barcode-32 k-button-icontext k-button" id="btnFindBarCode" style="z-index:10001; position: absolute; top:0px;right: 0px; height: 25px; min-width: 50px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text"></span></a>';

    /**  
    * Layout control
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.Layout = function () {
        //$(".VoucherNo_REL").css("position", "relative");
        //$(".VoucherNo_REL .asf-filter-input").append(this.btnBarcode);
        //$(".VoucherNo_REL .asf-filter-input .asf-textbox").css('border', "1px solid #aaa");
        $(".VoucherNo_REL").css("display", "none");
        $(".asf-form-container.container_12.pagging_bottom").css('display', 'none');
        //$("#SaveClose").css('display', 'none');
        // Clear grid
        var grid = $("#GridEditCSMT20511").data('kendoGrid');
        setTimeout(function () {
            // Check grid default clear row default
            if (grid.dataSource._data.length == 1 && (grid.dataSource._data[0].VoucherNo_REL == null 
                || grid.dataSource._data[0].VoucherNo_REL == "" ||
                grid.dataSource._data[0].VoucherNo_REL == undefined)) {
                    grid.dataSource.data([]);
            }
        }, 200);

    }

    /**  
    * Custom Event control
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.CustomEvent = function () {
        //$("#btnFindBarCode").unbind('click');
        //$("#btnFindBarCode").bind('click', CSMF2053.btnFind_Click);
        //$("#VoucherNo_REL").bind('keydown', CSMF2053.txt_keypress);
        $("#Save").unbind('click');
        $("#Save").bind('click', CSMF2053.Save);
        $("#Close").unbind('click');
        $("#Close").bind('click', CSMF2053.Close);
    }

    /**  
   * Load Grid
   *
   * [Kim Vu] create new [25/01/2018]
   **/
    this.LoadGrid = function (e) {
        //var grid = $("#GridEditCSMT20511").data('kendoGrid');
        //var rowCount = grid.dataSource.data().length;
        ////if (rowCount >= 50) {
        ////    ASOFT.dialog.showMessage('CSFML000006');
        ////    return;
        ////}
        //var url = "/CSM/CSMF2050/GetDataGridCSMF2053";
        //var data = {
        //    txtSearch: window.parent.$("#PK").val()
        //};
        //ASOFT.helper.postTypeJson(url, data, function (result) {
        //    if (result.length > 0) {
        //        result.forEach(function (row) {
        //            if (!CSMF2053.CheckContain(grid, row)) {
        //                grid.dataSource._data.push(row);
        //            }
        //        });
        //    }
        //});
        //grid.refresh();
    }

    /**  
    * Check contain APK
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.CheckContain = function (grid, dataRow) {
        var check = false;
        grid.dataSource._data.forEach(function (currentRow) {
            if (currentRow.VoucherNo_REL == dataRow.VoucherNo_REL)
                check = true;
        });
        return check;
    }

    /**  
    * Check Input
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.TestInput = function () {
        ASOFT.form.clearMessageBox();

        var grid = $("#GridEditCSMT20511").data('kendoGrid');
        if (grid &&
            grid.dataSource._data.length == 0) {
            var msg = ASOFT.helper.getMessage("00ML000061");
            ASOFT.form.displayError("#CSMF2053", msg);
            return false;
        }

        return true;
    }

    // #region  --- Event Handle ---

    /**  
    * Call CSMF2053 
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.btnFind_Click = function (e) {
        CSMF2053.LoadGrid();
    }

    /**  
    * Key press dispatchID
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.txt_keypress = function (e) {
        if (e.keyCode == 13) {
            CSMF2053.LoadGrid();
        }
    }

    /**  
   * Close form
   *
   * [Kim Vu] Create New [26/01/2018]
   **/
    this.Close = function (e) {
        if (isDataChanged()) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                CSMF2053.Save,
                function () {
                    parent.popupClose();
                });
        }
        else {
            parent.popupClose();
        }
        window.parent.CSMF2052.ReLoadGridCSMT2051();
    }

    /**  
    * Save Data
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.Save = function (e) {
        // Kiem tra nhap lieu
        if (!CSMF2053.TestInput())
            return;
        var urlSave = "/CSM/CSMF2050/DoExecuteData";
        var dataGrid = [];
        var grid = $("#GridEditCSMT20511").data('kendoGrid');
        dataGrid = grid.dataSource.data();
        var dataSave = {
            apkMaster: window.parent.$("#PK").val(),
            dataGrid: dataGrid
        };
        ASOFT.helper.postTypeJson(urlSave, dataSave, function (result) {
            if (result) {
                ASOFT.dialog.showMessage('00ML000015');
                parent.popupClose();
            } else {
                ASOFT.dialog.showMessage('00ML000062');
            }
        });
    }

    // #endregion  --- Event Handle ---
}