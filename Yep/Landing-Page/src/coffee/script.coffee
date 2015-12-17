
scrollTo = (element, to, duration) ->
  if duration <= 0 then return
  difference = to - (element.scrollTop)
  perTick = difference / duration * 10
  setTimeout (->
    element.scrollTop = element.scrollTop + perTick
    if element.scrollTop == to then return
    scrollTo element, to, duration - 10
  ), 10

$.ready().then ->

  swipe_wrap =  $.clone $(".features ul")
  swipe_wrap.classList.add "swipe-wrap"

  slider = $.create "div",
    className: "swipe"
    id: "slider"

  swipe_wrap._.inside slider
  slider._.before $(".features")

  window.mySwipe = new Swipe $('#slider'),
    startSlide: 0
    speed: 0
    auto: 0
    continuous: true
    disableScroll: false
    stopPropagation: false
    callback: (index, elem) ->
      dots = $$(".dots .dot")
      dots.forEach (dot) -> dot.classList.remove "active"
      dots[index].classList.add "active"


  $(".top")._.addEventListener "click", ->
    scrollTo(document.body, 0, 100)

  # --- RESPONSIVE LAYOUT ---
  if os.android then $('.ios').style.display = "none"
  if os.ios then $('.android').style.display = "none"
