
//去掉下载页面下载按钮
var openMangguoTVTimer = setInterval(function(){
                                     
                                     if(document.getElementsByClassName('btns')[0]){
                                     var openMangguoTV = document.getElementsByClassName('btns')[0];
                                     openMangguoTV.style.display = 'none';
                                     clearInterval(openMangguoTVTimer)}
                                     },50)

//去掉登录后的退出登录按钮
var exitMangguoTVTimer = setInterval(function(){
                                     
                                     if(document.getElementsByClassName('mgui-btn mgui-btn-nowelt')[0]){
                                     var exitMangguoTV = document.getElementsByClassName('mgui-btn mgui-btn-nowelt')[0];
                                     exitMangguoTV.style.display = 'none';
                                     clearInterval(exitMangguoTVTimer)}
                                     },50)


////去掉个人信息
//var userLoginTimer = setInterval(function(){
//                              
//                              if(document.getElementsByClassName('listicon')[0]){
//                              var userLogin = document.getElementsByClassName('listicon')[0];
//                              userLogin.style.display = 'none';
//                              clearInterval(userLoginTimer)}
//                              },50)
//
//
//var centerShareTimer = setInterval(function(){
//                                   
//                                   if(document.querySelectorAll('.listicon')){
//                                   var length = document.querySelectorAll('.m-icon-link').length;
//                                   for(var i = 0;i<length;i++){
//                                   document.querySelectorAll('.listicon')[i].style.display = 'none';
//                                   }
//                                   clearInterval(centerShareTimer)}
//                                   },50)
//
////去掉顶部下载按钮
//var headDownloadTimer = setInterval(function(){
//                                 
//                                 if(document.getElementsByClassName('mg-apps-download')[0]){
//                                 var headDownload = document.getElementsByClassName('mg-apps-download')[0];
//                                 headDownload.style.display = 'none';
//                                 clearInterval(headDownloadTimer)}
//                                 },50)
//
////去掉播放页面播放记录
//var playListTimer = setInterval(function(){
//                                    
//                                    if(document.getElementsByClassName('box')[0].getElementsByTagName('ul')[0]){
//                                    var playList = document.getElementsByClassName('box')[0].getElementsByTagName('ul')[0];
//                                    playList.style.display = 'none';
//                                    clearInterval(playListTimer)}
//                                    },50)
//
////去掉播放页面个人信息
//var playUserInfoTimer = setInterval(function(){
//                                
//                                if(document.getElementsByClassName('m-headerbar')[1]){
//                                var playUserInfo = document.getElementsByClassName('m-headerbar')[1];
//                                playUserInfo.style.display = 'none';
//                                clearInterval(playUserInfoTimer)}
//                                },50)
//
//
//
////去掉播放页中部打开APP按钮
//var centerDownloadTimer = setInterval(function(){
//
//                                if(document.getElementsByClassName('bd')[0]){
//                                var centerDownload = document.getElementsByClassName('bd')[0];
//                                centerDownload.style.display = 'none';
//                                clearInterval(centerDownloadTimer)}
//                                },50)
////去掉底部打开APP按钮
//var footerDownloadTimer = setInterval(function(){
//                                      
//                                      if(document.getElementsByClassName('ft')[1]){
//                                      var footerDownload = document.getElementsByClassName('ft')[1];
//                                      footerDownload.style.display = 'none';
//                                      clearInterval(footerDownloadTimer)}
//                                      },50)
//
////mg-app-open on
//var suspensionDownloadTimer = setInterval(function(){
//                                    
//                                    if(document.getElementsByClassName('mg-app-open on')[0]){
//                                    var suspensionDownload = document.getElementsByClassName('mg-app-open on')[0];
//                                    suspensionDownload.style.display = 'none';
//                                    clearInterval(footerDownloadTimer)}
//                                    },50)



