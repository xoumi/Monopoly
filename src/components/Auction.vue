<template lang="pug">
transition( @leave="aucAnim.btnLeave" )
  .auction(ref="auc" @click="btnClick" :style="bgCSS")

    //Label
    h1.auction-title AUCTION

    //End Btn
    transition( name="closeBtn" )
      .auction-close( ref="close" v-show="isAuctioning && isOver" @click.stop="closePopup" ) END

    //Property Label, Victory Message
    transition( name="auctionMsg" )
      .auction-msg( ref="aucMsg" v-show="isAuctioning" ) 
        .auction-msg-bg( :style="countdownCSS" )
        .auction-msg-bg.light( ref="tileBG" :style="countdownCSS" )
        .auction-msg-text {{tileText}}

    //Player Cards
    transition( @enter="cardOpen" @leave="cardClose" )
      .participant-container( v-show="isAuctioning" )
        .participant(
          v-for="(player, i) in players"
          ref="players"
          :key="i"
          :style="shadowCSS(player, i)"
        )
          .participant-final ${{bids[i]}}
          .participant-bids( ref="bids" )
            .participant-bid( @click.self="increaseBid(i, 10)" ) $10
            .participant-bid( @click.self="increaseBid(i, 50)" ) $50
            .participant-bid( @click.self="increaseBid(i, 100)" ) $100
          .player-head.auction-head( :style="{background: player.color}" )
            .player-name {{player.name}}
            .player-money {{player.money}}
</template>

<script lang="coffee">
import {mapState, mapGetters} from 'vuex'
import aucAnim from '@/assets/animations/auction.coffee'

export default
  computed : {
    ...mapState(['players', 'tiles']),
    ...mapGetters(['getPos', 'canBuy']),
    bgCSS: -> if @isAuctioning
        color: '#E2ECDC', background: 'transparent', boxShadow: 'none' 
    countdownCSS: -> {background: @tiles[@getPos()].color}
  }
  data : ->
    isAuctioning: false, 
    isOver: false,
    tileText: '',
    bids: {0: 10, 1: 0, 2: 0, 3: 0},
    bidIsChanging: [false, false, false, false],
    aucAnim: aucAnim,
    winner: null

  watch :
    isAuctioning: (val) -> 
      if val
        @$emit 'dim', true
        @cardAnim.show()
        @timerReset()
      else
        @$emit 'dim', false
        @cardAnim.hide =>
          @$emit 'over'


  methods :
    cardOpen: (e, done) ->
      aucAnim.showPlayers @$refs.players, @$refs.bids, done
    cardClose: (e, done) ->
      aucAnim.hidePlayers @$refs.players, done

    shadowCSS: (player, i) -> 
      if i == @winner
        boxShadow: "inset 0 0 0 10px #{player.color}"
      else
        boxShadow: "none"

    btnClick: ->
      @$emit 'start'
      @isAuctioning = true;

    closePopup: -> 
      @isAuctioning = false

    getWinner: ->
      bids = Object.values(@bids)[0..3]
      winningBid = Math.max ...bids
      @winner = bids.indexOf winningBid
      @$store.dispatch 'buyProp',
        player: @winner
        tile: @getPos()
        price: winningBid,
        auction: true

      aucAnim.removeControls @$refs
      @isOver = true


    increaseBid: (player, amt) ->
      if not @isOver and not @bidIsChanging[player]
        @timerReset()
        @bidIncrease player, amt

    timerReset: -> 
      if @countdown.totalProgress() > 0
        @countdown.timeScale(8).reverse()
      else
        if not @isOver
          @countdown.play()
          @countdown.eventCallback 'onComplete', () => @getWinner()

  mounted: -> 
    aucAnim.btnEnter @$refs.auc
    #Calculate size only after it's enter transition ends
    setTimeout => 
      @tileText = @tiles[@getPos()].name
      @cardAnim = aucAnim.setCardSize @$refs, 800, 600
      @countdown = aucAnim.getCountdown @$refs.tileBG, 3
      @bidIncrease = aucAnim.getBidIncrease @bids, @bidIsChanging
    ,500
</script>

<style lang="sass">
.auction
  border-radius: 15px
  display: flex
  flex-direction: column
  position: relative
  width: 100%
  z-index: 4
  background: #E2ECDC
  transition: background .5s ease-in-out, color .5s ease-in-out
  cursor: pointer
  box-shadow: 0 0 5px rgba(100, 120, 100, .6)

  &-head
    border-radius: 0
    color: #666
    z-index: 1

  &-close
    position: absolute
    bottom: 10%
    left: 50%
    transform: translateX(-50%)
    font-size: 30pt
    font-weight: bold
    color: white
    background: tomato
    padding: 20px 50px
    border-radius: 15px
  &-msg
    padding: 10px
    font-size: 15pt
    min-width: 50%
    border-radius: 15px
    margin: auto
    position: relative
    overflow: hidden
    border: 2px solid white
    &-bg
      position: absolute
      top: 0
      left: 0
      width: 100%
      height: 100%
      z-index: -1
    &-text
      padding-bottom: 8px
      color: #666


  &-title
    font-size: 40px
    font-weight: bold 
    margin: 0 auto
    padding: 20px
    &::selection
      background: transparent
      color: white

  &-player

.participant
  width: 100%
  height: calc(100% - 20px)
  margin: 10px
  border-radius: 15px
  background: #fafffa
  display: flex
  flex-direction: column
  justify-content: flex-end
  position: relative
  overflow: hidden
  transition: box-shadow .5s ease-in-out .5s
  &-container
    display: flex
    margin: 10px
    height: 100%
  &-bids
    border-top: 2px dashed #B6C8B6
    border-bottom: 2px dashed #B6C8B6
  &-bid
    padding: 10px
    background: #81C784
    color: white
    margin: 10px
    border-radius: 5px
  &-final
    font-size: 45pt
    position: absolute
    top: 50px
    left: 50%
    color: #666
    transform: translateX(-50%)

.light
  filter: brightness(1.2)
    
.auctionMsg-enter-active, .closeBtn-enter-active
  transition: all .5s cubic-bezier(.7, 0,.2,1.2) 1s
.auctionMsg-leave-active
  transition: all .5s cubic-bezier(1,-0.2,.8,1)

.auctionMsg-enter
  transform: scaleX(0)

.closeBtn-enter, .closeBtn-leave-to
  transform: translate(-50% 50%)
  opacity: 0
</style>