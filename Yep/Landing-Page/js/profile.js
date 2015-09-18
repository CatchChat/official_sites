var api, dpr, speed, updateCardHeight, username;

dpr = window.devicePixelRatio || 1;

speed = 0.1;

new Zodiac('zodiac', {
  dotColor: '#3F87E5',
  linkColor: '#A8DEFF',
  directionX: 0,
  directionY: 0,
  velocityX: [speed / 2, speed * 2],
  velocityY: [speed / 2, speed * 2],
  bounceX: true,
  bounceY: true,
  density: 10000 * dpr,
  dotRadius: [dpr * 1.2, dpr * 1.2],
  backgroundColor: '#FAFCFD',
  linkDistance: 50 + (30 * dpr),
  linkWidth: dpr
});

updateCardHeight = function() {
  var cardHeight, footHeight;
  $('.spinner').remove();
  $('.skills').css('opacity', '1');
  $('.location').css('opacity', '1');
  cardHeight = $('.card').height();
  footHeight = $('.footer').height();
  $('.card').css({
    marginTop: -(cardHeight / 2) - footHeight
  });
  $('.container').css({
    minHeight: cardHeight + footHeight + 50 * 2 + 20 * 2
  });
  if ($.os.phone) {
    return $('.container').css({
      minHeight: cardHeight + footHeight + 50
    });
  }
};

username = window.location.pathname.split("/")[1];

api = "http://park.catchchatchina.com/api/v1/users/" + username + "/profile?callback=?";

$.getJSON(api, function(json) {
  var geoc, icon, index, key, point, skill, value, _ref, _ref1, _ref2;
  $('.avatar').css('background-image', "url(" + json.avatar_url + ")");
  $('.badge').css('background-image', "url(../Profile/img/badge_" + json.badge + ".png)");
  $('.nickname').html(json.nickname);
  $('.intro').html(json.introduction);
  point = new BMap.Point(json.longitude, json.latitude);
  geoc = new BMap.Geocoder();
  geoc.getLocation(point, function(rs) {
    return $('.location').html(rs.addressComponents.city);
  });
  _ref = json.providers;
  for (key in _ref) {
    value = _ref[key];
    if (value !== null) {
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
          icon.attr("href", "http://instagram.com/" + value.media[0].user.username);
      }
    }
  }
  _ref1 = json.master_skills;
  for (index in _ref1) {
    skill = _ref1[index];
    $('.master').append($('<div>').addClass('skill').html(skill.name));
  }
  _ref2 = json.learning_skills;
  for (index in _ref2) {
    skill = _ref2[index];
    $('.learn').append($('<div>').addClass('skill').html(skill.name));
  }
  return updateCardHeight();
});

if ($.os.android) {
  $('.ios').remove();
}

if ($.os.ios) {
  $('.android').remove();
}

if ($.os.phone) {
  $('#zodiac').remove();
  $('.container').css({
    width: "100%",
    height: "100%",
    margin: 0,
    left: 0
  });
  $('.card').css({
    padding: "50px 20px",
    width: "100%",
    boxShadow: "none",
    top: 0
  });
  $('.footer').css({
    width: "100%",
    padding: "0 20px"
  });
}
