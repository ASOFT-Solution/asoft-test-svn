var GridWT0095 = null;
var GridWT0096 = null;
var rowNumber = 0;
var row = null;

$(document).ready(function () {
    $("#TxtSearch").remove();
    $("#btnSearchObject").remove();
    LoadPartialFilter();

    GridWT0095 = $("#GridWT0095").data('kendoGrid');
    GridWT0095.bind('dataBound', function (e) {
        $("input[name='radio-check']").click(function () {
            row = $(this).parent().closest('tr');
            refreshGrid();
        })

        if (!GridWT0096) {
            LoadGrid();
        }
    })

    $("#btnChoose").unbind();
    $("#btnChoose").kendoButton({
        "click": SaveCustom_Click,
    });
})

function SaveCustom_Click() {
    var checkedRadio = $('input[name=radio-check]:checked');
    if (checkedRadio.length == 0) {
        console.log('NO MEMEBER CHOOSEN');
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));//ASOFT.helper.getMessage("00ML000066"));
    } else {
        var dataDT = [];
        var ListColumn = $("#ListColumn").val();
        ListColumn = ListColumn.split(',');
        var item = {};
        for (i = 0; i < ListColumn.length - 1; i++) {
            item[ListColumn[i]] = checkedRadio.attr("radio_" + ListColumn[i]);
        }

        var records = ASOFT.asoftGrid.selectedRecords(GridWT0096);

        if (records.length == 0)
            return;

        window.parent.receiveResultCustom(item, records);
        ASOFT.asoftPopup.closeOnly();
    }
}

function refreshGrid() {
    GridWT0096.dataSource.page(1);
}


function LoadPartialFilter() {
    $.ajax({
        url: '/Partial/PartialFilterPOSF00221',
        success: function (result) {
            $(".asf-quick-search-container").before(result);
            BtnFilter_Click();
            var ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });
        }
    });
}

function LoadGrid() {
    $.ajax({
        url: '/Partial/GridPartialWT0096',
        success: function (result) {
            $(".clearfix").after(result);
            GridWT0096 = $("#GridPartialWT0096").data('kendoGrid');
            GridWT0096.bind('dataBound', function (e) {
                rowNumber = 0;
            })
        }
    });
}

function BtnFilter_Click() {
    GridWT0095.dataSource.page(1);
}

function sendDataWT0096() {
    var dataLoad = {};
    //var selectitem = GridWT0095.dataItem(GridWT0095.select());
    var selectitem = GridWT0095.dataItem(row);
    if (selectitem != null) {
        dataLoad.VoucherID = selectitem.VoucherID;
    }
    return dataLoad;
}

function renderNumber(data) {
    return ++rowNumber;
}