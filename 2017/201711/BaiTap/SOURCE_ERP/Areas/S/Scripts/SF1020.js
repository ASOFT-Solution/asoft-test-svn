var SF1020Grid = null;
var isSearch = false;
var SF1020 = new function () {
    //xử lý sự kiện filter
    this.btnFilter_Click = function()  {
        SF1020.isSearch = true;
        SF1020.SF1020Grid.dataSource.page(1);
    }

    //xử lý ko filter nữa -- refresh trở lại grid ko filter
    this.btnClearFilter_Click = function () {
        SF1020.isSearch = false;                
        $('#FormFilter input').val('');  
        SF1020.SF1020Grid.dataSource.page(1);
    }

    //xử lý lấy điều kiện lọc và xác định có lọc hay không
    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter"); 
        dataMaster.IsSearch = SF1020.isSearch;
        return dataMaster;                                          
    }

    //xử lý sự kiện tạo mới
    this.btnAddNew_Click = function () {
        formStatus = 1;
        data = { FormStatus: formStatus };
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl($("#UrlSF1021").val(), data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});

    };

    //xử lý sự kiện import
    this.btnImport_Click = function () {
        data = {IsLanguage:true};
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl($("#UrlSF0005").val(), data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    }

    //xử lý sự kiện edit
    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        formStatus = 2;
        var ID = $('#ID').val();
        var LangID = $('#LangID').val();
        var module = $('#ModuleID').val();
        var data = {
            FormStatus: formStatus,
            ID: ID,
            LanguageID: LangID,
            Module:module
        };

        // [3] Url load dữ liệu lên form
        var postUrl = ASOFT.helper.renderUrl($("#UrlSF1021").val(), data);

        // [4] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});

    }

    //xử lý sự kiện export SQL
    this.btnSQLQueryExport_Click = function () {
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        var urldownload = ASOFT.helper.renderUrl($("#UrlDownload").val(), data);
        window.open(urldownload, "_blank");
    }

    //xử lý sự kiện delete
    this.btnDelete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (SF1020.SF1020Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(SF1020.SF1020Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                //args.push(records[i].LanguageID);
                args.push(records[i].ID);
            }        
        }else {
        // Lấy đối tượng hiện tại nếu đang ở màn hình details
        var ID = $('#ID').val();
        args.push(ID);
        }
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, SF1020.deleteSuccess);
        });
    }

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

        //
        ASOFT.helper.showErrorSeverOption(1, result, formId, function () {
            var urlSF1020 = $('#UrlSF1020').val();
            // Chuyển hướng hoặc refresh data
            if (urlSF1020 != null) {
                window.location.href = urlSF1020; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (SF1020.SF1020Grid) {
            SF1020.SF1020Grid.dataSource.page(1); // Refresh grid 
        }
    }

    //xử lý eport file excel
    this.ExportEXCEL_Click = function () {
        // Lấy dữ liệu trên form
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        data.ReportId = "AR00001";

        if (data) {
            var urlexport = ASOFT.helper.renderUrl($("#UrlExport").val(), data);
            window.open(urlexport, "_blank");
        }
    }
};

$(document).ready(function () {
    SF1020.SF1020Grid = ASOFT.asoftGrid.castName('SF1020Grid');
})