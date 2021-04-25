<template>
  <section class="hero is-medium">
    <div class="hero-body">
      <div class="container">
        <div
          class="columns is-align-items-center has-text-white has-text-centered"
        >
          <div class="column">
            <h3>Current Balance</h3>
            <span class="is-size-1">
              ${{
                this.balance
                  .toFixed(10)
                  .replace(/\d(?=(\d{3})+\.)/g, '$&,')
                  .split('.')[0]
              }}
            </span>
            <span class="is-size-5 has-text-grey-lighter decimals">
              .{{
                this.balance
                  .toFixed(10)
                  .replace(/\d(?=(\d{3})+\.)/g, '$&,')
                  .split('.')[1]
              }}
            </span>
            <h3>Total Earnings</h3>
            <span class="is-size-1">
              ${{
                this.yield
                  .toFixed(10)
                  .replace(/\d(?=(\d{3})+\.)/g, '$&,')
                  .split('.')[0]
              }}
            </span>
            <span class="is-size-5 has-text-grey-lighter decimals">
              .{{
                this.yield
                  .toFixed(10)
                  .replace(/\d(?=(\d{3})+\.)/g, '$&,')
                  .split('.')[1]
              }}
            </span>
          </div>
          <div class="pa-6 column is-one-quarter">
            <h3>APY</h3>
            <h1 class="is-size-1">{{ this.apy }}%</h1>
            <div
              class="mt-6 is-flex is-justify-content-center is-align-content-center level"
            >
              <b-button class="mr-1 level-item" @click="openDeposit"
                >Deposit</b-button
              >
              <b-button class="ml-1 level-item" @click="openWithdrawl"
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
      balance: 1000000000,
      apy: 25,
      yield: 0,
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

.level-item {
  border-radius: 50px;
}

.decimals {
  margin-left: -13px;
}
</style>
