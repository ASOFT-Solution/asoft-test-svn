$(document).ready(function () {
    CIF1060.CIF1060Grid = ASOFT.asoftGrid.castName('CIF1060Grid');
});

CIF1060 = new function () {
    this.isSearch = false;
    this.CIF1060Grid = null;
    this.formStatus = null;
    this.urlUpdate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        CIF1060.isSearch = true;
        var query = new kendo.data.Query(CIF1060.CIF1060Grid.dataSource.data());
        CIF1060.CIF1060Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        CIF1060.isSearch = false;
        CIF1060.CIF1060Grid.dataSource.page(1);
    };

    //Send data grid
    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = CIF1060.isSearch;
        return dataMaster;
    };

    //Hiển thị các dòng được chọn
    this.showRecord = function () {
        CIF1060.showHideRecords(0);
    };

    //Ẩn các dòng được chọn
    this.hideRecord = function () {
        CIF1060.showHideRecords(1);
    };

    this.showHideRecords = function (disabled) {
        ASOFT.form.clearMessageBox();
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(CIF1060.CIF1060Grid, 'FormFilter');
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].CityID);
        }

        var url = $("#UpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                CIF1060.CIF1060Grid.dataSource.page(1);
            }
        });
    };

    // Delete button events
    this.btnDelete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (CIF1060.CIF1060Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(CIF1060.CIF1060Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].CityID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var CityID = $('#CityID').text();
            args.push(CityID);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, CIF1060.deleteSuccess);
        });
    };

    //Kết quả server trả về sau khi xóa
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
            var urlCIF1060 = $('#UrlCIF1060').val();
            // Chuyển hướng hoặc refresh data
            if (urlCIF1060 != null) {
                window.location.href = urlCIF1060; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (CIF1060.CIF1060Grid) {
            CIF1060.CIF1060Grid.dataSource.page(1); // Refresh grid 
        }
    };

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        CIF1061.formStatus = 1;
        CIF1060.urlUpdate = $('#urlInsert').val();

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlCIF1061").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: CIF1061.formStatus
        };

        // [4] Hiển thị popup
        CIF1061.showPopup(postUrl, data);
    };

    // Edit button events
    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        CIF1060.formStatus = 2;
        CIF1060.urlUpdate = $('#UrlUpdate').val();
        var cityID = $('#CityID').text();

        ASOFT.helper.post($('#UrlCheckEdit').val(), { CityID: cityID }, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var postUrl = $("#UrlCIF1061").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: CIF1060.formStatus,
                    CityID: cityID
                };

                // [4] Hiển thị popup
                CIF1061.showPopup(postUrl, data);
            }
            else {
                ASOFT.form.displayMessageBox('#ViewMaster', [ASOFT.helper.getMessage(result[0].MessageID)]);
            }
        });
    };
}