<template lang="pug">
.board
  //Log
  Log

  //Buy, Pay, End
  .center.action(
    :style="{background: players[currentPlayer].color}"
  )
    transition(name="pop2" mode="out-in")
      .button(@click="roll" v-if="rollBtn" key="roll") 
        h1.button-label ROLL
      .button.buy(@click="buy" v-if="buyBtn" key="buy")
        h1.button-label BUY for ${{getRent(getCurrent.pos)}}
      .button.end(@click="endTurn" v-if="endBtn" key="end")
        h1.button-label END TURN
      PayBtn.button(
        key="pay" @click="pay" v-if="payBtn"
        :from="fromCSS" :to="toCSS" :cost="getRent(getCurrent.pos)"
      )

  //Players
  simplebar.players
    Player(
      v-for="player in players"
      :key="player.id"
      :player="player" :properties="true"
      )

  //Tiles
  Tile(
    v-for="(i, index) in tiles"
    :key="i.name" :data="i"
    :style="{gridArea: `t${index}`}"
    )

  .board-bg(
    :class="{dim}"
  )

  Auction.bottom(
    key="auction" v-if="auctionBtn" @click="auction" @dim="setDim"
    )
    //
      .action.button.bottom.trade(key="trade" v-if="rollBtn")
        h1.bottom-label TRADE

</template>

<script lang="coffee">
import { mapState, mapGetters } from 'vuex';
import simplebar from 'simplebar-vue';
import 'simplebar/dist/simplebar.min.css';
import Tile from '@/components/Tile.vue';
import Player from '@/components/Player.vue';
import Log from '@/components/Log.vue';
import PayBtn from '@/components/PayBtn.vue';
import Auction from '@/components/Auction.vue';

export default
  components: { Tile, Player, Log, simplebar, PayBtn, Auction }

  data: () ->
    rollBtn: true,
    buyBtn: false,
    random: null,
    randomChangeInterval: null,
    payBtn: false,
    endBtn: false,
    auctionBtn: false,
    dim: false

  computed: {
    ...mapState(['tiles', 'players', 'currentPlayer']),
    ...mapGetters(['canBuy', 'getRent', 'getPos', 'getOwner', 'getCurrent']),
    rollCSS: -> background: @players[@currentPlayer].color
    fromCSS: -> background: @getCurrent.color
    toCSS: -> background: @players[@getOwner(@getCurrent.pos)].color
  }
  methods:
    setDim: (e) -> @dim = e
    endTurn: ->
      @$store.commit 'nextPlayer'
      @rollBtn = true
      @payBtn = false
      @random = null
      @endBtn = false
      @auctionBtn = false

    buy: ->
      @$store.dispatch 
        type: 'buyProp'
        player:  @currentPlayer
        tile: @getPos()
        auction: true
      @buyBtn = false
      @endTurn()

    pay: -> 
      @$store.dispatch 'pay', {}
      @endTurn()

    roll: ->
      @random = Math.ceil Math.random() * 10
      # let random = 3;
      pos = @getPos()
      newPos = pos + @random
      newPos = if newPos > 23 then newPos - 23 else newPos
      @$store.commit 'log', "<span style='color:#{@players[@currentPlayer].color}'>#{@getCurrent.name}</span> rolled <b>#{@random}</b>"
      @$store.dispatch
        type: 'movePlayer'
        from: pos
        to: newPos
      @rollBtn = false
      @action()

    action: ->
      if @canBuy() 
        @buyBtn = true
        @auctionBtn = true
      else if @getOwner() isnt null and @getOwner() isnt @currentPlayer
        @payBtn = true
      else @endBtn = true

    auction: ->
      @buyBtn = false
      @endBtn = true
  </script>

<style lang="sass">
.board
  height: 100vh
  width: 100vw
  display: grid
  grid-template-columns: repeat(8, 12.2%)
  grid-template-rows: repeat(6, 1fr)
  grid-gap: 5px
  padding: 5px
  overflow: hidden
  &-bg
    position: fixed
    top: 0
    left: 0
    width: 100vw
    height: 100vh
    transition: background .5s
    pointer-events: none
    z-index: 3
.dim
  background: rgba(0,0,0, .5)
  transition: background .5s

.button
  font-weight: 700
  font-family: 'Barlow'
  border-radius: 15px
  color: white
  display: flex
  align-items: center
  width: 100%
  &-label
    font-size: 40px
    margin: auto
    &::selection
      background: transparent
      color: white

.action
  display: flex
  width: 100%
  height: 80%
  transition: transform .3s, filter .5s, box-shadow .3s, background 1s
  cursor: pointer
  box-shadow: 0 0 5px rgba(100, 120, 100, .6)
  border-radius: 15px
  &:hover
    box-shadow: 0 2px 10px rgba(100, 120, 100, .4)
    filter: brightness(1.1)
    transform: scale(1.05)
    transition: transform .3s, filter .5s, box-shadow .3s, background 1s
  &:active
    box-shadow: 0 0 10px rgba(100, 120, 100, .5)
    filter: brightness(0.9)
    transform: scale(1)
    transition: transform .3s, filter .5s, box-shadow .3s

.trade
  background: #F0B27A 


.players
  background: #cae0da
  grid-area: p
  border-radius: 15px
  display: flex
  flex-direction: column
  margin: 18px
  padding: 10px
  width: 80%
  height: calc(100% - 20px)
  box-shadow: inset 0px 0px 5px 0px rgba(0,0,0,0.25)
</style>

<style lang="scss">
@keyframes fade-slide {
  0% {
    opacity: 0;
    transform: translateX(-100%)
  }
  45% {
    opacity: 1;
    transform: translateX(0)
  }
  55% {
    opacity: 1;
    transform: translateX(0)
  }
  100% {
    opacity: 0;
    transform: translateX(100%)
  }
}
.board {
  grid-template-areas: 
  "t12 t13 t14 t15 t16 t17 t18 t19" 
  "t11   l   l   a   a   p   p t20" 
  "t10   l   l   r   r   p   p t21" 
  " t9   l   l   r   r   p   p t22" 
  " t8   l   l   b   b   p   p t23"  
  " t7  t6  t5  t4  t3  t2  t1  t0";
  align-items: center;
  justify-items: center;
}
.bottom { grid-area: b }
.center{ grid-area: r }
</style>