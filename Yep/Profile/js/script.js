(function(){var i,a,o,e,n;a=window.devicePixelRatio||1,o=.1,new Zodiac("zodiac",{dotColor:"#3F87E5",linkColor:"#A8DEFF",directionX:0,directionY:0,velocityX:[o/2,2*o],velocityY:[o/2,2*o],bounceX:!0,bounceY:!0,density:1e4*a,dotRadius:[1.2*a,1.2*a],backgroundColor:"#FAFCFD",linkDistance:50+30*a,linkWidth:a}),e=function(){var i,a;return $(".spinner").remove(),$(".skills").css("opacity","1"),$(".location").css("opacity","1"),i=$(".card").height(),a=$(".footer").height(),$(".card").css({marginTop:-(i/2)-a}),$(".container").css({minHeight:i+a+100+40}),$.os.phone?$(".container").css({minHeight:i+a+50}):void 0},n=window.location.pathname.split("/").pop(),i="http://park.catchchatchina.com/api/v1/users/"+n+"/profile?callback=?",$.getJSON(i,function(i){var a,o,n,t,r,s,c,l,d,h;$(".avatar").css("background-image","url("+i.avatar_url+")"),$(".badge").css("background-image","url(../img/badge/"+i.badge+".png)"),$(".nickname").html(i.nickname),$(".intro").html(i.introduction),r=new BMap.Point(i.longitude,i.latitude),a=new BMap.Geocoder,a.getLocation(r,function(i){return $(".location").html(i.addressComponents.city)}),s=i.providers;for(t in s)if(h=s[t],null!==h)switch(o=$("."+t),o.css("display","inline-block"),t){case"github":o.attr("href",h.user.html_url);break;case"dribbble":o.attr("href",h.user.html_url);break;case"instagram":o.attr("href","这里还没好")}c=i.master_skills;for(n in c)d=c[n],$(".master").append($("<div>").addClass("skill").html(d.name));l=i.learning_skills;for(n in l)d=l[n],$(".learn").append($("<div>").addClass("skill").html(d.name));return e()}),$.os.android&&$(".ios").remove(),$.os.ios&&$(".android").remove(),$.os.phone&&($("#zodiac").remove(),$(".container").css({width:"100%",height:"100%",margin:0,left:0}),$(".card").css({padding:"50px 20px",width:"100%",boxShadow:"none",top:0}),$(".footer").css({width:"100%",padding:"0 20px"}))}).call(this);