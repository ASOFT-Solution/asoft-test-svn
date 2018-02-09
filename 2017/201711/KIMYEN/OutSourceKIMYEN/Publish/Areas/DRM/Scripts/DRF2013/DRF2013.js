//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {

});

DRF2013 = new function () {
    this.formStatus = null;
    this.rowNum = 0;


    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2013.closePopup();
    };

    //Get data form DRF2041
    this.getFormData = function () {
        var data = ASOFT.helper.dataFormToJSON('DRF2013');
        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequired("DRF2013")) {
            return;
        }

        var url = $('#URLUpdate').val();
        var data = JSON.parse($('#initData').val());
        data.Content = $('#Content').val();

        ASOFT.helper.postTypeJson(url, data, DRF2013.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        if (result.Status == 0) {
           
            if ($(window.parent.$('#contentMaster')).length > 0) {
                parent.window.location.reload(true);
            }
            else {
                var urlGetCV = $('#UrlGetDataCV').val();
                var data = {
                    ContractNo: result.Data[0].toString(),
                    TableName: result.Data[1].toString()
                }
                ASOFT.helper.postTypeJson(urlGetCV, data, DRF2013.saveSuccess2);
                if (data.TableName == "DRT2000") {
                    window.parent.DRF2001.DRF2073GridDocument.dataSource.read();
                    window.parent.DRF2001.DRF2074GridCloseResume.dataSource.read();
                }
                else if (data.TableName == "DRT2010") {
                    window.parent.DRF2011.DRF2073GridDocument.dataSource.read();
                    window.parent.DRF2011.DRF2074GridCloseResume.dataSource.read();
                }
            }
            DRF2013.closePopup();
        }
        else {
            ASOFT.form.displayMessageBox('#DRF2013', [ASOFT.helper.getMessage(result.MessageID)]);
        }
    }

    this.saveSuccess2 = function (data) {
        if (data != null) {
            btnSendXR = window.parent.$('#btnSendXR').data('kendoButton');
            btnSendVPL = window.parent.$('#btnSendVPL').data('kendoButton');
            btnClose = window.parent.$('#btnClose').data('kendoButton');

            btnSendXRparent = window.parent.parent.$('#btnSendXR').data('kendoButton');
            btnSendVPLparent = window.parent.parent.$('#btnSendVPL').data('kendoButton');
            btnCloseparent = window.parent.parent.$('#btnClose').data('kendoButton');

            btnSendXR.enable(true);
            btnSendXRparent.enable(true);
            btnSendVPL.enable(true);
            btnSendVPLparent.enable(true);
            btnClose.enable(true);
            btnCloseparent.enable(true);

            var isSendXR = data.IsXR;
            var isSendVPL = data.IsVPL;
            var isClose = data.IsClose;
            var isClosed = data.IsClosed;

            if (btnSendXR && btnSendVPL && btnClose && btnSendXRparent && btnSendVPLparent && btnCloseparent) {
                if (!(isSendXR == 0
                    || isSendXR == 3
                    || isSendXR == 5
                    || isSendXR == 7
                    || (isSendXR == null || isSendXR == ''))
                    || isClosed == 1) {
                    btnSendXR.enable(false);
                    btnSendXRparent.enable(false);
                }

                if (!(isSendVPL == 0
                    || isSendVPL == 3
                    || isSendVPL == 5
                    || isSendVPL == 7
                    || (isSendVPL == null || isSendVPL == ''))
                    || isClosed == 1) {
                    btnSendVPL.enable(false);
                    btnSendVPLparent.enable(false);
                }

                if (!(isClose == 0
                    || isClose == 3
                    || isClose == 5
                    || isClose == 7
                    || (isClose == null || isClose == ''))
                    || isClosed == 1) {
                    btnClose.enable(false);
                    btnCloseparent.enable(false);
                }
            }

            window.parent.$('#IsSendXR').val(isSendXR);
            window.parent.$('#IsSendVPL').val(isSendVPL);
            window.parent.$('#IsClose').val(isClose);
            window.parent.$('#IsClosed').val(isClosed);
            window.parent.parent.$('#IsSendXR').val(isSendXR);
            window.parent.parent.$('#IsSendVPL').val(isSendVPL);
            window.parent.parent.$('#IsClose').val(isClose);
            window.parent.parent.$('#IsClosed').val(isClosed);
        }        
    }


    // Save button events
    this.btnSave_Click = function () {
        DRF2013.saveData();
    };

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframeHttpPost(url, data);
    };

    // Hide Iframes
    this.closePopup = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };
}