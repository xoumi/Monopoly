<template lang="pug">
transition(@appear="appear" @leave="leave")
  .trade(ref="container")
    .trade-bg(ref="bg")
    .trade-players
      .trade-player-controls(
          v-for="(player, i) in players"
          :key="player.id"
          ref="player"
      )
        Player.trade-player(
          :class="{'select': state == 'selectingTrader' && i != 0 }"
          :player="player"
          :allowSelect="state == 'selectingProperty'"
          :selected="tradeProps[player.id]"
          @click.native.stop="tradeWith(player.id, i)"
          style="margin: 0 30px"
        )

    .button.trade-action(ref="action" :style="{background: actionCSS}")
      transition(name="slidefade" mode="out-in")
        .action(key="confirm" v-if="state == 'selectingProperty'" @click="confirmTrade") CONFIRM
        .action(key="cancel" v-else @click="closeTrade") {{ btnText }}
</template>

<script lang="coffee">
import {mapState, mapGetters} from 'vuex'
import Player from '@/components/PlayerDetails.vue';
import tradeAnim from '@/assets/animations/trade.coffee';

export default
  components: { Player },
  computed: {
    ...mapState(['currentPlayer']),
    ...mapGetters(['getCurrent']),
    players: ->
      players = [...@$store.state.players]
      temp = players[@currentPlayer]
      players[@currentPlayer] = players[0]
      players[0] = temp
      players
    btnText: ->
      if @state != 'complete' then "CANCEL" else "DONE" 
    actionCSS: ->
      color = ''
      if @state is 'selectingProperty' then color = 'skyblue'
      else if @state is 'selectingTrader' then color = 'lightcoral'
      if @state is 'complete' then color = 'mediumaquamarine'
      color
  }
  data: ->
    tradingWith: null
    state: 'selectingTrader'
    tradeComplete: false
    tradeAnim: tradeAnim
    tradeProps: [[], [], [], []]

  methods:
    expand: ->
      unless @isSelectingTrader or @isSelectingProperties
        @isTrading = true
        @$emit 'dim', true
        @$nextTick ->
          @container.show => @isSelectingTrader = true

    tradeWith: (id, i) ->
      if @tradingWith is null
        unless id is @currentPlayer
          @tradingWith = id
          @state = 'selectingProperty'
          @movePlayersForTrade i

    movePlayersForTrade: (i) ->
      players = @$refs.player
      move = null; hide = []

      players.forEach (player, index) =>
        if index is i then move = player
        else if index not in [0, i] then hide.push player
      tradeAnim.movePlayersForTrade @$refs, hide, move

    confirmTrade: ->
      @$store.dispatch 'tradeProps',
        player1: @currentPlayer
        player2: @tradingWith
        props1: @tradeProps[@currentPlayer]
        props2: @tradeProps[@tradingWith]
      @state = 'complete'

    closeTrade: ->
      @$emit 'completed'

    appear: ->
      tradeAnim.appear @$refs
    leave: (el, done) ->
      tradeAnim.leave @$refs, done
</script>

<style lang="sass">
.trade
  position: absolute
  top: 0
  left: 0
  width: 100vw
  height: 100vh
  z-index: 4
  background: transparent
  transition: background .5s ease-in-out, color .5s ease-in-out
  box-shadow: 0 0 5px rgba(100, 120, 100, .6)
  display: flex
  justify-content: center
  align-items: center
  &-label
    font-weight: bold
    color: white
    font-size: 4em
    position: absolute
    top: 10%
    left: 50%
    transform: translateX(-50%)
  &-bg
    position: fixed
    top: 0
    left: 0
    width: 100%
    height: 100%
    transition: background .5s
    background: #000
    z-index: -1
    opacity: .5
  &-players
    padding: 100px
    width: 100vw
    position: relative
    display: grid
    grid-template-columns: 1fr 1fr 1fr 1fr
  &-action
    height: auto !important
    position: absolute
    bottom: 15%
    
.select
  transition: all .2s
  &:hover
    transform: scale(1.05)

.trade .button
  transition: filter .5s, box-shadow .3s, background 1s
.trade .action
  padding: 20px 0
</style>