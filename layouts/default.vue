<template>
  <div>
    <b-navbar fixed-top>
      <template #brand>
        <b-navbar-item tag="router-link" :to="{ path: '/dashboard' }">
          <img
            src="~/assets/logo.png"
            alt="Lightweight UI components for Vue.js based on Bulma"
          />
          <strong> Farmtopia </strong>
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
    <section class="main-content">
      <nuxt />
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
      items: [],
    }
  },
}
</script>
