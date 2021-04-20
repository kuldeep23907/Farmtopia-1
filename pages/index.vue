<template>
  <div>
    <vue-particles
      color="#dedede"
      :particleOpacity="0.7"
      :particlesNumber="120"
      shapeType="polygon"
      :particleSize="2"
      linesColor="#dedede"
      :linesWidth="1"
      :lineLinked="true"
      :lineOpacity="0.4"
      :linesDistance="150"
      :moveSpeed="3"
      :hoverEffect="true"
      hoverMode="grab"
      :clickEffect="true"
      clickMode="push"
    >
    </vue-particles>
    <section class="hero main">
      <div class="container">
        <div class="hero-body">
          <div class="columns holder">
            <div class="column is-three-quarters">
              <p class="title is-size-1 has-text-weight-bold">
                Farmtopia High Yield Savings Account
              </p>
              <p class="subtitle is-italic has-text-weight-light">
                Backed by the Blockchain.
              </p>

              <h1 class="is-size-2 mt-6">
                <strong>Earn up to 26% APY</strong>
              </h1>
              <connect class="mt-6" />
            </div>
            <div class="column">
              <b-image
                responsive
                src="https://d33wubrfki0l68.cloudfront.net/9d0ffeb08eaade7f2bc1e0f8bd44c1e0a469248d/bafb4/static/21501e8dfa2f42d8260c096e21d8dbb4/aff26/hero.png"
                alt=""
              />
            </div>
          </div>
        </div>
      </div>
    </section>

    <section>
      <integrations-logos />
    </section>
  </div>
</template>

<script>
import Connect from '~/components/Connect.vue'
import IntegrationsLogos from '~/components/IntegrationLogos.vue'
import Vue from 'vue'
import VueParticles from 'vue-particles'
Vue.use(VueParticles)
export default {
  name: 'HomePage',
  layout: 'home',
  data() {
    return {}
  },
  computed: {},
  components: {
    Connect,
    IntegrationsLogos,
  },
  methods: {},
  async beforeMount() {},

  async mounted() {},
}
</script>
<style>
canvas {
  position: absolute;
}
</style>
