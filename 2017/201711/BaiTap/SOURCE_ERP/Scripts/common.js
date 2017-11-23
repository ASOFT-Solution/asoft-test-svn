
// Đã comment out "displayInfo" ở dòng 1400 (1401)
/// <reference path='../_references.js' />
var messageDefault = ['Bạn cần phải nhập các thông tin bắt buộc trước khi lưu.'];
var ASOFT = [];
var isTabPressed = false;
var cellIndex, lastEditedRow = 0;
var leavecell = true;
var currentcell = null;
var MTF0060Popup = null;
var objectData = null;
var delegateFunction = null;
var currentRecordGrid = null;
var isMobile = true;

$(document).keypress(function (e) {
    ASOFT.form.enterReplaceTab(e);
});

$(document).keyup(function (e) {
    if (e.keyCode == 120) {
        $("#BtnFilter").trigger("click");
    }
});

//---------------------------------------Hàm của action----------------------------------------------------
function calendar_Click() {
    window.parent.parent.location = "/Calendar";
}

function addContactID_Click() {
    var TableREL = "";
    var RelColumn = "";
    if (parseInt($(".RelatedToTypeID").text()) == 4) {
        RelColumn = "OpportunityID";
        TableREL = "CRMT20501_CRMT10001_REL";
    }
    var urlLink = "/PopupLayout/Index/CRM/CRMF1001?RelColumn=" + RelColumn + "&RelatedToID=" + $("#PK").val() + "&TableREL=" + TableREL;
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function addLeadID_Click() {
    var TableREL = "";
    var RelColumn = "";
    if (parseInt($(".RelatedToTypeID").text()) == 4) {
        RelColumn = "OpportunityID";
        TableREL = "CRMT20501_CRMT20301_REL";
    }
    var urlLink = "/PopupLayout/Index/CRM/CRMF2031?RelColumn=" + RelColumn + "&RelatedToID=" + $("#PK").val() + "&TableREL=" + TableREL;
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function addQuotation_Click() {
    var TableREL = "";
    var RelColumn = "";
    var ID = "";
    if (parseInt($(".RelatedToTypeID").text()) == 4) {
        RelColumn = "OpportunityID";
        TableREL = "CRMT20501_OT2101_REL";
        ID = $(".OpportunityID").text();
    }
    var urlLink = "/PopupMasterDetail/Index/SO/SOF2021?RelColumn=" + RelColumn + "&RelatedToID=" + $("#PK").val() + "&TableREL=" + TableREL + "&ID=" + ID;
    ASOFT.asoftPopup.showIframe(urlLink, {});
}


function addOpportunity_Click() {
    var TableREL = "";
    var RelColumn = "";
    if (parseInt($(".RelatedToTypeID").text()) == 1) {
        RelColumn = "LeadID";
        TableREL = "CRMT20501_CRMT20301_REL";
    }
    var urlLink = "/PopupLayout/Index/CRM/CRMF2051?RelColumn=" + RelColumn + "&RelatedToID=" + $("#PK").val() + "&TableREL=" + TableREL;
    ASOFT.asoftPopup.showIframe(urlLink, {});
}



function LinkConvert_Click() {
    var vlInherit;

    if (parseInt($(".RelatedToTypeID").text()) == 4) {
        var dtCheck = [];
        dtCheck.push($(".APK").text());

        ASOFT.helper.postTypeJson("/CRM/CRMF2050/CheckExist", dtCheck, function (result) {
            if (result) {
                vlInherit = $(".OpportunityID").text();
                var urlLink = "/PopupLayout/Index/CRM/CRMF1011?DivisionID=" + $(".DivisionID").text() + "&ConvertType=" + parseInt($(".RelatedToTypeID").text()) + "&InheritConvertID=" + vlInherit;
                ASOFT.asoftPopup.showIframe(urlLink, {});
            }
            else {
                ASOFT.dialog.messageDialog(kendo.format(ASOFT.helper.getMessage('CRMFML000013'), $(".OpportunityID").text()));
            }
        })
    }
    else {
        if (parseInt($(".RelatedToTypeID").text()) == 1) {
            vlInherit = $(".LeadID").text();
        }
        if (parseInt($(".RelatedToTypeID").text()) == 2) {
            vlInherit = $(".ContactID").text();
        }

        var dtCheck = [];
        dtCheck.push(vlInherit);

        if (parseInt($(".RelatedToTypeID").text()) == 2) {
            ASOFT.helper.postTypeJson("/CRM/CRMF1001/CheckExist", dtCheck, function (result) {
                if (!result) {
                    ASOFT.dialog.confirmDialog(kendo.format(ASOFT.helper.getMessage('CRMFML000012'), $(".ContactID").text()), function () {
                        var urlLink = "/PopupLayout/Index/CRM/CRMF1011?DivisionID=" + $(".DivisionID").text() + "&ConvertType=" + parseInt($(".RelatedToTypeID").text()) + "&InheritConvertID=" + vlInherit;
                        ASOFT.asoftPopup.showIframe(urlLink, {});
                    }, function () {
                    })
                }
                else {
                    var urlLink = "/PopupLayout/Index/CRM/CRMF1011?DivisionID=" + $(".DivisionID").text() + "&ConvertType=" + parseInt($(".RelatedToTypeID").text()) + "&InheritConvertID=" + vlInherit;
                    ASOFT.asoftPopup.showIframe(urlLink, {});
                }
            })
        }
        else {
            ASOFT.helper.postTypeJson("/CRM/CRMF2030/CheckExist", dtCheck, function (result) {
                if (!result) {
                    ASOFT.dialog.confirmDialog(kendo.format(ASOFT.helper.getMessage('CRMFML000012'), $(".LeadID").text()), function () {
                        var urlLink = "/PopupLayout/Index/CRM/CRMF1011?DivisionID=" + $(".DivisionID").text() + "&ConvertType=" + parseInt($(".RelatedToTypeID").text()) + "&InheritConvertID=" + vlInherit;
                        ASOFT.asoftPopup.showIframe(urlLink, {});
                    }, function () {
                    })
                }
                else {
                    var urlLink = "/PopupLayout/Index/CRM/CRMF1011?DivisionID=" + $(".DivisionID").text() + "&ConvertType=" + parseInt($(".RelatedToTypeID").text()) + "&InheritConvertID=" + vlInherit;
                    ASOFT.asoftPopup.showIframe(urlLink, {});
                }
            })
        }
    }
}


function sendMail_Click() {
    var urlLink = "/SendMail?RelatedToID=" + $("#PK").val() + "&RelatedToTypeID_REL=" + parseInt($(".RelatedToTypeID").text()) + "&EmailToReceiver=" + $(".HomeEmail").text();
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function addNotes_Click() {
    var divisionAdd = $(".DivisionID").text() == "@@@" ? $("#EnvironmentDivisionID").val() : $(".DivisionID").text();
    var urlLink = "/PopupLayout/Index/CRM/CRMF9003?DivisionID=" + divisionAdd + "&RelatedToTypeID=" + parseInt($(".RelatedToTypeID").text()) + "&RelatedToID=" + $("#PK").val();
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function attachFile_Click() {
    var divisionAdd = $(".DivisionID").text() == "@@@" ? $("#EnvironmentDivisionID").val() : $(".DivisionID").text();
    var urlLink = "/AttachFile?Type=1&DivisionID=" + divisionAdd + "&RelatedToTypeID=" + parseInt($(".RelatedToTypeID").text()) + "&RelatedToID=" + $("#PK").val();
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function addEvent_Click() {
    var divisionAdd = $(".DivisionID").text() == "@@@" ? $("#EnvironmentDivisionID").val() : $(".DivisionID").text();
    var urlLink = "/PopupLayout/Index/CRM/CRMF9005?DivisionID=" + divisionAdd + "&RelatedToTypeID=" + parseInt($(".RelatedToTypeID").text()) + "&RelatedToID=" + $("#PK").val();
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function addTask_Click() {
    var divisionAdd = $(".DivisionID").text() == "@@@" ? $("#EnvironmentDivisionID").val() : $(".DivisionID").text();
    var urlLink = "/PopupLayout/Index/CRM/CRMF9004?DivisionID=" + divisionAdd + "&RelatedToTypeID=" + parseInt($(".RelatedToTypeID").text()) + "&RelatedToID=" + $("#PK").val();
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function addOrder_Click() {
    var urlLink = "/PopupMasterDetail/Index/SO/SOF2001?QuotationID=" + $("#PK").val();
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

//---------------------------------------Hàm của action-----------------------------------------------------

$(window).resize(function () {
    if ((/android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(navigator.userAgent.toLowerCase()))) {
        if ($('ul.k-tabstrip-items').length > 0) {
            $("#BtnNext").remove();
            $("#BtnPrev").remove();

            var id = $('ul.k-tabstrip-items').parent().attr("id");

            var tabStrip = $('#' + id).data("kendoTabStrip");
            var ul = $('#' + id).data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

            var count = $(ul).find('li').length;
            var total = 0;

            var li_list = ul.find($("li[style!='display:none']"));

            for (i = 0; i <= count; i++) {
                var num_width = $(li_list[i]).width();
                total += num_width;
                if (ul.width() < total) {
                    $("#" + id + " .k-tabstrip-items").css("overflow-x", "hidden");
                    $("#" + id + " .k-tabstrip-items").css("overflow-y", "hidden");
                    $("#" + id + " .k-tabstrip-items").css("white-space", "nowrap");

                    $('ul.k-tabstrip-items').parent().before('<a id="BtnNext" style="height: 30px;width: 35px; position: absolute; z-index: 1;left: ' + ul.width() + 'px;" data-role="button" class="k-button k-button-icontext" role="button" aria-disabled="false" tabindex="0" onclick="BtnNext_Click()"><span class="k-sprite asf-icon-logo_next"></span><span class="asf-button-text"></span></a>');
                    $('ul.k-tabstrip-items').parent().before('<a id="BtnPrev" style="display:none; height: 30px;width: 35px; position: absolute; z-index: 1;" data-role="button" class="k-button k-button-icontext" role="button" aria-disabled="false" tabindex="0" onclick="BtnPrev_Click()"><span class="k-sprite asf-icon-logo_prev"></span><span class="asf-button-text"></span></a>');
                    break;
                }
            }
        }
    }
})

function btnFilter_Click1() {
    var width = $(document).width();
    if (width < 1200) {
        ASOFT.asoftPopup.showIframe("/ContentMaster/PopupSearch", {});
        $(".k-overlay").removeAttr("style");
    }
    return;
}

function returnHtml() {
    var data = [];
    data = $("#FormFilter").find('table').find('tbody').find('tr');
    var list = $("#FormFilter").find(".asf-filter-main");
    if (list.length > 0) {
        for (i = 0; i < list.length; i++) {
            data.push(list[i]);
        }
    }
    return data;
}

function searchMobile(dataSearch) {
    var dataSearchTemp = dataSearch;
    $.each(dataSearch, function (key, value) {


        if (key === "rdoFilter" || key == "rdoFilter1") {
            if (value == 0) {
                if ($("#FromPeriodFilter").data("kendoComboBox") != null) {
                    $("#FromPeriodFilter").data("kendoComboBox").enable(true);
                    $("#ToPeriodFilter").data("kendoComboBox").enable(true);
                    $("#FromPeriodFilter").data("kendoComboBox").value(dataSearchTemp["FromPeriodFilter"]);
                    $("#ToPeriodFilter").data("kendoComboBox").value(dataSearchTemp["ToPeriodFilter"]);
                }

                if ($("#FromPeriodFilter").data("kendoDropDownList") != null) {
                    var dropdownlist = $("#FromPeriodFilter").data("kendoDropDownList");
                    dropdownlist.enable(true);
                    if (dataSearchTemp["CheckListPeriodControl"] == "" || dataSearchTemp["CheckListPeriodControl"] == null) {
                        dropdownlist.refresh();
                    }
                    else {
                        var listVL = dataSearchTemp["CheckListPeriodControl"].split(',');
                        dropdownlist.dataSource.read();
                        var listDrop = dropdownlist.options.dataSource;
                        for (var j = 0; j < listVL.length; j++) {
                            for (var k = 0; k < listDrop.length; k++) {
                                if (listDrop[k].Value === listVL[j]) {
                                    $($(dropdownlist.list.find('li')[k])).trigger("click");
                                    break;
                                }
                            }
                        }
                    }
                }


                if ($("#CheckListPeriodControl").data("kendoDropDownList") != null) {
                    var dropdownlist = $("#CheckListPeriodControl").data("kendoDropDownList");
                    dropdownlist.enable(true);
                    if (dataSearchTemp["CheckListPeriodControl"] == "" || dataSearchTemp["CheckListPeriodControl"] == null) {
                        dropdownlist.refresh();
                    }
                    else {
                        var listVL = dataSearchTemp["CheckListPeriodControl"].split(',');
                        dropdownlist.dataSource.read();
                        var listDrop = dropdownlist.options.dataSource;
                        for (var j = 0; j < listVL.length; j++) {
                            for (var k = 0; k < listDrop.length; k++) {
                                if (listDrop[k].Value === listVL[j]) {
                                    $($(dropdownlist.list.find('li')[k])).trigger("click");
                                    break;
                                }
                            }
                        }
                    }
                }

                if ($("#FromDate").data("kendoDatePicker") != null) {
                    $("#FromDate").data("kendoDatePicker").enable(false);
                    $("#ToDate").data("kendoDatePicker").enable(false);
                }
                if ($("#FromDatePeriodControl").data("kendoDatePicker") != null) {
                    $("#FromDatePeriodControl").data("kendoDatePicker").enable(false);
                    $("#ToDatePeriodControl").data("kendoDatePicker").enable(false);
                }
                if ($("#FromDateFilter").data("kendoDatePicker") != null) {
                    $("#FromDateFilter").data("kendoDatePicker").enable(false);
                    $("#ToDateFilter").data("kendoDatePicker").enable(false);
                }

                $("#rdbIsDate1").trigger("click");
                $("#rdbUsePeriods").trigger("click");
                $("#rdoFilterPeriod").trigger("click");
            }
            else {
                if ($("#FromDate").data("kendoDatePicker") != null) {
                    $("#FromDate").data("kendoDatePicker").enable(true);
                    $("#ToDate").data("kendoDatePicker").enable(true);
                }
                if ($("#FromDatePeriodControl").data("kendoDatePicker") != null) {
                    $("#FromDatePeriodControl").data("kendoDatePicker").enable(true);
                    $("#ToDatePeriodControl").data("kendoDatePicker").enable(true);
                }
                if ($("#FromDateFilter").data("kendoDatePicker") != null) {
                    $("#FromDateFilter").data("kendoDatePicker").enable(true);
                    $("#ToDateFilter").data("kendoDatePicker").enable(true);
                }

                if ($("#FromPeriodFilter").data("kendoComboBox") != null) {
                    $("#FromPeriodFilter").data("kendoComboBox").enable(false);
                    $("#ToPeriodFilter").data("kendoComboBox").enable(false);
                }
                if ($("#CheckListPeriodControl").data("kendoDropDownList") != null) {
                    $("#CheckListPeriodControl").data("kendoDropDownList").enable(false);
                }

                if ($("#FromPeriodFilter").data("kendoDropDownList") != null) {
                    $("#FromPeriodFilter").data("kendoDropDownList").enable(false);
                }

                $("#rdbIsDate0").trigger("click");
                $("#rdbUseDates").trigger("click");
                $("#rdoFilterDate").trigger("click");
            }
            return true;
        }

        if (key == "FromDatePeriodControl" || key == "FromDate" || key == "FromDateFilter") {
            $("#" + key).val(value);
            $("#FromDateFilter").val(value);
            return true;
        }

        if (key == "ToDatePeriodControl" || key == "ToDate" || key == "ToDateFilter") {
            $("#" + key).val(value);
            $("#ToDateFilter").val(value);
            return true;
        }

        if ($("#" + key).data("kendoComboBox") != null) {
            $("#" + key).data("kendoComboBox").value(value);
        }
        else {
            if ($("#" + key).data("kendoDropDownList") != null) {
                $("#" + key).data("kendoDropDownList").value(value);
                var dropdownlist = $("#" + key).data("kendoDropDownList");
                if (value == "" || value == null) {
                    dropdownlist.refresh();
                }
                else {
                    var listVL = value.split(',');
                    dropdownlist.dataSource.read();
                    var listDrop = dropdownlist.options.dataSource;
                    for (var j = 0; j < listVL.length; j++) {
                        for (var k = 0; k < listDrop.length; k++) {
                            if (listDrop[k].Value === listVL[j]) {
                                $($(dropdownlist.list.find('li')[k])).trigger("click");
                                break;
                            }
                        }
                    }
                }
            }
            else {
                $("#" + key).val(value);
            }
        }
    })
    $("#BtnFilter").trigger("click");
    $("#POSF0010BtnFilter").trigger("click");
    $("#btnFilterPOSF0012").trigger("click");
    $("#POSF0020BtnFilter").trigger("click");
    $("#btnFilter_").trigger("click");
    $("#POSF0016BtnFilter").trigger("click");
    $("#POSF0027BtnFilter").trigger("click");
    $("#POSF0021BtnFilter").trigger("click");
    $("#POSF0017BtnFilter").trigger("click");
    $("#POSF0019BtnFilter").trigger("click");
    $("#POSF0024BtnFilter").trigger("click");
    ASOFT.asoftPopup.hideIframe();
}

function BtnPrev_Click() {
    var id = $('ul.k-tabstrip-items').parent().attr("id");

    var tabStrip = $('#' + id).data("kendoTabStrip");
    var ul = $('#' + id).data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

    if (num == 1) {
        $(tabStrip.items()[num]).attr("style", "")
        $(tabStrip.items()[num - 1]).attr("style", "")
        $('#BtnPrev').attr("style", "display:none")
        $('#BtnNext').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: " + ul.width() + "px;")
        num = 1;
    } else {
        $(tabStrip.items()[num]).attr("style", "")
        $(tabStrip.items()[num - 1]).attr("style", "margin-left:35px")
        $('#BtnNext').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: " + ul.width() + "px;")
        num = num - 1;
    }
}

function BtnNext_Click() {
    var id = $('ul.k-tabstrip-items').parent().attr("id");

    var tabStrip = $('#' + id).data("kendoTabStrip");
    var ul = $('#' + id).data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

    var count = $(ul).find('li').length;
    var total = 0;

    var li_list = ul.find($("li[style!='display:none']"));

    for (i = num - 1; i < count; i++) {
        var num_width = $(li_list[i]).width();
        total += num_width;
        if (ul.width() < total) {
            break;
        }
    }

    if (i == count) {
        $(tabStrip.items()[num - 1]).attr("style", "display:none");
        $('#BtnPrev').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
        $('#BtnNext').attr("style", "display:none");
    } else {
        $(tabStrip.items()[num - 1]).attr("style", "display:none");
        $(tabStrip.items()[num]).attr("style", "margin-left:35px");
        $('#BtnPrev').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
        num = num + 1;
    }
}

$(document).ready(function () {

    if (!(/android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(navigator.userAgent.toLowerCase()))) {
        isMobile = false;
        $("#RWDPopup400").remove();
        $("#RWDPopup600").remove();
        $("#RWDContent400").remove();
        $("#RWDContent600").remove();
        $("#RWDMasterDetail400").remove();
        $("#RWDMasterDetail600").remove();
        $("#RWDNoDetail400").remove();
        $("#RWDNoDetail600").remove();
        $("#RWDNoDetail600").remove();
        $("#RWDReport").remove();
        $("#DashBoardRWD").remove();
    }

    setTimeout(function () {
        if ($('ul.k-tabstrip-items').length > 0) {
            var id = $('ul.k-tabstrip-items').parent().attr("id");

            var tabStrip = $('#' + id).data("kendoTabStrip");
            var ul = $('#' + id).data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

            var count = $(ul).find('li').length;
            var total = 0;

            var li_list = ul.find($("li[style!='display:none']"));

            for (i = 0; i <= count; i++) {
                var num_width = $(li_list[i]).width();
                total += num_width;
                if (ul.width() < total) {
                    $("#" + id + " .k-tabstrip-items").css("overflow-x", "hidden");
                    $("#" + id + " .k-tabstrip-items").css("overflow-y", "hidden");
                    $("#" + id + " .k-tabstrip-items").css("white-space", "nowrap");

                    $('ul.k-tabstrip-items').parent().before('<a id="BtnNext" style="height: 30px;width: 35px; position: absolute; z-index: 1;left: ' + ul.width() + 'px;" data-role="button" class="k-button k-button-icontext" role="button" aria-disabled="false" tabindex="0" onclick="BtnNext_Click()"><span class="k-sprite asf-icon-logo_next"></span><span class="asf-button-text"></span></a>');
                    $('ul.k-tabstrip-items').parent().before('<a id="BtnPrev" style="display:none; height: 30px;width: 35px; position: absolute; z-index: 1;" data-role="button" class="k-button k-button-icontext" role="button" aria-disabled="false" tabindex="0" onclick="BtnPrev_Click()"><span class="k-sprite asf-icon-logo_prev"></span><span class="asf-button-text"></span></a>');
                    break;
                }
            }
        }
    }, 200)

    //Set timeout for session
    var sessionTimeout = $('#sessionTimeout').val();
    ASOFT.helper.sessionTimeOut(sessionTimeout);

    // asoftLanguage.SetCaption();
    ASOFT.form.setAutoHeight("asf-filter-content-block", "horz-line");
    // ASOFT.form.setSameHeight("asf-filter-content-block");
    ASOFT.form.setSameWidth("asf-content-block");
    ASOFT.form.setSameHeight("asf-filter-content-block");
    ASOFT.form.setSameWidth("asf-filter-content-block");

    $('.asf-button, .asfbtn-item-32,.asf-menu-active, .asf-button-common-custom-search').mousedown(function () {
        $(this).addClass('asf-button-active');
        $(this).children('span').addClass('asf-button-active');
    }).mouseup(function () {
        $(this).removeClass('asf-button-active');
        $(this).children('span').removeClass('asf-button-active');
    })
    this.nextCell
    $('.asf-header-user, .period-info, .asf-header-icon-setting').mousedown(function () {
        $(this).addClass('asf-header-active');
    }).mouseup(function () {
        $(this).removeClass('asf-header-active');
    })

    $('#configSystem').click(function () {
        window.location.href = $('#UrlAS0001').val();
    });

    // Kiểm tra có scroll dọc hay không
    $.fn.hasVScrollBar = function () {
        return this.get(0).scrollHeight > this.innerHeight();
    };

    // Kiểm tra có scroll ngang hay không
    $.fn.hasHScrollBar = function () {
        return this.get(0).scrollWidth > this.innerWidth();
    };

    if (window.frameElement) {
        if (window.parent.$('#asf-help').length > 0) {
            window.parent.$('#asf-help').unbind('click').bind('click', function () {
                var moduleID = $('#currentDagArea').val();
                var controller = $('#currentDagController').val();
                var action = $('#currentDagAction').val();

                var url = $('#urlHelp').val() + (moduleID ? moduleID + '_' : '') + controller + (action === 'Index' ? '' : '_' + action) + '.html';
                window.open(url, '_blank');
            });
        }
        else {
            window.parent.window.parent.$('#asf-help').unbind('click').bind('click', function () {
                var moduleID = $('#currentDagArea').val();
                var controller = $('#currentDagController').val();
                var action = $('#currentDagAction').val();

                var url = $('#urlHelp').val() + (moduleID ? moduleID + '_' : '') + controller + (action === 'Index' ? '' : '_' + action) + '.html';
                window.open(url, '_blank');
            });
        }
    }
    else {
        $('#asf-help').unbind('click').bind('click', function () {
            var moduleID = $('#currentArea').val();
            var controller = $('#currentController').val();
            var action = $('#currentAction').val();

            var url = $('#urlHelp').val() + (moduleID ? moduleID + '_' : '') + controller + (action === 'Index' ? '' : '_' + action) + '.html';
            //window.location.href = url
            window.open(url, '_blank');
        });

    }

    //Scroll header
    if (window.frameElement) {
        $(window).scroll(function () {
            window.parent.$('#Header').css('left', (0 - $(this).scrollLeft()));
        });
    }
    else {
        $(window).scroll(function () {
            $('#Header').css('left', (0 - $(this).scrollLeft()));
        });
    }
});


ASOFT.partialView = new function () {
    this.Load = function (url, id, typeAdd) {
        $.ajax({
            url: url,
            success: function (result) {
                if (typeAdd == 1) {// add html truoc class 
                    $(id).before(result);
                }
                if (typeAdd == 0) {// add html sau class 
                    $(id).after(result);
                }
                if (typeAdd == 2) {
                    $(id).prepend(result);
                }
                if (typeAdd == 3) {
                    $(id).append(result);
                }
            }
        });
    }
}

ASOFT.ExportSuccessCommon = new function () {
    this.Load = function (result, areas, screen, isPrint, action) {
        if (result) {
            var urlPrint = "/" + areas + '/' + screen + '/ReportViewer';
            var urlExcel = "/" + areas + '/' + screen + '/ExportReport';
            var urlPost;
            var options = '';

            if (isPrint) {
                urlPost = !isMobile ? urlPrint : urlExcel;
                options = !isMobile ? '&viewer=pdf' : '&viewer=pdf&mobile=mobile';
            }
            else
                urlPost = urlExcel;

            // Tạo path full
            var fullPath = urlPost + "?id=" + result.apk + options;

            if (action)
                fullPath = fullPath + "&actionPrint=" + action;

            // Getfile hay in báo cáo
            if (isPrint)
                if (!isMobile)
                    window.open(fullPath, "_blank");
                else
                    window.location = fullPath;
            else {
                window.location = fullPath;
            }
        }
    }
}

$(document).click(function (e) {
    var dialog = $('#Action').data("kendoWindow");
    if (!dialog) return;
    if (e.target.className != 'asf-i-action') {
        dialog.close();
    }
});

String.prototype.format = String.prototype.f = function () {
    var s = this,
        i = arguments.length;

    while (i--) {
        s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), arguments[i]);
    }
    return s;
};

String.prototype.endsWith = function (suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

$.fn.hasId = function () {
    return this.prop('id');
};

//action click
function actionClick(e) {
    var top = $(".asf-panel-master-header")[0].offsetTop + $(".asf-panel-master-header")[0].offsetHeight
    var left = $(".asf-panel-master-header")[0].offsetLeft;
    var dialog = $('#Action').data("kendoWindow");
    dialog.wrapper.css({ top: top, left: left });
    dialog.open();
}


/**
*Resize grid
*/
function calHeightGrid(gridId, searchConheight) {

    var gridElement = $(kendo.format("#{0}", gridId));
    var dataArea = gridElement.find(".k-grid-content");

    var newGridHeight = $(document).height() - searchConheight;
    var newDataAreaHeight = newGridHeight - 65;

    dataArea.height(newDataAreaHeight);
    gridElement.height(newGridHeight);

    $(kendo.format("#{0}", gridId)).data("kendoGrid").refresh();

}

/**
* sector jquery
*/
function sectorEl(id, sub) {
    if (sub != null) {
        return kendo.format('#{0} {1}', id, sub);
    }
    return kendo.format('#{0}', id);
}

/**
* format Url
*/
function getAbsoluteUrl(action, module) {
    var urlERP = "";
    if (module == null) {
        module = CURRENT_AREA;
    }
    if (BASE_URL != null) {
        if (BASE_URL == "/") {
            urlERP = kendo.format("{0}{1}/{2}",
                BASE_URL,
                module,
                action
            );
        } else {
            urlERP = kendo.format("{0}/{1}/{2}",
                BASE_URL,
                module,
                action
            );
        }
    } else {
        urlERP = kendo.format("/{0}/{1}",
            module,
            action);
    }
    return urlERP;
};

ASOFT.panelFormat = new function () {
    // fit column height of panel item
    this.fitColumnHeight = function (e) {
        var item = $(e.item);
        if (item) {
            var panelId = "panelbar-" + (item.index() + 1),
                cssClassName = "asf-content-block";

            var maxHeigth = ASOFT.form.getMaxHeightByClass(cssClassName, panelId);
            $('#' + panelId + ' div.' + cssClassName).height(maxHeigth);

            //Padding content-ellipsis class
            var lineHeightDefault = 30;
            var objsEllipsis = $('#' + panelId + " div.content-ellipsis");
            for (var i = 0; i < objsEllipsis.length; i++) {
                var current = objsEllipsis[i].clientHeight;
                var lineNumber = Math.round(current / lineHeightDefault);
                if (lineNumber > 1) {
                    objsEllipsis[i].setAttribute("style", "padding-bottom: 5px;");
                } else if (lineNumber == 1) {
                    objsEllipsis[i].setAttribute("style", "line-height: 26px;");
                }
            }
        }
    };
};

ASOFT.form = new function () {

    // Phân hệ
    this.moduleID = "";

    // Trạng thái lưu thành công
    this.saveStatus = {};

    //Validate
    this.validator = null;

    this.messageError = {};

    //Set height auto
    this.getMaxHeightByClass = function (className, parentId) {
        var objs = (typeof parentId !== "undefined")
            ? $('#' + parentId + ' div.' + className)
            : $('div.' + className);
        var max = 0;

        for (var i = 0; i < objs.length; i++) {
            var current = objs[i].clientHeight;
            if (current > max) {
                max = current;
            }
        }

        return max;
    };

    // Lưu trạng thái form
    /**
    * Param: [formId: Form Id]
    * Param: [result: object result set from server]
    * Param: [skipParams: non-display parameters form server (optional: APK string)]
    */
    this.updateSaveStatusOption = function (formId, result, skipParams) {
        if (typeof result === "object" && result !== null) {
            if (result instanceof Array) {
                $.each(result, function (i, val) {
                    if (val.Params) {
                        // Override parameters
                        val.Data = val.Params;
                    }
                    ASOFT.form.updateSaveStatus(formId, val.Status, skipParams ? null : val.Data);
                });
            } else {
                if (result.Params) {
                    // Override parameters
                    result.Data = result.Params;
                }

                ASOFT.form.updateSaveStatus(formId, result.Status, skipParams ? null : result.Data);
            }
        }
    };

    // save status
    this.updateSaveStatus = function (formId, status, appendKey, timeOut) {
        this.saveStatus = {
            FormID: formId,
            Status: status,
            AppendKey: appendKey,
            TimeOut: timeOut
        };
    };

    this.clearSaveStatus = function () {
        this.saveStatus = {};
    };

    this.setAutoHeight = function (heightOfClass, horzClass) {
        var objs = $('div.' + horzClass);
        var heigth = ASOFT.form.getMaxHeightByClass(heightOfClass);
        $('div.' + horzClass).height(heigth);
    };

    this.setSameHeight = function (className) {
        var heigth = ASOFT.form.getMaxHeightByClass(className);
        var objs = $('.' + className).height(heigth);

        var filter = $(".asf-filter-content-block");
        if (filter) {
            // Center line height
            $('div.horz-line-left').height(heigth);
            $('div.horz-line-right').height(heigth);
        }

    };

    this.setSameWidth = function (className, cols) {
        var widthObj = null;
        var objs = $('.' + className);
        var master = $('#contentMaster').width() - 40;
        var padding = 122;
        var percent = null;
        var widthPx = null;

        if (className == 'asf-filter-content-block') {
            padding = 84; // padding horz-line
        }
        var screenwidth = master - padding;
        if (typeof cols != 'undefined') {
            percent = (100 / cols) - 3;
            widthObj = percent + '%';
        }
        else {
            widthPx = (((screenwidth / objs.length) / master)) * 100;
            widthObj = widthPx + '%';

        }

        if ($(".asf-content-block-sys")) {
            var width = (master - 81) / 2; // Khong tinh padding
            var percentage = (width / master) * 100 + '%';
            $(".asf-content-block-sys").css({ width: percentage });
        }
        objs.css({ width: widthObj });
        //objs.width(screenwidth/objs.length);
    };

    // Ẩn hiện div bằng hiệu ứng
    this.showDiv = function (ctrl, display) {
        if (display == undefined) display = true;

        if (display) {
            ctrl.css('display', 'inline');
            ctrl.css('visibility', 'visible');

            ctrl.css('opacity', 0);
            ctrl.stop(true, false).animate({ opacity: 1 }, 1500);
        } else {
            ctrl.css('display', 'none');
            ctrl.css('visibility', 'hidden');
        }
    };
    this.isNumberKey = function (evt) {
        var charCode = (evt.which) ? evt.which : evt.keyCode;

        if (charCode == 46) {
            var inputValue = $(eval.target).val();
            if (inputValue.indexOf(',') < 1 || inputValue.indexOf('.') < 1) {
                return true;
            }
            return false;
        }
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    };

    this.formatNumber = function (value, format) {
        return kendo.format(value, format);
    };

    //Set kendo validator
    this.setValidator = function (value) {
        this.validator = value;
    };

    //cehck contains element
    this.containsElement = function (formSector, childSector) {
        return ($(formSector + ' ' + childSector).length == 0);
    };

    // Sử dụng cho check required kết hợp với kiểm tra in list combobox
    this.checkRequiredAndInList = function (formId, itemArray) {
        if (!this.checkRequired(formId)) {
            var message = this.checkInListCombobox(formId, itemArray);
            if (message.length > 0) {
                ASOFT.form.displayMessageBox("form#" + formId, message);
                return true;
            }
            $("form#" + formId + " .asf-message").remove();
            return false;
        }

        return true;
    };

    // Sử dụng cho kiểm tra ngày trong kỳ
    this.checkDateInPeriod = function (formId, beginDate, endDate, itemArray) {
        if (!this.checkRequired(formId)) {
            var message = this.checkInPeriod(formId, beginDate, endDate, itemArray);
            if (message.length > 0) {
                ASOFT.form.displayMessageBox("form#" + formId, message);
                return true;
            }
            $("form#" + formId + " .asf-message").remove();
            return false;
        }

        return true;
    };

    // Hàm sử dụng cho combo với sự kiện change
    this.checkItemInListFor = function (e, formId) {
        var result = false;
        if ((e.selectedIndex == -1 && e.dataSource._data.length > 0 && e.input.val() != "") // Có data mà chưa chọn
            || (e.selectedIndex == -1 && e.dataSource._data.length == 0 && e.input.val() != "")) { // Không có data mà nhập value
            if (!ASOFT.form.messageError[e.input.context.id]) {
                ASOFT.form.messageError[e.input.context.id] = ASOFT.helper.getLabelText(e.input.context.id, '00ML000064' /*"A00ML000016"*/);
            }
            result = false;
        } else {
            delete ASOFT.form.messageError[e.input.context.id];
            result = true;
        }

        ASOFT.form.displayMessageBox("form#" + formId, ASOFT.form.messageError);

        if (Object.keys(ASOFT.form.messageError).length == 0) {
            $("form#" + formId + " .asf-message").remove();
        }
        ASOFT.asoftComboBox.castName(e.input.context.id).focus();
        //ASOFT.asoftComboBox.castName(e.input.context.id).input.focus();
        return result;
    };

    this.checkInListCombobox = function (formId, itemIds) {
        var message = [];

        // Reset các hiển thị lỗi
        $('#' + formId + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
        $('#' + formId + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');

        for (var i = 0; i < itemIds.length; i++) {
            var combo = ASOFT.asoftComboBox.castName(itemIds[i]);
            if (combo.input.attr('aria-disabled') && combo.input.attr('disabled') == 'disabled') continue;
            var itemValue = combo.input.val();
            if (itemValue && (itemValue != null || itemValue != "")) {
                if ((combo.selectedIndex == -1 && combo.dataSource._data.length > 0 && combo.input.val() != "") // Có data mà chưa chọn
                    || (combo.selectedIndex == -1 && combo.dataSource._data.length == 0 && combo.input.val() != "")) { // Không có data mà nhập value
                    //message.push('Phải chọn trong danh sách [' + itemIds[i] + ']');
                    message.push(ASOFT.helper.getLabelText(itemIds[i], '00ML000064' /*"A00ML000016"*/));

                    //Update by Thai Son
                    var element = $("#" + itemIds[i]);
                    var fromWidget = element.closest(".k-widget");
                    var widgetElement = element.closest("[data-" + kendo.ns + "role]");
                    var widgetObject = kendo.widgetInstance(widgetElement);

                    if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
                        fromWidget.addClass('asf-focus-input-error');
                        var input = fromWidget.find(">:first-child").find(">:first-child");
                        $(input).addClass('asf-focus-combobox-input-error');
                    } else {
                        element.addClass('asf-focus-input-error');
                    }
                }
            }
        }

        return message;
    };

    // Kiểm tra ngày trong kỳ
    this.checkInPeriod = function (formId, beginDate, endDate, itemIds) {
        var message = [];

        // Reset các hiển thị lỗi
        $('#' + formId + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
        $('#' + formId + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');

        for (var i = 0; i < itemIds.length; i++) {
            var datePicker = ASOFT.asoftDateEdit.castName(itemIds[i]);
            if (datePicker.element.attr('aria-disabled') && datePicker.element.attr('disabled') == 'disabled') continue;
            var itemValue = datePicker.value();
            if (itemValue && (itemValue != null || itemValue != "")) {
                itemValue = kendo.parseDate(new Date(new Date(itemValue).setHours(0, 0, 0, 0)), "dd/MM/yyyy");
                var beginDate = kendo.parseDate(beginDate, "dd/MM/yyyy");
                var endDate = kendo.parseDate(endDate, "dd/MM/yyyy");
                if (!dates.inRange(itemValue, beginDate, endDate)) {
                    var widget = datePicker.element.closest(".k-widget");
                    widget.addClass('asf-focus-input-error');
                    var input = widget.find(">:first-child").find(">:first-child");
                    if (input) {
                        $(input).addClass('asf-focus-combobox-input-error');
                    }

                    message.push(ASOFT.helper.getLabelText(itemIds[i], '00ML000085'));
                }
            }
        }

        return message;
    };

    // Check require form items on save
    this.checkRequired = function (formId) {
        var formSector = '#' + formId;

        var elem = null;
        var checkRequired = false;
        var message = messageDefault;
        // Block need to validate
        var validatorBlock = (formId != null && formId != undefined) ? $('#' + formId) : $(document);

        // Get all tabStripPanel
        var tabStrips = validatorBlock.attr("data-role", "tabpanel")[0].children[0].children;

        // Memory error items
        var itemError = [];

        // Store tab
        var seletedTab = [];
        var defaultTab = [];

        var itemError = null;

        // Reset message box
        $(formSector + ' div.asf-text-message-error').empty();
        $(formSector + ' div.asf-panel-warning').remove();
        $(formSector + ' div.asf-panel-info').remove();

        //$(formSector + ' .k-widget.input-validation-error').removeClass('asf-focus-input-error');
        $(formSector + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
        $('#' + formId + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');

        //$(formSector + ' .asf-textbox').removeClass('asf-focus-input-error');

        //Check null
        createValidator(formId);
        //if (this.validator == null) {
        //    createValidator(formId);
        //}
        this.validator.hideMessages();

        //Check kendoui
        checkRequired = this.validator.validate();
        //Error
        if (!checkRequired) {
            message = [];
            itemError = this.validator._errors;
            // update by Thai Son


            $.each(itemError, function (itemId, element) {
                var element = $("#" + itemId);
                var fromWidget = element.closest(".k-widget");
                var widgetElement = element.closest("[data-" + kendo.ns + "role]");
                var widgetObject = kendo.widgetInstance(widgetElement);

                if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
                    fromWidget.addClass('asf-focus-input-error');
                    var input = fromWidget.find(">:first-child").find(">:first-child");
                    if (input) {
                        $(input).addClass('asf-focus-combobox-input-error');
                    }
                } else {
                    element.addClass('asf-focus-input-error');
                }

                var sMessage = itemError[itemId];
                message.push(sMessage);
            });

            // Get item error in each tab
            $.each(tabStrips, function (index, tab) {
                var items = [];
                if (tab.tagName === "DIV") {
                    defaultTab.push(tab.id);
                }
            });
            $(formSector + ' div.asf-panel-required').remove();
            // If it has no tabStrip
            if (tabStrips.length >= 1) {
                if (this.containsElement(formSector, 'div.asf-panel-required')) {
                    var content = this.createMessageBox(message);
                    $("#" + formId).prepend(content);
                }
            } else if (tabStrips.length > 0) {
                var content = this.createMessageBox(message);
                // If it has errors, render error message box in tab
                if (defaultTab.length > 0) {
                    $("div#" + defaultTab[0]).prepend(content);
                    seletedTab.push(defaultTab[0]);
                } else {
                    $("#" + formId).prepend(content);
                }

                // Select first tab has errors
                if (seletedTab.length > 0) {
                    this.selectedTab($("div#" + seletedTab[0])[0].parentElement.id, seletedTab[0]);
                }
            }
        } else {
            $(formSector + ' div.asf-panel-required').remove();
        }

        return !checkRequired;
    };

    // Create HTML message box with message list and ignore special message in this list
    // ASOFT.createMessageBox(['message', 'message'], [0, 1])
    this.createMessageBox = function (message, skipItems, css) {
        if (typeof skipItems != 'undefined') {
            for (var i = 0; i < skipItems.length; i++) {
                // remove item at index of array
                message.splice(skipItems[i], 1);
            }
        }
        var content = document.createElement("div");
        //var iconError = document.createElement("div");
        var bodyMessage = document.createElement("ul");

        for (var index in message) {
            var li = document.createElement("li");
            li.textContent = message[index];
            bodyMessage.appendChild(li);
        }
        //iconError.setAttribute("class", "asf-icon-required");
        //content.appendChild(iconError);
        content.appendChild(bodyMessage);
        var className = (css == null) ? "asf-panel-required" : css;
        className = 'asf-message ' + className;
        content.setAttribute("class", className);
        if (message.length > 3) {
            $(content).css({ height: '80px' });
        }
        return content;
    };

    // Display messages into block and ignore special message in this
    // ASOFT.displayMessageBox("div#tabPanel", ['message', 'message'], [0, 1])
    this.displayMessageBox = function (elementID, message, skipMessageItems) {
        $(elementID + ' .asf-message').remove();
        var content = null;
        if (skipMessageItems == null) {
            content = this.createMessageBox(message);
        } else {
            content = this.createMessageBox(message, skipMessageItems);
        }

        if (this.containsElement(elementID, 'div.asf-panel-required')) {
            $(elementID).prepend(content);
        }
    };

    /**
    * Xử lý hiển thị message box
    * --------------------------------------------
    * Params [elementId: Id]
    * Params [type: 0: Info, 1: Error, 2: Warning]
    * Params [message: List message]
    * --------------------------------------------
    */
    this.displayMultiMessageBox = function (elementId, type, message) {
        $('#' + elementId + ' .asf-message').remove();

        var cssClass = null;
        if (type == 0) {
            cssClass = 'asf-panel-info';
        }
        else if (type == 1) {
            cssClass = 'asf-panel-required';
        }
        else if (type == 2) {
            cssClass = 'asf-panel-warning';
        }

        // append contents
        var content = this.createMessageBox(message, [], cssClass);
        if (this.containsElement(elementId, 'div.' + cssClass)) {
            $("#" + elementId).prepend(content);
        }

        //this.addEventToDocumentWhenMessageBox();
    };

    // Display messages into block and ignore special message in this
    // ASOFT.displayMessageBox("div#tabPanel", ['message', 'message'], [0, 1])
    this.displayError = function (elementID, message) {
        $(elementID + ' .asf-message').remove();
        var arrayMsg = [];
        if ($.isArray(message)) {
            arrayMsg = message;
        } else {
            arrayMsg.push(message);
        }
        var content = this.createMessageBox(arrayMsg, [], 'asf-panel-required');
        if (this.containsElement(elementID, 'div.asf-panel-required')) {
            $(elementID).prepend(content);
        }
    };

    // Display messages into block and ignore special message in this
    // ASOFT.displayMessageBox("div#tabPanel", ['message', 'message'], [0, 1])
    this.displayInfo = function (elementID, message) {
        $(elementID + ' .asf-message').remove();
        var arrayMsg = [];
        if ($.isArray(message)) {
            arrayMsg = message;
        } else {
            arrayMsg.push(message);
        }
        var content = this.createMessageBox(arrayMsg, [], 'asf-panel-info');
        if (this.containsElement(elementID, 'div.asf-panel-info')) {
            $(elementID).prepend(content);
        }
    };

    // Display messages into block and ignore special message in this
    // ASOFT.displayWarning("div#tabPanel", ['message', 'message'], [0, 1])
    this.displayWarning = function (elementID, message) {
        $(elementID + ' .asf-message').fadeOut("slow", function () {
            $(elementID + ' .asf-message').remove();
        });


        var arrayMsg = [];
        if ($.isArray(message)) {
            arrayMsg = message;
        } else {
            arrayMsg.push(message);
        }
        var content = this.createMessageBox(arrayMsg, [], 'asf-panel-warning');
        if (this.containsElement(elementID, 'div.asf-panel-warning')) {
            $(elementID).prepend(content);
        }

        //this.addEventToDocumentWhenMessageBox();
    };

    // Hiển thị message khi lưu thành công
    this.displayStatus = function () {
        // Nếu lưu thành công
        if (this.saveStatus.Status == 0) {
            this.displaySuccessMessageBox(this.saveStatus.FormID, this.saveStatus.AppendKey, this.saveStatus.TimeOut);

            // reset status
            this.clearSaveStatus();
        }
    };

    // Save success message
    // Danh mục: appendKey là ID
    // Nghiệp vụ: appendKey rỗng
    this.displaySuccessMessageBox = function (element, appendKey, timeout) {
        $('#' + element + ' .asf-message').remove();

        var str = ASOFT.helper.getMessage('00ML000065' /*"A00ML000017"*/);
        var strWithoutParams = ASOFT.helper.getMessage('00ML000015');

        // Set timeout
        var mgs = (typeof appendKey === 'undefined' || appendKey == "" || appendKey == null)
            ? strWithoutParams
            : str.f(appendKey);

        // get message
        var message = [mgs];

        // append contents
        var content = this.createMessageBox(message, [], 'asf-panel-info');
        if (this.containsElement(element, 'div.asf-panel-info')) {
            $('#' + element).prepend(content);

            // Set fadeout
            if (typeof timeout !== 'undefined') {
                $('#' + element + ' .asf-message').fadeOut(timeout);
            }
        }
    };

    // clear message box
    this.clearMessageBox = function (formid) {
        if (formid != null) {
            $(kendo.format('#{0} .asf-message', formid)).remove();
        } else {
            $('.asf-message').remove();
        }
    };

    this.addEventToDocumentWhenMessageBox = function () {
        $(document).unbind().bind('click', function (e) {
            //console.log('click on document');
            $('.asf-message').remove();
        });
    }

    // clear message box
    //this.clearMessageBoxNew = function () {
    //    $('.asf-message asf-panel-info').remove();
    //};

    // Select tab of tabstrip panel
    // ASOFT.selectedTab("TabMaster", "TabMaster-1")
    this.selectedTab = function (tabStripId, tabPanelSeletedId) {
        var tabStrip = $("#" + tabStripId).kendoTabStrip().data("kendoTabStrip");
        var tabToActivate = $("#" + tabPanelSeletedId);
        tabStrip.activateTab(tabToActivate);
    };

    /**
    * Enter 
    */
    this.enterReplaceTab = function (e) { //Xử lí chuyển tab khi nhấn phím enter
        var elem = e.target.id;
        var key = e.keyCode;

        if (!e.target.id && e.target.name) {
            elem = e.target.name.substring(0, e.target.name.lastIndexOf('_'));
        }
        else {
            if ($(e.target).attr("aria-owns") != undefined && $(e.target).attr("aria-owns") != "")
                elem = $(e.target).attr("aria-owns").split('_')[0];
        }

        if (key == 13) //13 is the keycode of the 'Enter' key
        {
            var input = elem; //ele[0].activeElement.id;

            //Lấy các input trên form
            var inputs = $.find('form input[type="text"], textarea, a.asf-button');

            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].type == 'textarea') continue;
                if (inputs[i].id == input) { //Tìm ô được nhấn
                    for (var k = i + 1; k < inputs.length; k++) { //Xử lý focus vào ô kế tiếp tính từ ô được nhấn
                        var nextElem = $("#" + inputs[k].id);
                        var widgetElement = nextElem.closest("[data-" + kendo.ns + "role]");
                        var widgetObject = kendo.widgetInstance(widgetElement);

                        if (!$("#" + inputs[k].id).hasId()) continue;
                        if (nextElem.prop('disabled') || nextElem.attr('disabled') == 'disabled') continue;

                        if (widgetObject != undefined) {
                            if (widgetObject.options.name == "ComboBox") {
                                ASOFT.asoftComboBox.castName(inputs[k].id).focus();
                                ASOFT.asoftComboBox.castName(inputs[k].id).input.trigger("focus");
                                break;
                            }
                            else if (widgetObject.options.name.indexOf("NumericTextBox") >= 0) {
                                ASOFT.asoftSpinEdit.castName(inputs[k].id).focus(function () {
                                    var input = $(this);
                                    input.select();
                                });
                                break;
                            }
                            else if (widgetObject.options.name.indexOf("DropDownList") >= 0) {
                                continue;
                            }
                        }

                        $(e.target).trigger("change");
                        $("#" + inputs[k].id).focus();
                        $("#" + inputs[k].id).select();
                        $("#" + inputs[k].id).trigger("focus");
                        e.preventDefault();
                        break;
                    }
                    break;
                }
            }
        }
    };

    //Check form changed before closing
    this.formClosing = function (formID) {
        var isClose = true;
        var formSector = kendo.format('#{0}', formID);
        var input = $(formSector).find('input[type="text"], textarea');

        for (var i = 0; i < input.length; i++) {
            if (($(input[i]).attr('name')
                && $(input[i]).attr('name').indexOf('_input')) > 0
                || !$(input[i]).attr('name')
                || $(input[i]).is(':disabled')) {
                continue;
            }

            if (!isNaN($(input[i]).attr('initValue'))
                && !($(input[i]).attr('initValue') == null
                    || $(input[i]).attr('initValue') == '')) { //Dữ liệu là kiểu số convert numer => so sánh
                if ($(input[i]).attr('initValue').indexOf('.') > 0) {//Kiểu số thực
                    //$(input[i]).val(parseFloat($(input[i]).val()));
                    $(input[i]).attr('initValue', parseFloat($(input[i]).attr('initValue')));
                }
                //else {//Kiểu số nguyên
                //    $(input[i]).attr('initValue', parseInt($(input[i]).attr('initValue')));
                //}
            }

            if ($(input[i]).attr('initValue') !== $(input[i]).val()) {
                isClose = false;
                break;
            }
        }

        return isClose;
    }

    //Format datetime
    this.dateFormat = function (value, format) {
        return kendo.toString(value, format)
    }
};

var dates = {
    convert: function (d) {
        // Converts the date in d to a date-object. The input can be:
        //   a date object: returned without modification
        //  an array      : Interpreted as [year,month,day]. NOTE: month is 0-11.
        //   a number     : Interpreted as number of milliseconds
        //                  since 1 Jan 1970 (a timestamp) 
        //   a string     : Any format supported by the javascript engine, like
        //                  "YYYY/MM/DD", "MM/DD/YYYY", "Jan 31 2009" etc.
        //  an object     : Interpreted as an object with year, month and date
        //                  attributes.  **NOTE** month is 0-11.
        return (
            d.constructor === Date ? d :
            d.constructor === Array ? new Date(d[0], d[1], d[2]) :
            d.constructor === Number ? new Date(d) :
            d.constructor === String ? new Date(d) :
            typeof d === "object" ? new Date(d.year, d.month, d.date) :
            NaN
        );
    },
    compare: function (a, b) {
        // Compare two dates (could be of any type supported by the convert
        // function above) and returns:
        //  -1 : if a < b
        //   0 : if a = b
        //   1 : if a > b
        // NaN : if a or b is an illegal date
        // NOTE: The code inside isFinite does an assignment (=).
        return (
            isFinite(a = this.convert(a).valueOf()) &&
            isFinite(b = this.convert(b).valueOf()) ?
            (a > b) - (a < b) :
            NaN
        );
    },
    inRange: function (d, start, end) {
        // Checks if date in d is between dates in start and end.
        // Returns a boolean or NaN:
        //    true  : if d is between start and end (inclusive)
        //    false : if d is before start or after end
        //    NaN   : if one or more of the dates is illegal.
        // NOTE: The code inside isFinite does an assignment (=).
        return (
             isFinite(d = this.convert(d).valueOf()) &&
             isFinite(start = this.convert(start).valueOf()) &&
             isFinite(end = this.convert(end).valueOf()) ?
             start <= d && d <= end :
             NaN
         );
    }
}
/**
* Dialog
*/
ASOFT.dialog = new function () {
    this.namePopup = null;
    this.nameMessageDialog = 'MessageDiaglog';
    this.nameConfirmDialog = 'ConfirmDiaglog';
    this.yesFunction = null;
    this.noFunction = null;
    this.isConfirm = false;

    /**
    * Oke
    */
    this.oKClick = function () {
        $("#" + this.nameMessageDialog).data("kendoWindow").close();
    };

    // Kiểm tra biến truyền vào là một function
    this.isFunction = function (obj) {
        var isFunc = obj && Object.prototype.toString.call(obj) == '[object Function]';
        return isFunc;
    };

    //Yes button
    this.yesClick = function () {
        this.isConfirm = true;
        $("#" + this.nameConfirmDialog).data("kendoWindow").close();
        if (this.isFunction(this.yesFunction)) {
            this.yesFunction.call(this);
        }
    };

    //no button
    this.noClick = function () {
        this.isConfirm = false;
        $("#" + this.nameConfirmDialog).data("kendoWindow").close();
        if (this.isFunction(this.noFunction)) {
            this.noFunction.call(this);
        }
    };

    //template Dialog
    this.templateMessageDialog = function (message, name) { //Dialog Message thay thế cho dialog của trình duyệt
        //Content message dialog
        var container = $('#' + name + ' .asf-dialog');
        var content = $('#' + name + ' .asf-dialog .asf-dialog-content');
        content.remove();
        container.prepend($('<div class="asf-dialog-content">' + message + '</div>'));
    };

    //Dialog
    this.createDialog = function (name) {
        //Tạo popup
        $('<div id="' + name + '"></div>').appendTo('body');
        var popupMessage = ASOFT.asoftPopup.create(name);
        this.namePopup = popupMessage.data('kendoWindow');
        return this.namePopup;
    };

    //Message dialog
    this.showMessage = function (idMessage) {
        var message = ASOFT.helper.getMessage(idMessage);
        this.messageDialog(message);
    };

    //Message dialog
    this.showConfirm = function (idMessage, callback) {
        var message = ASOFT.helper.getMessage(idMessage);
        this.confirmDialog(message, callback);
    };


    //Message dialog
    this.messageDialog = function (message) {

        this.namePopup = ASOFT.asoftPopup.castName(this.nameMessageDialog);
        ASOFT.asoftPopup.show(this.namePopup);
        ASOFT.dialog.templateMessageDialog(message, this.nameMessageDialog);
        this.namePopup.center();
    };

    //Confirm dialog
    this.confirmDialog = function (message, yesFunction, noFunction) {

        this.namePopup = ASOFT.asoftPopup.castName(this.nameConfirmDialog);
        if (typeof yesFunction !== 'undefined') {
            this.yesFunction = yesFunction;
        }

        if (typeof noFunction !== 'undefined') {
            this.noFunction = noFunction;
        }
        ASOFT.asoftPopup.show(this.namePopup);
        ASOFT.dialog.templateMessageDialog(message, this.nameConfirmDialog);
    };
};

//Panel loading quá trình đang lưu dữ liệu
ASOFT.asoftLoadingPanel = new function () {
    this.panelText = 'Loading.....';

    //Show popup
    this.show = function () { //Che màn hình khi đang trong quá trình lư dữ liệu
        var dialog = this.createPanel();
        var leftPosition = (window.innerWidth / 2) - ($('.asf-save-process').width() / 2);
        var topPosition = (window.innerHeight / 2) - (($('.asf-save-process').height() / 2) + 10);
        $('.asf-save-process').css({ top: topPosition, left: leftPosition, display: "block" });
        dialog.css({ display: "block", 'background-color': 'rgba(0,0,0,0.4)' });
    };
    //hide popup
    this.hide = function () {
        $('.asf-overlay').css({ display: "none" });
        $('.asf-save-process').css({ display: "none" });
    };

    //create panel
    this.createPanel = function () {
        if ($(".asf-overlay").length > 0) {
            return $(".asf-overlay");
        } else {
            var loadingElement = $('.asf-save-process');
            var overlay = $('<div  class="asf-overlay"></div>');
            var loading = $('<div class="asf-save-process"></div>');

            loading.append($('<div class="asf-save-process-img"></div>')).append($('<div class="asf-save-process-text">' + this.panelText + '</div>'));
            var result = $('body#bodyMaster').append(overlay).append(loading);
            return overlay;
        }
    };
};

//Xử lí các thao tác trên popup
ASOFT.asoftPopup = new function () {

    //create popup
    this.create = function (name, title, modal, visible, draggable) {
        var popup = $("#" + name);
        if (!popup.data("kendoWindow")) {
            popup.kendoWindow({
                title: title,
                modal: modal,
                actions: [],
                visible: visible,
                draggable: draggable
            });
        }
        return popup;
    };
    //get kendoName
    this.castName = function (name) {
        var name = $("#" + name).data("kendoWindow");
        return name;
    };

    this.open = function (popup) {
        ASOFT.asoftPopup.center(popup);
        popup.open();
    }

    //show
    this.show = function (popup, url, data) {
        if (typeof url !== 'undefined') {
            popup.content('<div class="t-loading"></div>');
            ASOFT.asoftPopup.refresh(popup, url, data);
        }
        popup.center();
        popup.open();
    };

    //show iframe with method post
    this.showIframeHttpPost = function (url, data) {
        if (typeof heartBeat === "function") {
            heartBeat();
        }

        var ifPopup = ASOFT.asoftPopup.castName("PopupIframe");
        if (typeof url !== 'undefined') {
            //Open and refresh popup
            ASOFT.asoftPopup.refreshIframe(ifPopup, url, data);

            // Update by Thai Son
            // Khắc phục lỗi "flash white" trên IE 8
            // <iframe style="visibility:hidden;" onload="this.style.visibility = 'visible';" src="../examples/inlineframes1.html" > </iframe>
            $(".k-content-frame").css('visibility', "hidden");
            $(".k-content-frame").attr('onload', "this.style.visibility = 'visible';");
        }

        return false;
    };

    //show iframe
    this.showIframe = function (url, data) {
        if (typeof heartBeat === "function") {
            heartBeat();
        }

        var ifPopup = $("#PopupIframe").data("kendoWindow");//ASOFT.asoftPopup.castName("PopupIframe");
        if (typeof url !== 'undefined') {
            //ifPopup.content('<div class="t-loading"></div>');
            ASOFT.asoftPopup.refresh(ifPopup, url, data);

            // Update by Thai Son
            // Khắc phục lỗi "flash white" trên IE 8
            // <iframe style="visibility:hidden;" onload="this.style.visibility = 'visible';" src="../examples/inlineframes1.html" > </iframe>
            $(".k-content-frame").css('visibility', "hidden");
            $(".k-content-frame").attr('onload', "this.style.visibility = 'visible';");
        }

        ifPopup.open();
        ifPopup.maximize();
        return false;
    };


    //hide iframe
    this.hideIframe = function (parent) {
        var ifPopup = null;
        if (typeof parent !== 'undefined') {
            ifPopup = window.parent.$("#PopupIframe").data("kendoWindow");
            ifPopup.close();
            return;
        }

        ifPopup = $("#PopupIframe").data("kendoWindow");
        ifPopup.close();
        return false;
    };

    //Open and refresh popup using iframe
    this.refreshIframe = function (popup, url, data) {
        popup.refresh({//Load empty page
            url: url
        });
        popup.bind('refresh', function (e) {
            var bodyIframe = ($("#PopupIframe .k-content-frame")[0].contentWindow || $("#PopupIframe .k-content-frame")[0].contentDocument);
            bodyIframe.$('body').html('');
            ASOFT.helper.postTypeJson(url, data, function (result) {
                bodyIframe.$('body').html(result);
            });
            this.unbind('refresh');
        })
        popup.open();
        popup.maximize();

        //Set timeout for session
        var sessionTimeout = $('#sessionTimeout').val();
        ASOFT.helper.sessionTimeOut(sessionTimeout);
    }

    //refresh popup
    this.refresh = function (popup, url, data) {
        if (typeof data === 'undefined') {
            data = [];
        }

        //Refresh content by url => result is a partialview
        popup.refresh({
            url: url,
            data: data,
            type: 'POST',
        });
    };

    //center
    this.center = function (popup) {
        var popupWidth = popup.wrapper.innerWidth() / 2;
        var popupHeight = popup.wrapper.innerHeight() / 2;
        var leftPosition = (window.innerWidth / 2) - popupWidth;
        var topPosition = (window.innerHeight / 2) - popupHeight;
        popup.wrapper.css({ top: topPosition, left: leftPosition });
    };

    //hide
    this.close = function (e) {
        ASOFT.form.messageError = {};
        ASOFT.form.clearSaveStatus();
        e.sender.element.html('');

        //Set timeout for session
        var sessionTimeout = $('#sessionTimeout').val();
        ASOFT.helper.sessionTimeOut(sessionTimeout);

        if (window.frameElement) {
            window.parent.$('#asf-help').unbind('click').bind('click', function () {
                var moduleID = window.$('#currentDagArea').val();
                var controller = window.$('#currentDagController').val();
                var action = window.$('#currentDagAction').val();

                var url = window.$('#urlHelp').val() + (moduleID ? moduleID + '_' : '') + controller + (action === 'Index' ? '' : '_' + action) + '.html';
                //window.location.href = url
                window.open(url, '_blank');
            });
        }
        else {
            $('#asf-help').unbind('click').bind('click', function () {
                var moduleID = $('#currentArea').val();
                var controller = $('#currentController').val();
                var action = $('#currentAction').val();

                var url = $('#urlHelp').val() + (moduleID ? moduleID + '_' : '') + controller + (action === 'Index' ? '' : '_' + action) + '.html';
                //window.location.href = url
                window.open(url, '_blank');
            });
        }
    };

    // Close không hỏi
    this.closeNormal = function (e) {
        //Set timeout for session
        var sessionTimeout = $('#sessionTimeout').val();
        ASOFT.helper.sessionTimeOut(sessionTimeout);

        namePopupParent = e.sender.element.closest('.asf-popup').attr('id');
        popupParent = ASOFT.asoftPopup.castName(namePopupParent);
        popupParent.close();
    }

    // Close không hỏi
    this.closeOnly = function () {
        if (window.parent != window) {
            window.parent.ASOFT.asoftPopup.hideIframe();
        }
    }

    //refresh popup
    this.refreshed = function (e) {
        ASOFT.asoftPopup.center(this);
        if (this.options.iframe) {
            var contentIframe = $("#" + this.wrapper.context.id + " .k-content-frame");
            var bodyIframe = (contentIframe[0].contentWindow || contentIframe[0].contentDocument);
            //$(".k-content-frame").height(bodyIframe.$('body').height());
        }

        ASOFT.form.displayStatus();
        ASOFT.asoftPopup.activedButton(e);

        //Set timeout for session
        var sessionTimeout = $('#sessionTimeout').val();
        ASOFT.helper.sessionTimeOut(sessionTimeout);
        //wnd.center();
    };

    //active
    this.activate = function (popup, handler) {
        popup.bind("activate", handler);
    };

    //Trạng thái active button trên nội dung của popup
    this.activedButton = function (e) {
        $('.asf-button').mousedown(function () {
            $(this).addClass('asf-button-active');
        }).mouseup(function () {
            $(this).removeClass('asf-button-active');
        });
    }

    //hide popup
    this.hidePopupAction = function (e) {
        var dialog = $("#Action").data("kendoWindow");
        dialog.close();
    };
};

//Xử lí sự kiện cho combobobox
ASOFT.asoftComboBox = new function () {
    //cast name
    this.castName = function (name) {
        var combo = $("#" + name).data("kendoComboBox");
        return combo;
    };

    //callback
    this.callBack = function (combo, data) {//Lưu ý data phải đặt ở dạng object (data = {})
        var asoftComboBox = null;
        var dataSource = null;
        if (typeof data === 'undefined') {
            data = {};
        }

        if (typeof combo !== 'undefined') {
            if (typeof combo === 'string') {
                asoftComboBox = ASOFT.asoftComboBox.CastName(combo);
            }
            else {
                asoftComboBox = combo;
            }

            asoftComboBox.dataSource.read(data);
            asoftComboBox.value(null);
            asoftComboBox.input.val('');
            asoftComboBox.selectedIndex = 0;

            //Set timeout for session
            var sessionTimeout = $('#sessionTimeout').val();
            ASOFT.helper.sessionTimeOut(sessionTimeout);
        }
    };

    //Xử lý khi dữ liệu được bind xuống
    this.dataBound = function (e) {
        var $comboBox = $(e.sender.element);
        var dataWidth = 350;
        var listHeight = e.sender.list.height() == 0 ? 300 : e.sender.list.height();
        var listBox = kendo.format('#{0}_listbox', e.sender.element.attr('id'));
        var panel = kendo.format('#{0}-list', e.sender.element.attr('id'));

        if (typeof e.sender.element.attr('listWidth') != 'undefined') {
            dataWidth = e.sender.element.attr('listWidth');
        }

        //Remove code
        /*if (typeof e.sender.element.attr('listWidth') != 'undefined') {
            dataWidth = e.sender.element.attr('listWidth');
            var listElem = kendo.format('{0} .asf-combo-item:first', panel); 
            var countItems = $(listElem).children('.k-state-default');
            if (countItems.length > 2) {
                var totalItem = kendo.format('{0} .asf-combo-item', panel);
                var listValueElem = $(totalItem).children('div.asf-combo-item-col-value');
                var listValueElem = $(totalItem).children('div.asf-combo-item-col-text');
                var widthValue = kendo.format('{0}%', 20 - (15 / dataWidth * 100));
                var widthText = kendo.format('{0}%', 80 / (countItems.length - 1) - (10 / dataWidth * 100));

                $(totalItem).each(function () {
                    $(this).children('div').each(function () {
                        if ($(this).attr('id').indexOf('asf-combo-value') >= 0) {
                            $(this).width(widthValue);
                        }
                        else if ($(this).attr('id').indexOf('asf-combo-text') >= 0) {
                            $(this).width(widthText);
                        }
                    });
                });
            }
        }*/

        if (e.sender.options.template.length != 0) {
            // Set widths to the new values
            e.sender.list.width(dataWidth);
        }

        /*if (e.sender.selectedIndex < 0 && (e.sender.value().length != 0)) {
            if (e.sender.dataSource.total() > 0) {
                e.sender.select(0);
            }
        }*/
    }

    this.comboBoxCheckBox = function (comboBox) {
        $.each(comboBox, function () {
            $comboBox = this.element;
            if (typeof $comboBox.attr('checkBoxID') != 'undefined') {
                var checkBoxID = $comboBox.attr('checkBoxID');
                var elemCheckBox = kendo.format('#{0}', checkBoxID);
                var elemCheckBoxHidden = $(kendo.format('input[name={0}][type=hidden]', checkBoxID));
                $(elemCheckBox).css({ 'margin-top': '7px' });
                $comboBox.prev().prepend($(elemCheckBox));
                $comboBox.prev().append(elemCheckBoxHidden);
            }
        });
    }

};


//Xử lí sự kiện cho date edit
ASOFT.asoftDateEdit = new function () {
    //cast name
    this.castName = function (name) {
        var dateEdit = $("#" + name).data("kendoDatePicker");
        return dateEdit;
    };
}

//Xử lí sự kiện cho date edit
ASOFT.asoftSpinEdit = new function () {
    //cast name
    this.castName = function (name) {
        var spinEdit = $("#" + name).data("kendoNumericTextBox");
        return spinEdit;
    };
}

//Xử lí sự kiện cho Gridview
ASOFT.asoftGrid = new function () {
    this.totalRow = 0;

    //first cell
    this.firstCell = 1;

    //last cell
    this.lastCell = 1;

    //current cell
    this.currentCell = 1;

    //current row
    this.currentRow = 0;

    //length
    this.columnsLength = -1;

    this.currentPage = 1;

    //Trả về đối tượng lưới 
    this.castName = function (name) {
        try {
            var grid = $('#' + name).data('kendoGrid');

            if (grid) {
                grid.focus = function (index) {
                    ASOFT.asoftGrid.focus(this, index);
                }
                grid.dataSource.isRowChange = false;
                grid.dataSource.numberRowChange = 0;
                grid.dataSource.bind("requestStart", function () {
                    if (this.isRowChange) {

                    }
                    this.isRowChange = false;
                });
            }
            return grid;
        } catch (e) {
            return null;
        }
    };

    //Focus row
    this.focus = function (grid, index) {
        var row = null;//grid.tbody.find(">tr:not(.k-grouping-row)").eq(index);
        if (typeof index === 'object') {
            row = index;
        }
        else {
            row = grid.tbody.find(">tr:not(.k-grouping-row)").eq(index);
        }
        grid.select(row);
    }

    //Set auto chiều cao cho gridview
    this.setHeight = function (grid) {
        //var newHeight = gridElement.parent().innerHeight() - 2;
        //screenHeight = $(document).height();
        if (typeof grid == 'undefined') {
            return false;
        }
        if (typeof (grid.element) == 'undefined') {
            return false;
        }
        gridElement = $('#' + grid.element[0].id);
        offsetTop = grid.wrapper.offset().top;
        screenHeight = window.innerHeight - 2;

        //Không set auto height cho các lưới trên popup
        var isAutoHeight = grid.element.attr('auto-height');
        if (typeof isAutoHeight === 'undefined') {
            return;
        }

        //ASOFT.asoftGrid.calculateGridHeight(grid, offsetTop, screenHeight);

        var dataArea = gridElement.find(".k-grid-content");
        var dataHeader = gridElement.find(".k-grid-header");
        var dataPager = gridElement.find(".k-pager-wrap.k-grid-pager");
        var headerHeight = dataHeader.innerHeight();
        var pagerHeight = dataPager.innerHeight();
        var diff = gridElement.innerHeight() - dataArea.innerHeight();
        var areaHeight = (screenHeight - offsetTop) - diff;

        if (diff <= (headerHeight + pagerHeight)) {
            //screenHeight = screenHeight + 50;
            diff = (headerHeight + pagerHeight) + 2;
        }

        if ((screenHeight - offsetTop) >= 410) {
            grid.wrapper.height((screenHeight - offsetTop));
            dataArea.height((screenHeight - offsetTop) - diff);
        }
    };

    this.calculateGridHeight = function (grid, top, parentHeight) {
        var gridElement = $('#' + grid.element[0].id);
        var offsetTop = top;
        var parentHeight = parentHeight;

        var dataArea = gridElement.find(".k-grid-content");
        var dataHeader = gridElement.find(".k-grid-header");
        var dataPager = gridElement.find(".k-pager-wrap.k-grid-pager");
        var headerHeight = dataHeader.innerHeight();
        var pagerHeight = dataPager.innerHeight();
        var diff = gridElement.innerHeight() - dataArea.innerHeight();
        var areaHeight = (parentHeight - offsetTop) - diff;

        if (diff <= (headerHeight + pagerHeight)) {
            //screenHeight = screenHeight + 50;
            diff = (headerHeight + pagerHeight) + 2;
        }

        if ((parentHeight - offsetTop) >= 200) {
            grid.wrapper.height((parentHeight - offsetTop));
            dataArea.height((parentHeight - offsetTop) - diff);
        }
    };
    this.calculateGridContentHeight = function (grid) {
        var gridElement = $('#' + grid.element[0].id);

        var dataArea = gridElement.find(".k-grid-content");
        var dataHeader = gridElement.find(".k-grid-header");
        var dataPager = gridElement.find(".k-pager-wrap.k-grid-pager");
        var headerHeight = dataHeader.innerHeight();
        var pagerHeight = dataPager.innerHeight();

        dataArea.height((gridElement.innerHeight() - headerHeight));
    };

    //Ham canh ben phai danh cho dropdown page size
    this.pageSizeRight = function () {
        var array = $('.k-list-container');
        $.each(array, function (idenx, value) {
            if (value.id == "") {
                value.style.textAlign = "right";
            }
        });
    };

    this.checkRecord = function (e) {
        var gridDOM = $(e).closest('div.asf-grid');

        if (gridDOM != undefined) {
            var id = gridDOM.prop('id');
            var sector = kendo.format("#{0} {1}", id, ".asoftcheckbox");
            var isCheck = $(sector + "#chkAll").is(':checked');
            if (isCheck && !$(e).is(':checked')) {
                $(sector + "#chkAll").prop('checked', false);
            }
        }

    };

    //Hàm check All Record
    this.checkAll = function (e) {
        var state = $(e).is('.asoftcheckbox:checked');
        var listCheckBox = null;
        var gridDOM = $(e).closest('div.asf-grid');
        var checkDatas = [];
        if (gridDOM != undefined) {
            var id = gridDOM.prop('id');
            var sector = kendo.format("#{0} {1}", id, ".asoftcheckbox");
            listCheckBox = $(sector);
            listCheckBox.prop('checked', state);

            var grid = ASOFT.asoftGrid.castName(id);
            checkDatas = this.getDataChecked(grid);
        }
        return { check: state, items: checkDatas };
    };


    //Hàm check All Record
    this.getDataChecked = function (grid) {
        var checkDatas = [];
        if (grid != undefined) {
            var data = grid.dataSource.data();
            var id = grid.element.prop('id');
            var sector = kendo.format("#{0} {1}", id, ".asoftcheckbox:checked");
            var items = $(sector);
            items.each(function (index, item) {
                var tr = $(item).closest('tr');
                if ($(item).closest('td').length > 0) {
                    var rowIndex = tr.index();
                    var row = data[rowIndex];
                    checkDatas.push(row);
                }
            });
        }
        return checkDatas;
    };

    this.setTotalRow = function () {
        this._total = ASOFT.asoftGrid.totalRow;
        return parseInt(this._total || 0, 10);
    };

    //Hàm trả về danh sách các dòng xóa.
    this.selectedRecords = function (grid, formID) {
        var data = [];
        //var grid = castName(name);

        grid.tbody.find('.asoftcheckbox:checked').closest('tr')
            .each(function () {
                if (typeof grid.dataItem(this) !== 'undefined') {
                    data.push(grid.dataItem(this));
                }
            });

        // Không thực hiện nếu chưa chọn dòng nào
        if (data.length == 0) {
            // Hiển thị thông báo
            if (formID != undefined) {
                ASOFT.form.displayMessageBox("#" + formID, [ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/)], null);
            }
            else {
                ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
            }
        }

        return data;
    };

    //Hàm trả về dòng được chọn
    this.selectedRecord = function (grid, formID) {
        var record = grid.dataItem(grid.select());

        // Không thực hiện nếu chưa chọn dòng nào
        if (!record || record == null) {
            // Hiển thị thông báo
            if (formID != undefined) {
                ASOFT.form.displayMessageBox("#" + formID, [ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/)], null);
            }
            else {
                ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
            }
        }

        return record;
    };

    //Xử lý phân trang cho lưới.
    this.dataBindGridPanging = function (e) {
        var totalProp = 0;
        var emptyRow = [];
        ASOFT.asoftGrid.currentPage = this.dataSource.page();

        //Định dạng lại dropdown pagesize trên lưới.
        ASOFT.asoftGrid.pageSizeRight();



        if (this.dataSource.data().length == 1) {
            var firstRow = this.dataSource.data()[0];
            $.each(firstRow.fields, function (key, value) {//Kiểm tra dòng trống
                if (firstRow && (firstRow[key] === null
                    || !firstRow[key]
                    || firstRow[key] === 0)) {
                    //emptyRow[key] = value;
                    emptyRow.push({ name: key, value: firstRow[key] });
                }
                totalProp++;
            });
        }

        if (emptyRow.length != 0
            && totalProp != 0
            && (emptyRow.length === totalProp)) { //Remove row empty
            this.dataSource.remove(this.dataSource.data()[0]);
        }

        //Phân trang => tính tổng số dòng
        if (this.dataSource.page() == 1 && this.dataSource.page() != undefined) {//Trường hợp lưới có phân trang
            ASOFT.asoftGrid.totalRow = 0;
            if (this.dataSource.data().length
                && this.dataSource.data().length != 0) {
                ASOFT.asoftGrid.totalRow = this.dataSource.data()[0].TotalRow;

            }
        }
        else if (this.dataSource.page() > 1 && this.dataSource.page() != undefined) {

        }
        else if (this.dataSource.page() == undefined) {//Trường hợp lưới không phân trang
            ASOFT.asoftGrid.totalRow = 0;
            if (this.dataSource.data().length
                && this.dataSource.data().length != 0) {
                ASOFT.asoftGrid.totalRow = this.dataSource.data().length;
            }
        }

        if (this.dataSource.data().length
            && this.dataSource.data().length != 0) {
            if (ASOFT.asoftGrid.totalRow /*this.dataSource.data()[0].TotalRow != 0*/) {
                this.dataSource.total = ASOFT.asoftGrid.setTotalRow;
            }
        }

        //TODO: Test cho sự kiện Bound của lưới
        //if (this.dataSource.total() > 0) {  
        //}
        //else {
        //    if (ASOFT.asoftGrid.totalRow != 0 && this.dataSource.data().length != 0) {
        //        //var totalPages = Math.floor(ASOFT.asoftGrid.totalRow / this.dataSource.pageSize());
        //        //this.dataSource.totalPages((totalPages + 1));

        //    }
        //}
    };

    //Xử lý phân trang cho lưới Xương rồng
    this.dataBindGridPangingXR = function (e) {
        var totalProp = 0;
        var emptyRow = [];
        ASOFT.asoftGrid.currentPage = this.dataSource.page();

        //Định dạng lại dropdown pagesize trên lưới.
        ASOFT.asoftGrid.pageSizeRight();



        if (this.dataSource.data().length == 1) {
            var firstRow = this.dataSource.data()[0];
            $.each(firstRow.fields, function (key, value) {//Kiểm tra dòng trống
                if (firstRow && (firstRow[key] === null
                    || !firstRow[key]
                    || firstRow[key] === 0)) {
                    //emptyRow[key] = value;
                    emptyRow.push({ name: key, value: firstRow[key] });
                }
                totalProp++;
            });
        }

        if (emptyRow.length != 0
            && totalProp != 0
            && (emptyRow.length === totalProp)) { //Remove row empty
            this.dataSource.remove(this.dataSource.data()[0]);
        }

        //Phân trang => tính tổng số dòng
        if (this.dataSource.page() == 1 && this.dataSource.page() != undefined) {//Trường hợp lưới có phân trang
            ASOFT.asoftGrid.totalRow = 0;
            if (this.dataSource.data().length
                && this.dataSource.data().length != 0) {
                ASOFT.asoftGrid.totalRow = this.dataSource.data()[0].TotalRow;

            }
        }
        else if (this.dataSource.page() > 1 && this.dataSource.page() != undefined) {

        }
        else if (this.dataSource.page() == undefined) {//Trường hợp lưới không phân trang
            ASOFT.asoftGrid.totalRow = 0;
            if (this.dataSource.data().length
                && this.dataSource.data().length != 0) {
                ASOFT.asoftGrid.totalRow = this.dataSource.data().length;
            }
        }

        if (this.dataSource.data().length
            && this.dataSource.data().length != 0) {
            if (ASOFT.asoftGrid.totalRow /*this.dataSource.data()[0].TotalRow != 0*/) {
                this.dataSource.total = ASOFT.asoftGrid.setTotalRow;
            }
        }

        if ($('#TotalAddress span#TAID') && this.dataSource.data() != []) {
            if (this.dataSource.data()[0] != undefined) {
                $('#TotalAddress span#TAID').text(this.dataSource.data()[0].TotalAddress ? this.dataSource.data()[0].TotalAddress : 0);
            } else {
                $('#TotalAddress span#TAID').text(0);
            }
        }

        //TODO: Test cho sự kiện Bound của lưới
        //if (this.dataSource.total() > 0) {  
        //}
        //else {
        //    if (ASOFT.asoftGrid.totalRow != 0 && this.dataSource.data().length != 0) {
        //        //var totalPages = Math.floor(ASOFT.asoftGrid.totalRow / this.dataSource.pageSize());
        //        //this.dataSource.totalPages((totalPages + 1));

        //    }
        //}
    };
    this.dataBound = function (e) {
        //Set timeout for session
        var sessionTimeout = $('#sessionTimeout').val();
        ASOFT.helper.sessionTimeOut(sessionTimeout);

        var grid = e.sender;
        if (grid == undefined) {
            grid = this;
        }

        var name = grid.element.prop('id');
        var idSector = kendo.format("#{0} {1}", name, ".asoftcheckbox");
        $(idSector).prop('checked', false);

        ASOFT.asoftGrid.setHeight(this);
        var domElement = grid.element[0];

        //Xử lí lưới không có dữ liệu
        $(this.element).find('div.k-grid-content > table').find('.asf-grid-no-record').remove();
        if (grid.dataSource.total() > 0) {
            //$(this.element).find('div.k-grid-content > table').find('.asf-grid-no-record').remove();

            //[Đức Quý] Add footer cho gridview [18/03/2015]
            var colIndex = 0;
            var aggregates = null;
            var sum = 0;
            var fieldAggregate = {};
            $.each(grid.columns, function (index, value) {
                if (this.aggregate) {
                    fieldAggregate = { field: this.field, format: this.format, value: 0 };
                    //console.log(this.aggregate);
                    aggregates = this.aggregate;
                    colIndex = index;
                    $.each(grid.dataSource.data(), function () {
                        if (this[fieldAggregate.field]) {
                            fieldAggregate.aggregate = aggregates[0];
                            if (aggregates[0] == 'sum') {
                                fieldAggregate.value += this[fieldAggregate.field];
                            }
                        }
                    });

                    if (fieldAggregate.aggregate == 'sum') {
                        $(grid.footer).find('table')
                            .find('tr.k-footer-template')
                            .find('td').eq(colIndex)
                            .text(kendo.format('Tổng: ' + fieldAggregate.format, fieldAggregate.value))
                            .css({ 'text-align': 'right' });
                    }
                }
            });
            //console.log(sum);
            //console.log(grid);
            //console.log(grid.dataSource);
            return;
        } else {
            $(this.element).find('div.k-grid-content > table').find('.asf-grid-no-record').remove();
            $('<td></td>').appendTo($('<tr></tr>'))
                .appendTo($(this.element).find('div.k-grid-content > table'))
                    .addClass('asf-grid-no-record')
                    .attr('colspan', grid.columns.length)
                    .text(ASOFT.helper.getMessage('00ML000067' /*'A00ML000004'*/));

            //TODO:Ghi đè lên dòng rỗng
            //if (this.dataSource.data().length == 1) {
            //    var firstRow = this.dataSource.data()[0];
            //    $.each(firstRow.fields, function (key, value) {//Kiểm tra dòng trống
            //        if (firstRow && (firstRow[key] === null
            //            || !firstRow[key]
            //            || firstRow[key] === 0)) {
            //            //emptyRow[key] = value;
            //            emptyRow.push({ name: key, value: firstRow[key] });
            //        }
            //        totalProp++;
            //    });
            //}

            //if (emptyRow.length === totalProp
            //    || this.dataSource.data().length == 0) { //Add message không có dữ liệu
            //    $('#' + domElement.id + ' table tbody td').addClass('asf-grid-no-record').text('');
            //    $('#' + domElement.id + ' table tbody td:gt(0)').remove();
            //    $('#' + domElement.id + ' table tbody td:eq(0)')
            //        .addClass('asf-grid-no-record')
            //        .attr('colspan', grid.columns.length)
            //        .text(ASOFT.helper.getMessage('00ML000067' /*'A00ML000004'*/));
            //}
        }

    };

    this.reloadCurrentPage = function (grid) {
        ASOFT.asoftGrid.totalRow = ASOFT.asoftGrid.totalRow - grid.dataSource.numberRowChange;
        var pages = ASOFT.asoftGrid.totalRow / grid.dataSource.pageSize();
        if (grid.dataSource.page() > pages) {
            if (pages % 2 !== 0) {
                pages = pages + 1;
            }
        }
        else {
            pages = ASOFT.asoftGrid.currentPage;
        }

        grid.dataSource.numberRowChange = 0;
        grid.dataSource.page(pages);
    }

    //Gán gía trị cho một cell trên lưới vào datasrouce
    this.setValueTextbox = function (name, e, cellindex, rowindex) {
        var grid = ASOFT.asoftGrid.castName(name);
        var fielid = grid.columns[cellindex].field;
        if (fielid != undefined && $(grid.tbody).find('#' + fielid).val() != undefined) {
            var dateFormat = /^(\d{2})\/(\d{2})\/(\d{4})$/; //check value is a date
            var row = grid.dataSource.data()[rowindex];
            var value = $(grid.tbody).find('#' + fielid).val();

            //row[fielid] = dateFormat.test(value) ? kendo.parseDate(value, "dd/MM/yyyy") : value;
            row.set(fielid, dateFormat.test(value) ? kendo.parseDate(value, "dd/MM/yyyy") : value);
            //grid._data[rowindex][fielid] = $(grid.tbody).find('#' + fielid).val();
        }
    };

    //Kiểm tra cell có đươc Edit ko? Tra ve cellIndex sẽ được chọn
    this.checkEditCell = function (model, fieldId) {
        if (model != undefined) {
            var attr = model.attributes;
            if (attr && attr.editable != undefined) {
                return true;
            }
        }
        return false;
    };

    //Mở cell để set giá trị
    this.openCellEdit = function (model, fieldId) {
        model.fields[fieldId].editable = true;
    };

    //Đóng cell khong cho phep sua
    this.closeCellEdit = function (model, fieldId) {
        model.fields[fieldId].editable = false;
    };

    //Thêm dòng mới trên lưới
    this.addRecord = function (name) {
        var grid = ASOFT.asoftGrid.castName(name);
        grid.addRow();
    };

    //Remove một dòng dữ liệu ra khỏi lưới
    this.removeRecord = function (name) {
        var grid = ASOFT.asoftGrid.castName(name);
        grid.dataSource.remove(currentRecordGrid);
    };

    //Move right cell 
    this.rightCell = function (elm, name) {
        //lastCell 
        if (ASOFT.asoftGrid.currentCell == this.lastCell) {
            return false;
        }
        this.nextCell(elm, name);
    };

    //Move right cell 
    this.leftCell = function (elm, name) {
        //lastCell 
        if (ASOFT.asoftGrid.currentCell == this.firstCell) {
            return false;
        }
        this.previousCell(elm, name);
    };

    //Move down cell
    this.downCell = function (elm, name) {
        var grid = ASOFT.asoftGrid.castName(name);
        var maxRows = grid.dataSource.data().length;
        if (ASOFT.asoftGrid.currentRow == (maxRows - 1)) {
            return false;
        }
        //update value
        ASOFT.asoftGrid.setValueTextbox(
            name,
            elm,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );
        //close cell
        grid.closeCell();
        grid.saveRow();
        //move row
        ASOFT.asoftGrid.currentRow++;

        this.moveCell(elm, name);
    };

    //Move up cell
    this.upCell = function (elm, name) {
        var grid = ASOFT.asoftGrid.castName(name);
        if (ASOFT.asoftGrid.currentRow == 0) {
            return false;
        }
        //update value
        ASOFT.asoftGrid.setValueTextbox(
            name,
            elm,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );
        //close cell
        grid.closeCell();
        grid.saveRow();
        //move row
        ASOFT.asoftGrid.currentRow--;
        this.moveCell(elm, name);
    };

    //Move cell
    this.moveCell = function (elm, name) {
        var grid = ASOFT.asoftGrid.castName(name);
        //Lấy dòng theo index row
        var prevrow = grid.tbody.find('tr').eq(ASOFT.asoftGrid.currentRow);
        //lấy cell theo index cell
        var cell = $(prevrow).find('td').eq(ASOFT.asoftGrid.currentCell);
        //Chọn dòng
        grid.select(prevrow);
        //Edit cell
        grid.editCell(cell);
    };

    //Move previous cell
    this.previousCell = function (elm, name, isEnter) {
        var grid = ASOFT.asoftGrid.castName(name);

        if (ASOFT.asoftGrid.currentCell == this.firstCell
            && ASOFT.asoftGrid.currentRow == 0
            && isEnter) {
            return false;
        }

        //update value
        ASOFT.asoftGrid.setValueTextbox(
            name,
            elm,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );
        //close cell
        grid.closeCell();
        var columns = grid.columns;
        var i = 0;
        var column = null;
        //move row
        if (ASOFT.asoftGrid.currentCell == this.firstCell) {
            if (isEnter) {
                ASOFT.asoftGrid.currentRow -= 1;
            }
            ASOFT.asoftGrid.currentCell = this.lastCell;

        } else {
            i = ASOFT.asoftGrid.currentCell;
            while (i > 0) {
                column = columns[i];
                if (ASOFT.asoftGrid.checkEditCell(column, column.field)
                        && ASOFT.asoftGrid.currentCell != i) {
                    ASOFT.asoftGrid.currentCell = i;
                    break;
                }
                i--;
            }
        }
        this.moveCell(elm, name);

        return false;
    };

    //Move next cell
    this.nextCell = function (elm, name, isEnter) {
        var grid = ASOFT.asoftGrid.castName(name);
        //update value
        ASOFT.asoftGrid.setValueTextbox(
            name,
            elm,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );
        //close cell
        grid.closeCell();
        grid.saveRow();
        var columns = grid.columns;

        //move row
        var maxRows = grid.dataSource.data().length;
        if (ASOFT.asoftGrid.currentCell == this.lastCell) {
            if (isEnter) {
                if (ASOFT.asoftGrid.currentRow == (maxRows - 1)) {
                    // Start Update
                    if ($(grid.element).is('[addnewrowdisabled]')) {
                        // Close cell
                        grid.closeCell();
                        return;
                    } else {
                        // Add new empty row
                        grid.addRow();
                        ASOFT.asoftGrid.currentRow = maxRows;
                    }
                    // End Update                   

                } else {
                    ASOFT.asoftGrid.currentRow += 1;
                }
            }
            ASOFT.asoftGrid.currentCell = this.firstCell;

        } else {
            var i = ASOFT.asoftGrid.currentCell;
            while (i < columns.length) {
                var column = columns[i];
                if (ASOFT.asoftGrid.checkEditCell(column, column.field)
                        && ASOFT.asoftGrid.currentCell != i) {
                    ASOFT.asoftGrid.currentCell = i;
                    break;
                }
                i++;
            }
        }

        this.moveCell(elm, name);

        return false;

    };

    //reset Events
    this.resetRow = function (item) {
        for (var name in item.defaults) {
            item.set(name, item.defaults[name]);
        }
        return false;
    };

    //remove Events
    this.removeEditRow = function (tagTd, grid, afterRemove) {

        var row = $(tagTd).closest("tr");
        var item = grid.dataItem(row);
        var items = grid.dataSource.data();
        var index = items.indexOf(item);
        if (items.length == 1 && index == 0) {
            ASOFT.asoftGrid.resetRow(item);
        } else {
            grid.removeRow(row);
        }

        //after delete
        if (afterRemove
            && typeof (afterRemove) === "function") {
            afterRemove(row);
        }

        return false;
    };

    //edit Events
    this.editGridEdit = function (e) {
        var grid = e.sender;
        var columns = grid.columns;
        var alowEdit = true;
        var cellIndex = $(e.container).index();

        if (cellIndex < columns.length) {
            var column = columns[cellIndex];
            if (column != null
                    && ASOFT.asoftGrid.checkEditCell(column)) {
                alowEdit = false;
            }

            if (alowEdit) {
                e.sender.closeCell();
            }
        }// end if

        return true;
    };

    //edit Events
    this.editGridEditXR = function (e) {
        var grid = e.sender;
        var columns = grid.columns;
        var alowEdit = true;
        var cellIndex = $(e.container).index();

        if (cellIndex == 1) {
            e.sender.closeCell();
        }

        if (cellIndex == 4) {
            var city = $(e.container.parent().children()[3]).text();
            if (city == " " || !city) {
                e.sender.closeCell();
            }
            else {
                e.sender.editCell();
            }
        }

        if (grid.items().length > 10) {
            e.sender.cancelChanges();
        }


        if (cellIndex < columns.length) {
            var column = columns[cellIndex];
            if (column != null
                    && ASOFT.asoftGrid.checkEditCell(column)) {
                alowEdit = false;
            }

            if (alowEdit) {
                e.sender.closeCell();
            }
            if ($('#' + e.model.AddressID).val() != null && $('#' + e.model.AddressID).val() != undefined) {
                if ($('#' + e.model.AddressID).val().indexOf(cellIndex) == -1) {
                    e.sender.closeCell();
                }
            }

        }// end if

        return true;
    };
    //DataBound
    this.editGridDataBound = function (e) {
        var grid = e.sender;
        var name = grid.element.prop('id');
        var columns = grid.columns;

        ASOFT.asoftGrid.firstCell = -1;
        //first cell && last cell
        var i = 0;
        var length = columns.length;
        while (i < length) {
            var column = columns[i];
            if (ASOFT.asoftGrid.checkEditCell(column, column.field)) {
                if (ASOFT.asoftGrid.firstCell == -1) {
                    ASOFT.asoftGrid.firstCell = i;
                }
                ASOFT.asoftGrid.lastCell = i;
            }
            i++;
        }
        //ASOFT.asoftGrid.lastCell = (columns.length - 2);

        $(grid.tbody).off("keydown mouseleave", "td").on("keydown mouseleave", "td", function (e) {

            ASOFT.asoftGrid.currentRow = $(this).parent().index();
            ASOFT.asoftGrid.currentCell = $(this).index();

            var editor = columns[ASOFT.asoftGrid.currentCell].editor;
            var isDefaultLR = $(grid.element).attr('isDefaultLR');
            if (editor != undefined) {
                var elm = $(this);
                if (e.shiftKey) {
                    switch (e.keyCode) {
                        case 13:
                            ASOFT.asoftGrid.previousCell(this, name, true);
                            e.preventDefault();
                            break;
                        case 9:
                            ASOFT.asoftGrid.previousCell(this, name, false);
                            e.preventDefault();
                            break;
                        default:
                            break;
                    }
                } else {
                    switch (e.keyCode) {
                        case 13:
                            ASOFT.asoftGrid.nextCell(this, name, true);
                            e.preventDefault();
                            break;
                        case 9:
                            ASOFT.asoftGrid.nextCell(this, name, false);
                            e.preventDefault();
                            break;
                        case 37: //left
                            if (!isDefaultLR) {
                                ASOFT.asoftGrid.leftCell(this, name);
                                e.preventDefault();
                            }
                            break;
                        case 39://right
                            if (!isDefaultLR) {
                                ASOFT.asoftGrid.rightCell(this, name);
                                e.preventDefault();
                            }
                            break;
                            //TODO : up & down
                            /*case 38:
                                ASOFT.asoftGrid.upCell(this, name);
                                e.preventDefault();
                            return false;
                            case 40:
                                ASOFT.asoftGrid.downCell(this, name);
                                e.preventDefault();
                            return false;*/
                        default:
                            break;
                    }
                }
            }// end if

        });

        //Set timeout for session
        var sessionTimeout = $('#sessionTimeout').val();
        ASOFT.helper.sessionTimeOut(sessionTimeout);
    };

    //remove validate
    this.editGridRemmoveValidate = function (grid) {
        $(grid.tbody).find('td').removeClass('asf-focus-input-error');
    };

    // validate
    // grid: lưới cần validate
    // notRequiredFields: Danh sách các cột không bắt buộc nhập
    // checkFunction: 
    this.editGridValidate = function (grid, notRequiredFields, checkFunction) {
        var columns = grid.columns;
        var data = grid.dataSource.data();
        var isError = false;
        $(grid.tbody).find('td').removeClass('asf-focus-input-error');
        $(grid.tbody).find("td").each(function (index, element) {
            var rowIndex = $(element).parent().index();
            var cellIndex = $(element).index();

            var editor = columns[cellIndex].editor;
            if (editor != undefined) {
                var column = columns[cellIndex];
                if ($.inArray(column.field, notRequiredFields) == -1 && ASOFT.asoftGrid.checkEditCell(column, column.field)) {
                    var row = data[rowIndex];
                    var value = row[column.field];
                    if (value === null || value === '') {
                        isError = true;
                        $(element).addClass('asf-focus-input-error');
                    } else {
                        //refresh grid master
                        if (checkFunction
                            && typeof (checkFunction) === "function") {
                            //raise event
                            checkFunction(row, column.field, $(element), rowIndex, cellIndex, value);
                        }
                    }
                }// end check edit
            }// end if

        });

        return isError;
    };

    this.editGridValidateNoEdit = function (grid, notRequiredFields, checkFunction) {
        var columns = grid.columns;
        var data = grid.dataSource.data();
        var isError = false;
        $(grid.tbody).find('td').removeClass('asf-focus-input-error');
        $(grid.tbody).find("td").each(function (index, element) {
            var rowIndex = $(element).parent().index();
            var cellIndex = $(element).index();

            var editor = columns[cellIndex].editor;
            if (editor != undefined) {
                var column = columns[cellIndex];
                if ($.inArray(column.field, notRequiredFields) == -1 && column.field != "") {
                    var row = data[rowIndex];
                    var value = row[column.field];
                    if (value === null || value === '' || value === undefined) {
                        isError = true;
                        $(element).addClass('asf-focus-input-error');
                    } else {
                        //refresh grid master
                        if (checkFunction
                            && typeof (checkFunction) === "function") {
                            //raise event
                            checkFunction(row, column.field, $(element), rowIndex, cellIndex, value);
                        }
                    }
                }// end check edit
            }// end if

        });

        return isError;
    };

    // validate
    // grid: lưới cần validate
    // notRequiredFields: Danh sách các cột không bắt buộc nhập
    // checkFunction: 
    this.borderGridValidate = function (grid, notRequiredFields, checkFunction) {
        var columns = grid.columns;
        var data = grid.dataSource.data();
        var isError = false;
        $(grid.tbody).find('td').removeClass('asf-focus-input-error');
        $(grid.tbody).find("td").each(function (index, element) {
            var rowIndex = $(element).parent().index();
            var cellIndex = $(element).index();
            var row = data[rowIndex];
            var column = columns[cellIndex];
            var value = row[column.field];
            //refresh grid master
            if (checkFunction
                && typeof (checkFunction) === "function") {
                //raise event
                checkFunction(row, column.field, $(element), rowIndex, cellIndex, value);
                isError = true;
            }
        });
        return isError;
    };

    //Hàm databind cho lưới edit
    this.dataBoundGridEdit = function (e) {
        if (e != undefined) {
            e.sender.table.unbind('keydown');
            e.sender.table.unbind('keypress');
        }
    };

    //bỏ sự kiện tab của windown khi đang Focus vào lưới
    this.removeEventKeyTab = function (gridobject) {

        if (gridobject != undefined) {
            $(gridobject.tbody).on('focusin', 'td', function (e) {
                window.onkeydown = function (e) {
                    if (e.keyCode == 9) {
                        return false;
                    }

                };
                //Bỏ sự kiện keydown của numberictextbox
                var ntb = $(gridobject.tbody).find('input[data-role=""numerictextbox""]').data('kendoNumericTextBox');
                if (ntb != undefined) {
                    ntb.element.unbind('keydown');
                    ntb.element.on('keydown', function (e) {
                        return ((e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 96 && e.keyCode <= 105) || e.keyCode == 8 || e.keyCode == 46
                                || e.keyCode == 37 || e.keyCode == 39)
                    });
                }
            }).focusout(function () {
                window.onkeydown = function (e) {
                    return true;
                };
            });
        }
    };

    this.grid_Save = function (e) {
        if (e.values == null) {
            return true;
        }
        var combo;
        var cboInventoryIDModel = e.model;
        //Business
        if (e.values) {
            if (combo = $(e.container.find("#CboInventoryName")[0]).data('kendoComboBox')) {
                var currentlySelectedValue = combo.value();
                var data = combo.dataSource.data();
                cboInventoryIDModel = combo.dataItem();
                log(cboInventoryIDModel);
                if (cboInventoryIDModel) {
                    var i = 0, item, inList = false;
                    for (; item = data[i++];) {
                        if (currentlySelectedValue === item.InventoryID) {
                            inList = true;
                        }
                    }
                    //log(inList);
                    if (inList) {
                        e.model.set("InventoryID", currentlySelectedValue);
                        e.model.set("InventoryName", cboInventoryIDModel.InventoryName);
                        e.model.set("InventoryTypeID", cboInventoryIDModel.InventoryTypeID);
                        e.model.set("UnitName", cboInventoryIDModel.UnitName);
                        e.model.set("UnitID", cboInventoryIDModel.UnitID);
                        e.model.set("UnitName", cboInventoryIDModel.UnitName);
                        e.model.set("WareHouseID", cboInventoryIDModel.WareHouseID);
                        e.model.set("WareHouseName", cboInventoryIDModel.WareHouseName);
                        e.model.set("UnitName", cboInventoryIDModel.UnitName);
                        e.model.set("ShipQuantity", cboInventoryIDModel.ShipQuantity);
                    } else {
                        e.model.set("InventoryID", '');
                    }
                } else {
                    e.model.set("InventoryID", '');
                    combo.value('');
                    currentlySelectedValue = '';
                }
            }
        }
    }
};

ASOFT.asoftTab = new function () {
    this.tabActivate = function (e) {
        var widgetElement = $(e.contentElement).find(kendo.format('[data-role]'));
        $.each(widgetElement, function () {
            if ($(this).attr('data-role').indexOf('grid') >= 0) {
                var widgetObject = kendo.widgetInstance($(this));

                if (widgetObject !== undefined) {
                    ASOFT.asoftGrid.calculateGridContentHeight(widgetObject);
                }
            }
        });
    }
};

ASOFT.asoftMultiSelect = new function () {
    this.DataBound = function (e) {
        if (typeof e.sender.element.attr('listWidth') != 'undefined') {
            dataWidth = e.sender.element.attr('listWidth');
        }

        if (e.sender.options.itemTemplate.length != 0) {
            // Set widths to the new values
            e.sender.list.width(dataWidth);
        }
    }
}

//Create validator - each form have a validate
function createValidator(formID) {
    var formSector = '#' + formID;

    var validator = $(formSector).kendoValidator({
        errorTemplate: "",
        //errorTemplate: "<span><a class='k-icon k-warning' title='#=message#'></a></span>",
        validateOnBlur: false,
        rules: { // custom rules
            radio: function (input) {
                if (input.filter("[type=radio]").length > 0 && input.attr("data-val-required")) {
                    return $(formSector).find("[name=" + input.attr("name") + "]").is(":checked");
                }
                return true;
            },
            mvcdate: function (input) {
                var dp = input.data("kendoDatePicker") || input.data("kendoDateTimePicker");
                if (dp != undefined) {
                    value = input.val();
                    var result = false;
                    try {
                        var t = kendo.parseDate(value, 'dd/MM/yyyy', 'vi-VN');
                        if (t != null
                            || (value == null || value == '')) {
                            return true;
                        }
                        result = false;
                    } catch (err) {
                        result = false;
                    }
                    return result;
                }

                return true;
            },
            mvcregex: function (input) {
                //check for the rule attribute
                if (input.filter("[data-val-regex]").length && input.val()) {
                    var regex = new RegExp(input.attr("data-val-regex-pattern"));
                    return regex.test(input.val());
                }
                return true;
            },

            //TODO:Rules check confirm password/equal value
            equalto: function (input) {
                if (input.filter("[data-val-equalto-other]").length) {
                    var otherField = input.attr("data-val-equalto-other");
                    otherField = otherField.substr(otherField.lastIndexOf(".") + 1);
                    return input.val() == $("#" + otherField).val();
                }
                return true;
            }
        },
        messages: {
            radio: function (input) {
                var id = $(input).attr('id');
                return ASOFT.helper.getLabelText(id, "ASML000082");
            },
            mvcrequired: function (input) {
                var id = $(input).attr('id');
                return ASOFT.helper.getLabelText(id, "00ML000039");
            },
            mvcdate: function (input) {
                var id = $(input).attr('id');
                return ASOFT.helper.getLabelText(id, "00ML000038");
            },
            mvcregex: function (input) {
                var id = $(input).attr('id');
                var messageID = input.attr("data-val-regex");
                return ASOFT.helper.getLabelText(id, messageID);
            },
            mvclength: function (input) {
            },
            mvcmax: function (input) {
            },
            mvcmin: function (input) {
            },
            mvcnumber: function (input) {
            },
            mvcrange: function (input) {
            },

            //TODO: Check confirm password/equal value
            equalto: function (input) {
                //Get id của các trường cần so sánh
                var id = $(input).attr('id');
                var otherField = $(input).attr("data-val-equalto-other");

                //Get caption của label input
                var sSectorField = "label[for|='{0}']".f(id);
                var sNameField = $(sSectorField).text();
                var sSectorOtherField = "label[for|='{0}']".f(otherField.substr(otherField.lastIndexOf(".") + 1));
                var sNameOtherField = $(sSectorOtherField).text();

                //Get message
                var sMessage = ASOFT.helper.getMessage('00ML000086').f(sNameField, sNameOtherField);

                return sMessage;
            }
        }
    }).data("kendoValidator");

    ASOFT.form.setValidator(validator);
    return validator;
}

///////////////////////////// AsoftPostData/////////////////////////////
ASOFT.helper = new function () {

    this.defaultErrorMessage = "Có lỗi trong quá trình xử lý. Vui lòng thực hiện lại thao tác.";

    this.sessionTimeOut = function (sessionTimeOut) {
        var timeStart = new Date();
        var timeOut = new Date(timeStart.getFullYear(), timeStart.getMonth(), timeStart.getDate(), timeStart.getHours(),
                    (timeStart.getMinutes() + parseInt(timeOut)));
        if (sessionTimeOut != undefined) {
            setInterval(function () {
                window.location.reload(true);
                //var now = new Date();
                //if ((timeOut.getMinutes() - now.getMinutes()) <= 0) {
                //    //alert('Session timeout');
                //    window.location.reload();
                //}
            }, (sessionTimeOut * 60 * 1000));
        }
    }

    this.registerFunction = function (name) {
        delegateFunction = name;
    };

    this.setObjectData = function (data) {
        objectData = data;
    };

    this.getObjectData = function () {
        return objectData;
    };

    //Lấy message id
    this.getMessage = function (id) {
        if (AsoftMessage != undefined && AsoftMessage[id] != undefined) {
            return AsoftMessage[id];
        }
        //For debug
        return kendo.format('Chưa khai báo message Id [{0}].', id);
    };

    //Lấy message id
    this.getLabelText = function (id, messageId) {
        var sSector = "label[for|='{0}']".f(id);
        //var sName = $(sSector).html();
        var sName = $(sSector).text();
        if (sName != null) {
            sMessage = this.getMessage(messageId).f(sName);
        } else {
            sMessage = this.getMessage(messageId);
        }
        //For debug
        return sMessage;
    };

    // Hiển thị thông tin ra console để debug
    this.debug = function (data) {
        //console.debug(data);
        return this;
    };



    // Lấy dữ liệu dùng để post về server, loại ra các dữ liệu không thiết.
    this.getFormData = function (includeListName, formID) {
        var temp = null;
        if (formID != null && formID != undefined) {
            temp = $("form#" + formID).serializeArray();
        } else {
            temp = $("form").serializeArray();
        }

        var data = [];
        var item = null;
        for (var i = 0; i < temp.length; i++) {
            item = temp[i];

            if (!item.name || !item.name.indexOf)
                continue;

            if (item.name.indexOf('_input') >= 0)
                continue;

            if (item.name.indexOf('[') >= 0) {
                // Nếu không có 
                if (includeListName == null) continue;
                // Trường hợp chỉ có 1 lưới
                if (typeof includeListName === 'string') {
                    if (item.name.indexOf(includeListName) != 0)
                        continue;
                }
                    // Trường hợp có nhiều lưới, phải truyền vào danh sách
                else if (Object.prototype.toString.call(includeListName) === '[object Array]') {
                    var found = false;
                    for (var j = 0; j < includeListName.length; j++) {
                        if (typeof includeListName[j] === 'string'
                            && item.name.indexOf(includeListName[j]) == 0) {
                            found = true;
                            break;
                        }
                    }
                    // Nếu không phải item trên lưới thì bỏ qua
                    if (!found) continue;
                }
            }

            data.push(item);
        }

        return data;
    };

    // Convert data sang json khi có post lưới
    this.dataFormToJSON = function (formID, listName, grid) {
        var temp = null;
        var data = {};
        if (formID != null && formID != undefined) {
            temp = $("form#" + formID).serializeArray();
        } else {
            temp = $("form").serializeArray();
        }

        $.each(temp, function () {
            if (data[this.name]) {
                if (!data[this.name].push) {
                    data[this.name] = [data[this.name]];
                }
                data[this.name].push(this.value || ''); //displayInfo
            } else {
                data[this.name] = this.value || '';
            }
        });

        if (listName !== undefined && grid !== undefined && grid !== null) {
            data[listName] = grid.dataSource.data();
        }
        return data;
    };

    // Thay cho hàm $.post, thêm xử lý lỗi mặc định.
    // Hiển thị thông báo báo khi có exception
    // 'Có lỗi trong quá trình xử lý. Vui lòng thực hiện lại thao tác.'
    this.post = function (url, data, success, error) {
        var sessionTimeout = null;
        //if (window.frameElement) {
        //    window.parent.ASOFT.asoftLoadingPanel.show();
        //}
        //else {
        //    ASOFT.asoftLoadingPanel.show();
        //}
        ASOFT.asoftLoadingPanel.show();

        // Hàm xử lý lỗi mặc định cho post
        error = error || this.defaultErrorHandler;

        $.ajax({
            type: "POST",
            url: url,
            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
            data: data,
            async: false,
            success: function (result) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    success(result);

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();
                if (error && typeof (error) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };

    // Thay cho hàm $.post, thêm xử lý lỗi mặc định.
    // Hiển thị thông báo báo khi có exception
    // 'Có lỗi trong quá trình xử lý. Vui lòng thực hiện lại thao tác.'
    //them beforeSend cho ajax 
    this.postXR = function (url, data, success, error) {
        var sessionTimeout = null;

        // Hàm xử lý lỗi mặc định cho post
        error = error || this.defaultErrorHandler;

        $.ajax({
            type: "POST",
            url: url,
            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
            data: data,
            //async: false,
            beforeSend: function (xhr) {
                ASOFT.asoftLoadingPanel.show();
            },
            success: function (result) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    success(result);

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();
                if (error && typeof (error) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };

    //Cho màn hình Khóa sổ kỳ kế toán- CloseOpenBook
    // Thay cho hàm $.post, thêm xử lý lỗi mặc định.
    // Hiển thị thông báo báo khi có exception
    // 'Có lỗi trong quá trình xử lý. Vui lòng thực hiện lại thao tác.'
    this.postOpenCloseBook = function (url, data, success, error) {
        var sessionTimeout = null;
        // Hàm xử lý lỗi mặc định cho post
        error = error || this.defaultErrorHandler;

        $.ajax({
            type: "POST",
            url: url,
            contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
            data: data,
            //async: false,
            beforeSend: function (xhr) {
                kendo.ui.progress($('div .form-content'), true);
            },
            success: function (result) {
                if (success && typeof (success) === "function") {
                    success(result);

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                if (error && typeof (error) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };

    // Thay cho hàm $.post, thêm xử lý lỗi mặc định.
    // Hiển thị thông báo báo khi có exception
    // 'Có lỗi trong quá trình xử lý. Vui lòng thực hiện lại thao tác.'
    // [ Created ] - Văn Tài - 05/01/2017
    this.postGetLargeJson = function (url, data, success, error) {
        var sessionTimeout = null;
        //ASOFT.asoftLoadingPanel.show();
        // Hàm xử lý lỗi mặc định cho post
        error = error || this.defaultErrorHandler;
        data = JSON.stringify(data);
        $.ajax({
            type: "POST",
            url: url,
            contentType: 'application/json; charset=utf-8',
            data: data,
            async: true,
            success: function (result) {
                //ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    success(result);
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };

    // Thay cho hàm $.post, thêm xử lý lỗi mặc định.
    // Hiển thị thông báo báo khi có exception
    // 'Có lỗi trong quá trình xử lý. Vui lòng thực hiện lại thao tác.'
    this.postTypeJson = function (url, data, success, error) {
        if (typeof heartBeat === "function") {
            var isSessionEnd = heartBeat();
            if (isSessionEnd)
                return;
        }
        else {
            if (typeof parent.heartBeat === "function") {
                var isSessionEnd = parent.heartBeat();
                if (isSessionEnd)
                    return;
            }
        }

        var sessionTimeout = null;
        ASOFT.asoftLoadingPanel.show();
        // Hàm xử lý lỗi mặc định cho post
        error = error || this.defaultErrorHandler;
        data = JSON.stringify(data);

        $.ajax({
            type: "POST",
            url: url,
            contentType: 'application/json; charset=utf-8',
            data: data,
            async: false,
            success: function (result) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    success(result);
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };

    //thêm xử lý lỗi mặc định. Xử lý cho framework động
    this.postTypeJson1 = function (url, column, value, success, error) {
        if (typeof heartBeat === "function") {
            var isSessionEnd = heartBeat();
            if (isSessionEnd)
                return false;
        }
        else {
            if (typeof parent.heartBeat === "function") {
                var isSessionEnd = parent.heartBeat();
                if (isSessionEnd)
                    return false;
            }
        }

        var sessionTimeout = null;
        ASOFT.asoftLoadingPanel.show();
        error = error || this.defaultErrorHandler;

        error = error || this.defaultErrorHandler;

        $.ajax({
            type: "POST",
            url: url,
            data: { dt: value, cl: column },
            traditional: true,
            dataType: "json",
            async: false,
            success: function (result) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    success(result);
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };


    this.postTypeJson3 = function (url, dtValue, success, error) {
        if (typeof heartBeat === "function") {
            var isSessionEnd = heartBeat();
            if (isSessionEnd)
                return false;
        }
        else {
            if (typeof parent.heartBeat === "function") {
                var isSessionEnd = parent.heartBeat();
                if (isSessionEnd)
                    return false;
            }
        }

        var sessionTimeout = null;
        ASOFT.asoftLoadingPanel.show();
        error = error || this.defaultErrorHandler;

        error = error || this.defaultErrorHandler;

        $.ajax({
            type: "POST",
            url: url,
            data: dtValue,
            traditional: true,
            dataType: "json",
            async: false,
            success: function (result) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    success(result);
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };

    // Thay cho hàm $.post, thêm xử lý lỗi mặc định.
    // Hiển thị thông báo báo khi có exception
    // 'Có lỗi trong quá trình xử lý. Vui lòng thực hiện lại thao tác.'
    //them beforeSend cho ajax 
    this.postTypeJsonXR = function (url, data, success, error) {
        var sessionTimeout = null;

        // Hàm xử lý lỗi mặc định cho post
        error = error || this.defaultErrorHandler;
        data = JSON.stringify(data);

        $.ajax({
            type: "POST",
            url: url,
            contentType: 'application/json; charset=utf-8',
            data: data,
            //async: true,
            beforeSend: function (xhr) {
                ASOFT.asoftLoadingPanel.show();
            },
            success: function (result) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    success(result);
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };

    this.postTypeJsonComboBox = function (url, data, combo, success, error) {
        if (typeof heartBeat === "function") {
            var isSessionEnd = heartBeat();
            if (isSessionEnd)
                return false;
        }
        else {
            if (typeof parent.heartBeat === "function") {
                var isSessionEnd = parent.heartBeat();
                if (isSessionEnd)
                    return false;
            }
        }

        var sessionTimeout = null;
        ASOFT.asoftLoadingPanel.show();

        // Hàm xử lý lỗi mặc định cho post
        error = error || this.defaultErrorHandler;
        data = JSON.stringify(data);

        $.ajax({
            type: "POST",
            url: url,
            contentType: 'application/json; charset=utf-8',
            data: data,
            async: false,
            success: function (result) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    success(result, combo);
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    }


    //thêm xử lý lỗi mặc định. Xử lý cho framework động
    //thực hiện cho truyền dữ liệu cho popup masterdetail
    this.postTypeJson2 = function (url, column, value, detail, success, error) {
        if (typeof heartBeat === "function") {
            var isSessionEnd = heartBeat();
            if (isSessionEnd)
                return false;
        }
        else {
            if (typeof parent.heartBeat === "function") {
                var isSessionEnd = parent.heartBeat();
                if (isSessionEnd)
                    return false;
            }
        }

        var sessionTimeout = null;
        ASOFT.asoftLoadingPanel.show();

        error = error || this.defaultErrorHandler;

        $.ajax({
            type: "POST",
            url: url,
            data: { dt: value, cl: column, grid: detail },
            traditional: true,
            dataType: "json",
            success: function (result) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {

                    //Set timeout for session
                    sessionTimeout = $('#sessionTimeout').val();
                    success(result);
                    ASOFT.helper.sessionTimeOut(sessionTimeout);
                }
            },
            error: function (xhr, status, exception) {
                ASOFT.asoftLoadingPanel.hide();

                if (success && typeof (success) === "function") {
                    error(xhr, status, exception);
                }
            }
        });
    };

    // Thay cho hàm $.post, thêm xử lý lỗi mặc định.
    // Hiển thị thông báo báo khi có exception
    // 'Có lỗi trong quá trình xử lý. Vui lòng thực hiện lại thao tác.'
    this.postMultiForm = function (url, formID, success, error) {
        if (typeof heartBeat === "function") {
            var isSessionEnd = heartBeat();
            if (isSessionEnd)
                return false;
        }
        else {
            if (typeof parent.heartBeat === "function") {
                var isSessionEnd = parent.heartBeat();
                if (isSessionEnd)
                    return false;
            }
        }


        ASOFT.asoftLoadingPanel.show();
        // Hàm xử lý lỗi mặc định cho post
        error = error || this.defaultErrorHandler;

        $('form#' + formID).submit(function (e) {
            var formData = new FormData(this);
            $.ajax({
                type: "POST",
                url: url,
                data: formData,
                mimeType: "multipart/form-data",
                contentType: false,
                cache: false,
                processData: false,
                success: function (result) {
                    ASOFT.asoftLoadingPanel.hide();
                    if (success && typeof (success) === "function") {
                        success(result);

                        //Set timeout for session
                        var sessionTimeout = $('#sessionTimeout').val();
                        ASOFT.helper.sessionTimeOut(sessionTimeout);
                    }
                },
                error: function (xhr, status, exception) {
                    ASOFT.asoftLoadingPanel.hide();
                    if (error && typeof (error) === "function") {
                        error(xhr, status, exception);
                    }
                }
            });

            e.preventDefault(); //Prevent Default action. 
            $('form#' + formID).unbind('submit');
        });
        $('form#' + formID).submit();
    };

    //Xử lý hiển thị message từ server trả về
    this.showErrorSever = function (result, formID) {
        var message = null;
        if (formID != undefined) { //Hiển thị message trên popup
            if (result.Message == null || result.Message == '')
                message = [ASOFT.helper.getMessage('00ML000062' /*'A00ML000005'*/)];
            else {
                message = [ASOFT.helper.getMessage(result.Message)];
                if (result.Data != null) {
                    message = [ASOFT.helper.getMessage(result.Message).f(result.Data)];
                }
            }
            ASOFT.form.displayMessageBox("#" + formID, message, null);
        }
        else {//Hiển thị message trên asoft dialog
            if (typeof result === 'object') {
                if (result.Message == null || result.Message == '') {
                    message = ASOFT.helper.getMessage("MFML000008");
                }
                else {
                    message = ASOFT.helper.getMessage(result.Message).f(result.Data);
                }
            }
            else {
                message = result;
            }
            ASOFT.dialog.messageDialog(message);
        }
    };

    /**
   * Xử lý hiển thị message từ server trả về
   * Lấy dữ liệu từ localStorage
   */
    this.showErrorSeverOptionFromRedirecting = function () {
        if (window.localStorage) {
            // Get cache values
            var message = window.localStorage.getItem("messageSuccess");
            var elementId = window.localStorage.getItem("displayAtElement");

            if (message != null && elementId != null) {
                if (message instanceof Array) {
                    if (message.length > 0 && elementId != "") {
                        ASOFT.form.displayMultiMessageBox(elementId, 0, message);
                    }
                } else {
                    if (message != "" && elementId != "") {
                        ASOFT.form.displayMultiMessageBox(elementId, 0, [message]);
                    }
                }

                // Remove cache
                window.localStorage.removeItem("messageSuccess");
                window.localStorage.removeItem("displayAtElement");
            }
        }
    };

    /**
    * Format Url với object data parameters
    *---------------------------------------
    * Trả về string url cho phương thức GET
    */
    this.renderUrl = function (url, obj) {
        var strUrl = "";

        //[1] Format object vs pair key|value
        if (typeof obj === "object" && obj != null) {
            $.each(obj, function (key, val) {
                strUrl += "&{0}={1}".f(key, val);
            });
        }

        //[2] Return Url string
        return url + "?" + strUrl.substr(1, strUrl.length);
    };

    this.convertToArray = function (obj) {
        var blkstr = [];
        if (typeof obj === "object") { // Object
            if (obj instanceof Array) { // Array: ["value1", "value2", value3]
                blkstr = obj;
            } else { // Object with multi properties: { "key": "", "value": "" }
                if (obj != null) {
                    $.each(obj, function (index, val) {
                        blkstr.push(val);
                    });
                }
            }
        } else if (obj) { // String, number, others: "value"/value
            blkstr.push(obj);
        } else {
            //undefined
            return null;
        }

        return blkstr;
    };

    // format string with an array pass arguments
    this.formatForArguments = function (str, obj) {
        return str.replace(/\{\s*([^}\s]+)\s*\}/g, function (m, p1, offset, string) {
            return obj[p1];
        });
    };

    /**
    * Xử lý hiển thị message từ server trả về
    * -------------------------------------------------
    * params [type: 0:Saving action, 1:Deleting action]
    * params [result: jsonResult]
    * params [formId: formId]
    * params [funcSuccess: function success]
    * params [funcError: function error]
    * params [funcWarning: function warning]
    * params [displaySuccessMessage: Có hiển thị message thông báo thành công hay không. true: có | false: không]
    * params [showSuccessOnRedirected: Có lưu message thông báo thành công hay không. true: có | false: không. Phụ thuộc vào displaySuccessMessage]
    * params [displayMessageAtElement: Vị trí hiển thị message thông báo thành công]
    * -------------------------------------------------
    * Các message thông báo lỗi và cảnh báo sẽ hiển thị inline
    */
    this.showErrorSeverOption = function (type, result, formId, funcSuccess, funcError, funcWarning,
        displaySuccessMessage, showSuccessOnRedirected, displayMessageAtElement) {

        var messageSaveSuccess = ASOFT.helper.getMessage('00ML000015'); // Dữ liệu đã lưu thành công.
        var messageDeleteSuccess = ASOFT.helper.getMessage('00ML000057'); // Xóa thành công
        var messageSaveFailure = ASOFT.helper.getMessage('00ML000062' /*'A00ML000005'*/); // Lưu không thành công
        var messageDeleteFailure = ASOFT.helper.getMessage('00ML000063' /*'A00ML000006'*/); // Xóa không thành công

        var formatAlias = function (message, params) {
            return ASOFT.helper.formatForArguments(ASOFT.helper.getMessage(message), ASOFT.helper.convertToArray(params));
        };

        if (result !== undefined && typeof result === "object") { // Nếu tồn tại Object Result
            if (result instanceof Array) { // Nếu kết quả trả về là danh sách lỗi List<ErrorMsgModel>
                if (result.length > 0) // Nếu danh sách có dữ liệu, có xảy ra lỗi
                {
                    // Array Items [{ "Status": "1", "MessageID": "value", "Params": "value" }]
                    // Lấy danh sách message tương ứng và thêm vào message hiện tại
                    var msgWarning = [];
                    var msgError = [];
                    var msgSuccess = [];

                    // Lấy danh sách message
                    $.each(result, function (key, value) {
                        if (value.Status == 0) { // message thành công
                            if (value.MessageID == null || value.MessageID == "") {
                                if (type == 0) {
                                    msgSuccess.push(messageSaveSuccess);
                                } else {
                                    msgSuccess.push(messageDeleteSuccess);
                                }
                            }
                            else {
                                msgSuccess.push(formatAlias(value.MessageID, value.Params));
                            }
                        }
                        if (value.Status == 1) { // message lỗi
                            if (value.MessageID == null || value.MessageID == "") {
                                if (type == 0) {
                                    msgSuccess.push(messageSaveFailure);
                                } else {
                                    msgSuccess.push(messageDeleteFailure);
                                }
                            }
                            msgError.push(formatAlias(value.MessageID, value.Params));
                        }
                        if (value.Status == 2) { // message cảnh báo
                            msgWarning.push(formatAlias(value.MessageID, value.Params));
                        }

                    });
                    if (displaySuccessMessage) {
                        // Hiển thị message
                        if (showSuccessOnRedirected) {
                            ASOFT.helper.saveLocalStorage(msgSuccess, displayMessageAtElement);
                        } else {
                            if (msgSuccess.length > 0) { // hiển thị message cảnh báo
                                ASOFT.form.displayMultiMessageBox(formId, 0, msgSuccess);

                            }
                        }
                    }
                    if (msgSuccess.length > 0) {
                        if (funcSuccess instanceof Function) { // apply hàm xử lý thành công
                            funcSuccess.apply();
                        }
                    }

                    if (msgError.length > 0) { // hiển thị message lỗi
                        ASOFT.form.displayMultiMessageBox(formId, 1, msgError); // apply hàm xử lý lỗi
                        if (funcError instanceof Function) {
                            funcError.apply();
                        }
                    }

                    if (msgWarning.length > 0) { // hiển thị message cảnh báo
                        ASOFT.form.displayMultiMessageBox(formId, 2, msgWarning); // apply hàm xử lý cảnh báo
                        if (funcWarning instanceof Function) {
                            funcWarning.apply();
                        }
                    }
                } else { // Danh sách rỗng [Length = 0]
                    if (displaySuccessMessage) {
                        if (type == 0) {
                            if (showSuccessOnRedirected) {
                                ASOFT.helper.saveLocalStorage([messageSaveSuccess], displayMessageAtElement);
                            } else {
                                ASOFT.form.displayMultiMessageBox(formId, 0, [messageSaveSuccess]);
                            }
                        } else {
                            if (showSuccessOnRedirected) {
                                ASOFT.helper.saveLocalStorage([messageDeleteSuccess], displayMessageAtElement);
                            } else {
                                ASOFT.form.displayMultiMessageBox(formId, 0, [messageDeleteSuccess]);
                            }
                        }
                    }

                    if (funcSuccess instanceof Function) { // apply hàm xử lý thành công
                        funcSuccess.apply();
                    }
                }
            } else { // Kết quả là object đơn ErrorMsgModel
                if (result != null) // Object { "Status": 0, "Message": "string", "Data": "Object" }
                {
                    // Ưu tiên sử dụng messageId và params theo format mới
                    if (result.MessageID) { // tồn tại messageId
                        result.Message = result.MessageID;
                    }
                    if (result.Params) { // tồn tại params
                        result.Data = result.Params;
                    }

                    switch (result.Status) {
                        case 0:
                            if (displaySuccessMessage) {
                                // Hiển thị message thành công
                                if (result.Message == null || result.Message == "") {
                                    if (type == 0) {
                                        if (showSuccessOnRedirected) {
                                            ASOFT.helper.saveLocalStorage([messageSaveSuccess], displayMessageAtElement);
                                        } else {
                                            ASOFT.form.displayMultiMessageBox(formId, 0, [messageSaveSuccess]);
                                        }
                                    } else {
                                        if (showSuccessOnRedirected) {
                                            ASOFT.helper.saveLocalStorage([messageDeleteSuccess], displayMessageAtElement);
                                        } else {
                                            ASOFT.form.displayMultiMessageBox(formId, 0, [messageDeleteSuccess]);
                                        }
                                    }
                                } else {
                                    ASOFT.form.displayMultiMessageBox(formId, 0, [formatAlias(result.Message, result.Data)]);
                                }
                            }

                            if (funcSuccess instanceof Function) {
                                // Apply function cho xử lý ngoại lệ dữ liệu là object đơn
                                funcSuccess.apply();
                            }
                            break;
                        case 1:
                            // Hiển thị message lỗi
                            if (result.Message == null || result.Message == "") {
                                if (type == 0) {
                                    ASOFT.form.displayMultiMessageBox(formId, 1, [messageSaveFailure]); // Message chung A00 [Lưu không thành công]
                                } else {
                                    ASOFT.form.displayMultiMessageBox(formId, 1, [messageDeleteFailure]); // Message chung A00 [Xóa không thành công]
                                }
                            } else {
                                ASOFT.form.displayMultiMessageBox(formId, 1, [formatAlias(result.Message, result.Data)]);
                            }

                            if (funcError instanceof Function) {
                                // Apply function cho xử lý ngoại lệ dữ liệu là object đơn
                                funcError.apply();
                            }
                            break;
                        case 2:
                            // Hiển thị message cảnh báo
                            if (result.Message != null || result.Message != "") { // Hiển thị message custom do server trả về
                                ASOFT.form.displayMultiMessageBox(formId, 2, [formatAlias(result.Message, result.Data)]);
                            }

                            if (funcWarning instanceof Function) {
                                // Apply function cho xử lý ngoại lệ dữ liệu là object đơn
                                funcWarning.apply();
                            }
                            break;
                        default:
                            break;
                    }

                    //ASOFT.dialog.messageDialog(message);
                }
            } // end if it's a single object.
        } // end if it's not undefined and it's an object
    };

    /**
   * Xử lý lưu trữ localStorage
   * -------------------------------------------------
   * params [message: messages list]
   * params [element: elementId]
   * -------------------------------------------------
   */
    this.saveLocalStorage = function (message, element) {
        if (typeof (Storage) !== "undefined") // Browser support storage local
        {
            // Lưu giá trị vào localStorage
            window.localStorage.setItem("messageSuccess", message);
            window.localStorage.setItem("displayAtElement", element);
        }
    };

    // Xử lý lỗi mặc định
    this.defaultErrorHandler = function (xhr, textStatus, errorThrown) {
        var msg = this.defaultErrorMessage
            || ASOFT.helper.getMessage('00ML000068' /*"A00ML000014"*/);
        ASOFT.dialog.messageDialog(errorThrown);

    };

    this.replaceNameProperties = function (start, end, prop) {
        var nameProp = prop.substring(index + 1, end);
        return prop.split('[' + nameProp + ']').join('.' + nameProp);
    }

    //Set auto chiều cao 
    this.setAutoHeight = function (elementID) {
        offsetTop = elementID.offset().top;
        screenHeight = window.innerHeight - 5;

        if ((screenHeight - offsetTop) >= 250) {
            elementID.height((screenHeight - offsetTop));
        }
    }

    // Ẩn Message box khi xảy ra một sự kiện bất kỳ trên màn hình  
    // Truyền vào ID của các control, và ID của lưới
    this.initAutoClearMessageBox = function (elementIDs, gridID) {
        var grid = null;
        if (typeof gridID === 'string') {
            grid = $(gridID).data('kendoGrid');
        } else {
            grid = gridID;
            gridID = grid.element.attr('id');
        }

        // Gán sự kiện cho các nút truyền vào
        if (elementIDs && typeof elementIDs == 'object') {
            elementIDs.forEach(function (id) {
                var element = $('#' + id);
                if (element) {
                    element.on('click', function () {
                        ASOFT.form.clearMessageBox();
                        ASOFT.asoftGrid.setHeight(grid);
                    });
                }
            });
        }

        // Gán sự kiện cho các nút của thanh phân trang
        var tagAnchors = $('div[data-role="pager"] a');
        $.each(tagAnchors, function (i, anchor) {
            $(anchor).on('click', function () {
                if ($(anchor).attr('class').indexOf('k-state-disabled') == -1) {
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftGrid.setHeight(grid);
                }

            });
        });

        var pageSizes = $('select[data-role="dropdownlist"]').data("kendoDropDownList");
        if (pageSizes) {
            pageSizes.bind('change', function () {
                ASOFT.form.clearMessageBox();
                ASOFT.asoftGrid.setHeight(grid);
            });
        }
        $('.k-pager-numbers li').on('click', function () {
            ASOFT.form.clearMessageBox();
        });
        // Gán sự kiện cho các link trên grid
        var gridLinks = $(gridID + '.k-widget div.k-grid-content table.k-selectable tbody tr td a');

        $.each(gridLinks, function (i, link) {
            var element = $(link);
            if (element) {
                element.on('click', function () {
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftGrid.setHeight(grid);
                });
            }
        });
        // Gán sự kiện cho các checkbox trên grid
        var gridCheckBoxs = $(gridID + '.k-widget div.k-grid-content table.k-selectable tbody tr td input.asoftcheckbox');
        $.each(gridCheckBoxs, function (i, checkbox) {
            var element = $(checkbox);
            if (element) {
                element.on('click', function () {
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftGrid.setHeight(grid);
                });
            }
        });
    }

    //Get control KendoUI
    this.getKendoUI = function (element, control) {
        var widgetElement = $(element).find(kendo.format('[data-role]'));
        var controlList = [];
        var widgetObject = null;
        $.each(widgetElement, function () {
            if ($(this).attr('data-role').indexOf(control) >= 0) {
                widgetObject = kendo.widgetInstance($(this));
                if (window.frameElement) {
                    widgetObject = kendo.widgetInstance(window.parent.$(this));
                }

                if (widgetObject !== undefined) {
                    controlList.push({
                        name: $(widgetObject.element).attr('id'),
                        value: widgetObject
                    });
                }
            }
        });
        return controlList;
    }

    //Get all control KendoUI
    this.getAllKendoUI = function (element) {
        var widgetElement = $(element).find(kendo.format('[data-role]'));
        var controlList = [];
        var widgetObject = null;
        $.each(widgetElement, function () {
            widgetObject = kendo.widgetInstance($(this));

            if (typeof widgetObject !== 'undefined') {
                controlList.push({
                    name: $(widgetObject.element).attr('id'),
                    value: widgetObject
                });
            }
        });
        return controlList;
    }
};

//format date
ASOFT.format = new function () {
    var jsonDatePattern = /Date\(\d+\)/i;
    var jsonDateGroup = /\d+/;

    this.longDateTime = "dd/MM/yyyy HH:mm:ss tt";
    this.shortDateTime = "dd/MM/yyyy";

    // Lấy giá trị Date theo server
    this.stringToDate = function (value) {
        // Kiểm tra kiểu dữ liệu của tham số
        if (value == null || typeof value !== 'string') return null;
        // Kiểm tra chiều dài của tham số
        if (value.length < 10) return null;
        // Định dạng ngày
        var format =
            value.length == 10 ? ASOFT.format.shortDateTime :
                ASOFT.format.longDateTime;
        // Chuyển thành kiểu ngày
        var result = Date.parseExact(value, format);
        return result;
    };

    this.dateToString = function (value, format) {
        // Kiểm tra kiểu dữ liệu của tham số
        if (!(value.getMonth)) return '';
        if (format == null || typeof format !== 'string')
            format = ASOFT.format.shortDateTime;
        // Kiểm tra định dạng ngày
        if (format != ASOFT.format.longDateTime
            && format != ASOFT.format.shortDateTime) return '';
        // Chuyển thành chuỗi
        var result = value ? value.toString(format) : '';
        return result;
    };

    this.jsonToDateInList = function (list) {
        if (!list) return;
        var item = null;
        for (var i = 0; i < list.length; i++) {
            for (var property in list[i]) {
                item = list[i];
                if (typeof item[property] === 'string'
                    && item[property].match(jsonDatePattern)) {
                    item[property] = ASOFT.format.jsonToDate(item[property]);
                }
            }
        }
    };

    // /d/234534523453245/
    this.jsonToDate = function (value) {
        // Kiểm tra kiểu dữ liệu của tham số
        if (value == null || typeof value !== 'string')
            return new Date;
        // Kiểm tra 
        var match = value.match(jsonDateGroup);
        if (!match) return new Date;
        // Chuyển thành kiểu Date
        var date = new Date();
        date.setTime(match[0] - 0);
        return date;
    };

    this.trim = function (value, charater) {
        if (charater == null || typeof charater !== 'string' || charater.length != 1) {
            return value.replace(/^\s+|\s+$/g, '');
        } else {
            var regexp = new RegExp("^[" + charater + "]+|[" + charater + "]+$", 'g');
            return value.replace(regexp, '');
        }
    };

    this.numberToString = function (value, decimal) {
        if (typeof value == 'undefined' || value == null || value == NaN)
            return '';
        // Bỏ số lẻ bị thừa
        if (decimal) value = value.toFixed(decimal);
        // Định dạng phần ngàn
        var parts = value.toString().split(".");
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        return parts.join(".");
    };
};

//Environment
ASOFT.environment = new function () {
    this.moduleID = '';
    this.beginDate = new Date();
    this.endDate = new Date();
};

executeFunctionByName = function (functionName) {
    var args = Array.prototype.slice.call(arguments).splice(1);
    //debug
    //console.log('args:', args);

    var namespaces = functionName.split(".");
    //debug
    //console.log('namespaces:', namespaces);

    var func = namespaces.pop();
    //debug
    //console.log('func:', func);

    var ns = namespaces.join('.');
    //debug
    //console.log('namespace:', ns);

    if (ns == '') {
        ns = 'window';
    }

    ns = eval(ns);
    //debug
    //console.log('evaled namespace:', ns);

    return ns[func].apply(ns, args);
};

ASOFT.grid = {
    alignCenter: function (options) {
        if (!options || !options.grid || !options.colNames) {
            throw 'options not valid';
        }
        options.direction = options.direction || 'left';
        options.all = options.all || false;

        var gridFields,
            colCount,
            indicesByString = options.colNames.filter(function (item) { return typeof item === 'string' }),
            indicesByNumber = options.colNames.filter(function (item) { return typeof item === 'number' })
        ;

        if (typeof options.grid === 'string') {
            options.grid = $('#' + options.grid).data('kendoGrid');
            if (!options.grid) {
                throw 'Cannot cast jquery object to kendo grid';
            }
        }

        gridFields = options.grid.dataSource.options.fields;
        colCount = gridFields.length;

        if (!Array.isArray(options.colNames)) {
            return;
        }

        gridFields.forEach(function (f, i) {
            var selectors = [],
                selector
            ;

            if (indicesByString.indexOf(f.field) !== -1) {
                selector = 'td:nth-child({0}n+{1})'.format(colCount, i + 1);
                selectors.push(selector)
            }

            indicesByNumber.forEach(function (f, i) {
                if (f < colCount) {
                    selector = 'td:nth-child({0}n+{1})'.format(colCount, f + 1);
                    selectors.push(selector)
                }
            });

            options.grid
                .element
                .find(selectors.join())
                .removeClass('asf-cols-align-right')
                .removeClass('asf-cols-align-left')
                .addClass('asf-cols-align-center');
        });
    }
};


(function () {

}());