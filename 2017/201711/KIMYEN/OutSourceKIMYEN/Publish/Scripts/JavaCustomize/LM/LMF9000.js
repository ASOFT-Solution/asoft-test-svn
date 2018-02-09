var GridLMP9001 = null;
var GridLMP9002 = null;
var rowNumber = 0;
var row = null;
var arrVoucherID = [];
var arrTransactionID = [];

Array.prototype.remove = function () {
    var what, a = arguments, L = a.length, ax;
    while (L && this.length) {
        what = a[--L];
        while ((ax = this.indexOf(what)) !== -1) {
            this.splice(ax, 1);
        }
    }
    return this;
};

$(document).ready(function () {
    $("#TxtSearch").remove();
    $("#btnSearchObject").remove();
    LoadPartialFilter();
    LoadGrid();

    GridLMP9001 = $("#GridLMT9000").data('kendoGrid');
    if (window.parent.$("#ScreenID").context.title.split('-')[1].trim() == 'LMF2011') {
        $("#GridLMT9000").find("input[id='chkAll']").css('display', 'none');
    }
    GridLMP9001.bind('dataBound', function (e) {
        $('#GridLMT9000 input#chkAll').click(function (e) {
            if ($('#GridLMT9000 #chkAll').prop('checked')) {
                var dataSource = GridLMP9001.dataSource._data;
                arrVoucherID = dataSource.map(function (item) { return item.VoucherID });
            } else {
                arrVoucherID = [];
            }
            refreshGrid();
        });

        $('#GridLMT9000 input[type="checkbox"]').not('#chkAll').click(function (e) {
            row = $(this).parent().closest('tr');
            var selectitem = GridLMP9001.dataItem(row);
            if (selectitem) {
                if ($(this).prop('checked')) {
                    if (!arrVoucherID.includes(selectitem.VoucherID))
                        arrVoucherID.push(selectitem.VoucherID);
                } else {
                    arrVoucherID.remove(selectitem.VoucherID);
                }
            }
            refreshGrid();
        });
    })

    $("#btnChoose").unbind();
$("#btnChoose").kendoButton({
    "click": SaveCustom_Click,
});
})

function LoadPartialFilter() {
    $.ajax({
        url: '/Partial/PartialFilter_LMF9000',
        success: function (result) {
            $(".asf-quick-search-container").before(result);
            var ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });
            BtnFilter_Click();
        }
    });
}

function LoadGrid() {
    $.ajax({
        url: '/Partial/GridPartialLMP9002',
        success: function (result) {
            $(".clearfix").after(result);
            GridLMP9002 = $("#GridPartialLMP9002").data('kendoGrid');
            $("#GridPartialLMP9002").find("input[id='chkAll']").addClass('gridLMP9002')
            if (window.parent.$("#ScreenID").context.title.split('-')[1].trim() == 'LMF2011') {
                $("#GridPartialLMP9002").find("input[id='chkAll']").css('display', 'none');
            }
            GridLMP9002.bind('dataBound', function (e) {
                rowNumber = 0;
                if (window.parent.$("#ScreenID").context.title.split('-')[1].trim() == 'LMF2011') {
                    $('#GridPartialLMP9002 input[type="checkbox"]').not('#chkAll').click(function (e) {
                        row = $(this).parent().closest('tr');
                        var selectitem = GridLMP9002.dataItem(row);
                        if (selectitem) {
                            if ($(this).prop('checked')) {
                                $('#GridPartialLMP9002 input[type="checkbox"]').prop('checked', false);
                                $(this).prop('checked', true);
                                if (!arrTransactionID.includes(selectitem.TransactionID))
                                    arrTransactionID.push(selectitem.TransactionID);
                            } else {
                                arrTransactionID.remove(selectitem.TransactionID);
                            }
                        }
                    });
                } else {
                    var view = GridLMP9002.dataSource.view();
                    for (var i = 0; i < view.length; i++) {
                        if ($.inArray(view[i].TransactionID, arrTransactionID) != -1) {
                            $($(this.element.context).find('input[type="checkbox"]').not('input#chkAll')[i]).prop('checked', true);
                        }
                    }

                    $('#GridPartialLMP9002 input#chkAll').click(function (e) {
                        if ($('#GridLMT9000 #chkAll').prop('checked')) {
                            var dataSource = GridLMP9002.dataSource._data;
                            arrTransactionID = dataSource.map(function (item) { return item.TransactionID });
                        } else {
                            arrTransactionID = [];
                        }
                    });

                    $('#GridPartialLMP9002 input[type="checkbox"]').not('#chkAll').click(function (e) {
                        row = $(this).parent().closest('tr');
                        var selectitem = GridLMP9002.dataItem(row);
                        if (selectitem) {
                            if ($(this).prop('checked')) {
                                if (!arrTransactionID.includes(selectitem.TransactionID))
                                    arrTransactionID.push(selectitem.TransactionID);
                            } else {
                                arrTransactionID.remove(selectitem.TransactionID);
                            }
                        }
                    });
                }
            })
        }
    });
}

function SaveCustom_Click() {
    if (arrVoucherID.length == 0) {
        console.log('NO MEMEBER CHOOSEN');
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));//ASOFT.helper.getMessage("00ML000066"));
    } else {
        var records = ASOFT.asoftGrid.selectedRecords(GridLMP9002);
        var item = null;
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            arrTransactionID.push(records[i].TransactionID);
        }

        var data = {
            lstTransactionID: arrTransactionID.join(',')
        };
        url = '/LM/LMF9000/GetDataInherit';
        ASOFT.helper.postTypeJson(url, data, function (data1) {
            window.parent.receiveResultLMF9000(data1);
            ASOFT.asoftPopup.closeOnly();
        });
    }
}

function BtnFilter_Click() {
    GridLMP9001.dataSource.page(1);
    arrVoucherID = [];
    arrTransactionID = [];

    //refreshGrid();
}

function renderNumber(data) {
    return ++rowNumber;
}

function sendDataLMP9002() {
    var dataLoad = {};
    if (arrVoucherID.length > 0) {
        dataLoad.VoucherID = arrVoucherID.join(",");
        dataLoad.FormID = 'LMF2011';
    }
    return dataLoad;
}

function refreshGrid() {
    GridLMP9002.dataSource.page(1);
}