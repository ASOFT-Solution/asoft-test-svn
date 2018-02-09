//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     29/10/2014      Trí Thiện       Tạo mới
//####################################################################

$(document).ready(function () {
    DRF0190.cboPeriod = ASOFT.asoftComboBox.castName('Period');
    DRF0190.cboReport = ASOFT.asoftComboBox.castName('ReportID');
});


DRF0190 = new function () {
    this.month = null;
    this.year = null;
    this.customerId = null;
    this.formStatus = null;
    this.cboPeriod = null;
    this.cboReport = null;
    this.comboRequires = ["ReportID"];

    //CIF1041.comboEmailGroup.dataItem(CIF1041.comboEmailGroup.selectedIndex)
    // Đóng FORM
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    }

    // In báo cáo
    this.btnPrint_Click = function () {

        // Export excel status
        DRF0190.formStatus = 6;

        // Do print or export action
        DRF0190.doPrintOrExport();
    }

    // Xuất excel
    this.btnExport_Click = function () {

        // Export excel status
        DRF0190.formStatus = 5;

        // Do print or export action
        DRF0190.doPrintOrExport();
    }

    // Do print or export
    this.doPrintOrExport = function () {
        // Kiểm tra hợp lệ
        if (ASOFT.form.checkRequiredAndInList("DRF0190", DRF0190.comboRequires)) {
            return;
        }

        // Lấy dữ liệu trên form
        var data = DRF0190.getFormData();

        if (data) {
            var urlPost = $('#UrlDoPrintOrExport').val();

            ASOFT.helper.post(urlPost, data, DRF0190.exportOrPrintSuccess);
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

        if (DRF0190.cboPeriod) {
            var dataItem = DRF0190.cboPeriod.dataItem(DRF0190.cboPeriod.selectedIndex);
            if (dataItem) {
                // Lấy giá trị tranmonth, tranyear
                DRF0190.month = dataItem.TranMonth;
                DRF0190.year = dataItem.TranYear;
            }
        }

        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "DRF0190");
        data.push({ name: "Month", value: DRF0190.month });
        data.push({ name: "Year", value: DRF0190.year });
        data.push({ name: "FormStatus", value: DRF0190.formStatus });

        return data;
    }

    //Sự kiên selectedIndexChanged combo chi nhánh
    this.onCustomer_Bound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        DRF0190.customerId = dataItem.CustomerID;
        $('#CustomerName').val(dataItem.CustomerName);

        ASOFT.asoftComboBox.callBack(DRF0190.cboReport, { CustomerID: dataItem.CustomerID });
        
    };

    //Sự kiên selectedIndexChanged combo chi nhánh
    this.onCustomer_Changed = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        DRF0190.customerId = dataItem.CustomerID;
        $('#CustomerName').val(dataItem.CustomerName);

        ASOFT.asoftComboBox.callBack(DRF0190.cboReport, { CustomerID: dataItem.CustomerID });
    };

    this.onReport_Bound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        this.selectedIndex = 0;

        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;
        
        // Lấy giá trị gán cho textbox
        $("input#ReportName").val(dataItem.ReportName);
        $("input#Title").val(dataItem.ReportName);
    }

    this.onReport_Changed = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị gán cho textbox
        $("input#ReportName").val(dataItem.ReportName);
        $("input#Title").val(dataItem.ReportName);
    }
}