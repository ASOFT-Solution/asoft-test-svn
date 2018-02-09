$(document).ready(function () {
    CSMF2054.Layout();
    CSMF2054.CustomEvent();
});

/**  
* Object CSMF2054
*
* [Kim Vu] Create New [30/01/2018]
**/
var CSMF2054 = new function () {

    /**  
    * Barcode control
    *
    * [Kim Vu] Create New [19/01/2018]
    **/
    this.btnBarcode = '<a class="asf-i-find-barcode-32 k-button-icontext k-button" id="btnFindBarCode" style="z-index:10001; position: absolute; top:0px;right: 0px; height: 25px; min-width: 50px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text"></span></a>';

    /**  
    * Layout control
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.Layout = function () {
        $(".VoucherNo").css("position", "relative");
        $(".VoucherNo .asf-filter-input").append(this.btnBarcode);
        $(".VoucherNo .asf-filter-input .asf-textbox").css('border', "1px solid #aaa");        
        $("#SaveClose").css('display', 'none');
        // Clear grid
        var grid = $("#GridEditCSMFT20531").data('kendoGrid');
        setTimeout(function () {
            grid.dataSource.data([]);
        }, 200);

    }

    /**  
    * Custom Event control
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.CustomEvent = function () {
        $("#btnFindBarCode").unbind('click');
        $("#btnFindBarCode").bind('click', CSMF2054.btnFind_Click);
        $("#VoucherNo").bind('keydown', CSMF2054.txt_keypress);
        $("#SaveNew").unbind('click');
        $("#SaveNew").bind('click', CSMF2054.Save);
        $("#Close").unbind('click');
        $("#Close").bind('click', CSMF2054.Close);
    }

    /**  
   * Load Grid
   *
   * [Kim Vu] create new [25/01/2018]
   **/
    this.LoadGrid = function (e) {
        var grid = $("#GridEditCSMFT20531").data('kendoGrid');
        var rowCount = grid.dataSource.data().length;
        if (rowCount >= 50) {
            ASOFT.dialog.showMessage('CSFML000006');
            return;
        }
        var url = "/CSM/CSMF2050/GetDataGridCSMF2054";
        var data = {
            txtSearch: $("#VoucherNo").val(),
            apk: window.parent.$("#PK").val()
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.length > 0) {
                result.forEach(function (row) {
                    if (!CSMF2054.CheckContain(grid, row)) {
                        grid.dataSource._data.push(row);
                    }
                });
            } else {
                ASOFT.dialog.showMessage('CSFML000005')
            }
        });
        setTimeout(function () {
            $("#VoucherNo").focus();
        }, 200);
        grid.refresh();
    }

    /**  
    * Check contain APK
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.CheckContain = function (grid, dataRow) {
        var check = false;
        grid.dataSource._data.forEach(function (currentRow) {
            if (currentRow.VoucherNo == dataRow.VoucherNo)
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
        var grid = $("#GridEditCSMFT20531").data('kendoGrid');
        if (grid &&
            grid.dataSource._data.length == 0) {
            var msg = ASOFT.helper.getMessage("00ML000061");
            ASOFT.form.displayError("#CSMF2054", msg);
            return false;
        }

        return true;
    }

    // #region  --- Event Handle ---

    /**  
    * Call CSMF2054 
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.btnFind_Click = function (e) {
        CSMF2054.LoadGrid();
    }

    /**  
    * Key press dispatchID
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.txt_keypress = function (e) {
        if (e.keyCode == 13) {
            CSMF2054.LoadGrid();
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
                CSMF2054.Save,
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
        if (!CSMF2054.TestInput())
            return;
        var urlSave = "/CSM/CSMF2050/DoExecuteDataCSMF2054";
        var dataGrid = [];
        var grid = $("#GridEditCSMFT20531").data('kendoGrid');
        var APKList = [];
        dataGrid = grid.dataSource.data().forEach(function (row) {
            APKList.push(row.APK);
        });
        var dataSave = {
            apkMaster: window.parent.$("#PK").val(),
            APKList: APKList
        };
        ASOFT.helper.postTypeJson(urlSave, dataSave, function (result) {
            if (result) {
                ASOFT.dialog.showMessage('00ML000015');
                grid.dataSource.data([]);
            } else {
                ASOFT.dialog.showMessage('00ML000062');
            }
        });
    }

    // #endregion  --- Event Handle ---
}