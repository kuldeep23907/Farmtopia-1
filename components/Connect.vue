<template>
  <b-button v-if="checkWeb3" @click="connect">
    {{ this.isLoggedIn ? this.truncateAddress(this.isLoggedIn) : 'Connect' }}
  </b-button>
</template>
<script>
export default {
  data() {
    return {
      isLoggedIn: '',
      isMetaMask: false,
    }
  },
  computed: {
    checkWeb3() {
      const { ethereum } = window
      return Boolean(ethereum && ethereum.isMetaMask)
    },
  },
  methods: {
    async connect() {
      try {
        // Will open the MetaMask UI
        // You should disable this button while the request is pending!
        await ethereum.request({ method: 'eth_requestAccounts' })
        await this.getAccounts()
      } catch (error) {
        console.error(error)
      }
    },
    async getAccounts() {
      const accounts = await ethereum.request({ method: 'eth_accounts' })
      //We take the first address in the array of addresses and display it
      this.isLoggedIn = accounts[0]
      let result = accounts[0] || 'Not able to get accounts'
      console.log(result)
      if (result != 'Not able to get accounts') {
        this.$router.push({
          path: '/dashboard',
        })
      } else {
        this.$router.push({
          path: '/',
        })
      }
      return accounts[0] || ''
    },
    truncateAddress(address) {
      if (address.length > 0) {
        return (
          address.substring(0, 4) +
          '....' +
          address.substring(address.length - 5, address.length)
        )
      } else {
        return address
      }
    },
  },
  async mounted() {
    this.isMetaMask = this.checkWeb3
    this.isLoggedIn = await this.getAccounts()
    ethereum.on('accountsChanged', async (accounts) => {
      this.isLoggedIn = await this.getAccounts()
      if (this.isLoggedIn.length > 0) {
        console.log('User logged in, going to dashboard')
        this.$router.push({
          path: '/dashboard',
        })
      } else {
        console.log('User logged out, going to home')
        this.$router.push({
          path: '/',
        })
      }
    })
  },
}
</script>
