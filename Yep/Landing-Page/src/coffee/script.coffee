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






# --- RESPONSIVE LAYOUT ---

# if $.os.android then $('.ios').remove()
# if $.os.ios then $('.android').remove()

# if $.os.phone
#     $('#zodiac').remove()
#     $('.container').css
#         width: "100%"
#         height: "100%"
#         margin: 0
#         left: 0
#     $('.card').css
#         padding: "50px 20px"
#         width: "100%"
#         boxShadow: "none"
#         top: 0
#     $('.footer').css
#         width: "100%"
#         padding: "0 20px"





