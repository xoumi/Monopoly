import gsap from 'gsap'

export default aucAnim =
  btnEnter : (el) ->
    gsap.fromTo el,
      { opacity: 0, scale: .5 }
      opacity: 1, scale: 1, duration: .5, ease: 'power4.inOut'

  btnLeave : (el, done) ->
    gsap.to el,
      opacity: 0.2, scale: 0, duration: .5, ease: 'power4.inOut'
      onComplete: => done

  showPlayers: (players, bids, done) ->
    gsap.set(players, {opacity: 0})
    setTimeout ->
      gsap.set(players, {opacity: 1})
      cr = players[0].getBoundingClientRect()
      gsap.from bids,
        y: "100%", stagger: .1, delay: .5, duration: .5, ease: 'power3.inOut'
      gsap.from players,
        {
          height: 0, stagger: .1, duration: 1,
          ease: 'power2.inOut',
          onComplete: => done
        }
    ,600
  hidePlayers: (players, done) ->
    gsap.to players,
      height: 0, stagger: .1, duration: .4,
      ease: 'power4.in',
      onComplete: => done


  removeControls: (ref ) ->
    {bids, auc, aucMsg, players} = ref
    gsap.to bids,
      y: "+100%", stagger: .1, duration: 1, ease: 'power4.inOut'
    gsap.to players,
      height: '-=250',
      stagger: .1, delay: .2, duration: 1, ease: 'power4.inOut',
    gsap.to aucMsg,
      scaleX: 0, duration: 1, ease: 'power4.inOut'
    gsap.to auc,
      height: '-=100',
      delay: .5, duration: 1, ease: 'power4.inOut'

  setCardSize : (ref, width, height ) ->
    popup = ref.auc
    closeBtn = ref.close
    cr = popup.getBoundingClientRect()
    ease = 'expo.inOut'
    duration = .8
    wx = window.innerWidth
    wy = window.innerHeight
    x = (wx - width) / 2
    y = (wy - height) / 2

    return
      show: ->
        gsap.fromTo popup,
          x: cr.x - 5, y: cr.y - 5, height: cr.height, width: cr.width
          {
            position: 'absolute',
            x: ''+x, y: ''+y, height , width
            ease, duration
          }

      hide:(callback) ->
        gsap.to closeBtn,
          y: '50%', opacity: 0, duration: duration, ease: 'power4.in'
        gsap.to popup, {
          x: cr.x - 5 , y: cr.y - 5, width: cr.width, height: cr.height,
          duration, ease, delay: .4,
          onComplete: =>
            gsap.set popup,
              position: 'static', x: 0, y: 0
        }
        gsap.delayedCall .8, callback

  getCountdown : (el, duration = 5) =>
    ease = 'power2.inOut'
    animation = gsap.timeline
      paused: true
      delay: .5
      onReverseComplete: => animation.timeScale(1).play()

    animation.to el,
      x: '-100%', duration: duration, ease: ease,
    , .3

  getBidIncrease : (el, change, baseDuration = 1 ) ->
    return (player, amt) =>
      gsap.to el,
        duration: baseDuration + (amt * .01),
        ease: 'power3.out',
        "#{player}": el[player] + amt
        onStart: () => change[player] = true
        onUpdate: () => el[player] = Math.round el[player]
        onComplete: () => change[player] = false