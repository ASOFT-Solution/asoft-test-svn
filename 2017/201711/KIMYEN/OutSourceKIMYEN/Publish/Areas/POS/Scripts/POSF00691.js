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
dataRows = {};
$(document).ready(function () {
    var
        btnSearchObject = $('#btnSearchObject'),
        btnCancel = $('#btnCancel'),
        btnChoose = $('#btnChoose'),
        element = $('#GridMember'),
        grid = element.data('kendoGrid'),
        MemberIDTextBox = $('#MemberName')
    //isSearch = false
    ;
    MemberIDTextBox.on('keypress', filterTextBox_KeyPress);
    
    // Xử lý sự kiện ấn phím trong text box tìm mã hàng hóa
    function filterTextBox_KeyPress(e) {
        if (e.keyCode == 13 && $(this).val()) {
            isSearch = 1;
            grid.dataSource.page(1);
        }
    };

    grid.bind('dataBound', function () {
        var length = grid.dataSource.data().length;
        element.find('td:nth-child(3n+1)').addClass('asf-cols-align-center');
        initEventOnTableCell();
        MemberIDTextBox.focus().select();

    });

    ASOFT.sendDataSearch = function () {
        var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
        //datamaster['IsSearch'] = isSearch;
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

        if (!dataRows) {
            console.log('NO MEMEBER CHOOSEN');
        } else {
            window.parent.recieveResult(dataRows);
        }

        ASOFT.asoftPopup.closeOnly();
    }

    // Khởi tạo sự kiện click lên một ô chứa checkbox "chọn"
    function initEventOnTableCell() {
        if (dataRows) {
            $('input[type="checkbox"]').off('click');

            $.each($(grid.element).find('input[type="checkbox"]'), function () {
                $(this).prop('checked', 'checked');
            });
            var rows = ASOFT.asoftGrid.selectedRecords(grid);
            $.each(rows, function (i, val) {
                if (dataRows[val.MemberID] === undefined) {
                    $(grid.element).children('.k-grid-content').find('table').find('tr[data-uid="' + val.uid + '"]').find('input[type="checkbox"]').removeAttr('checked');
                }
            });

            checkAll();
        }

        var ckb_Click = function (e) {
            if (this.checked) {
                if (this.id == "chkAll") {
                    var rows = ASOFT.asoftGrid.selectedRecords(grid);
                    $.each(rows, function (i, val) {
                        dataRows[val.MemberID] = val;
                    });
                } else {
                    var single = ASOFT.asoftGrid.selectedRecord(grid);
                    dataRows[single.MemberID] = single;
                }
            }
            else {
                if (this.id == "chkAll") {
                    var rows = ASOFT.asoftGrid.selectedRecords(grid);
                    $.each(rows, function (i, val) {
                        delete dataRows[val.MemberID];
                    });
                } else {
                    var single = ASOFT.asoftGrid.selectedRecord(grid);
                    delete dataRows[single.MemberID];
                }
            }

            checkAll();
            console.log(dataRows);
        }

       $('input[type="checkbox"]').on('click', ckb_Click);
    }

    function checkAll() {
        var length = 0;
        $.each($(grid.element).find('input:not(#chkAll)[type="checkbox"]'), function (i, val) {
            if (val.checked) {
                length++;
            }
        });

        if (length == grid.pager.pageSize()) {
            $('input#chkAll').prop('checked', 'checked');
        } else {
            $('input#chkAll').removeAttr('checked');
        }
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
    //datamaster['isSearch'] = isSearch;
    return datamaster;
}

//function btnSearchObject_Click() {
//    isSearch = true;
//    POSF00202Grid.dataSource.page(1);

//}