<template lang="pug">
.trade(ref="container" @click="expand")
  h1.auction-title TRADE
  button.button.action(@click="confirmTrade") CONFIRM
  .trade-players(v-if="isTrading")
    Player.trade-player(
      v-for="player in players"
      ref="player"
      :key="player.id"
      :class="{'select': isSelectingTrader }"
      :player="player"
      :allowSelect="isSelectingProperties"
      @selected="tradeProps"
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

    tradeProps: ( propIds, id ) ->
      if id is @currentPlayer
        @p1Trading = propIds
      else @p2Trading = propIds

    confirmTrade: ->
      @$store.dispatch 'tradeProps',
        player1: @currentPlayer
        player2: @tradingWith
        props1: @p1Trading
        props2: @p2Trading

  mounted: ->
    @container = tradeAnim.setContainer @$refs, 800, 600
</script>

<style lang="sass">
.trade
  border-radius: 15px
  display: flex
  flex-direction: column
  position: relative
  width: 100%
  z-index: 4
  background: #E2ECDC
  transition: background .5s ease-in-out, color .5s ease-in-out
  box-shadow: 0 0 5px rgba(100, 120, 100, .6)
  &-players
    padding: 20px
    position: relative
    display: flex
.select
  transition: all .2s
  &:hover
    transform: scale(1.05)
</style>