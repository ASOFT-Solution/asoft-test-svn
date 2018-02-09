// Get the Sidebar
var mySidebar = document.getElementById("mySidebar");


//ID group select
var PanalLevel1ID = {}
var PanalLevel0ID = {};
var panelShow = $("#MenuSelectedStart").val();
var isSmall = true;
var indexItemFrist = 0;
var indexItemLast = 0;
var isPanelMobile = true;
var isChangeSize = false;

$(window).resize(function () {
    indexItemFrist = 0;
    indexItemLast = 0;
    HiddenWidthMenu();

    if (window.innerWidth > 768 && !isChangeSize)
    {
        $("#mySidebar").show();
        isSmall = isPanelMobile;
        if (isSmall) {
            $("#mySidebar").css("width", "300px");
            localStorage.setItem("isSmall", isSmall);
            isSmall = false;
            setSizeMenu("Panel", "PanelSmall");
            $(".level1Panel").css("width", "300px");
            $("#imageIconMenu").removeClass("div-image-menu");
            $("#imageIconMenu").addClass("image-icon-menu");
            $("#contentMaster").css("padding-left", "320px");
        } else {
            $("#mySidebar").css("width", "50px");
            localStorage.setItem("isSmall", isSmall);
            isSmall = true;
            setSizeMenu("PanelSmall", "Panel");
            $(".level1Panel").css("width", "50px");
            $("#imageIconMenu").addClass("div-image-menu");
            $("#imageIconMenu").removeClass("image-icon-menu");
            $("#contentMaster").css("padding-left", "65px");
        }
        isChangeSize = true;
    }

    if (window.innerWidth <= 768 && isChangeSize) {
        isPanelMobile = isSmall;
        setSizeMenu("Panel", "PanelSmall");
        localStorage.setItem("isSmall", isSmall);
        isSmall = false;
        if (!isPanelMobile) {
            $("#imageIconMenu").removeClass("div-image-menu");
            $("#imageIconMenu").addClass("image-icon-menu");
            $("#mySidebar").show();
            $("#imageIconMenuMobile").hide();
            isPanelMobile = true;
        }
        else {
            $("#mySidebar").hide();
            $("#imageIconMenuMobile").show();
            isPanelMobile = false;
        }
        isChangeSize = false;
    }
})

$(document).ready(function () {
    if (localStorage.getItem("isSmall") == null) {
        localStorage.setItem("isSmall", isSmall);
    }
    else {
        isSmall = localStorage.getItem("isSmall") == "true";
    }

    var clArrow = $(".classLeve1_Small .k-i-arrow-e");
    $.each(clArrow, function (index, element) {
        if ($(element).parent().parent().attr("class").indexOf("classLeve1_Small") != -1) {
            $(element).hide();
        }
    })

    for (var i = 0; i < listMenuLevel0.length; i++) {
        PanalLevel0ID[listMenuLevel0[i].Name] = listMenuLevel0[i];
    }
    for (var i = 0; i < listMenuLevel1.length; i++) {
        PanalLevel1ID[listMenuLevel1[i].Name] = listMenuLevel1[i];
    }

    $("#contentMaster").css("padding", "120px 10px 0 65px");
    HiddenWidthMenu();

    if (window.innerWidth <= 768) {
        setSizeMenu("Panel", "PanelSmall");
    }
    w3_open();

    if (window.innerWidth > 768) {
        isChangeSize = true;
        isPanelMobile = true;
    }
    else {
        isChangeSize = false;
        isPanelMobile = false;
    }

    //isSmall = false;
    setPaddingMenu();
})

function setPaddingMenu() {
    var level = $("input[name='MenuLevelMax']").val();
    var padding = 10;
    for (var i = 3; i <= level; i++)
    {
        $(".asf-menunew-level" + i + " .k-link").css("padding-left", padding + "%");
        padding += 10;
    }
}


// Toggle between showing and hiding the sidebar, and add overlay effect
function w3_open() {
    if (window.innerWidth >= 769) {
        if (isSmall) {
            $("#mySidebar").css("width", "300px");
            localStorage.setItem("isSmall", isSmall);
            isSmall = false;
            setSizeMenu("Panel", "PanelSmall");
            $(".level1Panel").css("width", "300px");
            $("#imageIconMenu").removeClass("div-image-menu");
            $("#imageIconMenu").addClass("image-icon-menu");
            $("#contentMaster").css("padding-left", "320px");
        } else {
            $("#mySidebar").css("width", "50px");
            localStorage.setItem("isSmall", isSmall);
            isSmall = true;
            setSizeMenu("PanelSmall", "Panel");
            $(".level1Panel").css("width", "50px");
            $("#imageIconMenu").addClass("div-image-menu");
            $("#imageIconMenu").removeClass("image-icon-menu");
            $("#contentMaster").css("padding-left", "65px");
        }
    }
    else {
        isSmall = false;
        localStorage.setItem("isSmall", isSmall);
        if (window.innerWidth < 769) {
            if (!isPanelMobile) {
                $("#imageIconMenu").removeClass("div-image-menu");
                $("#imageIconMenu").addClass("image-icon-menu");
                $("#mySidebar").show();
                $("#imageIconMenuMobile").hide();
                isPanelMobile = true;
            }
            else {
                $("#mySidebar").hide();
                $("#imageIconMenuMobile").show();
                isPanelMobile = false;
            }
        }
    }
}

// Close the sidebar with the close button
function w3_close() {
    mySidebar.style.display = "none";
}

function DisplayItemPreNew() {
    var arryTopmenu = $('#MenuNew .w3-quarter');
    indexItemFrist -= 1;
    indexItemLast -= 1;
    arryTopmenu[indexItemLast].style.display = "none";
    arryTopmenu[indexItemFrist].style.display = "inline-block";
    $('#imgNext').css('display', 'block');
    if (indexItemFrist <= 0) {
        $('#imgPrev').css('display', '');
    }
}

function DisplayItemNextNew() {
    var arryTopmenu = $('#MenuNew .w3-quarter');
    arryTopmenu[indexItemFrist].style.display = "none";
    arryTopmenu[indexItemLast].style.display = "inline-block";
    indexItemFrist += 1;
    indexItemLast += 1;
    $('#imgPrev').css('display', 'block');
    if (indexItemLast >= arryTopmenu.length) {
        $('#imgNext').css('display', '');
    }
}

function HiddenWidthMenu() {
    //Lay chieu rong cua man hinh
    widthscreen = $('#MenuNew').outerWidth();

    var arryTopmenu = $('#MenuNew .w3-quarter');
    var totalwidth = 0;
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


function iconMenu_Click() {
    w3_open();
}

function moduleList_Click(e, id) {
    var panel_KEY = isSmall ? "PanelSmall" : "Panel";
    var panel = panel_KEY + id;
    $.each(PanalLevel0ID, function (key, value) {
        if (value.Selected && key != id) {
            $("html, body").animate({ scrollTop: 0 }, 500, 'swing');
            $("#" + panel_KEY + key).hide();
            $("." + panel_KEY + key).hide();
            PanalLevel0ID[key].Selected = false;
            if (window.innerWidth < 769) {
                isPanelMobile = false;
                w3_open();
            }
        }
    })
    PanalLevel0ID[id].Selected = true;
    $("#" + panel).show();
    $("." + panel).show();
    $("#" + panel_KEY + panelShow).hide();
    $("." + panel_KEY + panelShow).hide();
    $(".asf-checked").attr("style", "display: none");
    $(".asf-Click").removeClass("asf-Click");
    $(".asf-color-module-select").addClass("asf-color-module");
    $(".asf-color-module-select").removeClass("asf-color-module-select");
    $(e).find(".asf-checked").attr("style", "display: block");
    $(e).find(".w3-container").addClass("asf-Click");
    $(e).find(".asf-color-module").addClass("asf-color-module-select");
    $(e).find(".asf-color-module").removeClass("asf-color-module");

    var isLevel1Select = false;
    var defaultSelect = "";

    $.each(PanalLevel1ID, function (key, value) {
        if (value.Selected && value.ParentID == PanalLevel0ID[id].Name) {
            $("#" + panel_KEY + key).show();
            $("." + panel_KEY + key).show();
            PanalLevel1ID[key].Selected = true;
            panelShow = key;

            if (!isSmall) {
                var widthLv0 = $("#Panel" + value.ParentID)[0].offsetHeight;
                var widthAll = $("#mySidebar")[0].offsetHeight;
                var widthLv1 = widthAll - widthLv0 - 70;
                $("#Panel" + key).css("height", widthLv1 + "px");
            }
            isLevel1Select = true;
        }
        if (!isLevel1Select && defaultSelect == "" && value.ParentID == PanalLevel0ID[id].Name)
        {
            defaultSelect = key;
        }
    })

    if (!isLevel1Select)
    {
        $("#ItemPanelSmall_" + defaultSelect).trigger("click");
        PanalLevel1ID[defaultSelect].Selected = true;
        panelShow = defaultSelect;
    }
}

function setSizeMenu(idShow, idHide) {
    var idKey = "";
    var widthLv1 = 0;
    $.each(PanalLevel0ID, function (key, value) {
        if (value.Selected) {
            $("#" + idShow + key).show();
            $("." + idShow + key).show();

            $("#" + idHide + key).hide();
            $("." + idHide + key).hide();

            idKey = key;

            if (!isSmall) {
                var widthLv0 = $("#Panel" + key)[0].offsetHeight;
                var widthAll = $("#mySidebar")[0].offsetHeight;
                widthLv1 = widthAll - widthLv0 - 70;
            }
        }
    })

    $.each(PanalLevel1ID, function (key, value) {
        if (value.Selected && PanalLevel0ID[idKey] && value.ParentID == PanalLevel0ID[idKey].Name) {
            $("#" + idShow + key).show();
            $("." + idShow + key).show();

            $("#" + idHide + key).hide();
            $("." + idHide + key).hide();

            if (!isSmall) {
                $("#Panel" + key).css("height", widthLv1 + "px");
            }
        }
    })
}

function menuPanel_Click(id) {
    var isExistPanel = false;
    var panel_KEY = isSmall ? "PanelSmall" : "Panel";
    $.each(PanalLevel1ID, function (key, value) {
        if (value.Selected && key != id) {
            $("#" + panel_KEY + key).hide();
            $("." + panel_KEY + key).hide();
            if (PanalLevel1ID[key].ParentID == PanalLevel1ID[id].ParentID) {
                PanalLevel1ID[key].Selected = false;
                $("#ItemPanelSmall_" + key).removeClass("k-state-selected");
                $("#ItemPanel_" + key).find(".k-link").removeClass("k-state-selected");
            }
            isExistPanel = true;
            PanalLevel1ID[id].Selected = true;
        }
    })

    if (!isExistPanel) {
        PanalLevel1ID[id].Selected = true;
    }

    if (!isSmall) {
        var widthLv0 = $("#Panel" + PanalLevel1ID[id].ParentID)[0].offsetHeight;
        var widthAll = $("#mySidebar")[0].offsetHeight;
        var widthLv1 = widthAll - widthLv0 - 70;
        $("#Panel" + id).css("height", widthLv1 + "px");
    }

    $("#" + panel_KEY + id).show();
    $("." + panel_KEY + id).show();

    $("#ItemPanelSmall_" + id).addClass("k-state-selected");
    $("#ItemPanel_" + id).find(".k-link").addClass("k-state-selected");
    panelShow = id;
}
