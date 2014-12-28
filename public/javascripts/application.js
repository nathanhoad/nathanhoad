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



$(function () {
    $('li[rel="tooltip"]').tooltip();
  
    $('*[data-date]').html(function() {
        var output, t, time;
        t = $(this).data('date').split(/[:\- ]/);
        time = new Date("Sun Jan 01 00:00:00 UTC 2012");
        time.setUTCFullYear(t[0]);
        time.setUTCMonth(t[1] - 1);
        time.setUTCDate(t[2]);
        time.setUTCHours(t[3]);
        time.setUTCMinutes(t[4]);
        time.setUTCSeconds(t[5]);

        return "{0} {1}".format(MONTHS[time.getMonth()], time.getFullYear());
    });
  
  
    var ADS = [
        { 
            image: 'http://a1.s6img.com/cdn/0015/v/5354425_1973074-clkfkhw_pm.jpg', 
            title: 'Jurassic Park Wall Clock', 
            url: 'http://society6.com/product/life-will-find-a-way-pip_wall-clock#33=284&34=285' 
        }, { 
            image: 'http://a1.s6img.com/cdn/0015/v/5342054_14153922-plwfr2_pm.jpg', 
            title: 'Command Key Pillow', 
            url: 'http://society6.com/product/modern-command_pillow#25=193&18=126' 
        }, {
            image: 'http://a1.s6img.com/cdn/0016/p/5564476_1574601-frm715bl01_pm.jpg',
            title: 'The Lost Songs of Hyrule',
            url: 'http://society6.com/product/the-lost-songs-of-hyrule_framed-print#12=52&13=54'
        }, {
            image: 'http://a1.s6img.com/cdn/0016/v/5466518_7448476-tsrmw127_pm.jpg',
            title: 'Sandwich Schematic T-Shirt',
            url: 'http://society6.com/product/the-perfect-sandwich-schematic_t-shirt#11=49&4=136'
        }, {
            image: 'http://a1.s6img.com/cdn/0015/v/5358447_3479179-tsrww124_pm.jpg',
            title: 'Thinking About Coffee T-Shirt',
            url: 'http://society6.com/product/thinking-about-coffee_t-shirt#11=50&4=135'
        }
    ];
    
    var ad = ADS[Math.floor(Math.random() * ADS.length)],
        element = $('.aff .internal');
        
    element.attr('href', ad.url);
    $('img', element).attr('src', ad.image);
    $('.title', element).text(ad.title);
});