<template>
  <div>
    <b-button v-if="checkMetaMask" @click="connect">
      {{ this.isLoggedIn ? this.truncateAddress(this.isLoggedIn) : 'Connect' }}
    </b-button>
    <a v-if="!checkMetaMask" href="https://metamask.io/download.html"
      ><h1>Install Metamask</h1></a
    >
  </div>
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
    checkMetaMask() {
      if (ethereum) {
        const { ethereum } = window
        return Boolean(ethereum && ethereum.isMetaMask)
      }
    },
  },
  methods: {
    async connect() {
      if (ethereum.networkVersion != '212984383488152') {
        this.$buefy.toast.open({
          message: 'Please connect to Arbitrum Network ',
          type: 'is-warning',
        })
        return
      }
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
    if (ethereum) {
      this.isLoggedIn = await this.getAccounts()
      ethereum.on('accountsChanged', async (accounts) => {
        this.isLoggedIn = await this.getAccounts()
        if (this.isLoggedIn.length > 0) {
          console.log('User logged in, going to dashboard')
          this.$router.push({
            path: '/dashboard',
          })
          this.$router.go()
        } else {
          console.log('User logged out, going to home')
          this.$router.push({
            path: '/',
          })
        }
      })
      ethereum.on('chainChanged', (chainId) => {
        if (chainId != '212984383488152') {
          this.$router.push({
            path: '/',
          })
          this.$router.go()

          return
        }
      })
    }
  },
}
</script>
