// 클릭 이벤트가 발생한 부분을 타케팅하여 ajax이벤트 발생
$('body').click(function (event) {
    var app_tab_div = document.getElementById('application_tab');
    if (event.target.id == 'OS') {
        var applist = document.getElementById('OS');
        app_tab_div.setAttribute('data-w-tab', 'OS');
        applist.click();
    } else if (event.target.id == 'tab12') {
        var applist = document.getElementById('tab12');
        app_tab_div.setAttribute('data-w-tab', 'Tab 12');
        applist.click();
    } else if (event.target.id == 'tab13') {
        var applist = document.getElementById('tab13');
        app_tab_div.setAttribute('data-w-tab', 'Tab 13');
        applist.click();
    } else if (event.target.id == 'tab14') {
        var applist = document.getElementById('tab14');
        app_tab_div.setAttribute('data-w-tab', 'Tab 14');
        applist.click();
    } else if (event.target.id == 'tab15') {
        var applist = document.getElementById('tab15');
        app_tab_div.setAttribute('data-w-tab', 'Tab 15');
        applist.click();
    } else if (event.target.id == 'tab16') {
        var applist = document.getElementById('tab16');
        app_tab_div.setAttribute('data-w-tab', 'Tab 16');
        applist.click();
    } else if (event.target.id == 'tab17') {
        var applist = document.getElementById('tab17');
        app_tab_div.setAttribute('data-w-tab', 'Tab 17');
        applist.click();
    } else if (event.target.id == 'tab18') {
        var applist = document.getElementById('tab18');
        app_tab_div.setAttribute('data-w-tab', 'Tab 18');
        applist.click();
    } else if (event.target.id == 'tab19') {
        var applist = document.getElementById('tab19');
        app_tab_div.setAttribute('data-w-tab', 'Tab 19');
        applist.click();
    } else if (event.target.id == 'tab20') {
        var applist = document.getElementById('tab20');
        app_tab_div.setAttribute('data-w-tab', 'Tab 20');
        applist.click();
    } else if (event.target.id == 'tab21') {
        var applist = document.getElementById('tab21');
        app_tab_div.setAttribute('data-w-tab', 'Tab 21');
        applist.click();
    } else if (event.target.id == 'tab22') {
        var applist = document.getElementById('tab22');
        app_tab_div.setAttribute('data-w-tab', 'Tab 22');
        applist.click();
    } else if (event.target.id == 'tab23') {
        var applist = document.getElementById('tab23');
        app_tab_div.setAttribute('data-w-tab', 'Tab 23');
        applist.click();
    } else if (event.target.id == 'tab24') {
        var applist = document.getElementById('tab24');
        app_tab_div.setAttribute('data-w-tab', 'Tab 24');
        applist.click();
    } else if (event.target.id == 'tab25') {
        var applist = document.getElementById('tab25');
        app_tab_div.setAttribute('data-w-tab', 'Tab 25');
        applist.click();
    } else if (event.target.id == 'tab26') {
        var applist = document.getElementById('tab26');
        app_tab_div.setAttribute('data-w-tab', 'Tab 26');
        applist.click();
    }

    // for (var i = 12; i < 27; i++) {
    //     if (event.target.id == 'tab' + i.toString) {
    //         var applist = document.getElementById('tab' + i.toString);
    //         app_tab_div.setAttribute('data-w-tab', 'Tab ' + i.toString);
    //         applist.click();
    //     }
    // }
});
