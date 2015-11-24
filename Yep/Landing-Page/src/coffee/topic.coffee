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


$ ->

# --- DATA RENDERING ---
  url = "https://park.catchchatchina.com/api/v1/circles/shared_messages"
  param = "?token=" + $.url("?token") + "&callback=?"

  $.getJSON url + param, (response) ->
    topic = response.topic
    messages = response.messages

    # Avatar
    $(".topic .avatar").css "background-image", "url(#{topic.user.avatar_url})"
    $(".topic .avatar").attr "username", topic.user.username

    # Nickname
    $(".topic .nickname").html topic.user.nickname

    # Time
    $(".topic .time").html $.timeago(topic.circle.created_at * 1000)

    # Text
    if not topic.body
      $(".topic .text").hide()
    else
      $(".topic .text").html topic.body




    # Image Tumbnails
    prefix = "data:image/jpeg;base64,"
    pswpItems = []
    for topic_attachment in topic.attachments
      topic_metadata = $.parseJSON topic_attachment.metadata
      topic_thumbnail = prefix + topic_metadata.thumbnail_string
      $("<img/>", src: topic_thumbnail).appendTo(".images")

      pswpItem = {
        msrc: topic_thumbnail
        src:  topic_attachment.file.url
        w:    topic_metadata.image_width
        h:    topic_metadata.image_height
      }
      pswpItems.push pswpItem
    # End of loop for Tumbnails




    # Image Gallery
    pswpElement = $('.pswp')[0]
    $(".topic .images img").on "tap", ->
      pswpOptions = { index: $(this).index() }
      gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, pswpItems, pswpOptions)
      setTimeout ( ->
        gallery.init()
      ), 10


    # Latest Conversations
    $(".chat").css "padding-top", $(".topic").css "height"

    for msg in messages

      element = $(".template.cell").clone().removeClass("template")
      content = element.find(".content")

      element.find(".avatar").css "background-image", "url(#{msg.sender.avatar_url})"
      element.find(".avatar").attr "username", msg.sender.username

      element.find(".nickname").html(msg.sender.nickname)

      attachment = msg.attachments[0]
      metadata = if attachment then $.parseJSON attachment.metadata else undefined

      switch msg.media_type
        when "text"
          content.addClass("text").html(msg.text_content)

        when "image"
          content.addClass("image")
          .append $("<img/>", src: attachment.file.url)

        when "audio"
          audio_duration = Math.round metadata.audio_duration
          audio_element = $("<audio controls>", src: attachment.file.url, preload: "auto")
          audio_element.append $("<source>", src: attachment.file.url, type: "audio/mpeg")

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
          # map.url = "https://www.google.cn/maps/preview/@#{map.lat},#{map.lng},#{map.zoom}z"
          map.url = "https://maps.google.cn/maps?q=#{map.lat},#{map.lng}&z=#{map.zoom}&ll=#{map.lat},#{map.lng}"


          content.addClass("location").css
            width: "#{map.width}px"
            height: "#{map.height}px"
            backgroundImage: "url(#{map.img})"

          content.append $("<div/>").addClass("marker")
          if map.address then content.append $("<div/>").addClass("address").html map.address

          content.click ->
            window.open map.url




      element.appendTo(".table")

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

    # Viewer - Image
    $(".chat .bubble .image").on "tap", ->
      image_src = $(this).find("img").attr "src"
      viewImage image_src

    $(".media.viewer").on "tap", ->
      $(".media.viewer").find("img").toggleClass("show")
      $(this).fadeOut(100)

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
