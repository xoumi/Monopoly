<template lang="pug">
transition(@appear="appear" @leave="leave")
  .auction(ref="auc")
    .auction-bg(ref="bg")
    //End Btn
    transition( name="closeBtn" )
      .auction-close( ref="close" v-if="isOver" @click.stop="leave" ) END

    //Property Label, Victory Message
    transition( name="auctionMsg" )
      .auction-msg( ref="aucMsg" v-show="isAuctioning" ) 
        .auction-msg-bg( :style="countdownCSS" )
        .auction-msg-bg.light( ref="tileBG" :style="countdownCSS" )
        .auction-msg-text {{tileText}}

    //Player Cards
    .participant-container
      .participant(
        v-for="player in players"
        ref="players"
        :key="player.id"
        :style="shadowCSS(player)"
      )
        Money.participant-final(:money="bids[player.id]")
        .participant-bids( ref="bids" )
          .participant-bid(
            v-for="bid in [10, 50, 100]" 
            @click.self="increaseBid(player.id, bid)"
          ) ${{bid}}
        .player-head.auction-head( :style="{background: player.color}" )
          .player-name {{player.name}}
          .player-money {{player.money}}
</template>

<script lang="coffee">
import {mapState, mapGetters} from 'vuex'
import aucAnim from '@/assets/animations/auction.coffee'
import Money from '@/components/Number.vue';

export default
  components: { Money },
  computed : {
    ...mapState(['players', 'tiles']),
    ...mapGetters(['getPos', 'canBuy']),
    countdownCSS: -> {background: @tiles[@getPos()].color}
  }
  data : ->
    isAuctioning: false, 
    tileText: '',
    bids: {0: 0, 1: 0, 2: 0, 3: 0},
    bidIsChanging: [false, false, false, false],
    aucAnim: aucAnim,
    winner: null
    isOver: false

  methods :
    shadowCSS: ( player ) -> 
      if player.id == @winner
        boxShadow: "inset 0 0 0 10px #{player.color}"
      else
        boxShadow: "none"

    closePopup: -> 

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
      @bids[player] += amt
      @timerReset()

    timerReset: -> 
      if @countdown.totalProgress() > 0
        @countdown.timeScale(8).reverse()
      else
        @countdown.play()
        @countdown.eventCallback 'onComplete', () => @getWinner()

    appear: -> 
      @isAuctioning = true;
      aucAnim.appear @$refs
      @countdown = aucAnim.getCountdown @$refs.tileBG, 5
      @timerReset()
      @tileText = @tiles[@getPos()].name
    
    leave: ->
      aucAnim.leave @$refs, =>
        @$emit 'over'
        @isAuctioning = false

</script>

<style lang="sass">
.auction
  padding: 50px 0
  display: flex
  flex-direction: column
  justify-content: center
  position: absolute
  top: 0
  left: 0
  width: 100vw
  height: 100vh
  z-index: 4
  transition: background .5s ease-in-out, color .5s ease-in-out

  &-bg
    position: absolute
    top: 0
    left: 0
    width: 100%
    height: 100%
    transition: background .5s
    background: #000
    z-index: -1
    opacity: 0
  &-head
    border-radius: 0
    color: #333
    z-index: 1

  &-close
    bottom: 20%
    left: 50%
    transform: translateX(-50%)
    font-size: 30pt
    font-weight: bold
    color: white
    background: tomato
    position: absolute
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

.participant
  width: 100%
  height: calc(100% - 100px)
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
    padding: 100px
    height: 100%
    margin: auto
    width: 1000px
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