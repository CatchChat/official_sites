window.$ = document.querySelectorAll.bind(document)

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

if os.android then $('.ios')[0].style.display = "none"
if os.ios then $('.android')[0].style.display = "none"
$('.buttons')[0].style.display = "block"

if not os.phone and dpr is 1
    $('.container')[0].classList.add('scale')
    $('.buttons')[0].classList.add('scale')







