$ ->
# --- LOOK AND FEEL ---

# --- RESPONSIVE LAYOUT ---
    $(".android").hide() if os.ios
    $(".ios").hide() if os.android

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

        $(".gallery .slick").slick(
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

        $(".topic .images img").tap ->
            index = $(this).index()
            $(".gallery .slick").slick('slickGoTo', index)
            $(".gallery").fadeIn(100)

        $(".gallery .slick").tap ->
            $(".gallery").fadeOut(100)

        $(".gallery .slick").children().tap -> return false


        # Latest Conversations
        for msg in messages
            console.log msg

            # $("<div/>", class: "cell text").appendTo(".table")

            $(".template.cell.text").clone().appendTo(".table").removeClass("template")








        # $("body").on "touchmove", (e)->
            # e.preventDefault()

  




