
////去掉优酷进入时的页面
//var fullPromotionTimer = setInterval(function(){
//                                  
//  if(document.getElementById('FullPromotion')){
//        var fullPromotion = document.getElementById('FullPromotion');
//        fullPromotion.style.display = 'none';
//        clearInterval(fullPromotionTimer)}
//    },50)


//去掉APP观看按钮
var downloadAPPTimer = setInterval(function(){
                                   
     if(document.getElementsByClassName('figure')[0]){
                                   
         //隐藏上面logo图片
         var logo = document.getElementsByClassName('logo')[0];
         logo.style.display = 'none';
//                                   logo.style.background = 'url(http://www.ykxia.com/images/gate/youku_topimg.png)';
//                                   
//                                   logo.style.backgroundSize = 'cover';
                                   
                                   
          //修改背景图片
         var figure = document.getElementsByClassName('figure')[0];
          figure.style.background = 'url(http://www.ykxia.com/images/gate/youku_bgimg.png)';
          figure.style.backgroundSize = 'cover';
                                   
                                   
                                   
         //去掉下载按钮
        var downloadAPP = document.getElementById('fDownload');
        downloadAPP.parentNode.style.display = 'none';
         //获取跳过按钮
        var skipButton = document.getElementById('fClose');
         
                                   
        var isPhone5s = (function(){
         var h=window.innerHeight,w=window.innerWidth,useragent = navigator.userAgent.toLowerCase(),isP5s = false;
         if(useragent.match(/mobile/i)!==null && useragent.match(/iphone/i)!==null && ( h>w ? (Math.abs(w-320)<10 && h<=568) : (Math.abs(w-568)<10) && h<=320)) isP5s = true;
                return isP5s;
         })();

         var isPhone6 = (function(){
              var h=window.innerHeight,w=window.innerWidth,useragent = navigator.userAgent.toLowerCase(),isP6 = false;
              if(useragent.match(/mobile/i)!==null && useragent.match(/iphone/i)!==null && ( h>w ? (Math.abs(w-375)<10 && h<=667) : (Math.abs(w-667)<10) && h<=375)) isP6 = true;
                   return isP6;
         })();
                                   
                                   
         var isPhone6p = (function(){
              var h=window.innerHeight,w=window.innerWidth,useragent = navigator.userAgent.toLowerCase(),isP6p = false;
              if(useragent.match(/mobile/i)!==null && useragent.match(/iphone/i)!==null && ( h>w ? (Math.abs(w-414)<10 && h<=736) : (Math.abs(w-736)<10) && h<=414)) isP6p = true;
                  return isP6p;
              })();
         
         if(isPhone5s){
            skipButton.parentNode.style.width = '70%';
         }else if(isPhone6){
            skipButton.parentNode.style.width = '70%';
         }else if(isPhone6p){
            skipButton.parentNode.style.width = '65%';
         }
                           
        clearInterval(downloadAPPTimer)}
     },50)



//去掉个人信息按钮
var userloginTimer = setInterval(function(){
                                 
    if(document.getElementsByClassName('yk-userlog')[0]){
        var userlogin = document.getElementsByClassName('yk-userlog')[0];
        userlogin.style.display = 'none';
        clearInterval(userloginTimer)}
    },50)


//去掉播放页面个人信息按钮
var loginIconTimer = setInterval(function(){
                              
    if(document.getElementsByClassName('x_login_icon')[0]){
        var loginIcon = document.getElementsByClassName('x_login_icon')[0];
        loginIcon.style.display = 'none';
        clearInterval(loginIconTimer)}
     },50)


//去掉反馈
var feedBackTimer = setInterval(function(){
                                  
    if(document.getElementById('sideBar')){
        var feedBack = document.getElementById('sideBar');
        feedBack.style.display = 'none';
        clearInterval(feedBackTimer)}
    },50)


//去掉播放页下面的收藏、下载、分享、高清按钮
var imgSrcTimer = setInterval(function(){
                              
    if(document.getElementsByClassName('brief-btn clearfix')[0]){
        var imgSrc = document.getElementsByClassName('brief-btn clearfix')[0];
        imgSrc.style.display = 'none';
        clearInterval(imgSrcTimer)}
    },50)


//去掉播放页下面所有推荐APP观看
var recommendTimer = setInterval(function(){
                                
    if(document.getElementById('Recommend')){
        var recommend = document.getElementById('Recommend');
        recommend.style.display = 'none';
        clearInterval(recommendTimer)}
    },50)


//去掉中间广告
var bigdramaTimer = setInterval(function(){
                                 
    if(document.getElementById('Bigdrama')){
        var bigdrama = document.getElementById('Bigdrama');
        bigdrama.style.display = 'none';
        clearInterval(bigdramaTimer)}
    },50)


//去掉下面的更多评论按钮
var moreCommentTimer = setInterval(function(){
                                
    if(document.getElementsByClassName('cmt-more')[0]){
       var moreComment = document.getElementsByClassName('cmt-more')[0];
       moreComment.style.display = 'none';
       clearInterval(moreCommentTimer)}
    },50)


//去掉下载页面的下载按钮
var APPDownloadTimer = setInterval(function(){
                                   
    if(document.getElementById('download')){
       var APPDownload = document.getElementById('download');
       APPDownload.style.display = 'none';
       clearInterval(APPDownloadTimer)}
    },50)

//修改下载页面的标题文字
var APPTitleTimer = setInterval(function(){
                                   
    if(document.getElementsByClassName('world bc')[0]){
       var APPTitle = document.getElementsByClassName('world bc')[0];
       APPTitle.innerHTML = '温馨提示';
       var APPContent = document.getElementsByClassName('world-txt')[0];
       APPContent.innerHTML = '无需下载优酷客户端<br /><a href="javascript:history.go(-1);">请返回</a>';
                                
       clearInterval(APPTitleTimer)}
    },50)

