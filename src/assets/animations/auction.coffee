import gsap from 'gsap'

export default aucAnim =
  enter : (el) ->
    gsap.fromTo el,
      { opacity: 0, scale: .5 }
      opacity: 1, scale: 1, duration: .5, ease: 'power4.in'

  leave : (el, done) ->
    gsap.to el,
      opacity: 0.2, scale: 0, duration: .5, ease: 'power4.in'
      onComplete: => done

  playerEnter: (players, bids, done) ->
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
  playerLeave: (players, done) ->
    gsap.to players,
      height: 0, stagger: .1, duration: .7,
      ease: 'power4.in',
      onComplete: => done
    
    

  removeBid: (player, bids, auc) ->
    gsap.to bids,
      y: "+100%", stagger: .1, duration: 1, ease: 'power4.inOut'

    gsap.to player,
      height: '-=250',
      stagger: .1, delay: .2, duration: 1, ease: 'power4.inOut',

    gsap.to auc,
      height: '-=100',
      delay: .5, duration: 1, ease: 'power4.inOut'
      
  getReveal : (el, width, height ) ->
    cr = el.getBoundingClientRect()
    ease = 'expo.inOut'
    duration = .8
    wx = window.innerWidth
    wy = window.innerHeight
    x = (wx - width) / 2
    y = (wy - height) / 2

    return (direction) ->
      if direction is 'forwards'
        gsap.fromTo el,
          { x: cr.x - 5, y: cr.y - 5, height: cr.height, width: cr.width}
          {
            position: 'absolute',
            x: ''+x, y: ''+y, height , width
            ease, duration
          }

      else if direction is 'backwards'
        gsap.to el, {
          x: cr.x - 5 , y: cr.y - 5, width: cr.width, height: cr.height,
          duration, ease, delay: .7,
          onComplete: => gsap.set el,
            position: 'static', x: 0, y: 0
        }

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