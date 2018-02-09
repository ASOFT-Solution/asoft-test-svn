$(document).ready(function () {
    CSMF2002.Layout();
    CSMF2002.addnew();
    getAPK();
    CSMF2002.addbtn();
    CSMF2002.choosebuttonedit();
    CSMF2002.loadtabCheckOrder();
    CSMF2002.deletetabCheckOrder();
    CSMF2002.GetPartialViewFilter();
    CSMF2002.deletetabdetail();
});

var CSMF2002 = new function () {

    /**  
    * Block control
    *
    * [Kim Vu] Create New [19/01/2018]
    **/
    this.block = '<div class="{0}" style="width:45%"><fieldset id="{1}"><legend style="padding:10px"><label>{2}</label></legend><div class="asf-table-view"></div></fieldset></div>';

    /**  
    * Layout Form
    *
    * [Kim Vu] Create New [19/01/2018]
    **/
    this.Layout = function () {
        var divNotes = $(".Notes").parent().parent().parent();
        // Add Block right thông tin bên giao
        var text = ASOFT.helper.getLanguageString("CSMF2001.Group2", "CSMF2001", "CSM");
        $(divNotes).after(kendo.format(this.block, "asf-content-block last", "Group2", text));

        // Nạp control vào group2
        $("#Group2 .asf-table-view").append($($(".DispatchReceiveName").parent()),
            $($(".StoreReceiveName").parent()),
            $($(".AddressReceive").parent()),
            $($(".ContactNameReceive").parent()),
            $($(".PhoneNumberReceive").parent()),
            $($(".EmailReceive").parent()),
            $($(".SoldToReceive").parent()),
            $($(".ShipToReceive").parent()))

        // Add Block left thông tin bên giao
        text = ASOFT.helper.getLanguageString("CSMF2001.Group1", "CSMF2001", "CSM");
        $(divNotes).after(kendo.format(this.block, "asf-content-block first", "Group1", text));

        // Nạp control vào group1
        $("#Group1 .asf-table-view").append($($(".DispatchSendName").parent()),
            $($(".StoreSendName").parent()),
            $($(".AddressSend").parent()),
            $($(".ContractNameSend").parent()),
            $($(".PhoneNumberSend").parent()),
            $($(".EmailSend").parent()),
            $($(".SlodToSend").parent()),
            $($(".ShipToSend").parent()))
    }

    /**
    click button addnew tab chi tiết đơn hàng
    **/
    this.addnew = function () {
        $("#BtnAddNew_CSMF2003_CSMT2001").unbind("click");
        $("#BtnAddNew_CSMF2003_CSMT2001").bind("click", function () {
            ASOFT.asoftPopup.showIframe("/PopupLayOut/Index/CSM/CSMF2003");
        });
    }

    /**
    thêm button edit, remove tab xác nhận đơn hàng
    **/
    this.addbtn = function () {
        var divbtn = '<div class="asfbtn asfbtn-right-3">'
                        + '<ul class="asf-toolbar">' +
                            '<li style="margin-right: 6px;">' +
                                '<a class="asfbtn-item-32  k-button k-button-icon" id="BtnEdit_CSMF2005" style="" title="Sửa" data-role="button" role="button" aria-disabled="false" tabindex="0">' +
                                    '<span class="k-sprite asf-icon asf-icon-32 asf-i-page-edit" style="padding: 0px;"></span>' +
                                 '</a>' +
                             '</li>' +
                             '<li style="margin-right: 6px;">' +
                                '<a class="asfbtn-item-32  k-button k-button-icon" id="BtnDelete_CSMF2005" style="" title="Xóa" data-role="button" role="button" aria-disabled="false" tabindex="0">' +
                                    '<span class="k-sprite asf-icon asf-icon-32 asf-i-delete-32" style="padding: 0px;"></span>' +
                                '</a>' +
                              '</li>' +
                            '</ul>' +
                        '</div>';
        $("#CSMF2002_GroupCheckOrder").append(divbtn);
    }

    /**
    click button edit tab xác nhận đơn hàng
    **/
    this.choosebuttonedit = function () {
        var url = new URL(window.location);
        var APK = url.searchParams.get("PK");
        var DivisionID = ASOFTEnvironment["DivisionID"];
        $("#BtnEdit_CSMF2005").on("click", function () {
            ASOFT.asoftPopup.showIframe("/PopupLayOut/Index/CSM/CSMF2005?PK=" + APK + "&Table=CSMT2000&key=APK&DivisionID=" + DivisionID);
        });
        //PopupLayout/Index/CSM/CSMF2001?Pk=bf469e12-3bd0-4735-9ad9-fc2e430a32be&Table=CSMT2000&key=APK&DivisionID=VF
    }

    /**
     * Load tab xác nhận đơn hàng
     * @returns {} 
     * @since [Thanh Trong] Created [Date]
     */
    this.loadtabCheckOrder = function () {
        var url = new URL(window.location);
        var APK = url.searchParams.get("PK");
        var data = {
            APK: APK,
        };
        $.ajax({
            url: '/CSM/CSMF2000/LoadFormCSMF2005',
            async: false,
            data: data,
            success: function (result) {
                $(".Status2002").text(result["StatusName"]);
                $(".Weight2002").text(result["Weight"]);
                $(".Quantity2002").text(result["Quantity"]);
                $(".Package2002").text(result["Package"]);
                $(".Notes2002").text(result["Notes"]);
                $(".TimeReceive2002").text(result["TimeReceive"]);
            }
        });
    }
    /**
     * Xóa tab xác nhận đơn hàng
     * @returns {} 
     * @since [Thanh Trong] Created [29/01/2018]
     */
    this.deletetabCheckOrder = function () {
        var url1 = "/CSM/CSMF2000/DeleteCheckOrder";
        var url = new URL(window.location);
        var APK = url.searchParams.get("PK");
        $("#BtnDelete_CSMF2005").on("click", function () {
            ASOFT.helper.postTypeJson(url1, { APK: APK }, function (result) {
                ASOFT.form.displayInfo('#contentMaster', ASOFT.helper.getMessage("00ML000057"));
                window.location.reload();
            });
        });
    }

    /**
     * add combobox trạng thái GSX, PSC, Lọc dữ liệu
     * @returns {} 
     * @since [Thanh Trong] Created [Date]
     */
    this.GetPartialViewFilter = function () {
        var url = "/CSM/CSMF2000/FilterGroupDetail";
        ASOFT.helper.postTypeJson(url, {}, function (result) {
            $("#tb_CSMT2001-1").prepend(result);
        });
    }

    /**
     *delete tab chi tiết đơn hàng 
     * @returns {} 
     * @since [Thanh Trong] Created [Date]
     */
    this.deletetabdetail = function () {
        var url = "/CSM/CSMF2000/DeleteDetail";
        $("#BtnDelete_CSMF2003_CSMT2001").on("click", function () {
            var IsCheckAll = $("#isAll").is(":checked") ? 1 : 0;
            if (IsCheckAll == 0) {
                var APKList = "";
                var grid = $("#GridCSMT2001").data("kendoGrid");
                grid.tbody.find('.asoftcheckbox:checked').closest('tr')
                .each(function () {
                    if (typeof grid.dataItem(this) != 'undefined') {
                        var dataItem = grid.dataItem(this);
                        APKList += dataItem.APK + ",";
                    }
                });
            }
            APKList = APKList.substring(0, APKList.length - 1);
            ASOFT.helper.postTypeJson(url, {APKList:APKList}, function (result) {
                ASOFT.form.displayInfo('#contentMaster', ASOFT.helper.getMessage("00ML000057"));
                window.location.reload();
            });
        });
    }
}

function getAPK() {
    var APKMaster = $("#PK").val();
    return APKMaster;
}
