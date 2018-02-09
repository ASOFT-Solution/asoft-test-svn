//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     27/10/2014      Trí Thiện       Tạo mới
//####################################################################

$(document).ready(function () {
    DRF0140.cboPeriod = ASOFT.asoftComboBox.castName('Period');
    DRF0140.cboFromPeriod = ASOFT.asoftComboBox.castName('FromPeriod');
    DRF0140.cboToPeriod = ASOFT.asoftComboBox.castName('ToPeriod');
    DRF0140.cboFromMonth = ASOFT.asoftComboBox.castName('FromStringMonth');
    DRF0140.cboToMonth = ASOFT.asoftComboBox.castName('ToStringMonth');
    DRF0140.cboFromQuater = ASOFT.asoftComboBox.castName('FromQuater');
    DRF0140.cboToQuater = ASOFT.asoftComboBox.castName('ToQuater');
    DRF0140.cboFromYear = ASOFT.asoftComboBox.castName('FromYear');
    DRF0140.cboToYear = ASOFT.asoftComboBox.castName('ToYear');
    DRF0140.dateEditFromDate = ASOFT.asoftDateEdit.castName('FromDate');
    DRF0140.dateEditToDate = ASOFT.asoftDateEdit.castName('ToDate');

    $('#DRF0140 input[name="Mode"]').click(function () {
        var value = $(this).val();
        if (value == 1) {
            DRF0140.isEnableMonth = false;
            DRF0140.isEnableQuater = false;
            DRF0140.isEnableYear = false;

            DRF0140.dateEditFromDate.enable(true);
            DRF0140.dateEditToDate.enable(true);

            DRF0140.cboFromMonth.enable(false);
            DRF0140.cboToMonth.enable(false);
            DRF0140.cboFromQuater.enable(false);
            DRF0140.cboToQuater.enable(false);
            DRF0140.cboFromYear.enable(false);
            DRF0140.cboToYear.enable(false);
        }
        else if (value == 2) {
            DRF0140.isEnableMonth = true;
            DRF0140.isEnableQuater = false;
            DRF0140.isEnableYear = false;

            DRF0140.cboFromMonth.enable(true);
            DRF0140.cboToMonth.enable(true);
            DRF0140.cboFromMonth.refresh();
            DRF0140.cboToMonth.refresh();

            DRF0140.dateEditFromDate.enable(false);
            DRF0140.dateEditToDate.enable(false);
            DRF0140.cboFromQuater.enable(false);
            DRF0140.cboToQuater.enable(false);
            DRF0140.cboFromYear.enable(false);
            DRF0140.cboToYear.enable(false);
        }
        else if (value == 3) {
            DRF0140.isEnableMonth = false;
            DRF0140.isEnableQuater = true;
            DRF0140.isEnableYear = false;

            DRF0140.cboFromQuater.enable(true);
            DRF0140.cboToQuater.enable(true);
            DRF0140.cboFromQuater.refresh();
            DRF0140.cboToQuater.refresh();

            DRF0140.dateEditFromDate.enable(false);
            DRF0140.dateEditToDate.enable(false);
            DRF0140.cboFromMonth.enable(false);
            DRF0140.cboToMonth.enable(false);
            DRF0140.cboFromYear.enable(false);
            DRF0140.cboToYear.enable(false);
        }
        else if (value == 4) {
            DRF0140.isEnableMonth = false;
            DRF0140.isEnableQuater = false;
            DRF0140.isEnableYear = true;

            DRF0140.cboFromYear.enable(true);
            DRF0140.cboToYear.enable(true);
            DRF0140.cboFromYear.refresh();
            DRF0140.cboToYear.refresh();

            DRF0140.dateEditFromDate.enable(false);
            DRF0140.dateEditToDate.enable(false);
            DRF0140.cboFromMonth.enable(false);
            DRF0140.cboToMonth.enable(false);
            DRF0140.cboFromQuater.enable(false);
            DRF0140.cboToQuater.enable(false);
        }
    });
});


DRF0140 = new function () {
    this.isEnableMonth = false;
    this.isEnableQuater = false;
    this.isEnableYear = false;
    this.timeMode = 0;
    this.month = null;
    this.year = null;
    this.fromMonth = null;
    this.fromYear = null;
    this.toMonth = null;
    this.toYear = null;
    this.fromQuater = null;
    this.toQuater = null;
    this.fromYear = null;
    this.toYear = null;
    this.brandName = null;
    this.formStatus = null;
    this.cboPeriod = null;
    this.cboFromPeriod = null;
    this.cboToPeriod = null;
    this.cboFromMonth = null;
    this.cboToMonth = null;
    this.cboFromQuater = null;
    this.cboToQuater = null;
    this.cboFromYear = null;
    this.cboToYear = null;
    this.dateEditFromDate = null;
    this.dateEditToDate = null;
    var datasourceDistrict;
    //CIF1041.comboEmailGroup.dataItem(CIF1041.comboEmailGroup.selectedIndex)
    // Đóng FORM
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    }

    // In báo cáo
    this.btnPrint_Click = function () {

        // Export excel status
        DRF0140.formStatus = 6;

        // Do print or export action
        DRF0140.doPrintOrExport();
    }

    // Xuất excel
    this.btnExport_Click = function () {

        // Export excel status
        DRF0140.formStatus = 5;

        // Do print or export action
        DRF0140.doPrintOrExport();
    }

    // Do print or export
    this.doPrintOrExport = function () {
        // Kiểm tra hợp lệ
        if (ASOFT.form.checkRequired("DRF0140")) {
            return;
        }

        // Lấy dữ liệu trên form
        var data = DRF0140.getFormData();

        if (data) {
            var urlPost = $('#UrlDoPrintOrExport').val();

            ASOFT.helper.post(urlPost, data, DRF0140.exportOrPrintSuccess);
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

    // Lấy dữ liệu
    this.getFormData = function () {

        if (DRF0140.cboPeriod) {
            var dataItem = DRF0140.cboPeriod.dataItem(DRF0140.cboPeriod.selectedIndex);
            if (dataItem) {
                // Lấy giá trị tranmonth, tranyear
                DRF0140.month = dataItem.TranMonth;
                DRF0140.year = dataItem.TranYear;
            }
        }

        if (DRF0140.cboFromPeriod) {
            var dataItem = DRF0140.cboFromPeriod.dataItem(DRF0140.cboFromPeriod.selectedIndex);
            if (dataItem) {
                // Lấy giá trị tranmonth, tranyear
                DRF0140.fromMonth = dataItem.TranMonth;
                DRF0140.fromYear = dataItem.TranYear;
            }
        }

        if (DRF0140.cboToPeriod) {
            var dataItem = DRF0140.cboToPeriod.dataItem(DRF0140.cboToPeriod.selectedIndex);
            if (dataItem) {
                // Lấy giá trị tranmonth, tranyear
                DRF0140.toMonth = dataItem.TranMonth;
                DRF0140.toYear = dataItem.TranYear;
            }
        }

        if (DRF0140.isEnableMonth) { //Combo từ tháng đến tháng
            var dataFromMonthItem = DRF0140.cboFromMonth.dataItem(DRF0140.cboFromMonth.selectedIndex);
            var dataToMonthItem = DRF0140.cboToMonth.dataItem(DRF0140.cboToMonth.selectedIndex);
            if (dataFromMonthItem && dataToMonthItem) {
                // Lấy giá trị tranmonth, tranyear
                DRF0140.fromMonth = dataFromMonthItem.TranMonth;
                DRF0140.fromYear = dataFromMonthItem.TranYear;

                DRF0140.toMonth = dataToMonthItem.TranMonth;
                DRF0140.toYear = dataToMonthItem.TranYear;
            }
        }

        if (DRF0140.isEnableQuater) { //Combo từ quý đến quý
            var dataFromQuaterItem = DRF0140.cboFromQuater.dataItem(DRF0140.cboFromQuater.selectedIndex);
            var dataToQuaterItem = DRF0140.cboToQuater.dataItem(DRF0140.cboToQuater.selectedIndex);
            if (dataFromQuaterItem && dataToQuaterItem) {
                // Lấy giá trị tranmonth, tranyear
                DRF0140.fromMonth = dataFromQuaterItem.TranMonth;
                DRF0140.fromYear = dataFromQuaterItem.TranYear;

                DRF0140.toMonth = dataToQuaterItem.TranMonth;
                DRF0140.toYear = dataToQuaterItem.TranYear;
            }
        }

        if (DRF0140.isEnableYear) { //Combo từ năm đến năm
            var dataFromYearItem = DRF0140.cboFromYear.dataItem(DRF0140.cboFromYear.selectedIndex);
            var dataToYearItem = DRF0140.cboToYear.dataItem(DRF0140.cboToYear.selectedIndex);
            if (dataFromYearItem && dataToYearItem) {
                // Lấy giá trị tranmonth, tranyear
                DRF0140.fromMonth = dataFromYearItem.TranMonth;
                DRF0140.fromYear = dataFromYearItem.TranYear;

                DRF0140.toMonth = dataToYearItem.TranMonth;
                DRF0140.toYear = dataToYearItem.TranYear;
            }
        }

        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "DRF0140");
        data.push({ name: "Month", value: DRF0140.month });
        data.push({ name: "Year", value: DRF0140.year });
        data.unshift({ name: "FromMonth", value: DRF0140.fromMonth });
        data.unshift({ name: "FromYear", value: DRF0140.fromYear });
        data.unshift({ name: "ToMonth", value: DRF0140.toMonth });
        data.unshift({ name: "ToYear", value: DRF0140.toYear });
        data.push({ name: "FormStatus", value: DRF0140.formStatus });

        return data;
    }

    //Sự kiên selectedIndexChanged combo chi nhánh
    this.onBrand_Changed = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#BranchName').val(dataItem.AnaName);
    };

    //Sự kiên selectedIndexChanged combo chi nhánh
    this.onBrand_Bound = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#BranchName').val(dataItem.AnaName);
    };


    this.comboBox_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF0140');
        console.log('combo ' + $(this.element).attr('id') + 'change');
    }
    this.isSaved = false;
    this.isEndRequest = false;
    this.countCombo = 0;
    this.comboNames = ['CityID', 'CityName', 'DistrictID', 'DistrictName']

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF0140.countCombo++;
        if (DRF0140.countCombo == DRF0140.comboNames.length) {
            DRF0140.isEndRequest = true;
        }

        console.log('combo ' + $(this.element).attr('id') + 'end request');
    }

    //load data district khi open combo city
    this.comboBox_Opened1 = function () {
        if (datasourceDistrict) {
            $("#District").data("kendoComboBox").text('');
            $("#District").data("kendoComboBox").setDataSource(datasourceDistrict);
        }
    }

    //khi open combo district
    this.comboBox_Opened = function () {
        DRF0140.loadDataComboBox(this);
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
}