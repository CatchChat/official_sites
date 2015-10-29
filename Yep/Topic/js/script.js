$(function() {
  var param, url;
  url = "https://park.catchchatchina.com/api/v1/circles/shared_messages";
  param = "?token=" + $.url("?token") + "&callback=?";
  $.getJSON(url + param, function(response) {
    var attachment, element, i, j, len, len1, messages, metadata, msg, prefix, ref, thumbnail, topic;
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
    $(".viewer.gallery .slick").slick({
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
    $(".topic .images img").on("tap", function() {
      var index;
      index = $(this).index();
      $(".gallery .slick").slick('slickGoTo', index);
      $(".gallery").fadeIn(100);
      return $(".gallery .slick").toggleClass("show");
    });
    $(".viewer.gallery .slick").on("tap", function() {
      $(".gallery").fadeOut(100);
      return $(".gallery .slick").toggleClass("show");
    });
    $(".viewer.gallery .slick").children().on("tap", function() {
      return false;
    });
    for (j = 0, len1 = messages.length; j < len1; j++) {
      msg = messages[j];
      element = $(".template.cell").clone().removeClass("template");
      $(element).find(".avatar").css("background-image", "url(" + msg.sender.avatar_url + ")");
      $(element).find(".nickname").html(msg.sender.nickname);
      switch (msg.media_type) {
        case "text":
          $(element).find(".content").addClass("text").html(msg.text_content);
          break;
        case "image":
          attachment = msg.attachments[0];
          metadata = $.parseJSON(attachment.metadata);
          $(element).find(".content").addClass("image").append($("<img/>", {
            src: attachment.file.url
          }));
          break;
        case "audio":
          $(element).find(".content").addClass("audio");
          break;
        case "location":
          $(element).find(".content").addClass("location");
      }
      $(element).appendTo(".table");
    }
    $(".chat .bubble .image").on("tap", function() {
      var src;
      src = $(this).find("img").attr("src");
      $(".media.viewer").html($("<img/>", {
        src: src
      }));
      $(".media.viewer").fadeIn(100);
      return $(".media.viewer").find("img").toggleClass("show");
    });
    return $(".media.viewer").on("tap", function() {
      $(".media.viewer").find("img").toggleClass("show");
      return $(this).fadeOut(100);
    });
  });
  if (os.ios) {
    $(".android").hide();
  }
  if (os.android) {
    return $(".ios").hide();
  }
});
