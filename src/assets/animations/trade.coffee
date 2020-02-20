import gsap from 'gsap'

cr = null
export default tradeAnim =
  setContainer: (ref, width, height) ->
    cr = ref.container.getBoundingClientRect()
    ease = 'power4.inOut'
    duration = .8
    wx = window.innerWidth
    wy = window.innerHeight
    x = (wx - width) / 2
    y = (wy - height) / 2

    return
      show: (callback) ->
        players = ref.player.map (e) => e.$el
        gsap.fromTo ref.container,
          x: cr.x - 5, y: cr.y - 5, height: cr.height, width: cr.width
          {
            position: 'absolute',
            x: ''+x, y: ''+y, height , width
            ease, duration
          }
        gsap.fromTo players,
          { opacity: 0, y: 30},
          {
            opacity: 1, y: 0, stagger: .1, delay: .6, clearProps: 'all',
            onComplete: => callback()
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

  movePlayersForTrade: (ref, current, tradeWith) ->
    players = ref.player
    cr = ref.container.getBoundingClientRect()
    duration = .5
    ease = 'power3.inOut'
    move = null
    hide = []

    players.forEach (player) =>
      el = player.$el
      if player.$vnode.key is tradeWith then move = el
      else if player.$vnode.key isnt current then hide.push el

    moveCr = move.getBoundingClientRect()
    toMove = cr.width - moveCr.width + cr.x - moveCr.x - 20
    gsap.to hide,
      {opacity: 0, y: 20, duration, ease, stagger: .1,
      onComplete: => gsap.set hide, {pointerEvents: 'none'}
      }
    gsap.to move,
      {x: toMove, duration: .8, ease, delay: .2}