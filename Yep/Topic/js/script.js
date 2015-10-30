$(function() {
  var param, url;
  url = "https://park.catchchatchina.com/api/v1/circles/shared_messages";
  param = "?token=" + $.url("?token") + "&callback=?";
  $.getJSON(url + param, function(response) {
    var attachment, audio_element, content, duration, element, i, j, len, len1, messages, metadata, msg, prefix, ref, topic, topic_attachment, topic_metadata, topic_thumbnail;
    topic = response.topic;
    messages = response.messages;
    $(".topic .avatar").css("background-image", "url(" + topic.user.avatar_url + ")");
    $(".topic .nickname").html(topic.user.nickname);
    $(".topic .time").html($.timeago(topic.circle.created_at * 1000));
    $(".topic .text").html(topic.body);
    prefix = "data:image/jpeg;base64,";
    ref = topic.attachments;
    for (i = 0, len = ref.length; i < len; i++) {
      topic_attachment = ref[i];
      topic_metadata = $.parseJSON(topic_attachment.metadata);
      topic_thumbnail = prefix + topic_metadata.thumbnail_string;
      $("<img/>", {
        src: topic_thumbnail
      }).appendTo(".images");
      $("<img/>", {
        src: topic_attachment.file.url
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
      content = element.find(".content");
      element.find(".avatar").css("background-image", "url(" + msg.sender.avatar_url + ")");
      element.find(".nickname").html(msg.sender.nickname);
      attachment = msg.attachments[0];
      metadata = attachment ? $.parseJSON(attachment.metadata) : void 0;
      switch (msg.media_type) {
        case "text":
          content.addClass("text").html(msg.text_content);
          break;
        case "image":
          content.addClass("image").append($("<img/>", {
            src: attachment.file.url
          }));
          break;
        case "audio":
          duration = metadata.audio_duration;
          audio_element = $("<audio controls>", {
            src: attachment.file.url
          });
          audio_element.append($("<source>", {
            src: attachment.file.url,
            type: "audio/mp4"
          }));
          content.addClass("audio").append(audio_element);
          content.addClass("audio").append($("<button/>"));
          content.addClass("audio").append($("<progress/>", {
            max: 10,
            value: 5
          }));
          content.addClass("audio").append($("<label/>").html("10″"));
          break;
        case "location":
          content.addClass("location");
      }
      element.appendTo(".table");
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
    $(".media.viewer").on("tap", function() {
      $(".media.viewer").find("img").toggleClass("show");
      return $(this).fadeOut(100);
    });
    return $(".chat .bubble .audio").on("tap", function() {
      var button, time, voice;
      voice = $(this).find("audio");
      button = $(this).find("button");
      time = voice.prop("currentTime");
      if (time === 0) {
        voice.trigger("play");
        button.addClass("playing");
      } else {
        voice.trigger("pause");
        button.removeClass("playing");
        voice.prop("currentTime", 0);
      }
      return voice.on("ended", function() {
        button.removeClass("playing");
        return voice.prop("currentTime", 0);
      });
    });
  });
  if (os.ios) {
    $(".android").hide();
  }
  if (os.android) {
    return $(".ios").hide();
  }
});
