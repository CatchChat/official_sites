var modulate;

modulate = function(value, fromLow, fromHigh, toLow, toHigh) {
  var result;
  result = toLow + (((value - fromLow) / (fromHigh - fromLow)) * (toHigh - toLow));
  if (toLow < toHigh) {
    if (result < toLow) {
      return toLow;
    }
    if (result > toHigh) {
      return toHigh;
    }
  } else {
    if (result > toLow) {
      return toLow;
    }
    if (result < toHigh) {
      return toHigh;
    }
  }
  return result;
};

$(function() {
  var param, url;
  url = "https://park.catchchatchina.com/api/v1/circles/shared_messages";
  param = "?token=" + $.url("?token") + "&callback=?";
  $.getJSON(url + param, function(response) {
    var attachment, audio_duration, audio_element, content, element, i, j, len, len1, map, messages, metadata, msg, prefix, ref, topic, topic_attachment, topic_metadata, topic_thumbnail;
    topic = response.topic;
    messages = response.messages;
    $(".topic .avatar").css("background-image", "url(" + topic.user.avatar_url + ")");
    $(".topic .avatar").attr("username", topic.user.username);
    $(".topic .nickname").html(topic.user.nickname);
    $(".topic .time").html($.timeago(topic.circle.created_at * 1000));
    if (!topic.body) {
      $(".topic .text").hide();
    } else {
      $(".topic .text").html(topic.body);
    }
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
        data_src: topic_attachment.file.url,
        data_height: topic_metadata.image_height
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
      $(".gallery .slick .slick-track img").each(function(index, element) {
        $(element).attr("src", $(element).attr("data_src"));
        return $(element).css("height", $(element).attr("data_height") / 2 + "px");
      });
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
    $(".chat").css("padding-top", $(".topic").css("height"));
    for (j = 0, len1 = messages.length; j < len1; j++) {
      msg = messages[j];
      element = $(".template.cell").clone().removeClass("template");
      content = element.find(".content");
      element.find(".avatar").css("background-image", "url(" + msg.sender.avatar_url + ")");
      element.find(".avatar").attr("username", msg.sender.username);
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
          audio_duration = Math.round(metadata.audio_duration);
          audio_element = $("<audio controls>", {
            src: attachment.file.url,
            preload: "auto"
          });
          audio_element.append($("<source>", {
            src: attachment.file.url,
            type: "audio/mpeg"
          }));
          content.addClass("audio").append(audio_element);
          content.addClass("audio").append($("<button/>"));
          content.addClass("audio").append($("<progress/>", {
            max: 100,
            value: 0
          }).css("width", (audio_duration * 20) + "px"));
          content.addClass("audio").append($("<label/>").html(audio_duration + "″"));
          break;
        case "location":
          map = {
            key: "P8qeoPmMSc6FKpMvbLKWVrR0",
            lng: msg.longitude,
            lat: msg.latitude,
            address: msg.text_content,
            width: 200,
            height: 100,
            zoom: 16
          };
          map.img = "http://api.map.baidu.com/staticimage?center=" + map.lng + "," + map.lat + "&width=" + map.width + "&height=" + map.height + "&zoom=" + map.zoom + "&ak=" + map.key;
          map.url = "http://maps.google.com/maps?q=" + map.lat + "," + map.lng + "&z=" + map.zoom + "&ll=" + map.lat + "," + map.lng;
          content.addClass("location").css({
            width: map.width + "px",
            height: map.height + "px",
            backgroundImage: "url(" + map.img + ")"
          });
          content.append($("<div/>").addClass("marker"));
          if (map.address) {
            content.append($("<div/>").addClass("address").html(map.address));
          }
          content.click(function() {
            return window.open(map.url);
          });
      }
      element.appendTo(".table");
    }
    $(".avatar").click(function() {
      var username;
      username = $(this).attr("username");
      if (username) {
        return window.open("http://soyep.com/" + username);
      }
    });
    $(".chat .bubble .image").on("tap", function() {
      var image_src;
      image_src = $(this).find("img").attr("src");
      $(".media.viewer").html($("<img/>", {
        src: image_src
      }));
      $(".media.viewer").fadeIn(100);
      return $(".media.viewer").find("img").toggleClass("show");
    });
    $(".media.viewer").on("tap", function() {
      $(".media.viewer").find("img").toggleClass("show");
      return $(this).fadeOut(100);
    });
    return $(".chat .bubble .audio").on("tap", function() {
      var bar, button, voice;
      voice = $.media($(this).find("audio"));
      button = $(this).find("button");
      bar = $(this).find("progress");
      voice.playPause();
      voice.play(function() {
        return button.addClass("playing");
      });
      voice.pause(function() {
        return button.removeClass("playing");
      });
      voice.ended(function() {
        button.removeClass("playing");
        return voice.stop();
      });
      return voice.time(function() {
        var progress;
        progress = modulate(this.time(), 0, this.duration(), 0, 100);
        return bar.attr("value", progress);
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
