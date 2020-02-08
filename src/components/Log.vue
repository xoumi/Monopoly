<template lang="pug">
 simplebar.logs(ref="logs" data-simplebar-auto-hide="false")
  .logs-wrapper
    .logs-separator
    .log(
      v-for="(log, index) in logs"
      :key="index"
    ) 
      .log-time {{ log.time }}
      .log-message(v-html="log.msg")

</template>

<script>
import simplebar from 'simplebar-vue';
import 'simplebar/dist/simplebar.min.css';
import {mapState} from 'vuex';

export default {
  components: { simplebar },
  computed: {
    ...mapState(['logs'])
  }
}
</script>

<style lang="sass">
.logs
  background: #cae0da
  grid-area: l
  margin: 18px
  border-radius: 15px
  display: flex
  flex-direction: column
  flex-grow: 1
  width: 80%
  height: calc(100%  - 20px)
  box-shadow: inset 0px 0px 5px 0px rgba(0,0,0,0.25)
  overflow-x: hidden
  overflow-y: auto
  &-wrapper
    position: relative
  &-separator
    position: absolute
    top: 0
    left: 45px
    min-height: 482px
    height: 100%
    width: 2px
    background: #333
    opacity: .3
  .log
    text-align: left
    font-size: .8em
    display: flex
    align-items: center
    margin: 5px
    b
      font-weight: bold
    span
      padding: 1px 3px
      border-radius: 4px
    &-time
      padding: 4px
      width: 3em
      margin-right: 4px
    &-message
      margin-left: 4px
</style>