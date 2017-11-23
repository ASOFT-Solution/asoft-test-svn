var GridOT2101 = null;
var GridOT2102 = null;
var rowNumber = 0;
var row = null;

$(document).ready(function () {
    $("#TxtSearch").remove();
    $("#btnSearchObject").remove();
    LoadPartialFilter();
    LoadGrid();

    GridOT2101 = $("#GridOT2101").data('kendoGrid');
    GridOT2101.bind('dataBound', function (e) {
        $("input[name='radio-check']").click(function () {
            row = $(this).parent().closest('tr');
            refreshGrid();
        })
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

        var records = ASOFT.asoftGrid.selectedRecords(GridOT2102);

        if (records.length == 0)
            return;

        window.parent.receiveResultCustom(item, records);
        ASOFT.asoftPopup.closeOnly();
    }
}

function refreshGrid() {
    GridOT2102.dataSource.page(1);
}


function LoadPartialFilter() {
    $.ajax({
        url: '/Partial/PartialFilter',
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
        url: '/Partial/GridPartialOT2102',
        success: function (result) {
            $(".clearfix").after(result);
            GridOT2102 = $("#GridPartialOT2102").data('kendoGrid');
            GridOT2102.bind('dataBound', function (e) {
                rowNumber = 0;
            })
        }
    });
}

function BtnFilter_Click() {
    GridOT2101.dataSource.page(1);
}

function sendDataOT2101() {
    var dataLoad = {};
    //var selectitem = GridOT2101.dataItem(GridOT2101.select());
    var selectitem = GridOT2101.dataItem(row);
    if (selectitem != null) {
        dataLoad.QuotationID = selectitem.QuotationID;
    }
    return dataLoad;
}

function renderNumber(data) {
    return ++rowNumber;
}