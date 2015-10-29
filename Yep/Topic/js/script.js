$(function() {
  var param, url;
  if (os.ios) {
    $(".android").hide();
  }
  if (os.android) {
    $(".ios").hide();
  }
  url = "https://park.catchchatchina.com/api/v1/circles/shared_messages";
  param = "?token=" + $.url("?token") + "&callback=?";
  return $.getJSON(url + param, function(response) {
    var attachment, element, i, j, len, len1, messages, metadata, msg, prefix, ref, results, thumbnail, topic;
    topic = response.topic;
    messages = response.messages;
    $(".topic .avatar").css("background-image", "url(" + topic.user.avatar_url + ")");
    $(".topic .nickname").html(topic.user.nickname);
    $(".topic .time").html($.timeago(topic.circle.created_at * 1000));
    $(".topic .text").html(topic.body);
    prefix = "data:image/jpeg;base64,";
    ref = topic.attachments;
    for (i = 0, len = ref.length; i < len; i++) {
      attachment = ref[i];
      metadata = $.parseJSON(attachment.metadata);
      thumbnail = prefix + metadata.thumbnail_string;
      $("<img/>", {
        src: thumbnail
      }).appendTo(".images");
      $("<img/>", {
        src: attachment.file.url
      }).appendTo(".gallery .slick");
    }
    $(".gallery .slick").slick({
      speed: 200,
      centerPadding: '10%',
      centerMode: true,
      dots: true,
      arrows: false,
      mobileFirst: true,
      focusOnSelect: true,
      responsive: [
        {
          breakpoint: 1024,
          settings: {
            centerPadding: '30%'
          }
        }
      ]
    }).on('setPosition', function() {
      return $(".slick-list").css("top", ($(".gallery").height() - $(".slick-list").height()) / 2);
    });
    $(".topic .images img").tap(function() {
      var index;
      index = $(this).index();
      $(".gallery .slick").slick('slickGoTo', index);
      return $(".gallery").fadeIn(100);
    });
    $(".gallery .slick").tap(function() {
      return $(".gallery").fadeOut(100);
    });
    $(".gallery .slick").children().tap(function() {
      return false;
    });
    results = [];
    for (j = 0, len1 = messages.length; j < len1; j++) {
      msg = messages[j];
      switch (msg.media_type) {
        case "text":
          element = $(".template.cell.text").clone().removeClass("template");
          $(element).find(".avatar").css("background-image", "url(" + msg.sender.avatar_url + ")");
          $(element).find(".nickname").html(msg.sender.nickname);
          $(element).find(".content").html(msg.text_content);
          results.push($(element).appendTo(".table"));
          break;
        default:
          results.push(void 0);
      }
    }
    return results;
  });
});
