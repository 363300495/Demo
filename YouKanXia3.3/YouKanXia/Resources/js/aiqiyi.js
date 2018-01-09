
//修改进入爱奇艺界面
var downloadAPPTimer = setInterval(function(){
                              
    if(document.getElementsByClassName('m-guide po-fixed')[0]){
       
       //上面的图片
//      var aqiyiGuideHeader = document.getElementsByClassName('m-guide-title')[0];
                                   
    //隐藏上面logo
       var aqiyiGuideTitle = document.getElementsByClassName('images')[0];
       aqiyiGuideTitle.style.display = 'none';
//                                   aqiyiGuideTitle.style.backgroundSize = 'cover';
//       aqiyiGuideTitle.style.background = 'url(http://www.ykxia.com/images/gate/iqiyi_topimg.png)';
                                   
      //修改背景图片
       var aqiyiGuideCont = document.getElementsByClassName('images')[1];
        aqiyiGuideCont.style.background = 'url(http://www.ykxia.com/images/gate/iqiyi_bgimg.jpg)';
        aqiyiGuideCont.style.backgroundSize = 'cover';
                                   
                                   
       //去掉下载端的按钮
       var downloadAPP = document.getElementsByClassName('m-guide-download')[0];
       downloadAPP.style.display = 'none';

       clearInterval(downloadAPPTimer)}
    },50)


//隐藏会员俱乐部、热点等
var vipHotTimer = setInterval(function(){
    
    if(document.getElementsByClassName('m-imgicon m-sliding')[0]){
        var vipHot = document.getElementsByClassName('m-imgicon m-sliding')[0];
        vipHot.style.display = 'none';
        clearInterval(vipHotTimer)}
    },50)


//隐藏历史记录列表
var headerRecorderTimer = setInterval(function(){
                                      
    if(document.getElementsByClassName('header-recorder')[0]){
       var headerRecorder = document.getElementsByClassName('header-recorder')[0];
       headerRecorder.style.display = 'none';
       clearInterval(headerRecorderTimer)}
    },50)



//隐藏登录头像按钮
var headerLoginTimer = setInterval(function(){
                                   
     if(document.getElementsByClassName('header-login')[0]){
        var headerLogin = document.getElementsByClassName('header-login')[0];
        headerLogin.style.display = 'none';
        clearInterval(headerLoginTimer)}
    },50)



//隐藏下载按钮APP
var headerAppTimer = setInterval(function(){
                                 
    if(document.getElementsByClassName('header-app')[0]){
       var headerApp = document.getElementsByClassName('header-app')[0];
       headerApp.style.display = 'none';
       clearInterval(headerAppTimer)}
    },50)




//隐藏VIP会员界面个人信息
var vipUserInfoTimer = setInterval(function(){
                                   
     if(document.getElementsByClassName('m-vip-userInfo')[0]){
        var vipUserInfo = document.getElementsByClassName('m-vip-userInfo')[0];
        vipUserInfo.style.display = 'none';
        clearInterval(vipUserInfoTimer)}
    },50)


//隐藏下部的爱奇艺下载banner
var bottomNativeTimer = setInterval(function(){

    if(document.getElementById('bottomNativePopup')){
       var bottomNative = document.getElementById('bottomNativePopup');
       bottomNative.style.display = 'none';
       clearInterval(bottomNativeTimer)}
    },50)


//隐藏意见反馈
var feedBackTimer = setInterval(function(){
    if(document.getElementsByClassName('m-linkMore noborder-top')[0]){
        var feedBack = document.getElementsByClassName('m-linkMore noborder-top')[0];
        feedBack.style.display = 'none';
        clearInterval(feedBackTimer)}
    },50)



//隐藏播放界面下面打开爱奇艺，提示三倍流畅度按钮
var threeFluentTimer = setInterval(function(){
                                  
    if(document.getElementsByClassName('m-box-items m-box-items-Ptop m-box-items-Pbottom')[0]){
       var threeFluent = document.getElementsByClassName('m-box-items m-box-items-Ptop m-box-items-Pbottom')[0];
       threeFluent.style.display = 'none';
       clearInterval(threeFluentTimer)}
    },50)



//隐藏下面立即续费，大片看不停按钮(与上面的按钮是同一个标签)
var fluentAPPTimer = setInterval(function(){
                                 
     if(document.getElementsByClassName('m-box-items m-box-items-Ptop m-box-items-Pbottom')[1]){
        var fluentAPP = document.getElementsByClassName('m-box-items m-box-items-Ptop m-box-items-Pbottom')[1];
        fluentAPP.style.display = 'none';
        clearInterval(fluentAPPTimer)}
    },50)



//隐藏播放界面下面的分享、收藏、下载按钮
var videoActionTimer = setInterval(function(){
                                  
     if(document.getElementsByClassName('m-video-action')[0]){
       var videoAction = document.getElementsByClassName('m-video-action')[0];
       videoAction.style.display = 'none';
       clearInterval(videoActionTimer)}
    },50)



//隐藏中间的广告banner
var centerBannerTimer = setInterval(function(){
                                  
    if(document.getElementsByClassName('m-wl-entrance m-wl-borderT')[0]){
        var centerBanner = document.getElementsByClassName('m-wl-entrance m-wl-borderT')[0];
        centerBanner.style.display = 'none';
        clearInterval(centerBannerTimer)}
    },50)


//去掉中间的小说广告
var novelTimer = setInterval(function(){
    if(document.getElementsByClassName('m-ipRelation m-wl-borderT m-ipRelation-btn')[0]){
        var novel = document.getElementsByClassName('m-ipRelation m-wl-borderT m-ipRelation-btn')[0];
        novel.style.display = 'none';
        clearInterval(novelTimer)}
    },50)



//去掉APP专享以及用券
var APPvipCardTimer = setInterval(function(){
                                  
    if(document.getElementsByClassName('m-player-tip')[0]){
        var APPvipCard = document.getElementsByClassName('m-player-tip')[0];
        APPvipCard.style.display = 'none';
        clearInterval(APPvipCardTimer)}
    },50)



//隐藏泡泡圈顶部的banner
var paoPaoTimer = setInterval(function(){
                                  
    if(document.getElementsByClassName('m-pp-appBar')[0]){
        var paoPao = document.getElementsByClassName('m-pp-appBar')[0];
        paoPao.style.display = 'none';
        clearInterval(paoPaoTimer)}
    },50)



//泡泡圈内顶部的分享
var paoPaoTopShareTimer = setInterval(function(){
                                  
     if(document.getElementsByClassName('c-handle')[0]){
        var paoPaoTopShare = document.getElementsByClassName('c-handle')[0];
        paoPaoTopShare.style.display = 'none';
        clearInterval(paoPaoTopShareTimer)}
    },50)



//泡泡圈评论中的分享，评论和点赞
var centerShareTimer = setInterval(function(){
                                  
    if(document.querySelectorAll('.m-icon-link')){
        var length = document.querySelectorAll('.m-icon-link').length;
        for(var i = 0;i<length;i++){
           document.querySelectorAll('.m-icon-link')[i].style.display = 'none';
        }
        clearInterval(centerShareTimer)}
    },50)


