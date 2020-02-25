<template>
  <div id="app">
    <Board />
  </div>
</template>

<script lang="coffee">
import Board from './components/Board.vue'

export default
  name: 'app'
  components:
    'Board': Board
</script>

<style lang="sass">
@import '../node_modules/reset-css/sass/reset'
@import url('https://fonts.googleapis.com/css?family=Barlow+Condensed:600|Barlow:500,700&display=swap')

*
  box-sizing: border-box

#app
  font-family: 'Barlow', Helvetica, Arial, sans-serif
  text-align: center
  color: #2c3e50
  background: #eaf0ea
  overflow: hidden

.pop-enter-active
  transition: all .5s cubic-bezier(.75, 0,.25,1.25) .2s
.pop-leave-active
  transition: all .5s cubic-bezier(1,-0.50,.83,1.01)
.pop-enter 
  transform: scale(.8)
  opacity: 0
.pop-leave-to
  transform: scale(.8)
  opacity: 0

.pop2-enter-active
  transition: transform .5s cubic-bezier(.75, 0,.25,1), opacity .5s linear
.pop2-leave-active
  transition: transform .5s cubic-bezier(.75, 0,.25,1), opacity .5s linear
.pop2-enter, .pop2-leave-to
  transform: scale(.5)
  opacity: 0

.slide-enter-active
  transition: transform .5s cubic-bezier(.7, 0,.2,1.2)
.slide-leave-active
  transition: transform .5s cubic-bezier(1,-0.2,.8,1)
.slide-enter, .slide-leave-to
  transform: translateX(-100%)

.slidefade-enter-active
  transition: all .5s ease-in-out
.slidefade-leave-active
  transition: all .5s ease-in-out
.slidefade-enter
  transform: translateX(-50px)
  opacity: 0
.slidefade-leave-to
  transform: translateX(50px)
  opacity: 0
</style>