import gsap from 'gsap'

cr = null
export default tradeAnim =
  show: (players, width, height) ->
    players = players.map (e) => e.$el
    gsap.fromTo players,
      { opacity: 0, y: 30},
      opacity: 1, y: 0, stagger: .1, clearProps: 'all',

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
    toMove = cr.width - ( moveCr.width + moveCr.x + 100 )

    gsap.to hide,
      opacity: 0, y: 20, duration: duration, ease: ease, stagger: .1,
      onComplete: => gsap.set hide, {pointerEvents: 'none'}

    gsap.to move,
      x: toMove, duration: .8, ease: ease, delay: .2