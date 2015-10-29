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
        for attachment in topic.attachments
            metadata = $.parseJSON attachment.metadata
            thumbnail = prefix + metadata.thumbnail_string
            $("<img/>", src: thumbnail).appendTo(".images")


        # Image Gallery
            $("<img/>", src: attachment.file.url).appendTo(".gallery .slick")
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
            $(element).find(".avatar").css "background-image", "url(#{msg.sender.avatar_url})"
            $(element).find(".nickname").html(msg.sender.nickname)

            switch msg.media_type
                when "text"
                    $(element).find(".content").addClass("text").html(msg.text_content)
                
                when "image"
                    attachment = msg.attachments[0]
                    metadata = $.parseJSON attachment.metadata
                    $(element).find(".content").addClass("image").append $("<img/>", src: attachment.file.url)
                
                when "audio"
                    $(element).find(".content").addClass("audio")
                
                when "location"
                    $(element).find(".content").addClass("location")


            $(element).appendTo(".table")

        # Viewer - Image
        $(".chat .bubble .image").on "tap", ->
            src = $(this).find("img").attr "src"

            # $("<img/>", src: src).appendTo(".media.viewer")
            $(".media.viewer").html($("<img/>", src: src))
            $(".media.viewer").fadeIn(100)
            $(".media.viewer").find("img").toggleClass("show")

        $(".media.viewer").on "tap", ->
            $(".media.viewer").find("img").toggleClass("show")
            $(this).fadeOut(100)


# --- RESPONSIVE LAYOUT ---
    $(".android").hide() if os.ios
    $(".ios").hide() if os.android






  




