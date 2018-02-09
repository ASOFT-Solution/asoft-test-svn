//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     29/04/2014      Dam Mo          tạo mới
//#     19/07/2014      Thai Son        Update
//####################################################################
var ASOFT = ASOFT || {},
    isSearch = 0;

$(document).ready(function () {
    var
        btnSearchObject = $('#btnSearchObject'),
        btnCancel = $('#btnCancel'),
        btnChoose = $('#btnChoose'),
        element = $('#GridObjects'),
        grid = element.data('kendoGrid'),
        ObjectIDTextBox = $('#ObjectID')
    //isSearch = false
    ;
    ObjectIDTextBox.on('keypress', filterTextBox_KeyPress);
    
    // Xử lý sự kiện ấn phím trong text box tìm mã hàng hóa
    function filterTextBox_KeyPress(e) {
        if (e.keyCode == 13 && $(this).val()) {
            isSearch = 1;
            grid.dataSource.page(1);
        }
    };

    // Khởi tạo sự kiện click lên một ô chứa checkbox "chọn"
    function initEventOnTableCell() {
        var td_Click = function (index) {
            var checkBox = $($(this).children()[0]);
            checkBox.attr('checked', !checkBox.attr('checked'));
        };

        var ckb_Click = function (e) {
            e.stopPropagation();
        }

        $('td').has('input[type="radio"]').on('click', td_Click);
        $('input[type="radio"]').on('click', ckb_Click);
    }

    grid.bind('dataBound', function () {
        var length = grid.dataSource.data().length;
        element.find('td:nth-child(3n+1)').addClass('asf-cols-align-center');
        initEventOnTableCell();
        ObjectIDTextBox.focus().select();

    });

    ASOFT.sendDataSearch = function () {
        var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
        datamaster['IsSearch'] = isSearch;
        return datamaster;
    };

    btnSearchObject.on('click', btnSearchObject_Click);
    btnChoose.on('click', btnChoose_Click);
    btnCancel.on('click', ASOFT.asoftPopup.closeOnly);

    function btnSearchObject_Click() {
        isSearch = 1;
        grid.dataSource.page(1);
    }

    function btnChoose_Click(e) {
        var checkedRadio = $('input[name=radio-check]:checked'),
            selectedObjectID = checkedRadio.attr('data-object-id'),
            selectedObjectName = checkedRadio.attr('data-object-name');

        if (!selectedObjectID) {
            console.log('NO MEMEBER CHOOSEN');
        } else {
            window.parent.recieveResult({
                ObjectID: selectedObjectID,
                ObjectName: selectedObjectName
            });
        }

        ASOFT.asoftPopup.closeOnly();
    }


});
///**
//* Đóng popup
//*/
//function Cancel_Click(event) {
//    parent.inherit_Close(event);
//}

//function posf00202Choose_Click() { }

// Hàm gởi dữ liệu từ FormFilter
function sendDataSearch() {
    var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
    datamaster['isSearch'] = isSearch;
    return datamaster;
}

//function btnSearchObject_Click() {
//    isSearch = true;
//    POSF00202Grid.dataSource.page(1);

//}