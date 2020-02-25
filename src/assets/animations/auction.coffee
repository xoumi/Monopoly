import gsap from 'gsap'

export default aucAnim =
  appear: (refs, bids, done) ->
    gsap.from refs.bids,
      y: "100%", stagger: .1, delay: .5, duration: .5, ease: 'power3.inOut'
    gsap.to refs.bg,
      opacity: .7, duration: .3, ease: 'linear'
    gsap.from refs.players,
      height: 0, stagger: .1, duration: 1,
      ease: 'power2.inOut',

  leave: (refs, callback) ->
    gsap.to refs.players,
      height: 0, stagger: .1, duration: .5,
      ease: 'power4.inOut',
      onComplete: => callback()
    gsap.to refs.close,
      opacity: 0, y: '100%', duration: .5,
      ease: 'power4.in'
    gsap.to refs.bg,
      opacity: 0, duration: .5, ease: 'linear'


  removeControls: (ref ) ->
    {bids, auc, aucMsg, players} = ref
    gsap.to bids,
      y: "+100%", stagger: .1, duration: 1, ease: 'power4.inOut'
    gsap.to players,
      height: '-=200',
      stagger: .1, delay: .2, duration: 1, ease: 'power4.inOut',
    gsap.to aucMsg,
      scaleX: 0, duration: 1, ease: 'power4.inOut'

  getCountdown : (el, duration = 5) =>
    ease = 'power2.inOut'
    animation = gsap.timeline
      paused: true
      delay: .5
      onReverseComplete: => animation.timeScale(1).play()

    animation.to el,
      x: '-100%', duration: duration, ease: ease,
    , .3