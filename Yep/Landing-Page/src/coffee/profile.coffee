# --- LOOK AND FEEL ---

dpr   = window.devicePixelRatio || 1
speed = 0.1

new Zodiac 'zodiac',
    dotColor: '#3F87E5'
    linkColor: '#A8DEFF'
    directionX: 0                     # -1:left;0:random;1:right
    directionY: 0                     # -1:up;0:random;1:down
    velocityX: [speed / 2, speed * 2]               # [minX,maxX]
    velocityY: [speed / 2, speed * 2]               # [minY,maxY]
    bounceX: true                     # bounce at left and right edge
    bounceY: true                     # bounce at top and bottom edge
    # parallax: .5                     # float [0-1...]; 0: no paralax
    # pivot: 1                         # float [0-1...]; pivot level for parallax;
    density: 10000 * dpr                    # px^2 per node
    dotRadius: [dpr * 1.2, dpr * 1.2] # px value or [minR,maxR]
    backgroundColor: '#FAFCFD'        # default transparent; use alpha value for motion blur and ghosting
    linkDistance: 50 + (30 * dpr)
    linkWidth: dpr



updateCardHeight = ->
    $('.spinner').remove()
    $('.skills').css('opacity', '1')
    $('.location').css('opacity', '1')

    cardHeight = $('.card').height()
    footHeight = $('.footer').height()

    $('.card').css
        marginTop: -(cardHeight / 2) - footHeight
    $('.container').css
        minHeight: cardHeight + footHeight + 50 * 2 + 20 * 2

    if $.os.phone
        $('.container').css
            minHeight: cardHeight + footHeight + 50

    $('body').css('height', $('.container').height())


# --- USER DATA RENDERING ---

username = window.location.pathname.split("/")[1]
# username = "kevinzhow"
api = "https://park.catchchatchina.com/api/v1/users/#{username}/profile?callback=?"

$.getJSON api, (json)->
    $('.avatar').css 'background-image', "url(#{json.avatar_url})"
    $('.nickname').html json.nickname
    $('.intro').html json.introduction

    if json.badge is null then $('.badge').css('display', 'none')
    else $('.badge').css 'background-image', "url(/img/badge_#{json.badge}.png)"

    point = new BMap.Point(json.longitude, json.latitude)
    geoc = new BMap.Geocoder()
    geoc.getLocation point, (rs)->
        $('.location').html(rs.addressComponents.city)

    for key, value of json.providers
        if value isnt null
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

    if json.learning_skills < 1 then $('.learn').css('display', 'none')
    else for index, skill of json.learning_skills
        $('.learn').append $('<div>').addClass('skill').html(skill.name)
    
    if json.master_skills < 1 then $('.master').css('display', 'none')
    else for index, skill of json.master_skills
        $('.master').append $('<div>').addClass('skill').html(skill.name)

    updateCardHeight()




# --- RESPONSIVE LAYOUT ---

if $.os.android then $('.ios').remove()
if $.os.ios then $('.android').remove()

if $.os.phone
    $('#zodiac').remove()
    $('.container').css
        width: "100%"
        height: "100%"
        margin: 0
        left: 0
    $('.card').css
        padding: "50px 20px"
        width: "100%"
        boxShadow: "none"
        top: 0
    $('.footer').css
        width: "100%"
        padding: "0 20px"





