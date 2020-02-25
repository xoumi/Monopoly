<template lang="pug">
.pay
  .pay-from(:style="from")
  .pay-text
    .pay-bg PAYING
    .button-label.pay-cost ${{cost}}
  .pay-to(:style="to") 
</template>

<script>
export default {
  props: ['from', 'to', 'cost']
}
</script>

<style lang="sass">
.pay
  display: flex
  position: relative
  background: rgba(0,0,0, .5)
  &-from, &-to
    height: 100%
    width: 100%
  &-text
    overflow: hidden
    position: absolute
    width: 100%
    height: 100%
    display: flex
    align-items: center
    justify-content: center
  &-bg
    font-weight: bold
    font-size: .7em
    color: rgba(0,0,0, .2)
  &-cost
    position: absolute
    animation: fade-slide 1.5s  ease-in-out infinite 
    transform: translate(-50%)
</style>

<style lang="scss">
@keyframes fade-slide {
  0% {
    opacity: 0;
    transform: translateX(-100%)
  }
  45% {
    opacity: 1;
    transform: translateX(-10px)
  }
  55% {
    opacity: 1;
    transform: translateX(-10px)
  }
  100% {
    opacity: 0;
    transform: translateX(100%)
  }
}
</style>