<template lang="pug">
.tile(
  @mouseover="activated = true"
  @mouseleave="activated = false"
  ref="tile"
  :style="{border: `solid 3px ${data.color}`}"
)
  .tile-head( :style="{background: data.color}")
    h3.tile-title {{ data.name }}  
    Money.tile-rent(:money="data.ownedBy == null ? data.price : data.rent[data.houses]")
  
  .tile-details-wrapper
    transition(name="slide")
      .tile-details(v-if="activated")
        .tile-detail(
          v-for="(amt, index) in data.rent"
          :key="index"
          :class="{'tile-detail-active': data.houses == index}"
          @click="setHouses(index)"
        )
          .tile-detail-level {{level[index]}}:
          Money.tile-detail-amt(:money="amt")


  .tile-owner(:style="{background: ownerCSS }") 
    p.tile-owner-text(:style="{color: ownerCSS }") {{ data.ownedBy != null ? "OWNER" : "" }}

  .tile-players
    .tile-player(
      v-for="i in data.onThisTile"
      :key="i"
      :style="{background: players[i].color}"
    )
</template>

<script lang="coffee">
import {mapState} from 'vuex'
import gsap from 'gsap'
import Buildings from '@/components/Buildings.vue'
import Money from '@/components/Number.vue'

export default
  props: ['data']
  components: { Buildings, Money }

  data: ->
    level: ['Base','1 House', '2 Houses', '3 Houses', '4 Houses', 'Hotel']
    activated: false
    x: null
    y: null
    w: null
    h: null

  computed: {
    ownerCSS: -> 
      if  @data.ownedBy? then @players[@data.ownedBy].color
      else ''
    ...mapState(['players'])
  },

  mounted: ->
    {x, y, width, height} = @$refs.tile.getBoundingClientRect()
    @x = x; @y = y; @w = width; @h = height;

  watch:
    activated: ->
      duration = .8
      ease = 'power4.out'
      wx = window.innerWidth
      wy = window.innerHeight
      offsetX = 0
      offsetY = 0
      if @x + 300 > wx then offsetX = @w - 300
      if @y + 300 > wy then offsetY = @h - 300

      if @activated 
        gsap.fromTo @$refs.tile,
          x: @x - 5, y: @y - 5, zIndex: 2
          {
            duration, ease,
            x: @x - 5 + offsetX,
            y: @y - 5 + offsetY,
            height: 300,
            width: 300,
            position: 'absolute',
            zIndex: 2
          }
      else
        gsap.set @$refs.tile, { zIndex: 1 }
        gsap.to @$refs.tile,
          ease: ease, duration: duration,
          x: @x - 5, y: @y - 5, height: @h, width: @w,
          onComplete: () =>
            gsap.set @$refs.tile,
              position: 'static'
              transform: 'translate(0,0)'
              zIndex: 0
</script>

<style lang="sass">
.tile
  position: relative
  border-radius: 8px
  background: #fff
  border: 3px solid
  box-shadow: 0px 5px 5px rgba(50, 50, 50, 0.1)
  height: 100%
  width: 100%
  &:hover
    z-index: 2

  &-head
    display: flex
    justify-content: space-between
    align-items: center
    padding: 5px 10px
    transition: .3s
    z-index: 2
  &-title
    white-space: nowrap
    overflow-x: hidden
    overflow-y: hidden
    text-overflow: ellipsis
    text-align: left
    width: 80%  
    padding: 5px
    padding-left: 0
  &-rent
    font-weight: bold
    font-size: 25px

  &-details
    &-wrapper
      width: 100%
      height: calc(100% - 46px)
      margin-top: 10px
      overflow: hidden
  &-detail
    display: flex
    padding: 5px 10px
    justify-content: space-between
    &-amt
      font-weight: bold
    &-active
      border-bottom: 2px solid #ccc

  &-buildings
    height: 80px
    width: 100%
    position: absolute
    bottom: 12px
    right: 5px
    z-index: 1

  &-owner
    height: 13px
    width: 100%
    border-radius: 0 0px 5px 5px
    display: flex
    position: absolute
    bottom: 0px
    z-index: 2
    &-text
      position: absolute
      right: 5px
      bottom: 11px
      font-weight: bold
      font-size: .9em  


  //PLAYER INDICATOR
  &-players
    width: 100%
    position: absolute
    bottom: 0
    display: flex
    align-items: center
    z-index: 3
  &-player
    width: 25px
    height: 25px
    border-radius: 25px
    border: 2px solid white
    margin: 5px
    box-shadow: 0 1px 2px rgba(0,0,0, .2)

</style>