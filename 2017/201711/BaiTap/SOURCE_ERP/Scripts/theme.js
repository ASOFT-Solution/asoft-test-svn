// init page controls

function path(url) {
    return /(.*\/)[^\/]*$/gi.exec(url)[1];
}

/*$("#language").kendoDropDownList({
    dataTextField: "text",
    dataValueField: "value",
    value: "common-bootstrap",
    dataSource: [
                    { text: "Tiếng Việt", value: "vi-Vn" },
                    { text: "Tiếng Anh", value: "en-US" }
                ],
    change: function (e) {
        //$.cookie("_culture", this.value(), { expires: 365, path: '/' });
        var url = $("#languageUrl").val();
        $.post(url, { lang: this.value() }, function (data) {
            window.location.reload(); 
        });
        
    }
});*/

$("#theme").kendoDropDownList({
    dataTextField: "text",
    dataValueField: "value",
    value: "silver",
    dataSource: [
                    { text: "Default", value: "default" },
                    { text: "Blue Opal", value: "blueopal" },
                    { text: "Bootstrap", value: "bootstrap" },
                    { text: "Silver", value: "silver" },
                    { text: "Uniform", value: "uniform" },
                    { text: "Metro", value: "metro" },
                    { text: "Black", value: "black" },
                    { text: "Metro Black", value: "metroblack" },
                    { text: "High Contrast", value: "highcontrast" },
                    { text: "Moonlight", value: "moonlight" },
                    { text: "Flat", value: "flat" }
                ],
    change: function (e) {
        theme = this.value();
        Application.changeTheme(theme, true);
    }
});

//$("#theme-list, #dimensions-list, #font-size-list").addClass("ra-list");

$("#configure").on("click", function (e) {
    $("#configurator-wrap").toggleClass("hidden-xs");
    e.preventDefault();
});
