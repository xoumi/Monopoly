import gsap from 'gsap'

export default tradeAnim =
  appear: (refs) ->
    players = refs.player
    gsap.fromTo players,
      { opacity: 0, y: 30},
      opacity: 1, y: 0, stagger: .1, clearProps: 'all',
    gsap.from refs.action,
      opacity: 0, y: 30
      duration: .5
    gsap.from refs.bg,
      {opacity: 0, duration: .2, ease: 'linear'}

  leave: (refs, done) ->
    players = refs.player
    gsap.to players,
      opacity: 0, y: 30
      stagger: .1, duration: .3
      onComplete: => done()
    gsap.to refs.action,
      opacity: 0, y: '+=30'
      duration: .3
    gsap.to refs.bg,
      opacity: 0, duration: .4, delay: .3, ease: 'linear'

  movePlayersForTrade: ( refs, hide, move ) ->
    ease = 'power3.inOut'
    cr = refs.container.getBoundingClientRect()
    moveCr = move.getBoundingClientRect()
    toMove = cr.width - ( moveCr.width + moveCr.x + 100 )

    gsap.to hide,
      opacity: 0, y: 20, duration: .9, ease: ease, stagger: .1,
      onComplete: => gsap.set hide, {pointerEvents: 'none'}
    gsap.to move,
      x: toMove, duration: .8, ease: ease, delay: .2