window.$ = document.querySelectorAll.bind(document)

# --- LOOK AND FEEL ---

window.mySwipe = new Swipe $('#slider')[0],
  startSlide: 0
  speed: 0
  auto: 0
  continuous: true
  disableScroll: false
  stopPropagation: false



# --- RESPONSIVE LAYOUT ---
# if os.android then $('.ios')[0].style.display = "none"
# if os.ios then $('.android')[0].style.display = "none"
