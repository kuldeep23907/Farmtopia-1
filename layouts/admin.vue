<template>
  <div>
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
