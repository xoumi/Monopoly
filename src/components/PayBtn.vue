<template lang="pug">
.button.pay(@click="$emit('click')")
  .pay-from(:style="from")
  .pay-text
    .pay-bg TRANSFERRING
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
  align-items: center
  &-from, &-to
    height: calc(100% - 20px)
    margin: 10px
    width: 90px
    background: white
    border: 2px dashed white
  &-from
    border-radius: 15px 0 0 15px
  &-to
    border-radius: 0 15px 15px 0
  &-text
    overflow: hidden
    position: relative
    width: 100%
    height: 100%
    display: flex
    align-items: center
    justify-content: center
  &-bg
    font-weight: bold
    font-size: 1.5em
    color: rgba(0,0,0, .3)
  &-cost
    position: absolute
    animation: fade-slide 1.5s  ease-in-out infinite 
</style>