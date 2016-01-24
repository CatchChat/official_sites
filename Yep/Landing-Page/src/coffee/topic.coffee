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

topic_pswpItems = []
msg_pswpItems = []
pswpItems = []

viewImage = (pswpItems, pswpIndex, thumbnailElements) ->
  pswpElement = $('.pswp')[0]

  pswpOptions = {
    index: pswpIndex
    showHideOpacity: true
    history: false
    bgOpacity: 0.9
    getThumbBoundsFn: (index)->
      thumbnail = thumbnailElements[index]
      pageYScroll = window.pageYOffset || document.documentElement.scrollTop
      rect = thumbnail.getBoundingClientRect()
      return {x:rect.left, y:rect.top + pageYScroll, w:rect.width}
  }

  topc_gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, pswpItems, pswpOptions)
  delay 10, -> topc_gallery.init()

# --- VARIABLES ---
base64Prefix = "data:image/jpeg;base64,"












$ ->
# --- DATA RENDERING ---
  url = "https://api.soyep.com/v1/circles/shared_messages"
  param = "?token=" + $.url("?token") + "&callback=?"

  $.getJSON url + param, (response) ->
    circle = response.circle
    topic = response.topic
    messages = response.messages
    kind = topic.kind

    # Avatar
    $(".topic .avatar").css "background-image", "url(#{topic.user.avatar.thumb_url})"
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
      when "text"
        $(".topic .text").show()
      when "image"
        # Image Tumbnails
        for topic_attachment in topic.attachments
          topic_metadata = $.parseJSON topic_attachment.metadata
          topic_thumbnail = base64Prefix + topic_metadata.thumbnail_string
          $("<div/>", class: "thumbnail")
            .css "background-image", "url(#{topic_thumbnail})"
            .appendTo(".images .thumbnails")

          topic_pswpItem = {
            msrc: topic_thumbnail
            src:  topic_attachment.file.url
            w:    topic_metadata.image_width
            h:    topic_metadata.image_height
          }
          topic_pswpItems.push topic_pswpItem
        $(".topic .images").show()
        # Image Gallery
        $(".topic .images .thumbnails .thumbnail").on "tap", ->
          viewImage(topic_pswpItems, $(this).index(), $(".topic .images .thumbnails .thumbnail"))


      # when "video"
      when "audio"
        audio_attachment = topic.attachments[0]
        audio_metadata = $.parseJSON audio_attachment.metadata

        audio_duration = Math.round audio_metadata.audio_duration
        audio_element = $("<audio controls>", src: audio_attachment.file.url, preload: "auto")
        audio_element.append $("<source>", src: audio_attachment.file.url, type: "audio/mpeg")

        content = $(".topic .audio .player")
        content.append audio_element

        content.append $("<button/>")
        content.append $("<progress/>", max: 100, value: 0).css "width", "#{audio_duration * 20}px"
        content.append $("<label/>").html("#{audio_duration}″")

        content.parent().show()

      when "location"
        location_attachment = topic.attachments[0]

        map =
          key: "P8qeoPmMSc6FKpMvbLKWVrR0"
          lng: location_attachment.longitude
          lat: location_attachment.latitude
          place: location_attachment.place
          width: 200
          height: 100 - 20
          zoom: 16

        map.img = "https://api.map.baidu.com/staticimage?center=#{map.lng},#{map.lat}&width=#{map.width}&height=#{map.height}&zoom=#{map.zoom}&ak=#{map.key}"
        map.url = "https://maps.google.cn/maps?q=#{map.lat},#{map.lng}&z=#{map.zoom}&ll=#{map.lat},#{map.lng}"
        # alternative:
        # map.url = "https://www.google.cn/maps/preview/@#{map.lat},#{map.lng},#{map.zoom}z"

        content = $(".topic .location")

        content.attr "href", map.url
        content.attr "target", "_blank"

        mapimg = $("<img/>", src: map.img).css
          width: "#{map.width}px"
          height: "#{map.height}px"
          # backgroundImage: "url(#{map.img})"

        content.append mapimg
        content.append $("<div/>", class: "marker")
        content.css "display", "block"
        if map.place then content.append $("<div/>", class: "place").html map.place


      when "dribbble"
        shot = topic.attachments[0]
        $(".topic .dribbble").show()
        $(".topic .dribbble img.shot").attr "src", shot.media_url
        $(".topic .dribbble a.link").html shot.title
        .attr "href", shot.url
        .attr "target", "_blank"

        pswpItems = [{
          msrc:  shot.media_url
          src:  shot.media_url.replace "_1x.","."
          w:    400*2
          h:    300*2
        }]

        $(".topic .dribbble .shot").on "tap", ->
          viewImage(pswpItems, 0, $(this))

      when "github"
        repo = topic.attachments[0]

        $(".topic .github").css "display", "table"
        .attr "href", repo.url
        .attr "target", "_blank"
        $(".topic .github .name").html repo.name
        $(".topic .github .desc").html repo.description

      # when "apple_music"
      # when "apple_movie"
      # when "apple_ebook"











    # Latest Conversations
    $(".chat").css "padding-top", $(".topic").css "height"

    if messages.length then $(".nomsg").hide()
    else $(".footer .popup").addClass("show")

    for msg in messages

      if msg.deleted
        element = $("<div/>", class: "cell")
        content = $("<div/>", class: "narrator").html(msg.sender.nickname + " recalled a message")
        content.appendTo element
      else
        element = $(".template.cell").clone().removeClass("template")
        content = element.find(".content")

        element.find(".avatar").css "background-image", "url(#{msg.sender.avatar.thumb_url})"
        element.find(".avatar").css "cursor", "pointer" if msg.sender.username
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
            .append $("<img/>", src: msg_attachment.file.thumb_url)
            .css 'background-image', "url(#{msg_img_thumbnail_blur})"


            # Image Gallery - Conversation
            msg_pswpItems.push {
              msrc: msg_attachment.file.thumb_url
              src:  msg_attachment.file.url
              w: msg_img_metadata.image_width
              h: msg_img_metadata.image_height
            }


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

            content.append $("<div/>", class: "marker")
            if map.address then content.append $("<div/>", class: "address").html map.address
        # End of Switch

      element.appendTo(".chat .table")
    # End of Conversation Loop





    # Image Gallery - Conversation
    $(".chat .bubble .image").click ->
    # $(".chat .bubble .image").on "tap", ->
    # Tap is not working at this momment, don't know why.
      viewImage(msg_pswpItems, $(".chat .bubble .image").index($(this)), $(".chat .bubble .image"))




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
    $(".chat .bubble .audio, .topic .audio").on "tap", ->

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
        bar.attr "value", 0

      voice.time ->
        progress = modulate this.time(), 0, this.duration(), 0, 100
        bar.attr "value", progress





    # Parse links
    $(".text").linkify()

    # Clickable @username
    regex_url = new RegExp("(\@)([a-z|0-9|_|\-]+)")
    $(".text").each (idx, ele) ->
      $(ele).html ele.innerHTML.replace(regex_url,"<a href='/$2' target='_blank'>$&</a>")

# --- RESPONSIVE LAYOUT ---
  $(".android").hide() if os.ios
  $(".ios").hide() if os.android


  if "-webkit-backdrop-filter" of document.body.style
    $(".footer").addClass "bfblur"
    $(".container .topic").addClass "bfblur"
    $(".pswp__bg").addClass "bfblur dark"
