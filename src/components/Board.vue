<template lang="pug">
.board
  //Log
  Log

  //Buy, Pay, End
  .center
    .button(
      :style="{background: players[currentPlayer].color}"
    )
      transition(name="slidefade" mode="out-in")
        .action(@click="roll" v-if="rollBtn" key="roll") ROLL
        .action(@click="buy" v-if="buyBtn" key="buy") BUY for ${{getRent(getPos())}}
        .action(@click="endTurn" v-if="endBtn" key="end") END TURN
        PayBtn.action(
          @click.native="pay" v-if="payBtn" key="pay"
          :from="fromCSS" :to="toCSS" :cost="getRent(getPos())"
        )
    //Trade, Auction
    transition(name="pop" mode="out-in")
      .action-secondary.button.action(
        key="trade"
        v-if="tradeBtn"
        @click="isTrading = true") TRADE
    transition(name="pop" mode="out-in")
      .action-ternary.button.action(
          key="upgrade"
          v-if="tradeBtn"
          @click="isTrading = true") UPGRADE
    transition(name="pop" mode="out-in")
      .action-secondary.button.action(
        key="auction"
        v-if="auctionBtn"
        @click="isAuctioning = true") AUCTION

  //Players
  Players

  //Tiles
  Tile(
    v-for="i in tiles"
    :key="i.name" :data="i"
    :style="{gridArea: `t${i.id}`}"
    )

  Auction( v-if="isAuctioning" @over="auction" "" )
  Trade( v-if="isTrading" @completed="isTrading = false" )

</template>

<script lang="coffee">
import { mapState, mapGetters } from 'vuex'
import simplebar from 'simplebar-vue'
import 'simplebar/dist/simplebar.min.css'
import Tile from '@/components/Tile.vue'
import Players from '@/components/Players.vue'
import Log from '@/components/Log.vue'
import PayBtn from '@/components/PayBtn.vue'
import Auction from '@/components/Auction.vue'
import Trade from '@/components/Trade.vue'

export default
  components: { Tile, Players, Log, simplebar, PayBtn, Auction, Trade }

  data: () ->
    rollBtn: true,
    buyBtn: false,
    random: null,
    payBtn: false,
    endBtn: false,
    auctionBtn: false,
    tradeBtn: true,
    isAuctioning: false,
    isTrading: false

  computed: {
    ...mapState(['tiles', 'players', 'currentPlayer']),
    ...mapGetters(['canBuy', 'getRent', 'getPos', 'getOwner', 'getCurrent']),
    rollCSS: -> background: @players[@currentPlayer].color
    fromCSS: -> background: @getCurrent.color
    toCSS: -> background: @players[@getOwner(@getPos())].color
  }
  methods:
    setDim: (e) -> @dim = e
    endTurn: ->
      @$store.commit 'nextPlayer'
      @rollBtn = true
      @tradeBtn = true
      @payBtn = false
      @random = null
      @endBtn = false
      @auctionBtn = false

    buy: ->
      @$store.dispatch 
        type: 'buyProp'
        player:  @currentPlayer
        tile: @getPos()
        auction: false
      @buyBtn = false
      @endTurn()

    pay: -> 
      @$store.dispatch 'pay', {}
      @endTurn()

    auction: ->
      @auctionBtn = false
      @buyBtn = false
      @isAuctioning = false
      @endBtn = true
      
    roll: ->
      @random = Math.ceil Math.random() * 10
      @random = 3
      pos = @getPos()
      newPos = pos + @random
      newPos = if newPos > 23 then newPos - 23 else newPos
      @$store.commit 'log', "<span style='color:#{@players[@currentPlayer].color}'>#{@getCurrent.name}</span> rolled <b>#{@random}</b>"
      @$store.dispatch
        type: 'movePlayer'
        from: pos
        to: newPos
      @rollBtn = false
      @tradeBtn = false
      @action()

    action: ->
      if @canBuy() 
        @buyBtn = true
        @auctionBtn = true
      else if @getOwner() isnt null and @getOwner() isnt @currentPlayer
        @payBtn = true
      else @endBtn = true

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

.action
  display: flex
  align-items: center
  justify-content: center
  width: 100%
  height: 100%
  font-family: 'Barlow'
  font-weight: 700
  font-size: 2em
  color: white
  &::selection
    background: transparent
    color: inherit
  &-secondary
    height: 70px !important
    background: #1ABC9C
    position: absolute
    top: calc(50% + 70px)
  &-ternary
    height: 70px !important
    background: #1ABC9C
    position: absolute
    top: calc(50% - 140px)

.button
  border-radius: 15px
  width: 250px
  height: 100px
  border: white solid 3px
  transition: transform .3s, filter .5s, box-shadow .3s, background 1s
  box-shadow: 0 0 5px rgba(100, 120, 100, .6)
  cursor: pointer
  overflow: hidden
  &:hover
    box-shadow: 0 2px 10px rgba(100, 120, 100, .4)
    filter: brightness(1.1)
    transform: scale(1.05)
  &:active
    transform: scale(1)

.center
  grid-area: c
  position: relative
  display: flex
  justify-content: center
  align-items: center
</style>

<style lang="scss">
.board {
  grid-template-areas: 
  "t12 t13 t14 t15 t16 t17 t18 t19" 
  "t11   l   l   c   c   p   p t20" 
  "t10   l   l   c   c   p   p t21" 
  " t9   l   l   c   c   p   p t22" 
  " t8   l   l   c   c   p   p t23"  
  " t7  t6  t5  t4  t3  t2  t1  t0";
  align-items: center;
  justify-items: center;
}
</style>
