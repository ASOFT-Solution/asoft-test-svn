;
jQuery(document).ready(function () {
    kendo.cultures.current.numberFormat.decimals = ASOFTEnvironment.NumberFormat.NumberPercentDigits;
    //var ASOFTEnvironment = ASOFTEnvironment || null;

    if (!ASOFTEnvironment) {
        return;
    }

    var
         numberDecimalSeparator = ASOFTEnvironment.NumberFormat.NumberDecimalSeparator,
         numberGroupSeparator = ASOFTEnvironment.NumberFormat.NumberGroupSeparator
    ;

    kendo.cultures['abc5'] = kendo.cultures['abc5'] || {
        name: 'abc5',
        numberFormat: {
            pattern: ["-n"],
            decimals: 5,
            ",": numberGroupSeparator,
            ".": numberDecimalSeparator,
            groupSize: [3],
            percent: {
                pattern: ["-n %", "n %"],
                decimals: 4,
                ",": numberGroupSeparator,
                ".": numberDecimalSeparator,
                groupSize: [3],
                symbol: "%"
            },
            currency: {
                pattern: ["-$n", "$n"],
                decimals: 4,
                ",": numberGroupSeparator,
                ".": numberDecimalSeparator,
                groupSize: [3],
                symbol: "£"
            }
        },
        calendars: {
           
        }
    }

    kendo.cultures['abc4'] = kendo.cultures['abc4'] || {
        name: 'abc4',
        numberFormat: {
            pattern: ["-n"],
            decimals: 4,
            ",": numberGroupSeparator,
            ".": numberDecimalSeparator,
            groupSize: [3],
            percent: {
                pattern: ["-n %", "n %"],
                decimals: 4,
                ",": numberGroupSeparator,
                ".": numberDecimalSeparator,
                groupSize: [3],
                symbol: "%"
            },
            currency: {
                pattern: ["-$n", "$n"],
                decimals: 4,
                ",": numberGroupSeparator,
                ".": numberDecimalSeparator,
                groupSize: [3],
                symbol: "£"
            }
        },
        calendars: {

        }
    }

    kendo.culture(ASOFTEnvironment.KendoCulture);
    $("#Culture").bind("change", function () {
        var selected = $(this).val();
        window.location = replaceQueryString(window.location.href, "culture", selected);
    });
});






