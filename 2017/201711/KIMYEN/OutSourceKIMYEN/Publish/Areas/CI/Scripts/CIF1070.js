$(document).ready(function () {
    CIF1070.CIF1070Grid = ASOFT.asoftGrid.castName('CIF1070Grid');
});

CIF1070 = new function () {
    this.isSearch = false;
    this.CIF1070Grid = null;
    this.formStatus = null;
    this.urlUpdate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        CIF1070.isSearch = true;
        var query = new kendo.data.Query(CIF1070.CIF1070Grid.dataSource.data());
        CIF1070.CIF1070Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        CIF1070.isSearch = false;
        CIF1070.CIF1070Grid.dataSource.page(1);
    };

    //Send data grid
    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = CIF1070.isSearch;
        return dataMaster;
    };

    this.comboBox_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'CIF1070');
        console.log('combo ' + $(this.element).attr('id') + 'change');
    }
    this.isSaved = false;
    this.isEndRequest = false;
    this.countCombo = 0;
    this.comboNames = ['CityID','CityName']
    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        CIF1070.countCombo++;
        if (CIF1070.countCombo == CIF1070.comboNames.length) {
            CIF1070.isEndRequest = true;
        }

        console.log('combo ' + $(this.element).attr('id') + 'end request');
    }

    //Hiển thị các dòng được chọn
    this.showRecord = function () {
        CIF1070.showHideRecords(0);
    };

    //Ẩn các dòng được chọn
    this.hideRecord = function () {
        CIF1070.showHideRecords(1);
    };

    this.showHideRecords = function (disabled) {
        ASOFT.form.clearMessageBox();
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(CIF1070.CIF1070Grid, 'FormFilter');
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].DistrictID);
        }

        var url = $("#UpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                CIF1070.CIF1070Grid.dataSource.page(1);
            }
        });
    };

    // Delete button events
    this.btnDelete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (CIF1070.CIF1070Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(CIF1070.CIF1070Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].DistrictID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var DistrictID = $('#DistrictID').text();
            args.push(DistrictID);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, CIF1070.deleteSuccess);
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
            var urlCIF1070 = $('#UrlCIF1070').val();
            // Chuyển hướng hoặc refresh data
            if (urlCIF1070 != null) {
                window.location.href = urlCIF1070; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (CIF1070.CIF1070Grid) {
            CIF1070.CIF1070Grid.dataSource.page(1); // Refresh grid 
        }
    };

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        CIF1070.formStatus = 1;
        CIF1070.urlUpdate = $('#urlInsert').val();

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlCIF1071").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: CIF1070.formStatus
        };

        // [4] Hiển thị popup
        CIF1071.showPopup(postUrl, data);
    };

    // Edit button events
    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        CIF1070.formStatus = 2;
        CIF1070.urlUpdate = $('#UrlUpdate').val();
        var districtID = $('#DistrictID').text();
        var cityID = $('#CityID').val();

        ASOFT.helper.post($('#UrlCheckEdit').val(), { DistrictID: districtID }, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var postUrl = $("#UrlCIF1071").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: CIF1070.formStatus,
                    DistrictID: districtID,
                    CityID: cityID,
                };

                // [4] Hiển thị popup
                CIF1071.showPopup(postUrl, data);
            }
            else {
                ASOFT.form.displayMessageBox('#ViewMaster', [ASOFT.helper.getMessage(result[0].MessageID)]);
            }
        });
    };
}