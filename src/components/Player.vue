<template lang="pug">
.player
  .player-head(:style="{backgroundColor: player.color}")
    .player-name {{player.name}}
    .player-money ${{player.money}}
  .player-properties
    transition-group(name="slide" tag="div" v-if="properties")
      .player-property(
        v-for="prop in player.ownedProps"
        :key="prop"
        :style="{background: tiles[prop].color}"
      )
        .player-property-name {{ tiles[prop].name }}
        .player-property-rent {{ getRent(prop) }}

</template>

<script lang="coffee">
import { mapState, mapGetters } from 'vuex'

export default
  props: ['player', 'properties']
  computed: {
    ...mapState(['tiles']),
    ...mapGetters(['getRent'])
  }
</script>

<style lang="sass">
.player
  background: white
  margin: 5px
  padding: 5px
  border-radius: 7px
  text-align: left
  box-shadow: 0px 2px 5px 0px rgba(0,50,0,0.15)

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
    overflow: hidden
    margin-top: 3px
    
  &-property
    padding: 8px 20px
    margin: 3px
    border-radius: 8px
    display: flex
    justify-content: space-between
    &-rent
      font-weight: bold

</style>