# --- LOOK AND FEEL ---



swipe_wrap =  $.clone $(".container ul")
swipe_wrap.classList.add "swipe-wrap"

slider = $.create "div",
  className: "swipe"
  id: "slider"

swipe_wrap._.inside slider
slider._.before $(".container")

window.mySwipe = new Swipe $('#slider'),
  startSlide: 0
  speed: 0
  auto: 0
  continuous: true
  disableScroll: false
  stopPropagation: false
  callback: (index, elem) ->
    console.log index



# --- RESPONSIVE LAYOUT ---
# if os.android then $('.ios')[0].style.display = "none"
# if os.ios then $('.android')[0].style.display = "none"
