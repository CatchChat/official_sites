
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

  window.screenshots = new Swipe $('#screen'),
    speed: 300
    auto: 3000

  swipe_wrap =  $.clone $(".features ul")
  swipe_wrap.classList.add "swipe-wrap"

  slider = $.create "div",
    className: "swipe"
    id: "slider"

  $.inside swipe_wrap, slider
  $.before slider, $(".features")

  window.features = new Swipe $('#slider'),
    speed: 300
    auto: if os.phone then 0 else 3000
    callback: (index, elem) ->
      dots = $$(".dots .dot")
      dot.classList.remove "active" for dot in dots
      dots[index].classList.add "active"


  $(".top").addEventListener "click", ->
    scrollTo(document.body, 0, 100)

  # --- RESPONSIVE LAYOUT ---
  if os.android then $('.ios').style.display = "none"
  if os.ios then $('.android').style.display = "none"
