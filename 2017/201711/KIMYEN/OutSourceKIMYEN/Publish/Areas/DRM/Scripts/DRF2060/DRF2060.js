
//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF2060 = new function () {
    this.DRF2060Grid = null;
    this.isSearch = false;
    this.FromDate = null;
    this.ToDate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2060.isSearch = true;
        DRF2060.DRF2060Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        DRF2060.isSearch = false;

        DRF2060.FromDate.value(new Date());
        DRF2060.ToDate.value(new Date());

        DRF2060.DRF2060Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF2060.isSearch;
        return dataMaster;
    }

    this.openDRF2061 = function (apk, dispathTypeID) {
        ASOFT.form.clearMessageBox();
        var data = {};
        data.apk = apk;
        data.dispathTypeID = dispathTypeID;

        // Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2061").val();

        // [4] Hiển thị popup
        DRF2061.showPopup(postUrl, data);
    }

    this.sendDoc_Click = function () {
        var urlSendDoc = $('#UrlSendDoc').val();
        var args = [];
        var data = {};
        var dispathTypeID = null;
        if (DRF2060.DRF2060Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2060.DRF2060Grid, 'FormFilter');
            if (records.length == 0) return;
            dispathTypeID = records[0].DispathTypeID;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('DRFML000020'), function () {
            data['args'] = args;
            data.dispathTypeID = dispathTypeID;
            ASOFT.helper.postTypeJson(urlSendDoc, data, DRF2060.sendSuccess);
        });
    };

    this.sendSuccess = function (result) {
        var messageID = null;
        if (result.Status == 0) {
            ASOFT.form.displayMultiMessageBox('FormFilter', 0, [ASOFT.helper.getMessage('DRFML000023')]);
        }
        else {
            ASOFT.form.displayMessageBox('#FormFilter', [ASOFT.helper.getMessage('DRFML000024')]);
        }

        if (DRF2060.DRF2060Grid) {
            DRF2060.DRF2060Grid.dataSource.page(1); // Refresh grid 
        }
    };

    this.delete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (DRF2060.DRF2060Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2060.DRF2060Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].ContractNo);
            }
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, DRF2060.deleteSuccess);
        });
    }

    this.deleteSuccess = function (result) {
        var formId = 'FormFilter';
        ASOFT.helper.showErrorSeverOption(1, result, formId);

        if (DRF2060.DRF2060Grid) {
            DRF2060.DRF2060Grid.dataSource.page(1); // Refresh grid 
        }
    }

    this.btnExport_Click = function () {

        // Export excel status
        DRF2060.formStatus = 5;

        // Do print or export action
        DRF2060.doPrintOrExport();
    }

    this.btnPrint_Click = function () {

        // Export excel status
        DRF2060.formStatus = 6;

        // Do print or export action
        DRF2060.doPrintOrExport();
    }

    // Do print or export
    this.doPrintOrExport = function () {
        // Lấy dữ liệu trên form
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        data.ReportId = "DRR2060";
        data.FormStatus = DRF2060.formStatus;
        var args = [];
        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        if (data.IsCheckAll == 0) {
            if (DRF2060.DRF2060Grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(DRF2060.DRF2060Grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].APK);
                }
            }
        }
        data.APKList = args;

        if (data) {
            var urlPost = $('#UrlDoPrintOrExport').val();

            ASOFT.helper.postTypeJson(urlPost, data, DRF2060.exportOrPrintSuccess);
        }
    }

    // Do print or export success
    this.exportOrPrintSuccess = function (data) {
        if (data) {
            var urlPost = $("#UrlGetReportFile").val();
            var options = "";

            if (data.formStatus == 6) {
                urlPost = $("#UrlReportViewer").val();
                options = "&viewer=pdf";
            }

            // Tạo path full
            var fullPath = urlPost + "?id=" + data.apk + "&reportId=" + data.reportId + options;

            // Getfile hay in báo cáo
            if (options) {
                window.open(fullPath, "_blank");
            } else {
                window.location = fullPath;
            }
        }
    };

    this.btnPrintCV_Click = function () {
        var urlPost = $('#UrlGetDataCV').val();
        var data = {};
        ASOFT.helper.postTypeJson(urlPost, data, DRF2060.doPrintCV);
        
    }
    // in cong van da gui
    this.doPrintCV = function (data) {
        if (data.checkEmail) {
            // Lấy dữ liệu trên form
            var data = ASOFT.helper.dataFormToJSON("FormFilter");
            data.FormStatus = DRF2060.formStatus;
            var argsXR = [];
            var argsVPL = [];
            data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
            if (data.IsCheckAll == 0) {
                if (DRF2060.DRF2060Grid) { // Lấy danh sách các dòng đánh dấu
                    var records = ASOFT.asoftGrid.selectedRecords(DRF2060.DRF2060Grid, 'FormFilter');
                    if (records.length == 0) return;
                    for (var i = 0; i < records.length; i++) {
                        if (records[i].DispathTypeID == 'XR') {
                            argsXR.push(records[i].APK);
                        }
                        else if (records[i].DispathTypeID == 'VPL') {
                            argsVPL.push(records[i].APK);
                        }
                    }
                }
            }
            data.APKListXR = argsXR;
            data.APKListVPL = argsVPL;
            //data.TypePrintDoc = $(value.children).attr('id');
            if (data) {
                var urlPost = $('#UrlDoExportHtml').val();

                ASOFT.helper.postTypeJson(urlPost, data, DRF2060.exportOrPrintSuccessDoc);
            }
        } else {
            ASOFT.form.displayMessageBox("#FormFilter", [ASOFT.helper.getMessage('DRFML000042')], null);
        }
    }

    // Do print or export success
    this.exportOrPrintSuccessDoc = function (data) {
        if (data.checkedData) {
            if (data.checkedXR2) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apkCVXR2 + "&typeDoc=0&templateID=XR2&checkScreen=3";
                window.open(fullPath, "_blank");
            }
            if (data.checkedVPL) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apkCVVPL + "&typeDoc=0&templateID=VPL&checkScreen=3";//"&checkScreen=" + true;
                window.open(fullPath, "_blank");
            }

            //if (data.checkedXR2) {
            //    var urlPost = $("#UrlHtml").val();
            //    var fullPath = urlPost + "?id=" + data.apkCVXR2 + "&typeDoc=0&templateID=XR2&checkScreen=0";
            //    window.open(fullPath, "_blank");
            //}
            //if (data.checkedVPL) {
            //    var urlPost = $("#UrlHtml").val();
            //    var fullPath = urlPost + "?id=" + data.apkCVVPL + "&typeDoc=0&templateID=VPL&checkScreen=0";
            //    window.open(fullPath, "_blank");
            //}
        } else {
            ASOFT.form.displayMessageBox("#FormFilter", [ASOFT.helper.getMessage('DRFML000040')], null);
        }
    };
}

// Xử lý ban đầu
$(document).ready(function () {
    installPeriod(true);
    DRF2060.DRF2060Grid = ASOFT.asoftGrid.castName('DRF2060Grid');
    DRF2060.FromDate = ASOFT.asoftDateEdit.castName('FromDate');
    DRF2060.ToDate = ASOFT.asoftDateEdit.castName('ToDate');

    //Button printCV
    //$('#btnPrintHtml ').html($('#UrlPrintAction').val())
    //if ($('#UrlPrintAction').val()) {
    //    var array = $('#UrlPrintAction').val().split("<span>Hoạt động</span>");
    //    var array1 = array[0].split("=");
    //    $('#btnPrintHtml ').html(array1[0] + "='asf-panel-master-left asf-i-printcv-32' style=' background-repeat: round;'>" + array[1]);
    //}
});

// #region --- Global Callback ---


/**
 * Lấy thông tin hợp đồng
 * @param {} contractNo : Số hợp đồng
 * @returns {} 
 * @since [Văn Tài] Created [28/12/2017]
 */
function CatchContractDetails(contractNo) {
    var result = null;

    var grid = $("#DRF2060Grid").data("kendoGrid");
    if (grid) {
        var data = grid.dataSource._data;

        for (var i = 0; i < data.length; i++) {
            if (data[i].ContractNo === contractNo) {
                result = data[i];
                break;
            }
        }
    }
    return result;
}


// #endregion --- Global Callback ---