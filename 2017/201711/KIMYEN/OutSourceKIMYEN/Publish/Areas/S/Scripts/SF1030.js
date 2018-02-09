SF1030 = new function () {
    this.isSearch = false;
    this.SF1030Grid = null;
    this.urlUpdate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        SF1030.isSearch = true;
        SF1030.SF1030Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        SF1030.isSearch = false;
        $('#FormFilter input').val('');
        SF1030.SF1030Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = SF1030.isSearch;
        return dataMaster;
    };

    // Delete button events
    this.btnDelete_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (SF1030.SF1030Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(SF1030.SF1030Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].ID);
            }
        } else {
             //Lấy đối tượng hiện tại nếu đang ở màn hình details
            var iD = $('#iD').val();
            args.push(iD);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, SF1030.deleteSuccess);
        });
    };

    this.deleteSuccess = function (result) {
        var formId = null;
        var displayOnRedirecting = null;

        if (document.getElementById('FormFilter')) {
            formId = "FormFilter";
            displayOnRedirecting = false;
        } else if (document.getElementById('ViewMaster')) {
            formId = "ViewMaster";
            displayOnRedirecting = true;
        }

        ASOFT.helper.showErrorSeverOption(1, result, formId, function () {
            var urlSF1030 = $('#UrlSF1030').val();

            //Chuyển hướng hoặc refresh data
            if (urlSF1030) {
                window.location.href = urlSF1030; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (SF1030.SF1030Grid) {
            SF1030.SF1030Grid.dataSource.page(1); // Refresh grid 
        }
    }

    //Add new button events
    this.btnAddNew_Click = function () {
        ASOFT.form.clearMessageBox();
        // [1] Tạo form status : Add new
        SF1030.formStatus = 1;
        SF1030.urlUpdate = $('#UrlUpdate').val();
        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: SF1030.formStatus
        };

        var postUrl = ASOFT.helper.renderUrl($("#UrlSF1031").val(), data);

        ASOFT.asoftPopup.showIframe(postUrl, {});
    }

    //Import new button events
    this.btnImport_Click = function () {
        // [1] Tạo form status : Add new
        SF1030.formStatus = 1;

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlSF0005").val();

        // [3] Data load dữ liệu lên form
        var data = {
            isLanguage:false
        };

        // [4] Hiển thị popup
        SF0005.showPopup(postUrl, data);
    };

    this.btnSQLQueryExport_Click = function () {
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        var postUrl = ASOFT.helper.renderUrl($("#UrlDownload").val(), data);
        window.open(postUrl,"_blank");
    }

    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        SF1030.formStatus = 2;
        SF1030.urlUpdate = $('#UrlUpdate').val();
        var iD = $('#iD').val();
        var languageID = $('#languageID').val();
        var module = $('#module').val();
        var data = {
            FormStatus: SF1030.formStatus,
            ID: iD,
            LanguageID: languageID,
            Module: module
        };
        var postUrl = ASOFT.helper.renderUrl($("#UrlSF1031").val(), data);
        ASOFT.asoftPopup.showIframe(postUrl, {});

        //ASOFT.helper.post($('#UrlCheckEdit').val(), { AnaID: anaID }, function (result) {
        //    if (result.length == 0) {
        //        // [2] Data load dữ liệu lên form
        //        var data = {
        //            FormStatus: CIF1030.formStatus,
        //            AnaID: anaID,
        //            AnaTypeID: anaTypeID
        //        };

        //        // [3] Url load dữ liệu lên form
        //        var postUrl = ASOFT.helper.renderUrl($("#UrlCIF1031").val(), data);

        //        // [4] Render iframe
        //        ASOFT.asoftPopup.showIframe(postUrl, {});
        //    }
        //    else {
        //        ASOFT.form.displayMessageBox('#ViewMaster', [ASOFT.helper.getMessage(result[0].MessageID)]);
        //    }
        //});
    }

    //Export new button events
    this.btnExport_Click = function () {
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        if (data) {
            var postUrl = ASOFT.helper.renderUrl($("#UrlGetReportFile").val(), data);
            window.open(postUrl, "_blank");
        }
    };
}




// Xử lý ban đầu
$(document).ready(function () {
    SF1030.SF1030Grid = ASOFT.asoftGrid.castName('SF1030Grid');
});