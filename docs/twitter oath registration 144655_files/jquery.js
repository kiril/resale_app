//Licensed under The MIT License
//Copyright (c) 2008 Jason Frame (jason@onehackoranother.com)
(function($){$.fn.tipsy=function(g){g=$.extend({fade:false,gravity:'n'},g||{});if(!g['offsetTop']){g['offsetTop']=0}if(!g['offsetLeft']){g['offsetLeft']=0}if(!g['header']){g['header']=''}if(!g['footer']){g['footer']=''}if(!g['hideTimeout']){g['hideTimeout']=100}if(!g['showTimeout']){g['hideTimeout']=0}if(!g['additionalCSSClass']){g['additionalCSSClass']=''}var h=false;var i=null,cancelHide=false;this.hover(function(){var a=$(this).text();var b=g['header'].replace('%{link}',a);var c=g['footer'].replace('%{link}',a);$.data(this,'cancel.tipsy',true);var d=$.data(this,'active.tipsy');if(!d){$('.tipsy').hide();d=$('<div class="tipsy '+g['additionalCSSClass']+'"><div class="tipsy-inner">'+b+$(this).attr('title')+c+'</div></div>');d.css({position:'absolute',zIndex:100000});$(this).attr('title','');$.data(this,'active.tipsy',d)}else if($(this).attr('title')!=''){d.find('.tipsy-inner').html($(this).attr('title'));$(this).attr('title','')}var e=$.extend({},$(this).offset(),{width:this.offsetWidth,height:this.offsetHeight});e.top=e.top+g['offsetTop'];e.left=e.left+g['offsetLeft'];$('.tipsy').hide();d.remove().css({top:0,left:0,visibility:'hidden',display:'block'}).appendTo(document.body);var f=d[0].offsetWidth,actualHeight=d[0].offsetHeight;switch(g.gravity.charAt(0)){case'n':d.css({top:e.top+e.height,left:e.left+e.width/2-f/2}).addClass('tipsy-north');break;case'l':d.css({top:e.top+e.height,left:e.left+e.width/2-18}).addClass('tipsy-north');break;case's':d.css({top:e.top-actualHeight,left:e.left+e.width/2-f/2}).addClass('tipsy-south');break;case'e':d.css({top:e.top+e.height/2-actualHeight/2,left:e.left-f}).addClass('tipsy-east');break;case'w':d.css({top:e.top+e.height/2-actualHeight/2,left:e.left+e.width}).addClass('tipsy-west');break}function show(){if(g.fade){d.css({opacity:0,display:'block',visibility:'visible'}).animate({opacity:1})}else{d.css({visibility:'visible'})}}if(g['showTimeout']){h=setTimeout(show,g['showTimeout'])}else{show()}},function(){clearTimeout(h);$.data(this,'cancel.tipsy',false);var b=this;setTimeout(function(){if($.data(this,'cancel.tipsy'))return;var a=$.data(b,'active.tipsy');if(g.fade){a.stop().fadeOut(function(){$(this).remove()})}else{a.remove()}},g['hideTimeout'])})}})(jQuery);