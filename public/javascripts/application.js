String.prototype.format = function() {
    var argument, formatted, i, regexp, _i, _len;
    formatted = this;
    for (i = _i = 0, _len = arguments.length; _i < _len; i = ++_i) {
        argument = arguments[i];
        regexp = new RegExp('\\{' + i + '\\}', 'gi');
        formatted = formatted.replace(regexp, argument);
    }
    return formatted;
};

var MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];


document.querySelectorAll('*[data-date]').forEach(function (element) {
    var output, t, time;
    t = element.getAttribute('data-date').split(/[:\- ]/);
    time = new Date("Sun Jan 01 00:00:00 UTC 2012");
    time.setUTCFullYear(t[0]);
    time.setUTCMonth(t[1] - 1);
    time.setUTCDate(t[2]);
    time.setUTCHours(t[3]);
    time.setUTCMinutes(t[4]);
    time.setUTCSeconds(t[5]);

    element.innerText = "{0} {1}".format(MONTHS[time.getMonth()], time.getFullYear());
});