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
  density: 10000,
  dotRadius: [2, 2],
  backgroundColor: '#FAFCFD',
  linkDistance: 80,
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

document.title = "Yep - " + username;

$.getJSON(api, function(json) {
  var addSkills, amapKey, amapUrl, icon, key, ref, value;
  $('.spiner').remove();
  $('.avatar').css({
    'display': 'block',
    'background-image': "url(" + json.avatar_url + ")"
  });
  if (json.badge) {
    $('.badge').css({
      'display': 'block',
      'background-image': "url(/img/badge_" + json.badge + ".png)"
    });
  }
  $('.nickname').html(json.nickname);
  document.title = "Yep - " + json.nickname;
  amapKey = "78aaeaa8e19b191499317db67ada8542";
  amapUrl = "https://restapi.amap.com/v3/geocode/regeo?key=" + amapKey + "&location=" + json.longitude + "," + json.latitude;
  $.getJSON(amapUrl, function(response) {
    $(".location").css("display", "inline-block");
    return $(".location").html(response.regeocode.addressComponent.city);
  });
  ref = json.providers;
  for (key in ref) {
    value = ref[key];
    if (value) {
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
  if (json.master_skills) {
    addSkills(".master", json.master_skills);
  }
  if (json.learning_skills) {
    return addSkills(".learning", json.learning_skills);
  }
});
