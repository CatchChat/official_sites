# --- LOOK AND FEEL ---
new Zodiac 'zodiac',
    dotColor: '#AADBFA'
    linkColor: '#AADBFA'
    directionX: 0
    directionY: 0
    velocityX: [0.2, 0.2]
    velocityY: [0.2, 0.2]
    bounceX: false
    bounceY: false
    density: 10000
    dotRadius: [2, 2]
    backgroundColor: '#FAFCFD'
    linkDistance: 80
    linkWidth: 1

if os.android then $('.ios').remove()
if os.ios then $('.android').remove()

cdn = "https://dn-catchinc.qbox.me"


# --- USER DATA RENDERING ---
username = window.location.pathname.split("/")[1]
api = "https://park.catchchatchina.com/api/v1/users/#{username}/profile?callback=?"

document.title = "Yep - #{username}"

$.getJSON api, (json)->

    # Spiner
    $('.spiner').remove()

    # Avatar
    $('.avatar').css
        'display': 'block'
        'background-image': "url(#{json.avatar_url})"

    # Badge
    if json.badge
        $('.badge').css
            'display': 'block'
            'background-image': "url(#{cdn}/badge_#{json.badge}.png)"

    # Nickname
    $('.nickname').html json.nickname
    document.title = "Yep - #{json.nickname}"

    # Location
    amapKey = "78aaeaa8e19b191499317db67ada8542"
    amapUrl = "https://restapi.amap.com/v3/geocode/regeo?key=#{amapKey}&location=#{json.longitude},#{json.latitude}&callback=?"
    $.getJSON amapUrl, (response)->
        $(".location").css "display", "inline-block"
        $(".location").html response.regeocode.addressComponent.city

    # Links
    for key, value of json.providers
        if value
            icon = $(".#{key}")
            icon.css "display", "inline-block"
            switch key
                when "github"
                    icon.attr "href", value.user.html_url
                when "dribbble"
                    icon.attr "href", value.user.html_url
                when "instagram"
                    icon.attr "href", "https://instagram.com/" + value.media[0].user.username
                # when "behance"
                    # icon.attr "href", value.

    # Introduction
    $('.intro').html json.introduction

    # Skills
    addSkills = (className, data)->
        $(className).css('display', 'block')
        for index, skill of data
            $(className).append $('<div>').addClass('skill').html(skill.name)

    if json.master_skills then addSkills(".master", json.master_skills)
    if json.learning_skills then addSkills(".learning", json.learning_skills)
