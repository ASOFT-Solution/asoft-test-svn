
POSF0075 = new function () {
    this.POSF0075Popup = null;
    this.fromMonth = null;
    this.fromYear = null;
    this.toMonth = null;
    this.toYear = null;
    this.isDate = 1;
    this.reportGroupRequest = null;
    this.reportTypeRequest = null;
    this.FromPeriod = null;
    this.ToPeriod = null;
    this.FromDate = null;
    this.ToDate = null;

    this.initStatePOSF00751 = function () {
        POSF0075.POSF00751Popup.bind("refresh", function () {
            POSF0075.FromPeriod = ASOFT.asoftComboBox.castName("FromPeriod");
            POSF0075.ToPeriod = ASOFT.asoftComboBox.castName("ToPeriod");
            POSF0075.FromDate = ASOFT.asoftDateEdit.castName("FromDate");
            POSF0075.ToDate = ASOFT.asoftDateEdit.castName("ToDate");

            //Sự kiện cho radio button kì kế toán và ngày
            $("#rdoPeriod").click(function () {
                if ($(this).prop('checked')) {
                    POSF0075.isDate = 0;
                    POSF0075.FromPeriod.enable(true);
                    POSF0075.ToPeriod.enable(true);
                    POSF0075.FromDate.enable(false);
                    POSF0075.ToDate.enable(false);
                }
            });

            $("#rdoDate").click(function () {
                if ($(this).prop('checked')) {
                    POSF0075.isDate = 1;
                    POSF0075.FromPeriod.enable(false);
                    POSF0075.ToPeriod.enable(false);
                    POSF0075.FromDate.enable(true);
                    POSF0075.ToDate.enable(true);
                }
            });
        });
    };


    //////////////////////////// CHỌN BÁO CÁO - MTF0060 /////////////////////////////
    this.showPOSF0075 = function (reportGroupId, reportType, formStatus) {
        var urlContent = "/POS/POSF0075";
        POSF0075.POSF0075Popup = ASOFT.asoftPopup.castName("POSF0075Popup");
        POSF0075.reportGroupRequest = reportGroupId;
        POSF0075.reportTypeRequest = reportType;

        var popup = POSF0075.POSF0075Popup;

        ASOFT.asoftPopup.show(popup, urlContent, { FormStatus: formStatus });
    };

    this.posf0075PostDataReport = function () {
        return {
            GroupID: POSF0075.reportGroupRequest,
            Type: POSF0075.reportTypeRequest
        };
    };

    this.posf0075ReportBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị gán cho textbox
        $("form#POSF0075 input#ReportName").val(dataItem.ReportName);
        $("form#POSF0075 input#Title").val(dataItem.Title);
    };

    this.posf0075ReportChanged = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị gán cho textbox
        $("form#POSF0075 input#ReportName").val(dataItem.ReportName);
        $("form#POSF0075 input#Title").val(dataItem.Title);
    };

    this.btnReportClose_Click = function () {
        POSF0075.POSF0075Popup.close();
    };

    this.btnReportPrint_Click = function () {
        var data = {};
        if ($("form#POSF0075")) {
            data = {
                ReportID: $("form#POSF0075 input#ReportID").val(),
                ReportName: $("form#POSF0075 input#ReportName").val(),
                Title: $("form#POSF0075 input#Title").val()
            };
        }

        ASOFT.helper.setObjectData(data);
        // Phải được định nghĩa lại trong view
        executeFunctionByName(delegateFunction);
    };

    //////////////////////////// CHỌN BÁO CÁO - MTF0061 /////////////////////////////

    this.btnPOSF00751Close_Click = function () {
        POSF0075.POSF00751Popup.close();
    };

    this.getDataPOSF00751 = function () {
        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "POSF00751");
        return data;
    };

    this.btnPOSF00751Print_Click = function () {

        // Kiểm tra hợp lệ
        if (ASOFT.form.checkRequired("POSF00751")) {
            return;
        }
        // Lấy dữ liệu trên form
        var data = POSF0075.getDataPOSF00751();
        data.push({ name: "FromMonth", value: POSF0075.fromMonth });
        data.push({ name: "FromYear", value: POSF0075.fromYear });
        data.push({ name: "ToMonth", value: POSF0075.toMonth });
        data.push({ name: "ToYear", value: POSF0075.toYear });
        data.push({ name: "IsDate", value: POSF0075.isDate });
        data.push({ name: "FormStatus", value: 6 });

        ASOFT.helper.setObjectData(data);
        // Phải được định nghĩa lại trong view
        executeFunctionByName(delegateFunction);
    };


    this.btnPOSF00751Export_Click = function () {

        //// Kiểm tra hợp lệ
        //if (ASOFT.form.checkRequired("MTF0061")) {
        //    return;
        //}
        // Lấy dữ liệu trên form
        var data = POSF0075.getDataPOSF00751();
        data.push({ name: "FromMonth", value: POSF0075.fromMonth });
        data.push({ name: "FromYear", value: POSF0075.fromYear });
        data.push({ name: "ToMonth", value: POSF0075.toMonth });
        data.push({ name: "ToYear", value: POSF0075.toYear });
        data.push({ name: "IsDate", value: POSF0075.isDate });
        data.push({ name: "FormStatus", value: 5 });

        ASOFT.helper.setObjectData(data);
        // Phải được định nghĩa lại trong view
        executeFunctionByName(delegateFunction);
    };

    //this.onBrand_Changed = function () {
    //    var dataItem = this.dataItem(this.selectedIndex);

    //    if (dataItem == null) return;

    //    $('#BranchName').val(dataItem.BranchName);
    //};

    this.onBrand_Bound = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#BranchName').val(dataItem.BranchName);
    };

    //Sự kiên selectedIndexChanged combo đến kì
    this.fromPeriod_Bound = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        POSF0075.fromMonth = dataItem.TranMonth;
        POSF0075.fromYear = dataItem.TranYear;
    };

    //Sự kiên selectedIndexChanged combo đến kì
    this.toPeriod_Bound = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        POSF0075.toMonth = dataItem.TranMonth;
        POSF0075.toYear = dataItem.TranYear;
    };

    this.fromPeriod_Changed = function () {
        var dataItem = this.dataItem(this.selectedIndex);
        POSF0075.fromMonth = dataItem.TranMonth;
        POSF0075.fromYear = dataItem.TranYear;
    };

    this.toPeriod_Changed = function () {
        var dataItem = this.dataItem(this.selectedIndex);
        POSF0075.toMonth = dataItem.TranMonth;
        POSF0075.toYear = dataItem.TranYear;
    };
};
