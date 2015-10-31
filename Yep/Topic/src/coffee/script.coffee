# --- UTILITY FUNCTIONS ---
modulate = (value, rangeA, rangeB, limit=false) ->

    [fromLow, fromHigh] = rangeA
    [toLow, toHigh] = rangeB

    result = toLow + (((value - fromLow) / (fromHigh - fromLow)) * (toHigh - toLow))

    if limit is true
        if toLow < toHigh
            return toLow if result < toLow
            return toHigh if result > toHigh
        else
            return toLow if result > toLow
            return toHigh if result < toHigh
    result













$ ->

# --- DATA RENDERING ---
    url = "https://park.catchchatchina.com/api/v1/circles/shared_messages"
    param = "?token=" + $.url("?token") + "&callback=?"

    $.getJSON url + param, (response) ->
        topic = response.topic
        messages = response.messages

        # Avatar
        $(".topic .avatar").css "background-image", "url(#{topic.user.avatar_url})"

        # Nickname
        $(".topic .nickname").html topic.user.nickname

        # Time
        $(".topic .time").html $.timeago(topic.circle.created_at * 1000)

        # Text
        $(".topic .text").html topic.body

        # Image Tumbnails
        prefix = "data:image/jpeg;base64,"          
        for topic_attachment in topic.attachments
            topic_metadata = $.parseJSON topic_attachment.metadata
            topic_thumbnail = prefix + topic_metadata.thumbnail_string
            $("<img/>", src: topic_thumbnail).appendTo(".images")


        # Image Gallery
            $("<img/>", src: topic_attachment.file.url).appendTo(".gallery .slick")
            # End of for loop

        $(".viewer.gallery .slick").slick(
            speed: 200
            centerPadding: '10%'
            centerMode: true
            dots: true
            arrows: false
            mobileFirst: true
            focusOnSelect: true
            responsive: [
                breakpoint: 1024
                settings:
                   centerPadding: '30%'
            ]
            ).on 'setPosition', ->
                # Center align vertically
                $(".slick-list").css "top", ($(".gallery").height() - $(".slick-list").height()) / 2

        $(".topic .images img").on "tap", ->
            index = $(this).index()
            $(".gallery .slick").slick('slickGoTo', index)
            $(".gallery").fadeIn(100)
            $(".gallery .slick").toggleClass("show")


        $(".viewer.gallery .slick").on "tap", ->
            $(".gallery").fadeOut(100)
            $(".gallery .slick").toggleClass("show")

        $(".viewer.gallery .slick").children().on "tap", -> return false


        # Latest Conversations
        for msg in messages

            element = $(".template.cell").clone().removeClass("template")
            content = element.find(".content")

            element.find(".avatar").css "background-image", "url(#{msg.sender.avatar_url})"
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
                    audio_element = $("<audio controls>", src: attachment.file.url)
                    audio_element.append $("<source>", src: attachment.file.url, type: "audio/mp4")
                    
                    content.addClass("audio").append audio_element

                    content.addClass("audio").append $("<button/>")
                    content.addClass("audio").append $("<progress/>", max: 100, value: 0).css "width", "#{audio_duration * 20}px"
                    content.addClass("audio").append $("<label/>").html("#{audio_duration}″")

                when "location"
                    content.addClass("location")

            element.appendTo(".table")

        # Viewer - Image
        $(".chat .bubble .image").on "tap", ->
            image_src = $(this).find("img").attr "src"

            $(".media.viewer").html($("<img/>", src: image_src))
            $(".media.viewer").fadeIn(100)
            $(".media.viewer").find("img").toggleClass("show")

        $(".media.viewer").on "tap", ->
            $(".media.viewer").find("img").toggleClass("show")
            $(this).fadeOut(100)

        # Player - Voice
        $(".chat .bubble .audio").on "click", ->

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
                progress = modulate this.time(), [0,this.duration()], [0,100], true
                bar.attr "value", progress


# --- RESPONSIVE LAYOUT ---
    $(".android").hide() if os.ios
    $(".ios").hide() if os.android





