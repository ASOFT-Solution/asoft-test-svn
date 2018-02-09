//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     18/09/2014      Đức Quý         Tạo mới
//####################################################################

DRMPeriodFilter = new function () {
    this.isDate = 0;
    this.fromMonth = null;
    this.fromYear = null;
    this.toMonth = null;
    this.toYear = null;
    this.fromDate = null;
    this.toDate = null;
    this.fromPeriod = null;
    this.toPeriod = null;

    //Get tranmonth, tranyear combobox FromPeriod
    this.fromPeriod_Changed = function (e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return null;
        };

        // Lấy giá trị tranmonth, tranyear
        DRMPeriodFilter.fromMonth = dataItem.TranMonth;
        DRMPeriodFilter.fromYear = dataItem.TranYear;
    }

    //Get tranmonth, tranyear combobox toPeriod
    this.toPeriod_Changed = function (e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return null;
        };

        // Lấy giá trị tranmonth, tranyear
        DRMPeriodFilter.toMonth = dataItem.TranMonth;
        DRMPeriodFilter.toYear = dataItem.TranYear;
    }

    //Sự kiên data bound combo từ kì
    this.fromPeriod_DataBound = function (e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return null;
        };

        // Lấy giá trị tranmonth, tranyear
        DRMPeriodFilter.fromMonth = dataItem.TranMonth;
        DRMPeriodFilter.fromYear = dataItem.TranYear;
    };

    //Sự kiên data bound combo đến kì
    this.toPeriod_DataBound = function (e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return null;
        };

        // Lấy giá trị tranmonth, tranyear
        DRMPeriodFilter.toMonth = dataItem.TranMonth;
        DRMPeriodFilter.toYear = dataItem.TranYear;
    };
}

/**
* Install Period
*/
function resetPeriod() {
    $("#rdbIsDate0").trigger('click');
}

/**
* Install Period
*/
function installPeriod(useNewTemplate) {
    $("#rdbIsDate").trigger('click');
    $("input[name='IsDate']").click(function (e) {
        var value = $(this).attr('value');
        var isDateCheck = (value == '0');
        $("#FromDateFilter").data("kendoDatePicker").enable(isDateCheck);
        $("#ToDateFilter").data("kendoDatePicker").enable(isDateCheck);

        $("#FromPeriodFilter").data("kendoComboBox").enable(!isDateCheck);
        $("#ToPeriodFilter").data("kendoComboBox").enable(!isDateCheck);
    });

    // Updated by Thai Son
    // Áp dụng khi dùng layout có chia section
    if (useNewTemplate) {
        var element = $('.tr-zero-height')[0];
        $(element).html('<td class="container_period_label"></td> <td class="container_period_control"></td> <td class="container_period_space"></td> <td class="container_period_label"></td> <td class="container_period_control"></td>');
    }
}

$(document).ready(function () {
    DRMPeriodFilter.fromPeriod = ASOFT.asoftComboBox.castName('FromPeriodFilter');
    DRMPeriodFilter.toPeriod = ASOFT.asoftComboBox.castName('ToPeriodFilter');
    DRMPeriodFilter.fromDate = ASOFT.asoftDateEdit.castName('FromDateFilter');
    DRMPeriodFilter.toDate = ASOFT.asoftDateEdit.castName('ToDateFilter');

    $('#rdbIsDate').change(function (e) {
        if ($(this).prop('checked')) {
            DRMPeriodFilter.isDate = 1;
            DRMPeriodFilter.fromPeriod.enable(false);
            DRMPeriodFilter.toPeriod.enable(false);
            DRMPeriodFilter.fromDate.enable(true);
            DRMPeriodFilter.toDate.enable(true);
        }
    });

    $('#rdbIsPeriod').change(function (e) {
        if ($(this).prop('checked')) {
            DRMPeriodFilter.isDate = 0;
            //DRMPeriodFilter.isDate = 1;
            DRMPeriodFilter.fromPeriod.enable(true);
            DRMPeriodFilter.toPeriod.enable(true);
            DRMPeriodFilter.fromDate.enable(false);
            DRMPeriodFilter.toDate.enable(false);

            DRMPeriodFilter.fromPeriod.refresh();
            DRMPeriodFilter.toPeriod.refresh();
            //var dataFromPeriod = DRMPeriodFilter.fromPeriod.dataItem(DRMPeriodFilter.fromPeriod.selectedIndex);
            //var dataToPeriod = DRMPeriodFilter.toPeriod.dataItem(DRMPeriodFilter.toPeriod.selectedIndex);

            //if (dataFromPeriod && dataToPeriod) {
            //    DRMPeriodFilter.fromMonth = dataFromPeriod.TranMonth;
            //    DRMPeriodFilter.fromYear = dataFromPeriod.TranYear;
            //    DRMPeriodFilter.toMonth = dataToPeriod.TranMonth;
            //    DRMPeriodFilter.toYear = dataToPeriod.TranYear;
            //}
        }
    })
})