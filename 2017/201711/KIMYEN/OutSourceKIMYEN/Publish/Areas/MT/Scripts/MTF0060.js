

MTF0060 = new function() {
    this.MTF0060Popup = null;
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
    this.formStatus = 0;

    this.initStateMTF0061 = function() {
        MTF0060.MTF0061Popup.bind("refresh", function () {
            MTF0060.FromPeriod = ASOFT.asoftComboBox.castName("FromPeriod");
            MTF0060.ToPeriod = ASOFT.asoftComboBox.castName("ToPeriod");
            MTF0060.FromDate = ASOFT.asoftDateEdit.castName("FromDate");
            MTF0060.ToDate = ASOFT.asoftDateEdit.castName("ToDate");

            //Sự kiện cho radio button kì kế toán và ngày
            $("#rdoPeriod").click(function () {
                if ($(this).prop('checked')) {
                    MTF0060.isDate = 0;
                    MTF0060.FromPeriod.enable(true);
                    MTF0060.ToPeriod.enable(true);
                    MTF0060.FromDate.enable(false);
                    MTF0060.ToDate.enable(false);
                }
            });

            $("#rdoDate").click(function () {
                if ($(this).prop('checked')) {
                    MTF0060.isDate = 1;
                    MTF0060.FromPeriod.enable(false);
                    MTF0060.ToPeriod.enable(false);
                    MTF0060.FromDate.enable(true);
                    MTF0060.ToDate.enable(true);
                }
            });
        });
    };
    

    //////////////////////////// CHỌN BÁO CÁO - MTF0060 /////////////////////////////
    this.showMTF0060 = function(reportGroupId, reportType, formStatus) {
        var urlContent = "/MT/MTF0060";
        MTF0060.MTF0060Popup = ASOFT.asoftPopup.castName("MTF0060Popup");
        MTF0060.reportGroupRequest = reportGroupId;
        MTF0060.reportTypeRequest = reportType;

        var popup = MTF0060.MTF0060Popup;

        ASOFT.asoftPopup.show(popup, urlContent, { FormStatus: formStatus });
    };

    this.mtf0060PostDataReport = function() {
        return {
            GroupID: MTF0060.reportGroupRequest,
            Type: MTF0060.reportTypeRequest
        };
    };

    this.mtf0060ReportBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị gán cho textbox
        $("form#MTF0060 input#ReportName").val(dataItem.ReportName);
        $("form#MTF0060 input#Title").val(dataItem.Title);
    };

    this.mtf0060ReportChanged = function() {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị gán cho textbox
        $("form#MTF0060 input#ReportName").val(dataItem.ReportName);
        $("form#MTF0060 input#Title").val(dataItem.Title);
    };

    this.btnReportClose_Click = function() {
        MTF0060.MTF0060Popup.close();
    };

    this.btnReportPrint_Click = function() {
        var data = { };
        if ($("form#MTF0060")) {
            data = {
                ReportID: $("form#MTF0060 input#ReportID").val(),
                ReportName: $("form#MTF0060 input#ReportName").val(),
                Title: $("form#MTF0060 input#Title").val()
            };
        }

        ASOFT.helper.setObjectData(data);
        // Phải được định nghĩa lại trong view
        executeFunctionByName(delegateFunction);
    };

    //////////////////////////// CHỌN BÁO CÁO - MTF0061 /////////////////////////////
    
    this.btnMTF0061Close_Click = function() {
        MTF0060.MTF0061Popup.close();
    };

    this.getDataMTF0061 = function() {
        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "MTF0061");
        return data;
    };

    this.btnMTF0061Print_Click = function() {

        // Kiểm tra hợp lệ
        if (ASOFT.form.checkRequired("MTF0061")) {
            return;
        }
        // Lấy dữ liệu trên form
        var data = MTF0060.getDataMTF0061();
        data.push({ name: "FromMonth", value: MTF0060.fromMonth });
        data.push({ name: "FromYear", value: MTF0060.fromYear });
        data.push({ name: "ToMonth", value: MTF0060.toMonth });
        data.push({ name: "ToYear", value: MTF0060.toYear });
        data.push({ name: "IsDate", value: MTF0060.isDate });
        data.push({ name: "FormStatus", value: 6 });

        ASOFT.helper.setObjectData(data);
        // Phải được định nghĩa lại trong view
        executeFunctionByName(delegateFunction);
    };


    this.btnMTF0061Export_Click = function() {

        // Kiểm tra hợp lệ
        if (ASOFT.form.checkRequired("MTF0061")) {
            return;
        }
        // Lấy dữ liệu trên form
        var data = MTF0060.getDataMTF0061();
        data.push({ name: "FromMonth", value: MTF0060.fromMonth });
        data.push({ name: "FromYear", value: MTF0060.fromYear });
        data.push({ name: "ToMonth", value: MTF0060.toMonth });
        data.push({ name: "ToYear", value: MTF0060.toYear });
        data.push({ name: "IsDate", value: MTF0060.isDate });
        data.push({ name: "FormStatus", value: 5 });

        ASOFT.helper.setObjectData(data);
        // Phải được định nghĩa lại trong view
        executeFunctionByName(delegateFunction);
    };

    this.onBrand_Changed = function() {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#BranchName').val(dataItem.AnaName);
    };

    this.onBrand_Bound = function() {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#BranchName').val(dataItem.AnaName);
    };

    //Sự kiên selectedIndexChanged combo đến kì
    this.fromPeriod_Bound = function() {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF0060.fromMonth = dataItem.TranMonth;
        MTF0060.fromYear = dataItem.TranYear;
    };

    //Sự kiên selectedIndexChanged combo đến kì
    this.toPeriod_Bound = function() {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF0060.toMonth = dataItem.TranMonth;
        MTF0060.toYear = dataItem.TranYear;
    };

    this.fromPeriod_Changed = function() {
        var dataItem = this.dataItem(this.selectedIndex);
        MTF0060.fromMonth = dataItem.TranMonth;
        MTF0060.fromYear = dataItem.TranYear;
    };

    this.toPeriod_Changed = function() {
        var dataItem = this.dataItem(this.selectedIndex);
        MTF0060.toMonth = dataItem.TranMonth;
        MTF0060.toYear = dataItem.TranYear;
    };
};
