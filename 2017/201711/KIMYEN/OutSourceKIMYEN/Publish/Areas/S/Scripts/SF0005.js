//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     27/11/2014      Đức Quý         Tạo mới
//####################################################################

SF0005 = new function () {
    this.fieldName = null;
    this.fileUploaded = 0;
    this.rowNum = 0;
    this.isPaging = false;
    this.grid = null;
    this.gridData = [];

    this.renderNumber = function () {
        return ++SF0005.rowNum;
    }

    // File uploader
    this.onUpload = function (data) {
        if (SF0005.fileUploaded > 0) {
            $('.k-upload-files .k-file:first').remove();
        }
        SF0005.fileUploaded++;
    }

    // File upload success
    this.onSuccess = function (data) {
        if (data && data.response.counter > 0) {
            SF0005.fieldName = data.response.array[0];
        }

        //ASOFT.asoftGrid.totalRow = data.response.data.length;
        //SF0005.grid.dataSource.total = ASOFT.asoftGrid.setTotalRow;
        //SF0005.grid.dataSource.data(data.response.data);
        SF0005.gridData = data.response.data;
        SF0005.grid.dataSource.read();
    };

    //Event button config
    this.btnSave_Click = function () {
        if (SF0005.gridData.length <= 0) {
            ASOFT.form.displayMessageBox('#SF0005', [ASOFT.helper.getMessage('00ML000067')]);
            return;
        }

        //var data = ASOFT.helper.dataFormToJSON('SF0005');
        var data = {};
        data.Islanguage = $('#IsLanguage').val();
        data.List = SF0005.gridData;

        var url = $('#UrlSF0005Update').val();
        ASOFT.helper.postTypeJson(url, data, SF0005.sf0005SaveSuccess);
    };

    this.sf0005SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'SF0005', function () {
            var grids = ASOFT.helper.getKendoUI($(window.parent.$('#contentMaster')), 'grid');
            $.each(grids, function () {
                this.value.dataSource.read();
            });
            SF0005.btnClose_Click();
        }, null, null, true);
    }

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };   
}

$(document).ready(function () {
    SF0005.grid = ASOFT.asoftGrid.castName("SF0005Grid");

    //if (SF0005.grid) {
    //    SF0005.grid.bind('dataBound', function () {
    //        SF0005.rowNum = 0;
    //        if (SF0005.gridData.length <= 0) {
    //            $.each(this.dataSource.data(), function (index, value) {
    //                if (typeof value !== 'function') {
    //                    SF0005.gridData.push(value);
    //                }
    //            });
    //        }
    //    });

    //    SF0005.grid.bind('dataBinding', function () {
    //        //var query = new kendo.data.Query(SF0005.gridData);
    //        //var data = query.skip((this.dataSource.page() * this.dataSource.pageSize() - 1)).take(this.dataSource.pageSize());
    //        //this.dataSource.data(data);
    //        SF0005.isPaging = true;
    //    });
    //}
});