//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     27/10/2014      Đức Quý         Tạo mới
//####################################################################

CIF0010 = new function () {

    //Event button config
    this.btnConfig_Click = function () {
        if (ASOFT.form.checkRequired("CIF0010")) {
            return;
        }

        var data = ASOFT.helper.dataFormToJSON('CIF0010');
        data.EnableSsl = $('#EnableSsl').prop('checked');
        //var bytesEndcode = [];
        //for (var i = 0; i < data.Password.length; i++) {
        //    bytesEndcode.push(data.Password[i].charCodeAt(0));
        //}
        //data.Password = bytesEndcode.join(',');
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, CIF0010.cif0010SaveSuccess);
    };

    this.cif0010SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'CIF0010', function () {
            ASOFT.asoftPopup.hideIframe(true);
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


    //Event button config
    this.btnCheckConfig_Click = function () {
        if (ASOFT.form.checkRequired("CIF0010")) {
            return;
        }

        var data = ASOFT.helper.dataFormToJSON('CIF0010');
        data.EnableSsl = $('#EnableSsl').prop('checked');
        //var bytesEndcode = [];
        //for (var i = 0; i < data.Password.length; i++) {
        //    bytesEndcode.push(data.Password[i].charCodeAt(0));
        //}
        //data.Password = bytesEndcode.join(',');
        var url = $('#UrlCheckUpdate').val();
        ASOFT.helper.postTypeJson(url, data, CIF0010.cif0010SaveSuccess1);
    };

    this.cif0010SaveSuccess1 = function (result) {
        if (result.Status == 1) {
            ASOFT.form.displayMessageBox('#CIF0010', [ASOFT.helper.getMessage('CFML000197')], null);
        }
        else{
            ASOFT.form.displayInfo('#CIF0010', [ASOFT.helper.getMessage('CFML000198')], null);
        }
    }
}