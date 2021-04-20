<template>
  <div class="columns">
    <div class="column">
      <carousel autoplay :scrollPerPage="false" :perPage="4">
        <slide v-for="logo in logos" :key="logo.name">
          <img class="slide" :src="logo.path" alt="" />
        </slide>
      </carousel>
    </div>
  </div>
</template>
<script>
import { Carousel, Slide } from 'vue-carousel'

export default {
  data() {
    return {
      logos: [
        {
          name: 'aave',
          path: '/logos/aave.png',
        },
        {
          name: 'comp',
          path: '/logos/comp.png',
        },
        {
          name: 'dai',
          path: '/logos/dai.png',
        },
        {
          name: 'eth',
          path: '/logos/eth.png',
        },
        {
          name: 'maker',
          path: '/logos/maker.png',
        },
        {
          name: 'tether',
          path: '/logos/tether.png',
        },
        {
          name: 'uni',
          path: '/logos/uni.png',
        },
        {
          name: 'usdc',
          path: '/logos/usdc.png',
        },
        {
          name: 'yearn',
          path: '/logos/yearn.png',
        },
      ],
    }
  },
  components: {
    Carousel,
    Slide,
  },
}
</script>
<style scoped></style>
