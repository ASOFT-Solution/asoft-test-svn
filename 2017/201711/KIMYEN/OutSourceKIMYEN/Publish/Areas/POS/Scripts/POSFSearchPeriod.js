//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//####################################################################

/**
*Sự kiên selectedIndexChanged combo từ kì
*/
function fromPeriod_Cascade(e) {
    var dataItem = this.dataItem(this.selectedIndex);

    if (dataItem == null) {
        return null;
    };

    // Lấy giá trị tranmonth, tranyear
    posViewModel.fromMonth = dataItem.TranMonth;
    posViewModel.fromYear = dataItem.TranYear;
}

/**
*Sự kiên selectedIndexChanged combo đến kì
*/
function toPeriod_Cascade(e) {
    var dataItem = this.dataItem(this.selectedIndex);

    if (dataItem == null) {
        return null;
    }

    // Lấy giá trị tranmonth, tranyear
    posViewModel.toMonth = dataItem.TranMonth;
    posViewModel.toYear = dataItem.TranYear;
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
    $("#rdbIsDate0").trigger('click');
    $("input[name='IsDate']").click(function (e) {
        var value = $(this).attr('value');
        var isDateCheck = (value == '0');
        $("#FromDateFilter").data("kendoDatePicker").enable(isDateCheck);
        $("#ToDateFilter").data("kendoDatePicker").enable(isDateCheck);

        $("#FromPeriodFilter").data("kendoDropDownList").enable(!isDateCheck);
        //$("#ToPeriodFilter").data("kendoComboBox").enable(!isDateCheck);
    });

    // Updated by Thai Son
    // Áp dụng khi dùng layout có chia section
    // null, undefined, "", 0, false
    if (useNewTemplate) {
        // Thay dòng trống mặc định 
        //          <td class="container_label"></td>
        //          <td class="container_control"></td>
        // Bằng dòng trống khi có tìm theo kỳ
        //          <td class="container_period_label"></td>
        //          <td class="container_period_control"></td>
        //          <td class="container_period_space"></td>
        //          <td class="container_period_label"></td>
        //          <td class="container_period_control">
        var element = $('.tr-zero-height')[0];
        $(element).html('<td class="container_period_label"></td> <td class="container_period_control"></td> <td class="container_period_space"></td> <td class="container_period_label"></td> <td class="container_period_control"></td>');

        //// Lấy ra tbody của cột đầu tiên trong form filter
        //var firstTBody = $('form#FormFilter div.grid_4 table.asf-table-view tbody')[0];

        //// Lấy số lượng thẻ con <tr> của tbody
        //var count = $(firstTBody).children().length;

        //// Bỏ qua 2 thẻ <tr> đầu tiên (tìm kỳ và tìm ngày)
        //// Với một thẻ <tr> tiếp theo, ta đặt attr colspan cho các thẻ con <td> là 2
        //for (var i = 2; i < count; i++) {
        //    var tr = $(firstTBody).children()[i]

        //    // đặt attr colspan cho các (2) thẻ con <td> là 2
        //    $.each($(tr).children(), function (i, td) {
        //        $(td).attr('colspan', '2');
        //    });

        //    // Thêm vào một thẻ <td> trống để phân cách
        //    $('<td class="container_period_space"></td>').insertAfter($(tr).children()[0]);
        //}
    }
    //var additionalTD =  $('form#FormFilter div.grid_4 table.asf-table-view tbody tr').last();
}