<template>
  <section class="hero is-medium is-primary">
    <div class="hero-body">
      <div class="container">
        <div class="columns is-align-items-center has-text-centered">
          <div class="column">
            <h3>Current Balance</h3>
            <h1 class="is-size-1">
              ${{
                this.balance.toFixed(10).replace(/\d(?=(\d{3})+\.)/g, '$&,')
              }}
            </h1>
            <h3>Total Earnings</h3>
            <h1 class="is-size-1">
              ${{ this.yield.toFixed(10).replace(/\d(?=(\d{3})+\.)/g, '$&,') }}
            </h1>
          </div>
          <div class="pa-6 column is-one-quarter">
            <h3>APY</h3>
            <h1 class="is-size-1">{{ this.apy }}%</h1>
            <div class="mt-6 level">
              <b-button class="mr-2 level-item" @click="openDeposit"
                >Deposit</b-button
              >
              <b-button class="level-item" @click="openWithdrawl"
                >Withdraw</b-button
              >
            </div>
          </div>
          <div class="column chart-container is-three-fifth">
            Historical Chart
            <line-chart />
          </div>
        </div>
      </div>
    </div>
    <withdraw ref="withdrawlmodal" />
    <deposit ref="depositmodal" />
  </section>
</template>

<script>
import Withdraw from '~/components/Withdraw'
import Deposit from '~/components/Deposit'
import LineChart from '~/components/LineChart'

export default {
  components: { LineChart, Deposit, Withdraw },
  data() {
    return {
      balance: 1000000,
      apy: 25,
      yield: 4000,
      withdrawlOpen: false,
    }
  },
  mounted() {
    setInterval(() => {
      let balance = Number(this.balance)
      let apy = Number(this.apy)
      let earnedInterest = balance * (apy / 100 / 365 / 24 / 60 / 60)
      let newBalance = balance + earnedInterest
      let newYield = Number(this.yield) + earnedInterest
      this.balance = newBalance
      this.yield = newYield
      this.emitUpdateTransaction([
        {
          id: (Math.random() * 100).toFixed(0),
          date: new Date(),
          transaction: {
            name: 'Farmtopia Harvest',
            type: 'Interest',
            amount: earnedInterest,
          },
        },
      ])
    }, 1000)
  },
  methods: {
    emitUpdateTransaction(message) {
      ;(this.$nuxt || EventBus || this.$EventBus).$emit('updateTransactions', {
        message,
      })
    },
    openWithdrawl() {
      return this.$refs.withdrawlmodal.open()
    },
    openDeposit() {
      return this.$refs.depositmodal.open()
    },
  },
}
</script>
<style scoped>
.chart-container {
  height: 400px;
}
</style>
