<template lang="pug">
.tile(
  @mouseover="activated = true"
  @mouseleave="activated = false"
  ref="tile"
  :style="{border: `solid 3px ${data.color}`}"
)
  .tile-head( :style="{background: data.color}")
    h3.tile-title {{ data.name }}  
    h2.tile-rent {{ data.ownedBy == null ? data.price : data.rent[data.houses] }}
  
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
          .tile-detail-amt ${{amt}}


  .tile-owner(:style="{background: ownerCSS }")

  .tile-players
    .tile-player(
      v-for="i in data.onThisTile"
      :key="i"
      :style="{background: players[i].color}"
    )
</template>

<script>
import {mapState} from 'vuex';
import gsap from 'gsap';
import Buildings from '@/components/Buildings.vue';

export default {
  props: ['data'],
  components: { Buildings },
  data() { return {
    level: ['Base','1 House', '2 Houses', '3 Houses', '4 Houses', 'Hotel'],
    activated: false,
    x: null,
    y: null,
    w: null,
    h: null
  }},
  computed:{
    ownerCSS() { 
      if ( this.data.ownedBy != null )
        return this.players[this.data.ownedBy].color
      else return ''
    },
    ...mapState(['players'])
  },
  mounted() {
    let {x, y, width, height} = this.$refs.tile.getBoundingClientRect();
    this.x = x; this.y = y; this.w = width; this.h = height;
  },
  watch: {
    activated() {
      let duration = .8;
      let ease = 'power4.out';
      let wx = window.innerWidth;
      let wy = window.innerHeight;
      let offsetX = 0;
      let offsetY = 0;
      if(this.x + 300 > wx) offsetX = this.w - 300;
      if(this.y + 300 > wy) offsetY = this.h - 300;

      if(this.activated)
        gsap.fromTo(this.$refs.tile,
          { x: this.x - 5, y: this.y - 5, zIndex: 2},{
          duration, ease,
          x: this.x - 5 + offsetX,
          y: this.y - 5 + offsetY,
          height: 300,
          width: 300,
          position: 'absolute',
          zIndex: 2
        })
      else {
        gsap.set(this.$refs.tile, {zIndex: 1});
        gsap.to(this.$refs.tile,{
          ease, duration,
          x: this.x - 5, y: this.y - 5, height: this.h, width: this.w,
          onComplete: () => {
            gsap.set(this.$refs.tile, {
              position: 'static',
              transform: 'translate(0,0)',
              zIndex: 0
            });
          }
        })
      }
    }
  },
  methods: {}
}
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