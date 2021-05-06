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
            <h6 class="has-text-grey-lighter mt-2">Earnings per Second</h6>
            <span class="is-size-5 has-text-text-white decimals">
              ${{
                this.earnedInterest
                  .toFixed(10)
                  .replace(/\d(?=(\d{3})+\.)/g, '$&,')
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
    <withdraw :balance="balance" ref="withdrawlmodal" />
    <deposit :balance="balance" ref="depositmodal" />
  </section>
</template>

<script>
import Withdraw from '~/components/Withdraw'
import Deposit from '~/components/Deposit'
import LineChart from '~/components/LineChart'
import fTokenABI from '~/helpers/fToken.json'

export default {
  components: { LineChart, Deposit, Withdraw },
  data() {
    return {
      balance: 0,
      apy: 25,
      yield: 0,
      withdrawlOpen: false,
      earnedInterest: 0,
    }
  },
  async mounted() {
    const accounts = await ethereum.request({ method: 'eth_accounts' })
    //We take the first address in the array of addresses and display it
    this.isLoggedIn = accounts[0]
    this.fDaiInstance = new this.$web3.eth.Contract(
      fTokenABI.abi,
      '0xF80cFBbed73261E3802603aEDF76bDb25530d328'
    )
    console.log('fToken Contract loaded on Dashboard', this.fDaiInstance)
    this.balance = Number(
      (await this.fDaiInstance.methods.balanceOf(this.isLoggedIn).call()) /
        Math.pow(10, 18)
    )
    ;(this.$nuxt || EventBus || this.$EventBus).$on(
      'addToBalance',
      this.addToBalance
    )
    ;(this.$nuxt || EventBus || this.$EventBus).$on(
      'removeFromBalance',
      this.removeFromBalance
    )
    ;(this.$nuxt || EventBus || this.$EventBus).$on(
      'getBalance',
      this.getBalance
    )
    this.earnedInterest = this.balance * (this.apy / 100 / 365 / 24 / 60 / 60)
    setInterval(() => {
      let balance = Number(this.balance)
      let apy = Number(this.apy)
      this.earnedInterest = balance * (apy / 100 / 365 / 24 / 60 / 60)
      let newBalance = balance + this.earnedInterest
      let newYield = Number(this.yield) + this.earnedInterest
      this.balance = newBalance
      this.yield = newYield
      // this.emitUpdateTransaction([
      //   {
      //     id: (Math.random() * 100).toFixed(0),
      //     date: new Date(),
      //     transaction: {
      //       name: 'Farmtopia Harvest',
      //       type: 'Interest',
      //       amount: this.earnedInterest,
      //     },
      //   },
      // ])
    }, 1000)
  },
  methods: {
    emitUpdateTransaction() {
      ;(this.$nuxt || EventBus || this.$EventBus).$emit('updateTransactions')
    },
    addToBalance(balanceIncrement) {
      this.balance = this.balance + Number(balanceIncrement.amount)
      this.emitUpdateTransaction()
    },
    removeFromBalance(balanceDecrement) {
      this.balance = this.balance - Number(balanceDecrement.amount)
      this.emitUpdateTransaction()
    },
    getBalance() {
      return this.balance
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

.automargin {
  margin-top: auto;
}
</style>
