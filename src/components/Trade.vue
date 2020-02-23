<template lang="pug">
.trade(ref="container")
  .trade-bg.dim
  .trade-confirm(@click="confirmTrade") CONFIRM
  .trade-players
    Player.trade-player(
      v-for="player in players"
      ref="player"
      :key="player.id"
      :class="{'select': isSelectingTrader }"
      :player="player"
      :allowSelect="isSelectingProperties"
      :selected="tradeProps[player.id]"
      @click.native.stop="tradeWith(player.id)"
    )
</template>

<script lang="coffee">
import {mapState, mapGetters} from 'vuex'
import Player from '@/components/Player.vue';
import tradeAnim from '@/assets/animations/trade.coffee';

export default
  components: { Player },
  computed: {
    ...mapState(['currentPlayer']),
    ...mapGetters(['getCurrent']),
    players: ->
      players = @$store.state.players
      temp = players[@currentPlayer]
      players[@currentPlayer] = players[0]
      players[0] = temp
      players
  }
  data: ->
    isTrading: false 
    tradingWith: null
    isSelectingTrader: false
    isSelectingProperties: false
    tradeAnim: tradeAnim
    tradeProps: [[], [], [], []]

  methods:
    expand: ->
      unless @isSelectingTrader or @isSelectingProperties
        @isTrading = true
        @$emit 'dim', true
        @$nextTick ->
          @container.show => @isSelectingTrader = true

    tradeWith: (id) ->
      if @tradingWith is null
        unless id is @currentPlayer
          @tradingWith = id
          @isSelectingTrader = false
          @isSelectingProperties = true
          tradeAnim.movePlayersForTrade @$refs, @currentPlayer, id

    confirmTrade: ->
      @$store.dispatch 'tradeProps',
        player1: @currentPlayer
        player2: @tradingWith
        props1: @tradeProps[@currentPlayer]
        props2: @tradeProps[@tradingWith]
      @$emit 'completed'

  mounted: ->
    console.log 'mounted'
    tradeAnim.show @$refs.player
</script>

<style lang="sass">
.trade
  position: absolute
  top: 0
  left: 0
  width: 100vw
  height: 100vh
  z-index: 4
  transition: background .5s ease-in-out, color .5s ease-in-out
  box-shadow: 0 0 5px rgba(100, 120, 100, .6)
  display: flex
  flex-direction: column
  justify-content: center
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
    z-index: -1
  &-players
    padding: 100px
    position: relative
    display: flex
.select
  transition: all .2s
  &:hover
    transform: scale(1.15)

.dim
  background: rgba(0,0,0, .5)
</style>