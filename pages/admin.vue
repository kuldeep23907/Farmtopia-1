<template>
  <div>
    <h1>Layer 2 Farmtopia Contract</h1>
    <h2>Total Deposit</h2>
    <span>${{ totalDeposit }}</span>
    <h2>Total Uninvested Amount</h2>
    <span>${{ uninvestedFunds }}</span>
    <br />
    <h1>Layer 2 fDai Contract</h1>
    <h2>Total Supply of fDai</h2>
    <span>${{ totalSupply }}</span>
  </div>
</template>

<script>
import farmtopiaInterface from '~/helpers/FarmtopiaInterface.json'
import fTokenABI from '~/helpers/fToken.json'
export default {
  name: 'Admin',
  layout: 'admin',
  data() {
    return {
      totalDeposit: 0,
      uninvestedFunds: 0,
      totalSupply: 0,
    }
  },
  computed: {},

  methods: {},
  async beforeMount() {},

  async mounted() {},
  async created() {
    this.fDaiInstance = new this.$web3.eth.Contract(
      fTokenABI.abi,
      '0xF80cFBbed73261E3802603aEDF76bDb25530d328'
    )

    this.farmtopiainterface = new this.$web3.eth.Contract(
      farmtopiaInterface.abi,
      '0xfE6a16D577854b6502d9b32B9683d0f56f3fA863'
    )
    console.log(this.fDaiInstance, this.farmtopiainterface)
    this.totalDeposit =
      (await this.farmtopiainterface.methods.totalDeposit().call()) /
      Math.pow(10, 18)
    this.uninvestedFunds =
      (await this.farmtopiainterface.methods.uninvestedAmount().call()) /
      Math.pow(10, 18)
    this.totalSupply =
      (await this.fDaiInstance.methods.totalSupply().call()) / Math.pow(10, 18)
  },
}
</script>
<style>
canvas {
  position: absolute;
}
</style>
