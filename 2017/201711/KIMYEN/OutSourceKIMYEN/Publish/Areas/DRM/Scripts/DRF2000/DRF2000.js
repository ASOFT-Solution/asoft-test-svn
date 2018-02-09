//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################

DRF2000 = new function () {
    this.isSearch = false;
    this.DRF2000Grid = null;
    this.DRF2004Grid = null;
    this.DRF2004Grid1 = null;
    this.urlUpdate = null;
    this.DRF2020 = null;
    var datasourceDistrict;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2000.isSearch = true;
        DRF2000.DRF2000Grid.dataSource.page(1);
    };

  

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        DRF2000.isSearch = false;

        DRF2000.DRF2000Grid.dataSource.page(1);
        
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF2000.isSearch;
        return dataMaster;
    };

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        DRF2000.formStatus = 1;
        DRF2000.urlUpdate = $('#UrlInsert').val();

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2001").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: DRF2000.formStatus
        };

        // [4] Hiển thị popup
        DRF2001.showPopup(postUrl, data);
    };

    // Add new button events
    this.btnImport_Click = function () {
        // [1] Tạo form status : Add new
        DRF2000.formStatus = 1;

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2003").val();

        // [3] Data load dữ liệu lên form
        var data = {
            type: "NewContractNTM"
        };

        // [4] Hiển thị popup
        DRF2003.showPopup(postUrl, data);
    };

    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        DRF2000.formStatus = 2;
        DRF2000.urlUpdate = $('#UrlUpdate').val();
        var apk = $('#APK').val();

        ASOFT.helper.post($('#UrlCheckEdit').val(), {apk : apk}, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var postUrl = $("#UrlDRF2001").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: DRF2000.formStatus,
                    APK: apk,
                    TableID: $('#TableID').val(),
                    TeamID: $('#TeamID').val(),
                    IsSendXR: parseInt($('#IsSendXR').val()),
                    IsSendVPL : parseInt($('#IsSendVPL').val()),
                    IsClose : parseInt($('#IsClose').val()),
                    IsClosed: parseInt($('#IsClosed').val()),
                    IsBankClose: parseInt($('#IsBankClose').val())
                };

                // [4] Hiển thị popup
                DRF2001.showPopup(postUrl, data);
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
        if (DRF2000.DRF2000Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2000.DRF2000Grid, 'FormFilter');
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
            ASOFT.helper.postTypeJson(urlDelete, data, DRF2000.deleteSuccess);
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
            var urlDRF2000 = $('#UrlDRF2000').val();
            // Chuyển hướng hoặc refresh data
            if (urlDRF2000 != null) {
                window.location.href = urlDRF2000; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (DRF2000.DRF2000Grid) {
            DRF2000.DRF2000Grid.dataSource.page(1); // Refresh grid 
        }
    }

    // Delete button events
    this.btnDeleteAll_Click = function () {
        if (DRF2000.DRF2000Grid.dataSource.data().length <= 0) {
            return;
        }

        var urlDeleteAll = $('#UrlDeleteAll').val();
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");        
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            ASOFT.helper.postTypeJson(urlDeleteAll, dataMaster, DRF2000.deleteAllSuccess);
        });
    };

    this.deleteAllSuccess = function (result) {
        var formId = null;
        var displayOnRedirecting = null;

        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
            if (DRF2000.DRF2000Grid) {
                DRF2000.DRF2000Grid.dataSource.page(1); // Refresh grid 
            }
        }, null);
    }

    //Gửi công văn Xương Rồng
    this.btnSendDocXR_Click = function () {
        DRF2000.showDRF2013('IsSendXR', 1);
    }

    //Gửi công văn Văn Phòng Luật
    this.btnSendDocVPL_Click = function () {
        DRF2000.showDRF2013('IsSendVPL', 2);
    }

    //Đóng hồ sơ
    this.btnClose_Click = function () {
        DRF2000.showDRF2013('IsClose', 3);
    }

    //Mở màn hình đề nghị
    this.showDRF2013 = function (isType, suggestType) {
        //Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2013").val();
        //Data load dữ liệu lên form
        var data = JSON.parse($('#initData').val());
        data.SuggesstType = suggestType;
        data.TableName = 'DRT2000';
        data[isType] = 2;
        //var data = {
        //    SuggesstType: suggestType,
        //    TableName: 'DRT2000',
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
            IsSendVPL : parseInt($('#IsSendVPL').val()),
            IsClose : parseInt($('#IsClose').val()),
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
        //if (DRF2000.DRF2004Grid) { // Lấy danh sách các dòng đánh dấu
        //    var records = ASOFT.asoftGrid.selectedRecords(DRF2000.DRF2004Grid);
        //    if (records.length == 0) return;
        //    for (var i = 0; i < records.length; i++) {
        //        args.push(records[i].APK);
        //    }
        //}

        var records = null;
        records = ASOFT.asoftGrid.selectedRecords($('#DRF2004Grid').data("kendoGrid"));
        //if (DRF2000.DRF2004Grid) { // Lấy danh sách các dòng đánh dấu
        //    records = ASOFT.asoftGrid.selectedRecords(DRF2000.DRF2004Grid);
        //}
        //else {
        //    records = ASOFT.asoftGrid.selectedRecords(DRF2000.DRF2004Grid1);
        //}

        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].APK);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            data['ScreenID'] = $('#ScreenID').val();
            ASOFT.helper.postTypeJson(urlDelete, data, DRF2000.deleteDRF2020_Success);
        });
    }

    this.deleteDRF2020_Success = function (result) {
        ASOFT.helper.showErrorSeverOption(1, result, 'ViewMaster');
        $('#DRF2014Grid').data("kendoGrid").dataSource.read();
        //if (DRF2000.DRF2004Grid) {
        //    DRF2000.DRF2004Grid.dataSource.read(); // Refresh grid 
        //}
        //else if (DRF2000.DRF2004Grid1) {
        //    DRF2000.DRF2004Grid1.dataSource.read();
        //    window.parent.DRF2000.DRF2004Grid.dataSource.read();
        //}
    }

    this.btnExport_Click = function () {

        // Export excel status
        DRF2000.formStatus = 5;
        // Do print or export action
        DRF2000.doPrintOrExport();
    }

    this.btnPrint_Click = function () {

        // Export excel status
        DRF2000.formStatus = 6;
        // Do print or export action
        DRF2000.doPrintOrExport();
    }

    // Do print or export
    this.doPrintOrExport = function () {
        var args = [];

        // Lấy dữ liệu trên form
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
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
        data.isSearch = DRF2000.isSearch;
        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        if (data.IsCheckAll == 0) {
            if (DRF2000.DRF2000Grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(DRF2000.DRF2000Grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].ContractNo);
                }
            }
        }
        data.ContractNoList = args;
        
        data.Mode = 2;
        data.DoPrintType = 0;
        data.FormStatus = DRF2000.formStatus;
        data.Host = window.location.host;
        if (data) {
            var postUrl = $("#UrlDRF2004").val();

            // [4] Hiển thị popup
            DRF2004.showPopup(postUrl, data);

            //var urlPost = $('#UrlDoPrintOrExport').val();
            //ASOFT.helper.postTypeJson(urlPost, data, DRF2000.exportOrPrintSuccess);
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
    //    // tạo dường dẫn tới ACTION.cshtml span.asf-i-printcv-32 style=" background-repeat: round; "
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
        data.isSearch = DRF2000.isSearch;
        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        if (data.IsCheckAll == 0) {
            if (DRF2000.DRF2000Grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(DRF2000.DRF2000Grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].ContractNo);
                }
            }
        }
        data.ContractNoList = args;
        data.Mode = 2;
        data.DoPrintType = 1;
        if (data) {
            var postUrl = $("#UrlDRF2004").val();

            // [4] Hiển thị popup
            DRF2004.showPopup(postUrl, data);

            //var urlPost = $('#UrlDoExportHtml').val();
            //ASOFT.helper.postTypeJson(urlPost, data, DRF2000.exportSuccess);
        };
    }

    this.exportSuccess = function (data) {
        if (data.checkedData) {
            //if (data.checkedXR1) {
            //    var urlPost = $("#UrlHtml").val();
            //    var fullPath = urlPost + "?id=" + data.apkCVXR1 + "&checkScreen=1";
            //    window.open(fullPath, "_blank");
            //}
            //if (data.checkedCA) {
            //    var urlPost = $("#UrlHtml").val();
            //    var fullPath = urlPost + "?id=" + data.apkCVCA + "&checkScreen=1";
            //    window.open(fullPath, "_blank");
            //}

            if (data.checkedXR1) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apk + "&typeDoc=" + data.typeDoc + "&templateID=XR1&checkScreen=1";
                window.open(fullPath, "_blank");
            }
            if (data.checkedCA) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apk + "&typeDoc=" + data.typeDoc + "&templateID=BC-CA&checkScreen=1";
                window.open(fullPath, "_blank");
            }
        } else {
            ASOFT.form.displayMessageBox("#FormFilter", [ASOFT.helper.getMessage('DRFML000039')], null);
        }
    }

    this.comboBox_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2000');
        console.log('combo ' + $(this.element).attr('id') + 'change');
    }
    this.isSaved = false;
    this.isEndRequest = false;
    this.countCombo = 0;
    this.comboNames = ['CityID', 'CityName', 'DistrictID', 'DistrictName']

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF2000.countCombo++;
        if (DRF2000.countCombo == DRF2000.comboNames.length) {
            DRF2000.isEndRequest = true;
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
        DRF2000.loadDataComboBox(this);
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
    DRF2000.DRF2000Grid = ASOFT.asoftGrid.castName('DRF2000Grid');
    DRF2000.DRF2004Grid = ASOFT.asoftGrid.castName('DRF2004Grid');
    DRF2000.DRF2004Grid1 = ASOFT.asoftGrid.castName('DRF2004Grid1');
    btnEdit = $('#BtnEdit').data('kendoButton');
    btnDelete = $('#BtnDeleteDetail').data('kendoButton');
    btnPrint = $('#BtnPrint').data('kendoButton');

    btnAddNew = $('#viewPartial #BtnAddNew').data('kendoButton');
    btnDeleteEve = $('#viewPartial #BtnDelete').data('kendoButton');
        btnSendXR = $('#btnSendXR').data('kendoButton');
        btnSendVPL = $('#btnSendVPL').data('kendoButton');
        btnClose = $('#btnClose').data('kendoButton');

        var isSendXR = parseInt($('#IsSendXR').val());
        var isSendVPL = parseInt($('#IsSendVPL').val());
        var isClose = parseInt($('#IsClose').val());
        var isClosed = parseInt($('#IsClosed').val());

        if (btnSendXR && btnSendVPL && btnClose ) {
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


    //Button printCV
   // $('#btnPrintHtml ').html($('#UrlPrintAction').val())
    //if ($('#UrlPrintAction').val()) {
    //    var array = $('#UrlPrintAction').val().split("<span>Hoạt động</span>");
    //    var array1 = array[0].split("=");
    //    var array2 = array[1].split("asf-i-action");
    //    var array3 = array2[0].split("span");
    //    var array4 = array2[1].split("actionClick(this)");
    //    $('#btnPrintHtml').html(array1[0] + "='asf-panel-master-left asf-i-printcv-32' style=' background-repeat: round; width: 20px;background-color: white;'>" + array3[0] + "span style='background: none;'" + array3[1] + "asf-i-action" + array4[0]+"DRF2000.ActionClick(this,0)"+ array4[1]);
    //}

    //if ($('#UrlPrintAction1').val()) {
    //    var array = $('#UrlPrintAction1').val().split("<span>Hoạt động</span>");
    //    var array1 = array[0].split("=");
    //    var array2 = array[1].split("asf-i-action");
    //    var array3 = array2[0].split("span");
    //    var array4 = array2[1].split("actionClick(this)");
    //    var array5 = array4[0].split("onclick");//array5[0] ",array5[1] ="
    //    $('#btnPrint ').html(array1[0] + "='asf-panel-master-left asf-i-printer-32' style=' background-repeat: round; width: 20px;background-color: white;'>" + array3[0] + "span style='background: none;'" + array3[1] + "asf-i-action" + array5[0] + "onclick" + array5[1] + "DRF2000.ActionClick(this,1)"  + array4[1]);
    //    //$('#btnPrint').html(array1[0] + "='asf-panel-master-left asf-i-printer-32' style=' background-repeat: round; width: 20px;background-color: white;'>" + array3[0] + "span style='background: none;'" + array3[1] + "asf-i-action" + array4[0] + "DRF2000.ActionClick(this,1)" + array4[1]);
    //}

    //if ($('#UrlPrintAction2').val()) {
    //    var array = $('#UrlPrintAction2').val().split("<span>Hoạt động</span>");
    //    var array1 = array[0].split("=");
    //    var array2 = array[1].split("asf-i-action");
    //    var array3 = array2[0].split("span");
    //    var array4 = array2[1].split("actionClick(this)");
    //    var array5 = array4[0].split("onclick");//array5[0] ",array5[1] ="
    //    $('#btnExport ').html(array1[0] + "='asf-panel-master-left asf-i-excel-32' style=' background-repeat: round; width: 20px;background-color: white;'>" + array3[0] + "span style='background: none;'" + array3[1] + "asf-i-action" + array5[0] + "onclick" + array5[1] + "DRF2000.ActionClick(this,2)"+ array4[1]);
    //    //$('#btnExport').html(array1[0] + "='asf-panel-master-left asf-i-excel-32' style=' background-repeat: round; width: 20px;background-color: white;'>" + array3[0] + "span style='background: none;'" + array3[1] + "asf-i-action" + array4[0] + "DRF2000.ActionClick(this,2)" + array4[1]);
    //}
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
    
    for (var i = 0; i < data.length ; i++) {
        if (data[i].CityName === e.sender._selectedValue) {
            DRF2001.DRF2001Grid._data[index - 1].City = data[i].CityID;
            DRF2001.DRF2001Grid._data[index - 1].CityName = data[i].CityName;
            e.sender._selectedValue = data[i].CityName;
            return;
        } 
      
    }
    for (var i = 0; i < data.length ; i++) {
       if (data[i].CityID === DRF2001.DRF2001Grid._data[index - 1].City) {
           DRF2001.DRF2001Grid._data[index - 1].CityName = data[i].CityName;
           return;
        }

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
    //    DRF2001.DRF2001Grid._data[index - 1].City = e.sender.dataSource._data[e.sender.selectedIndex].CityID;
    //    DRF2001.DRF2001Grid._data[index - 1].CityName = e.sender.dataSource._data[e.sender.selectedIndex].CityName;
    //}
    if (checkedEditCityID == DRF2001.DRF2001Grid._data[index - 1].City) {
        checkedEdit = 1;
        e.sender.value(DRF2001.DRF2001Grid._data[index - 1].CityName);
    } else {
        checkedEdit = 0;
        DRF2001.DRF2001Grid._data[index - 1].District = '';
        DRF2001.DRF2001Grid._data[index - 1].DistrictName = '';
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
            DRF2001.DRF2001Grid._data[index - 1].District = data[i].DistrictID;
            DRF2001.DRF2001Grid._data[index - 1].DistrictName = data[i].DistrictName;
            e.sender._selectedValue = data[i].DistrictName;
            return;
        }

    }
    for (var i = 0; i < data.length ; i++) {
        if (data[i].DistrictID === DRF2001.DRF2001Grid._data[index - 1].District) {
            DRF2001.DRF2001Grid._data[index - 1].DistrictName = data[i].DistrictName;
            return;
        }

    }
   
}

//khi dong combobox District
function comboBoxD_Closed(e) {
    var index = $(e.sender.wrapper.parent().parent().children()[0]).text();
    //if (e.sender.dataSource._data[e.sender.selectedIndex]) {
    //    DRF2001.DRF2001Grid._data[index - 1].District = e.sender.dataSource._data[e.sender.selectedIndex].DistrictID;
    //    DRF2001.DRF2001Grid._data[index - 1].DistrictName = e.sender.dataSource._data[e.sender.selectedIndex].DistrictName;
    //}
    if (checkedEdit == 1) {
        e.sender.value(DRF2001.DRF2001Grid._data[index - 1].DistrictName);
    }

}

//khi open combobox District
function comboBox_Opened1(e) {
    var index = $(e.sender.wrapper.parent().parent().children()[0]).text();
    var city = DRF2001.DRF2001Grid._data[index - 1].City;
    if (city) {
        loadDataComboBox(this, city);
    }    
}

function comboBox_RequestEnd (e) {
    DRF2000.countCombo++;
    if (DRF2000.countCombo == DRF2000.comboNames.length) {
        DRF2000.isEndRequest = true;
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
    $("#DistrictName").data("kendoComboBox").setDataSource(data2);
}