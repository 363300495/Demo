
//去掉乐视视频首页弹出框
//var startTimer = setInterval(function(){
//                                     
//    if(document.getElementsByClassName('m-start logoRed')[0]){
//                             
//        var start = document.getElementsByClassName('m-start logoRed')[0];
//        start.style.display = 'none';
//                             
////       var start = document.getElementsByClassName('start-logo')[0];
////       start.style.display = 'none';
////                             
////       var btnArr = document.getElementsByClassName('btn-arr')[0];
////       btnArr.style.display = 'none';
//                             
//       clearInterval(startTimer)}
//    },50)

//去掉下载客户端按钮
var downloadAPPTimer = setInterval(function(){
                                   
      if(document.getElementsByClassName('m-start logoRed')[0]){
         
        //修改背景图片
        var startlogo = document.getElementsByClassName('m-start logoRed')[0];
        startlogo.style.background = 'url(http://www.ykxia.com/images/gate/le_bgimg.jpg)';
        startlogo.style.backgroundSize = 'cover';
                                   
         //去掉下载按钮
        var downloadAPP = document.getElementsByClassName('btn-arr')[0];
        var a = downloadAPP.getElementsByTagName('a')[0];
        a.style.display = 'none';
        clearInterval(downloadAPPTimer)}
     },50)

//隐藏个人信息图标
var iconUserTimer = setInterval(function(){

    if(document.getElementsByClassName('icon_font icon_user_in icon_user_in1')[0]){
        var iconUser = document.getElementsByClassName('icon_font icon_user_in icon_user_in1')[0];
        iconUser.style.display = 'none';
        clearInterval(iconUserTimer)}
    },50)

var iconUserPlayTimer = setInterval(function(){
                                
    if(document.getElementsByClassName('icon_font icon_user1')[0]){
       var iconUserPlay = document.getElementsByClassName('icon_font icon_user1')[0];
       iconUserPlay.style.display = 'none';
       clearInterval(iconUserPlayTimer)}
    },50)



//隐藏APP按钮
var APPDownloadTimer = setInterval(function(){

    if(document.getElementsByClassName('leapp_btn')[0]){
        var APPDownload = document.getElementsByClassName('leapp_btn')[0];
        APPDownload.style.display = 'none';
        clearInterval(APPDownloadTimer)}
    },50)



//隐藏播放下载按钮
var playDownloadTimer = setInterval(function(){

    if(document.getElementsByClassName('ico_down j-down')[0]){
       var playDownload = document.getElementsByClassName('ico_down j-down')[0];
       playDownload.style.display = 'none';
       clearInterval(playDownloadTimer)}
    },50)


//隐藏播放分享按钮
var playShareTimer = setInterval(function(){
                                 
    if(document.getElementsByClassName('ico_share j-share')[0]){
        var playShare = document.getElementsByClassName('ico_share j-share')[0];
        playShare.style.display = 'none';
        clearInterval(playShareTimer)}
    },50)



//隐藏打开乐视视频APP
var openAPPTimer = setInterval(function(){
                               
    if(document.getElementById('j-leappMore')){
        var openAPP = document.getElementById('j-leappMore');
        openAPP.style.display = 'none';
        clearInterval(openAPPTimer)}
    },50)


//页面底部免费下载
var bottomDownloadTimer = setInterval(function(){
    if(document.getElementById('j-addDesktop')){
        var bottomDownload = document.getElementById('j-addDesktop');
        bottomDownload.style.display = 'none';
        clearInterval(bottomDownloadTimer)}
    },50)

//去掉反馈按钮
var feedbackTimer = setInterval(function(){
                                      
    if(document.getElementById('j-btn-showhide')){
        var feedback = document.getElementById('j-btn-showhide');
        feedback.style.display = 'none';
        clearInterval(feedbackTimer)}
    },50)

