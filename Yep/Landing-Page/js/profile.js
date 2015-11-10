var api, username;

new Zodiac('zodiac', {
  dotColor: '#AADBFA',
  linkColor: '#AADBFA',
  directionX: 0,
  directionY: 0,
  velocityX: [0.2, 0.2],
  velocityY: [0.2, 0.2],
  bounceX: false,
  bounceY: false,
  density: 6000,
  dotRadius: [2, 2],
  backgroundColor: '#FAFCFD',
  linkDistance: 50,
  linkWidth: 1
});

if (os.android) {
  $('.ios').remove();
}

if (os.ios) {
  $('.android').remove();
}

username = window.location.pathname.split("/")[1];

api = "https://park.catchchatchina.com/api/v1/users/" + username + "/profile?callback=?";

$.getJSON(api, function(json) {
  var BDMapKey, BDMapUrl, addSkills, icon, key, ref, value;
  $('.spiner').remove();
  $('.avatar').css({
    'display': 'block',
    'background-image': "url(" + json.avatar_url + ")"
  });
  if (json.badge != null) {
    $('.badge').css({
      'display': 'block',
      'background-image': "url(/img/badge_" + json.badge + ".png)"
    });
  }
  $('.nickname').html(json.nickname);
  BDMapKey = "P8qeoPmMSc6FKpMvbLKWVrR0";
  BDMapUrl = "https://api.map.baidu.com/api?v=2.0&ak=" + BDMapKey;
  $.ajax({
    url: BDMapUrl,
    converters: {
      'text script': function(text) {
        return text;
      }
    },
    success: function(response) {
      var regex, result, script;
      result = response.replace("http://", "https://");
      regex = /(.*)(javascript" src=")(.*)(\"\>\<\/script\>\'\)\;\}\)\(\)\;)/;
      script = result.replace(regex, "$3");
      return $.getScript(script, function() {
        var geoc, point, time;
        time = new Date();
        window.BMap_loadScriptTime = time.getTime();
        point = new BMap.Point(json.longitude, json.latitude);
        geoc = new BMap.Geocoder();
        return geoc.getLocation(point, function(rs) {
          $('.location').html(rs.addressComponents.city);
          return $('.location').css("display", "inline-block");
        });
      });
    }
  });
  ref = json.providers;
  for (key in ref) {
    value = ref[key];
    if (value != null) {
      icon = $("." + key);
      icon.css("display", "inline-block");
      switch (key) {
        case "github":
          icon.attr("href", value.user.html_url);
          break;
        case "dribbble":
          icon.attr("href", value.user.html_url);
          break;
        case "instagram":
          icon.attr("href", "https://instagram.com/" + value.media[0].user.username);
      }
    }
  }
  $('.intro').html(json.introduction);
  addSkills = function(className, data) {
    var index, results, skill;
    $(className).css('display', 'block');
    results = [];
    for (index in data) {
      skill = data[index];
      results.push($(className).append($('<div>').addClass('skill').html(skill.name)));
    }
    return results;
  };
  if (json.master_skills != null) {
    addSkills(".master", json.master_skills);
  }
  if (json.learning_skills != null) {
    return addSkills(".learning", json.learning_skills);
  }
});
