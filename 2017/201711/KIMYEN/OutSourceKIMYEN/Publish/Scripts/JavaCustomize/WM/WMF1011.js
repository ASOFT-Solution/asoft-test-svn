//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     11/12/2017      Kiều Nga          Tạo mới
//####################################################################

var divgroupcbb = "<div class='asf-filter-main groupcbb' >"
"</div>";
var divChild = "<div class ='asf-width-20'  id ='{0}'> " +
                    "<div class ='asf-filter-label'>" +
                    "</div>" +
                    "<div class ='asf-filter-input'>" +
                    "</div>"
"</div>";
var divLocation = "<div class='asf-filter-main groupLocation'><div class='block-left' id ='divLocationID'><div class ='asf-filter-label'></div><div class ='asf-filter-input'></div></div><div class='block-right' id ='divDisabled'></div></div>";
$(document).ready(function () {
    $("#WMF1011").prepend(divLocation);
    $("#divLocationID .asf-filter-label").append($(".LocationID").children()[0]);
    $("#divLocationID .asf-filter-input").append($($(".LocationID").children()[0]).children());

    if ($("#isUpdate").val() == "True") {
        //$("#divDisabled").append($($(".Disabled").children()[1]).html());
        //$(".Disabled").css('display', 'none');

        $("#divDisabled").append($(".Disabled"));
        $(".Disabled .asf-td-caption").remove();
    }
    $(".WareHouseID").css('display', 'none');
    $(".Level1ID").css('display', 'none');
    $(".Level2ID").css('display', 'none');
    $(".Level3ID").css('display', 'none');
    $(".Level4ID").css('display', 'none');
    $(".LocationID").css('display', 'none');

    $("#WMF1011").prepend(divgroupcbb);
    $(".groupcbb").append(kendo.format(divChild, "divWareHouseID"));
    $(".groupcbb").append(kendo.format(divChild, "divLevel1ID"));
    $(".groupcbb").append(kendo.format(divChild, "divLevel2ID"));
    $(".groupcbb").append(kendo.format(divChild, "divLevel3ID"));
    $(".groupcbb").append(kendo.format(divChild, "divLevel4ID"));

    $("#divWareHouseID .asf-filter-label").append($(".WareHouseID").children()[0]);
    $("#divWareHouseID .asf-filter-input").append($($(".WareHouseID").children()[0]).children());

    $("#divLevel1ID .asf-filter-label").append($(".Level1ID").children()[0]);
    $("#divLevel1ID .asf-filter-input").append($($(".Level1ID").children()[0]).children());

    $("#divLevel2ID .asf-filter-label").append($(".Level2ID").children()[0]);
    $("#divLevel2ID .asf-filter-input").append($($(".Level2ID").children()[0]).children());

    $("#divLevel3ID .asf-filter-label").append($(".Level3ID").children()[0]);
    $("#divLevel3ID .asf-filter-input").append($($(".Level3ID").children()[0]).children());

    $("#divLevel4ID .asf-filter-label").append($(".Level4ID").children()[0]);
    $("#divLevel4ID .asf-filter-input").append($($(".Level4ID").children()[0]).children());

    $(".line_left_with_grid").removeClass("line_left_with_grid");

    $("#WareHouseID").change(function(e)
    {
        SetLocation();
    });

    $("#Level1ID").change(function (e) {
        SetLocation();
    });

    $("#Level2ID").change(function (e) {
        SetLocation();
    });

    $("#Level3ID").change(function (e) {
        SetLocation();
    });

    $("#Level4ID").change(function (e) {
        SetLocation();
    });

    function SetLocation() {
        var Location = $("#WareHouseID").val() + "_" + $("#Level1ID").val() + "_" + $("#Level2ID").val() + "_" + $("#Level3ID").val() + "_" + $("#Level4ID").val();
        $("#LocationID").val(Location);
    }
})