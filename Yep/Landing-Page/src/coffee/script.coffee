
scrollTo = (element, to, duration) ->
  if duration <= 0 then return
  difference = to - (element.scrollTop)
  perTick = difference / duration * 10
  setTimeout (->
    element.scrollTop = element.scrollTop + perTick
    if element.scrollTop == to then return
    scrollTo element, to, duration - 10
  ), 10


$ ->
  window.screenshots = new Swipe $('#screen')[0],
    speed: 300
    auto: 3000

  $("<div />",
    class: "swipe"
    id: "slider"
  ).insertBefore $(".features")

  $(".features ul")
    .clone()
    .addClass("swipe-wrap")
    .appendTo(slider)

  window.features = new Swipe $('#slider')[0],
    speed: 300
    auto: if os.phone then 0 else 3000
    transitionEnd: (index, elem) ->
      $(".dot").removeClass "active"
      $(".dot").eq(index).addClass "active"


  $(".top").on "click", ->
    scrollTo(document.body, 0, 100)

  # $(".ghbtns")
    # .clone()
    # .appendTo ".hero"

  # --- RESPONSIVE LAYOUT ---
  $(".android").hide() if os.ios
  $(".ios").hide() if os.android
