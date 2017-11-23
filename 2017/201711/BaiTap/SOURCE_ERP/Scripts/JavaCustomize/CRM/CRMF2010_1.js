$(document).ready(function (e) {
    var listLB = $(".Address").find("td")[0];
    $(listLB).css("background-color", "#000000");
    $(listLB).css("color", "#fff");

    grid = $('#GridOT2001').data('kendoGrid');
    grid.bind("dataBound", RowGrid_ChangeColor);
    grid.hideColumn("");

    setTimeout(function () {
        $("#ShipDate_CRMF2010").val("");

        var ObjectID = $("#ObjectID_CRMF2010").parent().parent();
        $("#ObjectName_CRMF2010").parent().parent().before(ObjectID);

        var DeliveryEmployeeName = $("#DeliveryEmployeeName_CRMF2010").parent().parent();
        $(".col3 .asf-table-view").prepend(DeliveryEmployeeName);
    }, 500);

    //setInterval(LoadEveryMinute, 60000);
});

function Coordi_Click(t) {
    if ($(t).attr("aria-disabled") == "true")
    {
        return;
    }
    var apk = $(t).attr("value");
    var urlAdd = "/CRM/CRMF2011?APK=" + apk;
    ASOFT.asoftPopup.showIframe(urlAdd, {});
};

function LoadEveryMinute()
{
    grid = $('#GridOT2001').data('kendoGrid').dataSource.page(1);
}

function RowGrid_ChangeColor(e) {
    //lấy giá trị của lưới
    var item = e.sender._data;

    //lấy tất cả các dòng grid
    var rows = $('div.k-grid-content table tr');

    for (var i = 0; i < item.length; i++) {
        if (item[i].ColorID == 1) {
            $(rows[i]).css('background', '#b24040');//Do
        } else if (item[i].ColorID == 2) {
            $(rows[i]).css('background', '#a4b00a');//Vang
        }
        else if (item[i].ColorID == 3) {
            $(rows[i]).css('background', '#3e96b7');//Xanh
        }
    }
}

function genCoordi(data) {
    if (data && data.IsinvoiceId != null)
    {
        if (data.IsinvoiceId == "0")
        {
            return "k-button k-button-icontext asf-button k-state-disabled";
        }
        return "k-button k-button-icontext asf-button";
    }
    return "k-button k-button-icontext asf-button k-state-disabled";
}

function genCoordiEvent(data)
{
    if (data && data.IsinvoiceId != null)
    {
        if (data.IsinvoiceId == "0")
        {
            return true;
        }
        return false;
    }
    return true;
}