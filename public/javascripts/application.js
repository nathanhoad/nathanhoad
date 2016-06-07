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
            image: 'https://01.img.society6.com/society6/img/xuS2W91aUW-3Jy8nJqSZl2yzAy0/w_700,h_700/wall-clocks/front/black-frame/white-hands/~artwork/s6-0015/a/5354423_2717811/~~/life-will-find-a-way-pip-wall-clocks.jpg', 
            title: 'Jurassic Park Wall Clock', 
            url: 'https://society6.com/product/life-will-find-a-way-pip_wall-clock#33=284&34=285' 
        }, { 
            image: 'https://01.img.society6.com/society6/img/_KyLDUCOCZRHAl07KRwHpfAHc80/w_550,h_550/pillows/~artwork/s6-0015/a/5342053_7667460/~~/modern-command-pillows.jpg', 
            title: 'Command Key Pillow', 
            url: 'https://society6.com/product/modern-command_pillow#25=193&18=126' 
        }, {
            image: 'https://01.img.society6.com/society6/img/93ktwud6pKrQ6JNCc7nRmn3saIQ/w_700,h_700/framed-prints/10x12/vector-black/~artwork/s6-0016/a/5564473_11393554/~~/the-lost-songs-of-hyrule-framed-prints.jpg',
            title: 'The Lost Songs of Hyrule',
            url: 'https://society6.com/product/the-lost-songs-of-hyrule_framed-print#12=60&13=54'
        }, {
            image: 'https://01.img.society6.com/society6/img/FbwgklPZ-1Meng6AD4U4-sUKpaU/w_700,h_700/tshirts/women/greybg/navy/~artwork/s6-0016/a/5466517_11324176/~~/the-perfect-sandwich-schematic-tshirts.jpg',
            title: 'Sandwich Schematic T-Shirt',
            url: 'https://society6.com/product/the-perfect-sandwich-schematic_t-shirt#11=50&4=84&5=17'
        }, {
            image: 'https://01.img.society6.com/society6/img/dRWc6kJ6ep4VxFJuQOqtU2v3oso/w_700,h_700/tshirts/men/greybg/tri-grey/~artwork/s6-0015/a/5358446_7832993/~~/thinking-about-coffee-tshirts.jpg',
            title: 'Thinking About Coffee T-Shirt',
            url: 'https://society6.com/product/thinking-about-coffee_t-shirt#11=49&4=133&5=17'
        }
    ];
    
    var ad = ADS[Math.floor(Math.random() * ADS.length)],
        element = $('.aff .internal');
        
    element.attr('href', ad.url);
    $('img', element).attr('src', ad.image);
    $('.title', element).text(ad.title);
});