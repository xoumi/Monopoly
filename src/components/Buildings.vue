<template lang="pug">
.buildings(ref="buildings")
  svg.house1(:style="{fill: color}" v-if="houses > 0" ref="house1" width="31" height="27" viewbox='0 0 31 27' xmlns='http://www.w3.org/2000/svg')
    path.building(fill='#fff' stroke='#000' stroke-linejoin='round' d='M3.5 12.5h23v14h-23zM3.5 10.5h23v2h-23z')
    path.building(fill='#fff' stroke='#000' stroke-linejoin='round' d='M17.5 24.5h7v2h-7zM18.5 14.5h5v10h-5z')
    path.building(fill='#000' d='M19 19h1v1h-1z')
    path.building(fill='#fff' stroke='#000' stroke-linejoin='round' d='M5.5 16.5h7v3h-7z')
    path.building(fill='#fff' stroke='#000' stroke-linejoin='round' d='M5.5 14.5h7v3h-7zM30 10.5H1l2-6h24l3 6z')
    path.building(fill='#fff' stroke='#000' stroke-linejoin='round' d='M19.5.5h3v5h-3z')
    path.building(stroke='#000' stroke-linecap='round' d='M18.5.5h5')

  svg.house2(:style="{fill: color}" v-if="houses > 1" ref="house2" width="37" height="47" viewbox='0 0 37 47' xmlns='http://www.w3.org/2000/svg')
    path.building(d='M15.6 9.6c-.2 0-.2.2-.2.4v36c0 .3.2.5.5.5h17c.2 0 .5-.2.5-.5V10c0-.2-.1-.3-.3-.4l-8.5-6a.5.5 0 00-.5 0l-8.5 6zM3.6 30c-.2.2-.2.3-.2.5V46c0 .3.2.5.5.5h11c.2 0 .5-.2.5-.5V24a.5.5 0 00-.8-.4L3.6 30z' fill='#fff' stroke='#000' stroke-linejoin='round')
    path.building(fill='#fff' stroke='#000' stroke-linejoin='round' d='M22.4 38.5h4v8h-4zM5.4 35.5h8v11h-8zM15.4 30.5h3v8h-3zM15.4 14.5h3v8h-3zM30.4 30.5h3v8h-3zM30.4 14.5h3v8h-3zM27.4 16.5v16h-6v-16z')
    path.building(stroke='#000' d='M14.9 34.5h3M29.9 34.5h3M29.9 18.5h3M14.9 18.5h3M21.9 21.5h5M21.9 27.5h5')
    path.building(d='M12.9 9.5L24.4 1l11.5 8.5' stroke='#000' stroke-linecap='round' stroke-linejoin='round')
    path.building(d='M15.4 7.5V11M33.4 7.5V11' stroke='#000')
    path.building(stroke='#000' stroke-linecap='round' d='M1.2 28.6l13.9-8M4 32.3l11.2-6.5')
    path.building(stroke='#000' d='M4.4 27v2.5M5.9 39.5h7M5.9 42.5h7')

  svg.house3(:style="{fill: color}" v-if="houses > 2" ref="house3" width="30" height="65" viewBox="0 0 30 65" fill="none" xmlns="http://www.w3.org/2000/svg")
    path.building(d="M2.1.5a.5.5 0 00-.6.5v62.5c0 .3.2.5.5.5h26.5c.3 0 .5-.2.5-.5V9.9c0-.2-.1-.4-.3-.4L2 .5z" fill="#fff" stroke="#000" stroke-linejoin="round")
    path.building(d="M17 5.6L29 4v5.5" stroke="#000" stroke-linejoin="round")
    path.building(stroke="#000" d="M5.4 7.9v41.7M9.4 8.9v34.8M9.4 45.6v6M21.1 42.7v5.9M13.3 11.9v36.7M17.5 15.5v35.7M21.1 12.9v27.8M25.1 12.9v35.7")
    path.building(fill="#fff" stroke="#000" stroke-linejoin="round" d="M6.4 56.1h3.9V64H6.4zM20.1 56.1H24V64h-3.9z")
    path.building(transform="matrix(.95115 .30873 -.3033 .9529 1 3)" stroke="#000" d="M0-.5h28.9")

  svg.hotel(:style="{fill: color}" v-if="houses > 3" ref="hotel" width="39" height="90" viewbox='0 0 39 90' xmlns='http://www.w3.org/2000/svg')
    path.building(d='M12.2 25.5c.2.1.3.3.3.5v63c0 .3-.2.5-.5.5H1a.5.5 0 01-.5-.5V21a.5.5 0 01.7-.5l11 5z' fill='#fff' stroke='#000' stroke-linejoin='round')
    path.building(d='M8.2 26.6c.2 0 .3.2.3.4v51c0 .3-.2.5-.5.5H4a.5.5 0 01-.5-.5V25a.5.5 0 01.7-.4l4 2zM38.3 44.8l.2.4V89c0 .3-.2.5-.5.5H26a.5.5 0 01-.5-.5V37a.5.5 0 01.8-.4l12 8.2zM11.6 9.2l-.1.3V89c0 .3.2.5.5.5h7c.3 0 .5-.2.5-.5V1a.5.5 0 00-.9-.3l-7 8.5z' fill='#fff' stroke='#000' stroke-linejoin='round')
    path.building(d='M19.6 15.5l-.1.3V89c0 .3.2.5.5.5h6c.3 0 .5-.2.5-.5V8a.5.5 0 00-.9-.3l-6 7.8z' fill='#fff' stroke='#000' stroke-linejoin='round')
    path.building(fill='#fff' stroke='#000' stroke-linejoin='round' d='M15.5 78.5h8v11h-8z')
    path.building(d='M14.5 75.5v-54' stroke='#000' stroke-dasharray='5 3')
    path.building(d='M17 70V16' stroke='#000' stroke-dasharray='5 5')
    path.building(d='M23 72V18' stroke='#000' stroke-dasharray='5 3')
    path.building(stroke='#000' stroke-miterlimit='3.9' stroke-linejoin='round' stroke-dasharray='10 2' d='M29.5 43v34M32.5 46v34M35.5 49v34')
    path.building(stroke='#000' d='M4 36.5h4M4 39.5h4M4 42.5h4M4 45.5h4M4 48.5h4M4 51.5h4')
  
  svg.tree(width="18" height="30" viewBox="0 0 18 30" fill="none" xmlns="http://www.w3.org/2000/svg")
    circle(cx="9" cy="9" r="8.5" fill="#9FF291" stroke="#000")
    path(stroke="#000" stroke-linecap="round" d="M8.9 10.1v19.4M9.5 14.8l3.4-3.4M8.8 12.4L4.2 8.9")

  svg.birds(width="13" height="6" viewbox='0 0 13 6' xmlns='http://www.w3.org/2000/svg')
    path(d='M1 1c1.2.2 1.5.4 2 1 .5-.6.9-.9 2-1M8 1c1.2.2 1.5.4 2 1 .5-.6.9-.9 2-1M4 4c1.2.2 1.5.4 2 1 .5-.6.9-.9 2-1' stroke='#000')

  svg.clouds(width='37' height='5' viewbox='0 0 37 5' xmlns='http://www.w3.org/2000/svg')
    path(d='M0 1h24M27 1h5M37 4H13M10 4H5' stroke='#B7B7B7')



</template>

<script>
import gsap from 'gsap';
import * as gen from 'random-seed';

export default {
  props: ['color', 'houses', 'name'] ,
  mounted() { 
    this.width = this.$refs.buildings.getBoundingClientRect().width;
    this.setPosition(); },
  data() {return{ width: 0}},
  watch: {
    houses() {
      this.setPosition();
    }
  },
  methods: {
    setPosition() {
      this.$nextTick( () => {
        let rand = gen(this.name);
        if(this.houses > 0)
          gsap.set(this.$refs.house1, {x: (rand.intBetween(0, this.width - 30))});
        if(this.houses > 1)
          gsap.set(this.$refs.house2, {x: (rand.intBetween(0, this.width - 30))});
        if(this.houses > 2)
          gsap.set(this.$refs.house3, {x: (rand.intBetween(0, this.width - 30))});
        if(this.houses > 3)
          gsap.set(this.$refs.hotel, {x: (rand.intBetween(0, this.width - 30))});
      });
    }
  }
}
</script>

<style lang="sass">
.buildings
  width: 100%
  height: 100%
  svg
    position: absolute
    bottom: 0
    left: 0

.house1
  z-index: 5
.house2
  z-index: 4
.house3
  z-index: 3
.hotel
  z-index: 2

.building, .tree
  stroke: #0D5D82
  stroke-linejoin: round
  stroke-linecap: round
  fill: inherit
.tree
  fill: #7FD271
  
</style>