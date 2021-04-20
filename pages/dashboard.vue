<template>
  <div>
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
}
</script>
<style scoped>
#header {
  background-color: #161d43;
}

#cross {
  top: -100px;
}
</style>
