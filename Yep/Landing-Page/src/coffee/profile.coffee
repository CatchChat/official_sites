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
    density: 6000
    dotRadius: [2, 2]
    backgroundColor: '#FAFCFD'
    linkDistance: 50
    linkWidth: 1


# --- USER DATA RENDERING ---
username = window.location.pathname.split("/")[1]
api = "https://park.catchchatchina.com/api/v1/users/#{username}/profile?callback=?"

$.getJSON api, (json)->

    # Spiner
    $('.spiner').remove()

    # Avatar
    $('.avatar').css
        'display': 'block'
        'background-image': "url(#{json.avatar_url})"
        
    # Badge
    if json.badge?
        $('.badge').css
            'display': 'block'
            'background-image': "url(/img/badge_#{json.badge}.png)"

    # Nickname
    $('.nickname').html json.nickname

    # Location
    BDMapKey = "P8qeoPmMSc6FKpMvbLKWVrR0"
    BDMapUrl = "https://api.map.baidu.com/api?v=2.0&ak=" + BDMapKey
    $.ajax
        url: BDMapUrl
        converters: 'text script': (text)-> return text
        success: (response)->
            result = response.replace("http://", "https://")
            regex = /(.*)(javascript" src=")(.*)(\"\>\<\/script\>\'\)\;\}\)\(\)\;)/
            script = result.replace regex, "$3"

            $.getScript script, ->            
                time = new Date()
                window.BMap_loadScriptTime = time.getTime()
                point = new BMap.Point(json.longitude, json.latitude)
                geoc = new BMap.Geocoder()
                geoc.getLocation point, (rs)->
                    $('.location').html(rs.addressComponents.city)

    # Links
    for key, value of json.providers
        if value?
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

    if json.master_skills? then addSkills(".master", json.master_skills)
    if json.learning_skills? then addSkills(".learning", json.learning_skills)

