//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     29/11/2013      Đức Quý         Tạo mới
//#     03/01/2014      Huy Cường       Update
//####################################################################
/// <reference path='../_references.js' />

var itemMenuSelectchild = null;
var itemMenuSelectParent = null;
var indexItemLast = 0;
var indexItemFrist = 0;
var levelMenu = 0;
var close = 0;
var hideConfig = 0;
var isShowSearchMobile = false; //kiểm tra ẩn hiện search mobile
var isCheckBeenShowMobile = true;

function heartBeat() {
    ASOFT.helper.post("/ContentMaster/Login", {}, function (data) {
        if (data != false) {
            //ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000109'));
            localStorage.setItem("EndSession", "true");
            return true;
        }
    }, function () {
    });
    return false;
}

function Interval() {
    ASOFT.helper.post("/ContentMaster/Login", {}, function (data) {
    }, function () {
    })
}

$(function () {
    setInterval("Interval()", 1000 * 120);
});


$(document).ready(function () {
    window.onbeforeunload = function confirmExit() {
        heartBeat();
    }

    ProcWidthMenu(null);

    $(".k-in").click(function (e) {
        $(e.target.parentElement).find(".k-icon").trigger("click");
    })

    $(".btnSell_Mobile").click(function () {
        btnSell_Click();
    })

    $(".btnReport_Mobile").click(function () {
        btnReport_Click();
    })

    var dynamicController = new Array();
    dynamicController.push("contentmaster");
    dynamicController.push("viewnodetails");
    dynamicController.push("viewmasterdetail");
    dynamicController.push("viewmasterdetail2");
    dynamicController.push("reportlayout");
    var curController = $('#currentController').val();
    var Dynamic = false;
    for (var i = 0; i < dynamicController.length; i++) {
        if (dynamicController[i] == curController.toLowerCase()) {
            Dynamic = true;
            continue;
        }
    }
    if (Dynamic) {
        SelectDynamicItemMenu();
        CreateDynamicBreakcrumb();
    }
    else {
        SelectItemMenu();
        CreateBreakcrumb();
    }

    //if (('ontouchstart' in window || (window.DocumentTouch && document instanceof DocumentTouch))) {
        $("#contentMaster").bind('touchstart', function () {
            HideAllMenu();
        }).bind('touchend', function () {
            HideAllMenu();
        });

        $("#Header").bind('touchstart', function () {
            HideAllMenu();
        }).bind('touchend', function () {
            HideAllMenu();
        });

        $("#TopMenu").on("touchstart", 'li', function (e) {
            e.preventDefault();
            OpenMenu(this);
        }).on("touchend", 'li', function (e) {
            //OpenMenu(this);
        });

        $("#BlockMenu").on("touchstart", "li", function () {
            var taga = $(this).children('a');
            var textTagA = taga.text();
            if (taga.attr('href') == '') {
                $(this).remove('a');
                $(this).text(textTagA);
            }
            CloseWindowMenu();
            OpenMenuWin(this);
        }).on("touchmove", 'li', function () {
            CloseWindowMenu();
            //OpenMenuWin(this);
        });

        $("#MenuPopup_win").bind('touchmove', function () {
            CloseWindowMenu();
        });

        $("#Config_win").bind('touchmove', function () {
            CloseWindowMenu();
        });
    //}
    //else {
        $("#contentMaster").mouseenter(function () {
            HideAllMenu();
        });

        $("#Header").mouseenter(function () {
            HideAllMenu();
        });

        $("#TopMenu").on("mouseenter", "li", function () {
            for (var j = 3; j < $("#countLevelMenu").val() ; j++) {
                CloseWindowMenuN(j);
            }
            OpenMenu(this);
        });

        $("#BlockMenu").on("mouseenter", "li", function () {
            //var taga = $(this).children('a');
            //var textTagA = taga.text();
            //if (taga.attr('href') == '') {
            //    $(this).remove('a');
            //    $(this).text(textTagA);
            //}
            CloseWindowMenu();
            OpenMenuWin(this);
        });

        $("#MenuPopup_win").on("mouseenter", "li", function () {
            //var taga = $(this).children('a');
            //var textTagA = taga.text();
            //if (taga.attr('href') == '') {
            //    $(this).remove('a');
            //    $(this).text(textTagA);
            //}
            //CloseWindowMenuN(2);
            OpenMenuWinLevel(this);
        });

        for (var j = 3; j < $("#countLevelMenu").val() ; j++) {
            $("#MenuPopup_win" + j).on("mouseenter", "li", function () {
                //var taga = $(this).children('a');
                //var textTagA = taga.text();
                //if (taga.attr('href') == '') {
                //    $(this).remove('a');
                //    $(this).text(textTagA);
                //}
                //CloseWindowMenuN(j);
                OpenMenuWinLevel(this);
            });
            //$("#MenuPopup_win" + j).mouseleave(function () {
            //    CloseWindowMenuN(j);
            //});
        }


        $("#MenuPopup_win").mouseleave(function () {
            //CloseWindowMenuN(2);
            if (close == 0)
                CloseWindowMenu();
        });

        $("#Config_win").mouseleave(function () {
            hideConfig = 0;
            CloseWindowMenu();
        });
    //}

    $("#Menu_Mobile").on("click", function () {
        showMenu_Click(this);
    })
});

$(document).ready(jqUpdateSize);
$(window).resize(jqUpdateSize);

function jqUpdateSize() {
    // Get the dimensions of the viewport
    var width = $(window).width();
    var height = $(window).height();
    var arryTopmenu = $('#TopMenu li');
    for (var i = 0; i < arryTopmenu.length; i++) {
        arryTopmenu[i].style.display = "inline-block";
    }
    ProcWidthMenu(width);
};

//Xu ly trong truong hop menu qua dai se hien thi button cho phep scroll
function ProcWidthMenu(widthscreen) {
    //Lay chieu rong cua man hinh
    if (widthscreen == null) {
        widthscreen = $('#TopMenu_div').outerWidth();
    }
    var arryTopmenu = $('#TopMenu li');
    var totalwidth = 130;
    for (var i = 0; i < arryTopmenu.length; i++) {
        totalwidth += arryTopmenu[i].offsetWidth;
        if (totalwidth > widthscreen) {
            indexItemLast = i;
            $('#imgNext').css('display', 'inline-block');

            i = arryTopmenu.length;
        }
        else {
            $('#imgNext').css('display', 'none');
            $('#imgPrev').css('display', 'none');
            $.each(arryTopmenu, function () {
                $(this).css({ display: 'inline-block' });
            });
        }
    }

    //An cac Tiem menu vuot qua gioi han
    if (indexItemLast < arryTopmenu.length && indexItemLast != 0) {
        for (var i = indexItemLast; i < arryTopmenu.length; i++) {
            arryTopmenu[i].style.display = "none";
        }
    }
}

function DisplayItemNext() {
    //An Item Dau hien thi item ke tiep
    var arryTopmenu = $('#TopMenu li');
    arryTopmenu[indexItemFrist].style.display = "none";
    arryTopmenu[indexItemLast].style.display = "";
    indexItemFrist += 1;
    indexItemLast += 1;
    $('#imgPrev').css('display', 'block');
    $('#TopMenu').css('margin-left', 'auto');
    if (indexItemLast >= arryTopmenu.length) {
        $('#imgNext').css('display', '');
    }
}

function DisplayItemPre() {
    //An Item cuoi hien thi aitem dau
    var arryTopmenu = $('#TopMenu li');
    indexItemFrist -= 1;
    indexItemLast -= 1;
    arryTopmenu[indexItemLast].style.display = "none";
    arryTopmenu[indexItemFrist].style.display = "";
    $('#imgNext').css('display', 'block');
    if (indexItemFrist <= 0) {
        $('#imgPrev').css('display', '');
    }
}

function OpenMenu(e) {
    if (document.getElementById(e.id + "_div") == null) {
        RemoveClassSelection();
        HideAllMenuChild();
        return;
    }
    else {
        RemoveClassSelection();
        HideAllMenuChild();
        CloseWindowMenu();
        $("#" + e.id).addClass("asf-menu-selectiontop");
        $("#BlockMenu").show();
        $("#" + e.id + "_div").show();
    }
}

//Remove class da duoc chon
function RemoveClassSelection() {
    var arrayselection = $("#TopMenu .asf-menu-selectiontop");
    $.each(arrayselection, function (idenx, value) {
        $("#" + value.id).removeClass("asf-menu-selectiontop");
    });
}

//An cac menu con trong the div BlockMenu
function HideAllMenuChild() {
    var arraymenuchild = $("#BlockMenu").children();
    $.each(arraymenuchild, function (index, value) {
        $("#" + value.id).hide();
    });
}
//An cac menu dang popup
function CloseWindowMenu() {
    $("#MenuPopup_win, #Config_win").each(function () {
        $(this).data("kendoWindow").close();
    });
}

function CloseWindowMenuN(n) {
    $("#MenuPopup_win" + n + ", #Config_win").each(function () {
        $(this).data("kendoWindow").close();
    });
    $("#MenuPopup_win" + n).attr("hidden", "hidden");
}

function HideAllMenu() {
    HideAllMenuChild();
    RemoveClassSelection();

    //Hien thi lai menu da dc chon
    $("#" + itemMenuSelectParent + '_div').show();
    $("#" + itemMenuSelectParent).addClass("asf-menu-selectiontop");

}

//Xu ly Select menu
function SelectItemMenu() {
    if (typeof (listMenu) === 'undefined' || listMenu == null) return;
    if (typeof (listMenuLevel0) === 'undefined' || listMenuLevel0 == null) return;
    if (typeof (listMenuLevel1) === 'undefined' || listMenuLevel1 == null) return;
    if (typeof (listMenuLevel2) === 'undefined' || listMenuLevel2 == null) return;
    var curController = $('#currentController').val();
    var curAction = $('#currentAction').val();
    var arrayString = [];
    //Neu duyet menu cap 2 ko co thi se duyet menu cap 1
    var loopMenuLevel1 = false;
    if (listMenuLevel2.length > 0) {
        for (var i = 0; i < listMenuLevel2.length; i++) {
            var item = listMenuLevel2[i];
            if (item.Controller == curController) {
                arrayString = item.Name.split("_");
                $("#BlockMenu").show();
                $("#" + arrayString[0]).addClass('asf-menu-selectiontop');
                $("#" + arrayString[0] + "_div").show();
                $("#" + arrayString[0] + "_" + arrayString[1]).addClass("asf-menu-sub-select");
                $("#" + arrayString[0] + "_" + arrayString[1]).css('background-color', '#006EB4');
                itemMenuSelectParent = arrayString[0];
                return;
            }
            else {
                loopMenuLevel1 = true;
            }
        }
    }
    else {
        loopMenuLevel1 = true;
    }

    if (loopMenuLevel1) {
        for (var i = 0; i < listMenuLevel1.length; i++) {
            var item = listMenuLevel1[i];
            if (item.Controller == curController) {
                arrayString = item.Name.split("_");
                $("#BlockMenu").show();
                $("#" + arrayString[0]).addClass('asf-menu-selectiontop');
                $("#" + arrayString[0] + "_div").show();
                $("#" + arrayString[0] + "_" + arrayString[1]).addClass("asf-menu-sub-select");
                $("#" + arrayString[0] + "_" + arrayString[1]).css('background-color', '#006EB4');
                itemMenuSelectParent = arrayString[0];
                return;
            }
        }
    }
}

//Ẩn toàn bộ các thẻ div của popupmenu
function HideAllElemntMenuWin() {
    var arraychild = $('#MenuPopup_win').children('div');
    //for (var i = 0; i < arraychild.length; i++) {
    //    $(arraychild[i]).hide();
    //}
    $.each(arraychild, function (index, value) {
        $("#" + value.id).hide();
    });
}

function HideAllElemntMenuWinN(i) {
    var arraychild = $('#MenuPopup_win' + (i + 1)).children('div');
    //for (var i = 0; i < arraychild.length; i++) {
    //    $(arraychild[i]).hide();
    //}
    $.each(arraychild, function (index, value) {
        $("#" + value.id).hide();
    });
}

//Kiểm tra item menu cấp 1 có link ko
//Nếu có không hiển thị popup
function CheckItemMenu(id) {
    var a = $('#' + id + ' a');
    if (a == undefined) {
        return false;
    }
    else {
        //var link = a.attr('href');
        //if (link != undefined) {
        //return true;
        //}
        //else {
        //return false;
        //}
        return true;
    }
}

//Selected menu level 2
function SelectedMenuLevel2(id) {
    var idmenulevel2 = $('#currMenuLevel2').val();
    if (idmenulevel2 == undefined || idmenulevel2 == "") {
        return;
    }
    var item = $('#' + id + '_div').find('#' + idmenulevel2);
    var chilitem = item.children().first();
    item.css('background-color', '#006EB4');
    chilitem.css('color', '#fff');
}

function SelectedMenuLevelN(name, level, idz) {
    var idmenulevelN = name + "-" + level
    var id = '#' + idz + '_Level' + (level - 1);
    if (level == 2) {
        idmenulevelN = name;
        id = '#' + idz + '_div';
    }
    var item = $(id).find('#' + idmenulevelN);
    var chilitem = item.children().first();
    item.css('background-color', '#006EB4');
    chilitem.css('color', '#fff');
}


//function SelectedMenuLevelN(id) {
//    var idmenulevel2 = $('#currMenuLevel2').val();
//    if (idmenulevel2 == undefined || idmenulevel2 == "") {
//        return;
//    }
//    var item = $('#' + id + '_div').find('#' + idmenulevel2);
//    var chilitem = item.children().first();
//    item.css('background-color', '#006EB4');
//    chilitem.css('color', '#fff');
//}

//Mo dialog 
function OpenMenuWin(e) {
    var top = e.offsetTop + e.offsetHeight;
    var left = e.offsetLeft;
    var id = e.id;
    //if (CheckItemMenu(id)) return;
    var dialog = $("#MenuPopup_win").data("kendoWindow");
    if (typeof (dialog) === 'undefined') return;
    //truoc khi hien thi popup chay ham HideAllElemntMenuWin
    HideAllElemntMenuWin();
    $("#" + id + "_div").show();
    //Kiểm tra xem dialog có dữ liệu không. Nếu không thì không cần hiển thị
    if ($("#" + id + "_div").find('li').length <= 0) {
        return;
    }
    SelectedMenuLevel2(id);
    dialog.wrapper.css({ top: top, left: left });

    dialog.open();

}

function OpenMenuWinLevel(e) {
    var top = e.offsetParent.offsetParent.offsetTop + e.offsetTop;
    var left = e.offsetParent.offsetParent.offsetLeft + e.offsetWidth + 2;
    var listid = e.id.split('-');
    if (listid[1] === undefined) {
        listid[1] = 2;
        close = 0;
    }

    for (var i = parseInt(listid[1]) + 1; i < $("#countLevelMenu").val() ; i++) {
        CloseWindowMenuN(i);
    }
    //if (CheckItemMenu(id)) return;
    var dialog = $("#MenuPopup_win" + (parseInt(listid[1]) + 1)).data("kendoWindow");
    if (typeof (dialog) === 'undefined') return;
    //truoc khi hien thi popup chay ham HideAllElemntMenuWin
    HideAllElemntMenuWinN(parseInt(listid[1]));
    $("#" + listid[0] + "_Level" + listid[1]).show();
    //Kiểm tra xem dialog có dữ liệu không. Nếu không thì không cần hiển thị
    if ($("#" + listid[0] + "_Level" + listid[1]).find('li').length <= 0) {
        return;
    }
    close = 1;
    //SelectedMenuLevel2(listid[0]);
    dialog.wrapper.css({ top: top, left: left });
    dialog.open();
    $("#MenuPopup_win" + (parseInt(listid[1]) + 1)).show();
}


function OpenWinConfig(e) {
    if (hideConfig == 1) {
        hideConfig = 0;
        CloseWindowMenu();
        return;
    }
    hideConfig = 1;
    var top = e.offsetHeight + 3;
    var dialog = $("#Config_win").data("kendoWindow");
    var headerSector = $(e).closest('#Header');
    dialog.wrapper.css({
        top: headerSector.offset().top + headerSector.innerHeight(),
        left: e.offsetLeft - ($("#Config_win").parent().innerWidth() - e.offsetWidth)
    });
    dialog.open();
}

//Tao BreakCrumb
function CreateBreakcrumb() {
    var curAction = $('#currentAction').val();
    var displayBreakcrumb = $('#Breakcrumb').val();
    var divBreakcrumb = $('#Breakcrumb_div');
    var currID = $('#currentIDUrl').val();
    var area = $('#currentArea').val();
    var curController = $('#currentController').val();

    var arrayString = [];
    var stringBreakcrumb = "";
    var stringBreakcrumbLast = "";

    //Lay parameter tu duong dan
    var parameter = window.location.search;
    if (displayBreakcrumb) {
        divBreakcrumb.show();
        //Kiem tra xem link co ID hoac Parameter vao man hinh truy van
        if (parameter == "" && currID == "") {
            for (var i = 0; i < listMenuLevel2.length; i++) {
                var item = listMenuLevel2[i];
                if (item.Controller == curController) {
                    arrayString = item.Name.split("_");
                    stringBreakcrumbLast = " /<a>&#160" + item.Text + "<\a>";
                    //Set ID cua level hidden de xu ly selected khi menu duoc mo.
                    $('#currMenuLevel2').val(item.Name);
                    i = listMenuLevel2.length;
                }
            }
            for (var i = 0; i < listMenuLevel1.length; i++) {
                var item = listMenuLevel1[i];
                if (arrayString.length <= 0) {
                    if (item.Controller == curController) {
                        stringBreakcrumb = "<a>" + item.Text + " <\a>";
                    }
                }
                else {
                    if (item.Name == arrayString[0] + "_" + arrayString[1]) {
                        stringBreakcrumb = "<a>" + item.Text + " <\a>";
                        i = listMenuLevel2.length;
                    }
                }
            }
            divBreakcrumb.append(stringBreakcrumb + stringBreakcrumbLast);
        }
        else {
            var link = "";
            for (var i = 0; i < listMenuLevel2.length; i++) {
                var item = listMenuLevel2[i];
                if (item.Controller == curController) {
                    arrayString = item.Name.split("_");
                    link = item.Url;
                    stringBreakcrumbLast = " /<a href='" + link + "'>&#160" + item.Text + "<\a>";
                    //Set ID cua level hidden de xu ly selected khi menu duoc mo.
                    $('#currMenuLevel2').val(item.Name);
                    i = listMenuLevel2.length;
                }
            }
            for (var i = 0; i < listMenuLevel1.length; i++) {
                var item = listMenuLevel1[i];
                if (item.Name == arrayString[0] + "_" + arrayString[1]) {
                    stringBreakcrumb = "<a>" + item.Text + " <\a>";
                    i = listMenuLevel2.length;
                }
            }
            divBreakcrumb.append(stringBreakcrumb + stringBreakcrumbLast);
        }
    }

    if (stringBreakcrumb == "" && stringBreakcrumbLast == "" && typeof (listMenu) !== 'undefined') {
        var menuItem = null;
        var brkList = [];
        for (var i = 0; i < listMenu.length; i++) {
            if (listMenu[i].Controller === curController) {
                menuItem = listMenu[i]
                break;
            }
        }

        if (menuItem != null) {
            brkList.push(menuItem);
            for (var i = menuItem.Level - 1; i > 0 ; i--) {
                for (var j = 0; j < listMenu.length; j++) {
                    if (listMenu[j].Level == i && menuItem.ParentID == listMenu[j].Name) {
                        brkList.push(listMenu[j]);
                        menuItem = listMenu[j];
                        break;
                    }
                }
            }

            if (brkList.length > 0) {
                stringBreakcrumb = "<a>" + brkList[brkList.length - 1].Text + "<a>";
                for (var i = brkList.length - 2; i >= 0 ; i--) {
                    if (i == 0 && parameter != "" && curAction != "") {
                        stringBreakcrumb = stringBreakcrumb + " /<a href='" + brkList[i].Url + "'>&#160" + brkList[i].Text + "<\a>"
                    }
                    else {
                        stringBreakcrumb = stringBreakcrumb + " /<a>&#160" + brkList[i].Text + "<\a>";
                    }
                }

                for (var i = brkList.length - 1; i > 0 ; i--) {
                    SelectedMenuLevelN(brkList[i - 1].Name, brkList[i - 1].Level, brkList[i].Name);
                }

                var arrayString = brkList[brkList.length - 1].Name.split('_');
                $("#BlockMenu").show();
                $("#" + arrayString[0]).addClass('asf-menu-selectiontop');
                $("#" + arrayString[0] + "_div").show();
                $("#" + arrayString[0] + "_" + arrayString[1]).addClass("asf-menu-sub-select");
                $("#" + arrayString[0] + "_" + arrayString[1]).css('background-color', '#006EB4');
                itemMenuSelectParent = arrayString[0];
            }

            divBreakcrumb.append(stringBreakcrumb);
        }
    }
}

function CreateDynamicBreakcrumb() {
    var curController = $('#currentController').val();
    var curAction = $('#currentAction').val();
    var displayBreakcrumb = $('#Breakcrumb').val();
    var divBreakcrumb = $('#Breakcrumb_div');
    var currID = $('#currentIDUrl').val();
    var area = $('#currentArea').val();
    var ParentID = $('#ParentID').val();

    var arrayString = [];
    var stringBreakcrumb = "";
    var stringBreakcrumbLast = "";

    //Lay parameter tu duong dan
    var parameter = window.location.search;
    if (displayBreakcrumb) {
        divBreakcrumb.show();
        //Kiem tra xem link Parameter vao man hinh truy van
        if (parameter == "") {
            for (var i = 0; i < listMenuLevel2.length; i++) {
                var item = listMenuLevel2[i];
                if (item.Controller == currID) {
                    arrayString = item.Name.split("_");
                    stringBreakcrumbLast = " /<a>&#160" + item.Text + "<\a>";
                    //Set ID cua level hidden de xu ly selected khi menu duoc mo.
                    $('#currMenuLevel2').val(item.Name);
                    i = listMenuLevel2.length;
                }
            }
            for (var i = 0; i < listMenuLevel1.length; i++) {
                var item = listMenuLevel1[i];
                if (arrayString.length <= 0) {
                    if (item.Controller == currID) {
                        stringBreakcrumb = "<a>" + item.Text + " <\a>";
                    }
                }
                else {
                    if (item.Name == arrayString[0] + "_" + arrayString[1]) {
                        stringBreakcrumb = "<a>" + item.Text + " <\a>";
                        i = listMenuLevel2.length;
                    }
                }
            }
            divBreakcrumb.append(stringBreakcrumb + stringBreakcrumbLast);
        }
        else {
            var link = "";
            for (var i = 0; i < listMenuLevel2.length; i++) {
                var item = listMenuLevel2[i];
                if (item.Controller == ParentID) {
                    arrayString = item.Name.split("_");
                    link = item.Url;
                    stringBreakcrumbLast = " /<a href='" + link + "'>&#160" + item.Text + "<\a>";
                    //Set ID cua level hidden de xu ly selected khi menu duoc mo.
                    $('#currMenuLevel2').val(item.Name);
                    i = listMenuLevel2.length;
                }
            }
            for (var i = 0; i < listMenuLevel1.length; i++) {
                var item = listMenuLevel1[i];
                if (item.Name == arrayString[0] + "_" + arrayString[1]) {
                    stringBreakcrumb = "<a>" + item.Text + " <\a>";
                    i = listMenuLevel2.length;
                }
            }

            divBreakcrumb.append(stringBreakcrumb + stringBreakcrumbLast);
        }
    }


    if (stringBreakcrumb == "" && stringBreakcrumbLast == "") {
        var menuItem = null;
        var brkList = [];
        for (var i = 0; i < listMenu.length; i++) {
            if (listMenu[i].Controller === currID || listMenu[i].Controller === ParentID) {
                menuItem = listMenu[i]
                break;
            }
        }

        if (menuItem != null) {
            brkList.push(menuItem);
            for (var i = menuItem.Level - 1; i > 0 ; i--) {
                for (var j = 0; j < listMenu.length; j++) {
                    if (listMenu[j].Level == i && menuItem.ParentID == listMenu[j].Name) {
                        brkList.push(listMenu[j]);
                        menuItem = listMenu[j];
                        break;
                    }
                }
            }

            if (brkList.length > 0) {
                stringBreakcrumb = "<a>" + brkList[brkList.length - 1].Text + "<a>";
                for (var i = brkList.length - 2; i >= 0 ; i--) {
                    if (i == 0 && ParentID != undefined) {
                        stringBreakcrumb = stringBreakcrumb + " /<a href='" + brkList[i].Url + "'>&#160" + brkList[i].Text + "<\a>"
                    }
                    else {
                        stringBreakcrumb = stringBreakcrumb + " /<a>&#160" + brkList[i].Text + "<\a>";
                    }
                }

                for (var i = brkList.length - 1; i > 0 ; i--) {
                    SelectedMenuLevelN(brkList[i - 1].Name, brkList[i - 1].Level, brkList[i].Name);
                }

                var arrayString = brkList[brkList.length - 1].Name.split('_');
                $("#BlockMenu").show();
                $("#" + arrayString[0]).addClass('asf-menu-selectiontop');
                $("#" + arrayString[0] + "_div").show();
                $("#" + arrayString[0] + "_" + arrayString[1]).addClass("asf-menu-sub-select");
                $("#" + arrayString[0] + "_" + arrayString[1]).css('background-color', '#006EB4');
                itemMenuSelectParent = arrayString[0];
            }

            divBreakcrumb.append(stringBreakcrumb);
        }
    }
}

function SelectDynamicItemMenu() {
    if (typeof (listMenu) === 'undefined' || listMenu == null) return;
    if (typeof (listMenuLevel0) === 'undefined' || listMenuLevel0 == null) return;
    if (typeof (listMenuLevel1) === 'undefined' || listMenuLevel1 == null) return;
    if (typeof (listMenuLevel2) === 'undefined' || listMenuLevel2 == null) return;
    var curController = $('#currentController').val();
    var curAction = $('#currentAction').val();
    var ParentID = $('#ParentID').val();
    var arrayString = [];
    var currID = $('#currentIDUrl').val();
    //Neu duyet menu cap 2 ko co thi se duyet menu cap 1
    var loopMenuLevel1 = false;
    if (listMenuLevel2.length > 0) {
        for (var i = 0; i < listMenuLevel2.length; i++) {
            var item = listMenuLevel2[i];
            if (item.Controller == ParentID || item.Controller == currID) {
                arrayString = item.Name.split("_");
                $("#BlockMenu").show();
                $("#" + arrayString[0]).addClass('asf-menu-selectiontop');
                $("#" + arrayString[0] + "_div").show();
                $("#" + arrayString[0] + "_" + arrayString[1]).addClass("asf-menu-sub-select");
                $("#" + arrayString[0] + "_" + arrayString[1]).css('background-color', '#006EB4');
                itemMenuSelectParent = arrayString[0];
                return;
            }
            else {
                loopMenuLevel1 = true;
            }
        }
    }
    else {
        loopMenuLevel1 = true;
    }

    if (loopMenuLevel1) {
        for (var i = 0; i < listMenuLevel1.length; i++) {
            var item = listMenuLevel1[i];
            if (item.Controller == currID) {
                arrayString = item.Name.split("_");
                $("#BlockMenu").show();
                $("#" + arrayString[0]).addClass('asf-menu-selectiontop');
                $("#" + arrayString[0] + "_div").show();
                $("#" + arrayString[0] + "_" + arrayString[1]).addClass("asf-menu-sub-select");
                $("#" + arrayString[0] + "_" + arrayString[1]).css('background-color', '#006EB4');
                itemMenuSelectParent = arrayString[0];
                return;
            }
        }
    }
}

function Logout(e) {
    window.location.href = "/";
}

var show = 1;
//Hide show menu mobile
function showMenu_Click(e) {
    if (show == 1) {
        $("#Menu_Mobile").css("z-index", "2");
        $("#contentMaster").css("position", "absolute");
        $("#contentMaster").animate({
            left: "80%"
        });
        $("#Menu_Mobile").animate({
            left: "80%"
        });
        $(".asf-menu-rwd").toggle("slide");
        show = 0;
    }
    else {
        $("#contentMaster").animate({
            left: 0
        });
        $("#Menu_Mobile").animate({
            left: 0
        });
        $(".asf-menu-rwd").toggle("slide");
        $("#Menu_Mobile").css("z-index", "0");

        setTimeout(function () {
            $("#contentMaster").removeAttr("style");
        }, 350)
        show = 1;
    }
}


function btnSell_Click() {
    localStorage.setItem("OpenCart", "true");
    if (ASOFTEnvironment.CustomerIndex.isPhucLong())
        window.location.href = "/POS/POSF0039";
    else
        window.location.href = "/POS/POSF0016";
}

function btnReport_Click() {
    window.location.href = "/POS/POSF0047";
}
function MenuShowPopup(url) {
    var data = {};
    // [1] Format url with object data
    var postUrl = ASOFT.helper.renderUrl(url, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}

//set lại chiều cao lưới khi ẩn hiện điều kiện search
function tabSearchClick() {
    var idGrid = $(".asf-grid").attr("id");
    if (idGrid)
    {
        var grid = $("#" + idGrid).data("kendoGrid");
        if (grid)
        {
            setTimeout(function () {
                ASOFT.asoftGrid.setHeight(grid);
            }, 400)
        }
    }
}

function btnFilter_ClickMobile() {
    //var width = $(document).width();
    //if (width < 1200) {
    //    ASOFT.asoftPopup.showIframe("/ContentMaster/PopupSearch", {});
    //    $(".k-overlay").removeAttr("style");
    //}
    //return;
    if (!isShowSearchMobile) {
        if ($("#currentController").val() != "POSF0024") {
            $("#FilterArea").css("display", "block");
            $(".asf-button-filter-container .float_right").css("display", "block");
            $("#FormFilter .asf-panel-filter").css("display", "block");
        }
        else {
            $(".posf0024Cutom").css("display", "block");
            $(".asf-button-filter-container .omega").css("display", "block");
        }

        isShowSearchMobile = true;
    }
    else {
        if ($("#currentController").val() != "POSF0024") {
            $("#FilterArea").css("display", "none");
            $(".asf-button-filter-container .float_right").css("display", "none");
            $("#FormFilter .asf-panel-filter").css("display", "none");
        }
        else {
            $(".posf0024Cutom").css("display", "none");
            $(".asf-button-filter-container .omega").css("display", "none");
        }

        isShowSearchMobile = false;
    }
}

$(window).resize(function () {
    if ($("#currentController").val() != "POSF0024") {
        if (window.innerWidth > 1024 && ($("#FilterArea").css("display") == "none" || $("#FormFilter .asf-panel-filter").css("display") == "none")) {

            $("#FilterArea").css("display", "block");
            $(".asf-button-filter-container .float_right").css("display", "block");
            $("#FormFilter .asf-panel-filter").css("display", "block");
            isShowSearchMobile = true;
        }
    }
    else {
        if (window.innerWidth > 1024 && $(".posf0024Cutom").css("display") == "none") {
            $(".posf0024Cutom").css("display", "block");
            $(".asf-button-filter-container .omega").css("display", "block");
            isShowSearchMobile = true;
        }
    }
})
