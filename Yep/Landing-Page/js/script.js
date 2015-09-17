var dpr, speed;

window.$ = document.querySelectorAll.bind(document);

dpr = window.devicePixelRatio || 1;

speed = 0.1;

new Zodiac('zodiac', {
  dotColor: '#3F87E5',
  linkColor: '#A8DEFF',
  directionX: 0,
  directionY: 0,
  velocityX: [speed / 2, speed * 2],
  velocityY: [speed / 2, speed * 2],
  bounceX: true,
  bounceY: true,
  density: 10000 * dpr,
  dotRadius: [dpr * 1.2, dpr * 1.2],
  backgroundColor: '#FAFCFD',
  linkDistance: 50 + (30 * dpr),
  linkWidth: dpr
});

if (os.android) {
  $('.ios')[0].style.display = "none";
}

if (os.ios) {
  $('.android')[0].style.display = "none";
}

$('.buttons')[0].style.display = "block";

if (!os.phone && dpr === 1) {
  $('.container')[0].classList.add('scale');
  $('.buttons')[0].classList.add('scale');
}
