<template lang="pug">
.money ${{num}}  
</template>

<script lang="coffee">
import gsap from 'gsap'
export default
  props: ['money']
  
  data: ->
    num: @money

  watch:
    money: (n, o) ->
      obj = {n}
      gsap.fromTo obj,
        {n: o},
        duration: 2
        ease: 'power3.out'
        n: n
        onUpdate: () =>
          @num = Math.round(obj.n)
</script>