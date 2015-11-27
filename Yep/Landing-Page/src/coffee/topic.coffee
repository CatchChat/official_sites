# --- FUNCTION DECLARE ---
modulate = (value, fromLow, fromHigh, toLow, toHigh) ->
  result = toLow + (((value - fromLow) / (fromHigh - fromLow)) * (toHigh - toLow))
  if toLow < toHigh
    return toLow if result < toLow
    return toHigh if result > toHigh
  else
    return toLow if result > toLow
    return toHigh if result < toHigh
  result

isChinese = -> return window.navigator.language.indexOf("zh") isnt -1

delay = (ms, func) -> setTimeout func, ms





# --- VARIABLES ---
base64Prefix = "data:image/jpeg;base64,"

pswpElement = $('.pswp')[0]
topic_pswpItems = []
msg_pswpItems = []





$ ->
# --- DATA RENDERING ---
  url = "https://park.catchchatchina.com/api/v2/circles/shared_messages"
  param = "?token=" + $.url("?token") + "&callback=?"

  $.getJSON url + param, (response) ->
    circle = response.circle
    topic = response.topic
    messages = response.messages
    kind = topic.kind

    # Avatar
    $(".topic .avatar").css "background-image", "url(#{topic.user.avatar_url})"
    $(".topic .avatar").attr "username", topic.user.username

    # Nickname
    $(".topic .nickname").html topic.user.nickname

    # Time
    $(".topic .time").html $.timeago(circle.created_at * 1000)

    # Text
    if not topic.body then $(".topic .text").hide()
    else $(".topic .text").html topic.body

    if kind isnt "image" then $(".topic .images").remove()

    switch kind
      # when "text"
      when "image"
        # Image Tumbnails
        for topic_attachment in topic.attachments
          topic_metadata = $.parseJSON topic_attachment.metadata
          topic_thumbnail = base64Prefix + topic_metadata.thumbnail_string
          $("<div/>")
          .addClass "thumbnail"
          .css "background-image", "url(#{topic_thumbnail})"
          .appendTo(".images .thumbnails")

          topic_pswpItem = {
            msrc: topic_thumbnail
            src:  topic_attachment.file.url
            w:    topic_metadata.image_width
            h:    topic_metadata.image_height
          }
          topic_pswpItems.push topic_pswpItem

        # Image Gallery
        $(".topic .images .thumbnails .thumbnail").on "tap", ->

          topic_pswpOptions = {
            index: $(this).index()
            showHideOpacity: true
            history: false
            bgOpacity: 0.9
            getThumbBoundsFn: (index)->
              thumbnail = $(".topic .images .thumbnails .thumbnail")[index]
              pageYScroll = window.pageYOffset || document.documentElement.scrollTop
              rect = thumbnail.getBoundingClientRect()
              return {x:rect.left, y:rect.top + pageYScroll, w:rect.width}
          }
          topc_gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, topic_pswpItems, topic_pswpOptions)
          delay 10, -> topc_gallery.init()

      # when "video"
      # when "audio"
      # when "location"
      # when "dribbble"
      # when "github"
      # when "apple_music"
      # when "apple_movie"
      # when "apple_ebook"











    # Latest Conversations
    $(".chat").css "padding-top", $(".topic").css "height"

    for msg in messages

      element = $(".template.cell").clone().removeClass("template")
      content = element.find(".content")

      element.find(".avatar").css "background-image", "url(#{msg.sender.avatar_url})"
      element.find(".avatar").attr "username", msg.sender.username

      element.find(".nickname").html(msg.sender.nickname)

      msg_attachment = msg.attachments[0]
      msg_metadata = if msg_attachment then $.parseJSON msg_attachment.metadata else undefined


      switch msg.media_type
        when "text"
          content.addClass("text").html(msg.text_content)

        when "image"
          msg_img_metadata = $.parseJSON msg_attachment.metadata
          msg_img_thumbnail_blur = base64Prefix + msg_img_metadata.blurred_thumbnail_string

          content.addClass("image")
          .append $("<img/>", src: msg_attachment.file.url)
          .css 'background-image', "url(#{msg_img_thumbnail_blur})"


          # Image Gallery - Conversation
          msg_pswpItem = {
            msrc: msg_img_thumbnail_blur
            src:  msg_attachment.file.url
            w: msg_img_metadata.image_width
            h: msg_img_metadata.image_height
          }
          msg_pswpItems.push msg_pswpItem

        when "audio"
          audio_duration = Math.round msg_metadata.audio_duration
          audio_element = $("<audio controls>", src: msg_attachment.file.url, preload: "auto")
          audio_element.append $("<source>", src: msg_attachment.file.url, type: "audio/mpeg")

          content.addClass("audio").append audio_element

          content.addClass("audio").append $("<button/>")
          content.addClass("audio").append $("<progress/>", max: 100, value: 0).css "width", "#{audio_duration * 20}px"
          content.addClass("audio").append $("<label/>").html("#{audio_duration}″")

        when "location"
          map =
            key: "P8qeoPmMSc6FKpMvbLKWVrR0"
            lng: msg.longitude
            lat: msg.latitude
            address: msg.text_content
            width: 200
            height: 100
            zoom: 16

          map.img = "https://api.map.baidu.com/staticimage?center=#{map.lng},#{map.lat}&width=#{map.width}&height=#{map.height}&zoom=#{map.zoom}&ak=#{map.key}"
          map.url = "https://maps.google.cn/maps?q=#{map.lat},#{map.lng}&z=#{map.zoom}&ll=#{map.lat},#{map.lng}"
          # alternative:
          # map.url = "https://www.google.cn/maps/preview/@#{map.lat},#{map.lng},#{map.zoom}z"

          content.attr "href", map.url
          content.attr "target", "_blank"

          content.addClass("location").css
            width: "#{map.width}px"
            height: "#{map.height}px"
            backgroundImage: "url(#{map.img})"

          content.append $("<div/>").addClass("marker")
          if map.address then content.append $("<div/>").addClass("address").html map.address
      # End of Switch

      element.appendTo(".table")
    # End of Conversation Loop





    # Image Gallery - Conversation
    $(".chat .bubble .image").on "tap", ->
      msg_pswpOptions = {
        index: $(".chat .bubble .image").index($(this))
        showHideOpacity: true
        history: false
        bgOpacity: 0.9
        getThumbBoundsFn: (index)->
          thumbnail = $(".chat .bubble .image")[index]
          pageYScroll = window.pageYOffset || document.documentElement.scrollTop
          rect = thumbnail.getBoundingClientRect()
          return {x:rect.left, y:rect.top + pageYScroll, w:rect.width}
      }
      msg_gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, msg_pswpItems, msg_pswpOptions)
      msg_gallery.init()





    # Click avatar goes to profile
    $(".avatar").click ->
      username = $(this).attr "username"
      if username then window.open "https://soyep.com/" + username





    # Show blue popup bubble when scroll reached the bottom of conversations
    $(document).scroll ->
      if $(this).scrollTop() >= $(this).height() - $(window).height() - 100
        $(".footer .popup").addClass("show")
      else
        $(".footer .popup").removeClass("show")





    # Player - Voice
    $(".chat .bubble .audio").on "tap", ->

      voice = $.media $(this).find("audio")
      button = $(this).find("button")
      bar = $(this).find("progress")

      voice.playPause()

      voice.play ->
        button.addClass("playing")

      voice.pause ->
        button.removeClass("playing")

      voice.ended ->
        button.removeClass("playing")
        voice.stop()

      voice.time ->
        progress = modulate this.time(), 0, this.duration(), 0, 100
        bar.attr "value", progress





# --- RESPONSIVE LAYOUT ---
  $(".android").hide() if os.ios
  $(".ios").hide() if os.android
