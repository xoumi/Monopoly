<template lang="pug">
.player
  .player-head(:style="{backgroundColor: player.color}")
    .player-name {{player.name}}
    .player-money ${{player.money}}
  transition-group.player-properties(name="slide" tag="div")
    .player-property(
      v-for="prop in player.ownedProps"
      :key="prop"
      :style="{background: tiles[prop].color}"
      :class="{'select': allowSelect}"
      @click="select(prop)"
    )
      .player-property-selector(
        v-if="allowSelect"
        :style="selectCSS(prop)"
      )
      .player-property-name {{ tiles[prop].name }}
      .player-property-rent {{ getRent(prop) }}

</template>

<script lang="coffee">
import { mapState, mapGetters } from 'vuex'

export default
  props: ['player', 'allowSelect', 'selected']
  components: { Money }
  computed: {
    ...mapState(['tiles']),
    ...mapGetters(['getRent'])
  }
  methods:
    selectCSS: (prop) -> 
      if prop in @selected then {background: 'white'}
    select: (prop) ->
      if @allowSelect 
        unless prop in @selected
          @selected.push prop
        else
          @selected.splice @selected.indexOf(prop), 1
</script>

<style lang="sass">
.player
  background: white
  margin: 5px
  padding: 5px
  border-radius: 7px
  text-align: left
  box-shadow: 0px 2px 5px 0px rgba(0,50,0,0.15)
  width: 100%
  height: min-content

  &-head
    display: flex
    justify-content: space-between
    border-radius: 7px
    padding: 5px 10px
    box-shadow: 0px 3px 5px 0px rgba(0,0,0,0.15)
  &-name
    padding: 5px 5px 5px 0
  &-money
    font-weight: bold
    font-size: 25px
  &-properties
    margin-top: 3px
    
  &-property
    padding: 8px 20px
    margin: 3px
    border-radius: 8px
    display: flex
    justify-content: space-between
    transition: all .2s
    position: relative
    &-selector
      height: 50%
      width: 3px
      margin-right: 3px
      border-radius: 5px
      position: absolute
      top: 25%
      left: 5px
    &-rent
      font-weight: bold

</style>