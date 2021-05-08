<template>
  <div v-if="metamask">
    <div id="header" class="hero-body">
      <div class="columns">
        <div class="column">
          <dashboard-header />
        </div>
      </div>
    </div>
    <div class="columns">
      <div class="column">
        <transactions ref="transaction" />
      </div>
    </div>
  </div>
</template>
<script>
import DashboardHeader from '~/components/DashboardHeader'
import Transactions from '~/components/Transactions'

export default {
  name: 'Dashboard',
  components: {
    DashboardHeader,
    Transactions,
  },
  data() {
    return {}
  },
  mounted() {},
  created() {
    this.metamask = ethereum
  },
}
</script>
<style scoped>
#header {
  /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#1e5799+0,2989d8+50,207cca+51,7db9e8+100;Blue+Gloss+Default */
  /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#1e5799+29,2989d8+57,207cca+58,7db9e8+100 */
  background: linear-gradient(
    60deg,
    #117aca,
    #0090d6,
    #00a5dc,
    #00b9dd,
    #16ccdc,
    #59deda,
    #86efd8,
    #b0ffd9
  );
}

#cross {
  top: -100px;
}
</style>
