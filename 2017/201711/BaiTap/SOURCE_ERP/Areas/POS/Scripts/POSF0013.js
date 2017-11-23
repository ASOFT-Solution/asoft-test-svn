//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     11/04/2014      Đam Mơ          Tạo mới
//####################################################################

var POSF0013Grid = null;
// Biến kiểm tra lọc dữ liệu
var isSearch = false;

$(document).ready(function ()
{
    var GRID_ID = '#POSF0013Grid',
        colCount = 6;

    POSF0013Grid = $('#POSF0013Grid').data('kendoGrid');

    POSF0013Grid.bind('dataBound', function () {
        $(GRID_ID).find('td:nth-child(6n+2), td:nth-child(6n+3), td:nth-child(6n+6), td:nth-child(6n+5)').addClass('asf-cols-align-center');
          
    });
});

// refresh POSF0013Grid
function refreshGrid() {
    POSF0013Grid.dataSource.page(1);
}

// Hàm gởi dữ liệu từ FormFilter
function sendDataFilter()
{
    var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
    datamaster['IsSearch'] = isSearch;
    return datamaster;
}

// Xử lý button search
function posf0013BtnFilter_Click()
{
    isSearch = true;
    refreshGrid();
}

// Xử lý button clearsearch
function posf0013BtnClearFilter_Click()
{
    isSearch = false;
    // Reset business combobox
    var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
    resetDropDown(multiComboBox);
    // Reset các field còn lại
    $('#PaymentIDFilter').val('');
    $('#PaymentNameFilter').val('');
    //POSF0013Grid.dataSource.page(0);
}