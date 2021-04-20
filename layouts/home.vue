<template>
  <div>
    <b-navbar>
      <template #brand>
        <b-navbar-item tag="router-link" :to="{ path: '/' }">
          <img
            src="https://d33wubrfki0l68.cloudfront.net/9d0ffeb08eaade7f2bc1e0f8bd44c1e0a469248d/bafb4/static/21501e8dfa2f42d8260c096e21d8dbb4/aff26/hero.png"
            alt="Lightweight UI components for Vue.js based on Bulma"
          />
          <strong> Farmtopia</strong>
        </b-navbar-item>
      </template>

      <template #end>
        <b-navbar-item tag="div">
          <div class="buttons">
            <connect />
          </div>
        </b-navbar-item>
      </template>
    </b-navbar>
    <section class="main-content columns">
      <div class="container column is-10">
        <nuxt />
      </div>
    </section>
  </div>
</template>

<script>
import Connect from '~/components/Connect.vue'
export default {
  components: {
    Connect,
  },
  data() {
    return {
      items: [
        {
          title: 'Home',
          icon: 'home',
          to: { name: 'index' },
        },
        {
          title: 'Dashboard',
          icon: 'lightbulb',
          to: { name: 'dashboard' },
        },
      ],
    }
  },
}
</script>
