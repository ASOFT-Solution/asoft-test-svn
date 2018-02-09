//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################

DRF2010 = new function () {
    this.isSearch = false;
    this.DRF2010Grid = null;
    this.DRF2014Grid = null;
    this.DRF2014Grid1 = null;
    this.urlUpdate = null;
    var datasourceDistrict;
    this.DRF2020 = null;
    this.formStatus = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2010.isSearch = true;
        DRF2010.DRF2010Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        DRF2010.isSearch = false;

        DRF2010.DRF2010Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF2010.isSearch;
        return dataMaster;
    };

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        DRF2010.formStatus = 1;
        DRF2010.urlUpdate = $('#UrlInsert').val();

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2011").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: DRF2010.formStatus
        };

        // [4] Hiển thị popup
        DRF2011.showPopup(postUrl, data);
    };

    // Add new button events
    this.btnImport_Click = function () {
        // [1] Tạo form status : Add new
        DRF2010.formStatus = 1;

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2003").val();

        // [3] Data load dữ liệu lên form
        var data = {
            type: "NewContractNTD"
        };

        // [4] Hiển thị popup
        DRF2003.showPopup(postUrl, data);
    };

    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        DRF2010.formStatus = 2;
        DRF2010.urlUpdate = $('#UrlUpdate').val();
        var apk = $('#APK').val();

        ASOFT.helper.post($('#UrlCheckEdit').val(), { apk: apk }, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var postUrl = $("#UrlDRF2011").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: DRF2010.formStatus,
                    APK: apk,
                    TableID: $('#TableID').val(),
                    TeamID: $('#TeamID').val(),
                    IsSendXR: parseInt($('#IsSendXR').val()),
                    IsSendVPL: parseInt($('#IsSendVPL').val()),
                    IsClose: parseInt($('#IsClose').val()),
                    IsClosed: parseInt($('#IsClosed').val()),
                    IsBankClose: parseInt($('#IsBankClose').val())
                };

                // [4] Hiển thị popup
                DRF2011.showPopup(postUrl, data);
            }
            else {
                ASOFT.form.displayMessageBox('#ViewMaster', [ASOFT.helper.getMessage(result[0].MessageID)]);
            }
        });
    };

    // Delete button events
    this.btnDelete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (DRF2010.DRF2010Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2010.DRF2010Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var apk = $('#APK').val();
            args.push(apk);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            data['ScreenID'] = $('#ScreenID').val();
            ASOFT.helper.postTypeJson(urlDelete, data, DRF2010.deleteSuccess);
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
            var urlDRF2010 = $('#UrlDRF2010').val();
            // Chuyển hướng hoặc refresh data
            if (urlDRF2010 != null) {
                window.location.href = urlDRF2010; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (DRF2010.DRF2010Grid) {
            DRF2010.DRF2010Grid.dataSource.page(1); // Refresh grid 
        }
    }

    // Delete button events
    this.btnDeleteAll_Click = function () {
        if (DRF2010.DRF2010Grid.dataSource.data().length <= 0) {
            return;
        }

        var urlDeleteAll = $('#UrlDeleteAll').val();
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            ASOFT.helper.postTypeJson(urlDeleteAll, dataMaster, DRF2010.deleteAllSuccess);
        });
    };

    this.deleteAllSuccess = function (result) {
        var formId = null;
        var displayOnRedirecting = null;

        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
            if (DRF2010.DRF2010Grid) {
                DRF2010.DRF2010Grid.dataSource.page(1); // Refresh grid 
            }
        }, null);
    }

    //Gửi công văn Xương Rồng
    this.btnSendDocXR_Click = function () {
        DRF2010.showDRF2013('IsSendXR', 1);
    }

    //Gửi công văn Văn Phòng Luật
    this.btnSendDocVPL_Click = function () {
        DRF2010.showDRF2013('IsSendVPL', 2);
    }

    //Gửi công văn Văn Phòng Luật
    this.btnClose_Click = function () {
        DRF2010.showDRF2013('IsClose', 3);
    }

    //Mở màn hình đề nghị
    this.showDRF2013 = function (isType, suggestType) {
        //Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2013").val();

        //Data load dữ liệu lên form
        var data = JSON.parse($('#initData').val());
        data.SuggesstType = suggestType;
        data.TableName = 'DRT2010';
        data[isType] = 2;
        //var data = {
        //    SuggesstType: suggestType,
        //    TableName: 'DRT2010',
        //    ContractNo: $('td#ContractNo').text(),
        //    TeamID: $('td#TeamID').text(),
        //    APK: $('#APK').val()
        //};

        //Hiển thị popup
        DRF2013.showPopup(postUrl, data);
    }

    //Thêm xử lý hàng ngày
    this.btnAddDRF2020_Click = function () {
        // [1] Tạo form status : Add new
        DRF2020 = new function () {
            this.urlUpdate = null;
        };
        DRF2020.urlUpdate = $('#UrlInsertDRF2020').val();
        DRF2020.formStatus = 4
        
        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2021").val();

        var contractNo = null;
        var debtorName = null;
        if ($('td#ContractNo').text() && $('td#DebtorName').text()) {
            contractNo = $('td#ContractNo').text();
            debtorName = $('td#DebtorName').text();
        }
        else {
            contractNo = window.parent.$('td#ContractNo').text();
            debtorName = window.parent.$('td#DebtorName').text();
        }
        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: 4,
            IsCall: 1,
            ContractNo: contractNo,//$('td#ContractNo').text(),
            DebtorName: debtorName,//$('td#DebtorName').text()
            TableID: $('#TableID').val(),
            TeamID: $('#TeamID').val(),
            APK: $('#APK').val(),
            IsSendXR: parseInt($('#IsSendXR').val()),
            IsSendVPL: parseInt($('#IsSendVPL').val()),
            IsClose: parseInt($('#IsClose').val()),
            IsClosed: parseInt($('#IsClosed').val()),
            IsBankClose: parseInt($('#IsBankClose').val()),
            ActionEmployeeID: $('#UserID').val()
        };

        // [4] Hiển thị popup
        DRF2021.showPopup(postUrl, data);
    }

    //Xóa dữ liệu hàng ngày
    this.btnDeleteDRF2020_Click = function () {
        var urlDelete = $('#UrlDeleteDRF2020').val();
        var args = [];
        var data = {};
        //if (DRF2010.DRF2014Grid) { // Lấy danh sách các dòng đánh dấu
        //    var records = ASOFT.asoftGrid.selectedRecords(DRF2010.DRF2014Grid);
        //    if (records.length == 0) return;
        //    for (var i = 0; i < records.length; i++) {
        //        args.push(records[i].APK);
        //    }
        //}

        var records = null;
        records = ASOFT.asoftGrid.selectedRecords($('#DRF2014Grid').data("kendoGrid"));
        //if (DRF2010.DRF2014Grid) { // Lấy danh sách các dòng đánh dấu
        //    records = ASOFT.asoftGrid.selectedRecords(DRF2010.DRF2014Grid);
        //}
        //else {
        //    records = ASOFT.asoftGrid.selectedRecords(DRF2010.DRF2014Grid1);
        //}

        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].APK);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            data['ScreenID'] = $('#ScreenID').val();
            ASOFT.helper.postTypeJson(urlDelete, data, DRF2010.deleteDRF2020_Success);
        });
    }

    this.deleteDRF2020_Success = function (result) {
        ASOFT.helper.showErrorSeverOption(1, result, 'ViewMaster');
        $('#DRF2014Grid').data("kendoGrid").dataSource.read();
        //if (DRF2010.DRF2014Grid) {
        //    DRF2010.DRF2014Grid.dataSource.read(); // Refresh grid 
        //} else if (DRF2010.DRF2014Grid1) {
        //    DRF2010.DRF2014Grid1.dataSource.read();
        //    window.parent.DRF2010.DRF2014Grid.dataSource.read();
        //}
    }

    // In báo cáo
    this.btnPrint_Click = function () {

        // Export excel status
        DRF2010.formStatus = 6;
        // Do print or export action
        DRF2010.doPrintOrExport();
    }

    this.btnExport_Click = function () {

        // Export excel status
        DRF2010.formStatus = 5;
        // Do print or export action
        DRF2010.doPrintOrExport();
    }
    // Do print or export
    this.doPrintOrExport = function () {
        var args = [];
 
        // Lấy dữ liệu trên form
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        //Get control Kendo UI => disabled
        var kendoControl = ASOFT.helper.getAllKendoUI($('#FormFilter'));
        $.each(kendoControl, function () {
            var control = this;
            if ($(control.value.element).attr('data-role').indexOf('datepicker') >= 0) {
                if (control.value && control.value._value!=null) {
                    data[control.name] = control.value._value.toJSON();
                }
            }
        });
        //data.ReportId = "DRR2010";
        data.isSearch = DRF2010.isSearch;
        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        if (data.IsCheckAll == 0) {
            if (DRF2010.DRF2010Grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(DRF2010.DRF2010Grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].ContractNo);
                }
            }
        }
        data.ContractNoList = args;
        data.Mode = 1;
        data.DoPrintType = 0;
        data.FormStatus = DRF2010.formStatus;
        data.Host = window.location.host;
        if (data) {
            var postUrl = $("#UrlDRF2004").val();

            // [4] Hiển thị popup
            DRF2004.showPopup(postUrl, data);
            //var urlPost = $('#UrlDoPrintOrExport').val();
            //ASOFT.helper.postTypeJson(urlPost, data, DRF2010.exportOrPrintSuccess);
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
            var fullPath = urlPost + "?id=" + data.apk + "&reportId=" + data.reportId + "&host=" + data.host + options;

            // Getfile hay in báo cáo
            if (options) {
                window.open(fullPath, "_blank");
            } else {
                window.location = fullPath;
            }
        }
    };

    //this.btnPrintHtml_Click = function () {
    //    // tạo dường dẫn tới ACTION.cshtml span.asf-i-printcv-32
    //    $('#btnPrintHtml ').html($('#UrlPrintAction').val())
    //    //DRF2000.btnExportF_Click();
    //}
    this.btnExportF_Click = function () {
        var args = [];

        // Lấy dữ liệu trên form
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        var kendoControl = ASOFT.helper.getAllKendoUI($('#FormFilter'));
        $.each(kendoControl, function () {
            var control = this;
            if ($(control.value.element).attr('data-role').indexOf('datepicker') >= 0) {
                if (control.value && control.value._value != null) {
                    data[control.name] = control.value._value.toJSON();
                }
            }
        });
        data.isSearch = DRF2010.isSearch;
        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        if (data.IsCheckAll == 0) {
            if (DRF2010.DRF2010Grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(DRF2010.DRF2010Grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].ContractNo);
                }
            }
        }
        data.ContractNoList = args;
        
        data.Mode = 1;
        data.DoPrintType = 1;
        if (data) {
            //var urlPost = $('#UrlDoExportHtml').val();
            //ASOFT.helper.postTypeJson(urlPost, data, DRF2010.exportSuccess);
            var postUrl = $("#UrlDRF2004").val();

            // [4] Hiển thị popup
            DRF2004.showPopup(postUrl, data);
        };
    }

    this.exportSuccess = function (data) {
        if (data.checkedData) {
            //if (data.checkedXR1) {
            //    var urlPost = $("#UrlHtmlCVXR1").val();
            //    var fullPath = urlPost + "?id=" + data.apkCVXR1 + "&checkScreen=2";
            //    window.open(fullPath, "_blank");
            //}
            //if (data.checkedCA) {
            //    var urlPost = $("#UrlHtmlCVCA").val();
            //    var fullPath = urlPost + "?id=" + data.apkCVCA + "&checkScreen=2";
            //    window.open(fullPath, "_blank");
            //}

            if (data.checkedXR1) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apk + "&typeDoc=" + data.typeDoc + "&templateID=XR1&checkScreen=2";
                window.open(fullPath, "_blank");
            }
            if (data.checkedCA) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apk + "&typeDoc=" + data.typeDoc + "&templateID=BC-CA&checkScreen=2";
                window.open(fullPath, "_blank");
            }
        } else {
            ASOFT.form.displayMessageBox("#FormFilter", [ASOFT.helper.getMessage('DRFML000039')], null);
        }
    }

    this.comboBox_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2010');
        console.log('combo ' + $(this.element).attr('id') + 'change');
    }
    this.isSaved = false;
    this.isEndRequest = false;
    this.countCombo = 0;
    this.comboNames = ['CityID', 'CityName', 'DistrictID', 'DistrictName'];

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF2010.countCombo++;
        if (DRF2010.countCombo == DRF2010.comboNames.length) {
            DRF2010.isEndRequest = true;
        }

        console.log('combo ' + $(this.element).attr('id') + 'end request');
    }

    //load data district khi open combo city
    this.comboBox_OpenedCity = function () {
        if (datasourceDistrict) {
            $("#District").data("kendoComboBox").text('');
            $("#District").data("kendoComboBox").setDataSource(datasourceDistrict);
        }
    }

    //khi open combo district
    this.comboBox_Opened = function () {
        DRF2010.loadDataComboBox(this);
    }

    //load data  district
    this.loadDataComboBox = function (e) {
        var data = [];
        data = e.dataSource._data;

        data2 = [];
        var cityID = $('#City').val();

        if (cityID != "%") {
            data2.push(data[0]);
            for (var i = 1; i < data.length ; i++) {
                if (data[i].CityID === cityID) {
                    data2.push(data[i]);
                }
            }

            if (datasourceDistrict == null) {
                datasourceDistrict = data;
            }
            $("#District").data("kendoComboBox").setDataSource(data2);
        }
    }

    // button events import ngân hàng rút về
    this.btnImportBank_Click = function () {
        var postUrl = $("#UrlDRF2003").val();
        var data = {
            type: "BankWithDrawContract"
        };

        DRF2003.showPopup(postUrl, data);
    };
}

// Xử lý ban đầu
$(document).ready(function () {
    DRF2020 = null;
    DRF2010.DRF2010Grid = ASOFT.asoftGrid.castName('DRF2010Grid');
    DRF2010.DRF2014Grid = ASOFT.asoftGrid.castName('DRF2014Grid');
    DRF2010.DRF2014Grid1 = ASOFT.asoftGrid.castName('DRF2014Grid1');

    btnSendXR = $('#btnSendXR').data('kendoButton');
    btnSendVPL = $('#btnSendVPL').data('kendoButton');
    btnClose = $('#btnClose').data('kendoButton');
    btnEdit = $('#BtnEdit').data('kendoButton');
    btnDelete = $('#BtnDeleteDetail').data('kendoButton');
    btnPrint = $('#BtnPrint').data('kendoButton');

    btnAddNew = $('#viewPartial #BtnAddNew').data('kendoButton');
    btnDeleteEve = $('#viewPartial #BtnDelete').data('kendoButton');

    var isSendXR = parseInt($('#IsSendXR').val());
    var isSendVPL = parseInt($('#IsSendVPL').val());
    var isClose = parseInt($('#IsClose').val());
    var isClosed = parseInt($('#IsClosed').val());

    if (btnSendXR && btnSendVPL && btnClose) {
        if (!(isSendXR == 0
            || isSendXR == 3
            || isSendXR == 5
            || isSendXR == 7
            || (isSendXR == null || isSendXR == ''))
            || isClosed == 1
            || $('#IsBankClose').val() == 1) {
            btnSendXR.enable(false);
        }

        if (!(isSendVPL == 0
            || isSendVPL == 3
            || isSendVPL == 5
            || isSendVPL == 7
            || (isSendVPL == null || isSendVPL == ''))
            || isClosed == 1
            || $('#IsBankClose').val() == 1) {
            btnSendVPL.enable(false);
        }

        if (!(isClose == 0
            || isClose == 3
            || isClose == 5
            || isClose == 7
            || (isClose == null || isClose == ''))
            || isClosed == 1
            || $('#IsBankClose').val() == 1) {
            btnClose.enable(false);
        }
    }

    if (btnEdit && btnDelete && btnPrint && btnAddNew && btnDeleteEve) {
        if (isClosed == 1) {
            btnEdit.enable(false);
            btnDelete.enable(false);
            btnPrint.enable(false);

            btnAddNew.enable(false);
            btnDeleteEve.enable(false);
        }
    }

    //Add header
    var element = $('.tr-zero-height')[0];
    $(element).html('<td class="container_period_label" style="width:29%"></td> <td class="container_period_control"></td> <td class="container_period_space"></td> <td class="container_period_label" style="width:2%"></td> <td class="container_period_control"></td>');

    
});

//------ District va City cho luoi--------

//biến kiểm tra giá trị City trên lưới có khác Grid Address
var checkedEditCityID;
var checkedEdit = 1; //Bằng 1 thì giá trị trùng nhau, Bằng 0 thì giá trị không trùng nhau

//khi changed Combobox City
function comboBox_Changed(e) {
    var index = $(e.sender.wrapper.parent().parent().children()[0]).text();

    var data = [];
    data = e.sender.dataSource._data;
    //data.forEach(function (item) {

    //    if (item.CityName == e.sender._selectedValue) {
    //        if (item.CityID === DRF2011.DRF2011Grid._data[index - 1].City) {
    //            DRF2011.DRF2011Grid._data[index - 1].CityName = item.CityName;
    //            e.sender.value(item.CityName);
    //            return;
    //        } else {
    //            DRF2011.DRF2011Grid._data[index - 1].City = item.CityID;
    //            DRF2011.DRF2011Grid._data[index - 1].CityName = item.CityName;
    //            e.sender.value(item.CityName);
    //            return;
    //        }
    //    }
       
    //});

    //data.forEach(function (item) {
    //    if (item.CityID == DRF2011.DRF2011Grid._data[index - 1].City) {
    //        DRF2011.DRF2011Grid._data[index - 1].CityName = item.CityName;
    //        e.sender.value(item.CityName);
    //        return;
    //    } else {
    //        e.sender._selectedValue = '';
    //        DRF2011.DRF2011Grid._data[index - 1].City = '';
    //        DRF2011.DRF2011Grid._data[index - 1].CityName = '';
    //        return;
    //    }
       
    //});
    
    for (var i = 0; i < data.length ; i++) {
        if (data[i].CityName === e.sender._selectedValue) {
            DRF2011.DRF2011Grid._data[index - 1].City = data[i].CityID;
            DRF2011.DRF2011Grid._data[index - 1].CityName = data[i].CityName;
            e.sender._selectedValue = data[i].CityName;
            return;
        }

    }
    for (var i = 0; i < data.length ; i++) {
        if (data[i].CityID === DRF2011.DRF2011Grid._data[index - 1].City) {
            
            DRF2011.DRF2011Grid._data[index - 1].CityName = data[i].CityName;
            return;
        }

    }
        if (!DRF2011.DRF2011Grid._data[index - 1].City) {
            DRF2011.DRF2011Grid._data[index - 1].CityName ='';
            return;
        }
    
}

//khi mo combobox City
function comboBox_Opened(e) {
    if (e.sender.dataSource._data[e.sender.selectedIndex]) {
        checkedEditCityID = e.sender.dataSource._data[e.sender.selectedIndex].CityID;
    }
}

//khi dong combobox City
function comboBox_Closed(e) {
    var index = $(e.sender.wrapper.parent().parent().children()[0]).text();
    //if (e.sender.dataSource._data[e.sender.selectedIndex]) {
    //    DRF2011.DRF2011Grid._data[index - 1].City = e.sender.dataSource._data[e.sender.selectedIndex].CityID;
    //    DRF2011.DRF2011Grid._data[index - 1].CityName = e.sender.dataSource._data[e.sender.selectedIndex].CityName;
    //}
    if (checkedEditCityID == DRF2011.DRF2011Grid._data[index - 1].City) {
        checkedEdit = 1;
        e.sender.value(DRF2011.DRF2011Grid._data[index - 1].CityName);
    } else {
        checkedEdit = 0;
        DRF2011.DRF2011Grid._data[index - 1].District = '';
        DRF2011.DRF2011Grid._data[index - 1].DistrictName = '';
        $(e.sender.wrapper.parent().parent().children()[4]).text('')
    }
}

//khi changed Combobox District
function comboBox_Changed1(e) {
    var index = $(e.sender.wrapper.parent().parent().children()[0]).text();

    var data = [];
    data = e.sender.dataSource._data;

    for (var i = 0; i < data.length ; i++) {
        if (data[i].DistrictName === e.sender._selectedValue) {
            DRF2011.DRF2011Grid._data[index - 1].District = data[i].DistrictID;
            DRF2011.DRF2011Grid._data[index - 1].DistrictName = data[i].DistrictName;
            e.sender._selectedValue = data[i].DistrictName;
            return;
        }

    }
    for (var i = 0; i < data.length ; i++) {
        if (data[i].DistrictID === DRF2011.DRF2011Grid._data[index - 1].District) {
            DRF2011.DRF2011Grid._data[index - 1].DistrictName = data[i].DistrictName;
            return;
        }

    }
}


//khi dong combobox District
function comboBoxD_Closed(e) {
    var index = $(e.sender.wrapper.parent().parent().children()[0]).text();
    //if (e.sender.dataSource._data[e.sender.selectedIndex]) {
    //    DRF2011.DRF2011Grid._data[index - 1].District = e.sender.dataSource._data[e.sender.selectedIndex].DistrictID;
    //    DRF2011.DRF2011Grid._data[index - 1].DistrictName = e.sender.dataSource._data[e.sender.selectedIndex].DistrictName;
    //}
    if (checkedEdit == 1) {
        e.sender.value(DRF2011.DRF2011Grid._data[index - 1].DistrictName);
    }
}

//khi open combobox District
function comboBox_Opened1(e) {
    var index = $(e.sender.wrapper.parent().parent().children()[0]).text();
    var city = DRF2011.DRF2011Grid._data[index - 1].City;
    if (city) {
        loadDataComboBox(this, city);
    }
}

function comboBox_RequestEnd(e) {
    DRF2010.countCombo++;
    if (DRF2010.countCombo == DRF2010.comboNames.length) {
        DRF2010.isEndRequest = true;
    }

    console.log('combo ' + $(this.element).attr('id') + 'end request');
}

//load data  district
function loadDataComboBox(e, city) {
    var data = [];
    data = e.dataSource._data;

    data2 = [];

    for (var i = 0; i < data.length ; i++) {
        if (data[i].CityID === city) {
            data2.push(data[i]);

        }
    }
    e.setDataSource(data2);
}