//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     29/04/2014      Dam Mo          tạo mới
//#     19/07/2014      Thai Son        Update
//####################################################################
var ASOFT = ASOFT || {},
    isSearch = false;

$(document).ready(function () {
    var 
        btnSearchMember = $('#btnSearchMember'),
        btnCancel = $('#btnCancel'),
        btnChoose = $('#btnChoose'),
        element = $('#GridMembers'),
        grid = element.data('kendoGrid'),
        searchTextBox = $('#MemberID')
        //isSearch = false
    ;

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

    });

    ASOFT.sendDataSearch = function () {
        var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
        datamaster['IsSearch'] = isSearch;
        return datamaster;
    };

    btnSearchMember.on('click', btnSearchMember_Click);
    btnChoose.on('click', btnChoose_Click);
    btnCancel.on('click', ASOFT.asoftPopup.closeOnly);
    searchTextBox.on('keypress', function (e) {
        if (e.keyCode === 13) {
            btnSearchMember_Click();
            searchTextBox.focus();
        }
    });

    function btnSearchMember_Click() {
        isSearch = true;
        grid.dataSource.page(1);
    }

    function btnChoose_Click(e) {
        var checkedRadio = $('input[name=radio-check]:checked'),
            selectedMemberID = checkedRadio.attr('data-member-id'),
            selectedMemberName = checkedRadio.attr('data-member-name');

        if (!selectedMemberID) {
            console.log('NO MEMEBER CHOOSEN');
        } else {
            window.parent.posViewModel.recieveResult({
                MemberID: selectedMemberID,
                MemberName: selectedMemberName
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
    datamaster['IsSearch'] = isSearch;
    return datamaster;
}

//function btnSearchMember_Click() {
//    isSearch = true;
//    POSF00202Grid.dataSource.page(1);

//}