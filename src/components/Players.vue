<template lang="pug">
simplebar.players
  Player(
    v-for="player in players"
    :key="player.color"
    :player="player"
    )
</template>

<script lang="coffee">
import simplebar from 'simplebar-vue'
import Player from '@/components/PlayerDetails.vue'
import { mapState } from 'vuex'
export default
  components: { simplebar, Player }
  computed: {
    ...mapState(['players'])
  }
</script>

<style lang="sass">
.players
  background: #cae0da
  grid-area: p
  border-radius: 15px
  display: flex
  flex-direction: column
  width: calc(100% - 50px)
  height: calc(100% - 20px)
  padding: 10px
  box-shadow: inset 0px 0px 5px 0px rgba(0,0,0,0.25)
  overflow: auto
</style>