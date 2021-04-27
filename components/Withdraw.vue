<template>
  <b-modal v-model="isOpen" :width="640" scroll="keep">
    <div class="modal-background"></div>

    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ modalMessage }}</p>
        <button @click="close" class="delete" aria-label="close"></button>
      </header>
      <section class="modal-card-body">
        <b-steps v-model="stepLocation" :has-navigation="false">
          <b-step-item
            headerClass="has-text-black"
            label="Withdraw"
            icon="account-key"
          ></b-step-item>
          <b-step-item
            headerClass="has-text-black"
            label="Confirm"
            icon="account"
          ></b-step-item>
          <b-step-item
            headerClass="has-text-black"
            label="Success"
            icon="account-plus"
          ></b-step-item>
        </b-steps>
        <div class="columns">
          <div class="column">
            <div class="column input-group is-four-fifth">
              <div class="columns">
                <div class="column text-wrap is-four-fifth">
                  <b-input
                    v-if="(stepLocation === 0)"
                    v-model="withdrawAmount"
                    type="number"
                    controls="false"
                    min="5"
                    :max="accountBalance"
                    :placeholder="
                      'Max Withdraw: $' +
                      balance
                        .toFixed(10)
                        .replace(/\d(?=(\d{3})+\.)/g, '$&,')
                        .split('.')[0]
                    "
                  ></b-input>
                  <h1
                    class="has-text-weight-bold is-size-3 has-text-success"
                    v-if="stepLocation === 2"
                  >
                    Withdraw of ${{ withdrawAmount }} Successful.
                  </h1>
                  <a
                    v-if="stepLocation === 2"
                    :href="'https://rinkeby.etherscan.io/tx/' + withdrawId"
                  >
                    <p>
                      {{
                        (
                          'https://rinkeby.etherscan.io/tx/' + withdrawId
                        ).substring(0, 45) + '............'
                      }}
                    </p>
                  </a>
                </div>
                <div class="column is-one-fifth">
                  <b-button v-if="(stepLocation === 0)" @click="withdraw"
                    >Withdraw</b-button
                  >
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  </b-modal>
</template>
<script>
export default {
  props: {
    balance: Number,
  },
  data() {
    return {
      isOpen: false,
      stepLocation: 0,
      withdrawAmount: null,
      accountBalance: null,
      withdrawId: null,
      stablecoins: [
        {
          name: 'dai',
          path: '/logos/dai.png',
          balance: 20,
        },
        {
          name: 'tether',
          path: '/logos/tether.png',
          balance: 0,
        },
        {
          name: 'usdc',
          path: '/logos/usdc.png',
          balance: 0,
        },
        {
          name: 'eth',
          path: '/logos/eth.png',
          balance: 0,
        },
      ],
      modalMessage: 'Select Your Withdraw Amount',
    }
  },
  mounted() {
    this.accountBalance = this.$emit('getBalance')
    console.log(this.accountBalance)
  },
  methods: {
    open() {
      this.isOpen = true
      this.withdrawAmount = null
      this.stepLocation = 0
      this.modalMessage = 'Select Your Withdraw Amount'
    },
    close() {
      this.isOpen = false
    },
    emitRemoveFromBalance(amount) {
      ;(this.$nuxt || EventBus || this.$EventBus).$emit('removeFromBalance', {
        amount,
      })
    },
    async withdraw() {
      if (
        this.withdrawAmount > 0 &&
        this.withdrawAmount < this.accountBalance
      ) {
        let loading = this.$buefy.loading.open()
        this.stepLocation = 1
        const transactionParameters = {
          nonce: '0x00', // ignored by MetaMask
          gasPrice: '0x09184e72a000', // customizable by user during MetaMask confirmation.
          gas: '0x2710', // customizable by user during MetaMask confirmation.
          to: '0xcCb43E3c1BA551a9B0D8E3d559f1be3EF7c6727c', // Required except during contract publications.
          from: ethereum.selectedAddress, // must match user's active address.
          value: this.withdrawAmount, // Only required to send ether to the recipient from the initiating external account.
          data:
            '0x7f7465737432000000000000000000000000000000000000000000000000000000600057', // Optional, but used for defining smart contract creation and interaction.
          chainId: '0x3', // Used to prevent transaction reuse across blockchains. Auto-filled by MetaMask.
        }

        // txHash is a hex string
        // As with any RPC call, it may throw an error
        const txHash = await ethereum
          .request({
            method: 'eth_sendTransaction',
            params: [transactionParameters],
          })
          .then((result) => {
            loading.close()
            this.stepLocation = 2
            this.$buefy.toast.open({
              message: 'Successful Withdraw of $' + this.withdrawAmount,
              type: 'is-success',
            })
            console.log(result)
            this.emitRemoveFromBalance(this.withdrawAmount)
            this.withdrawId = result
          })
          .catch((error) => {
            loading.close()
            console.log(error)
            this.stepLocation = 0
            this.$buefy.toast.open({
              message: error.message,
              type: 'is-danger',
            })
          })
      } else {
        this.$buefy.toast.open({
          message: 'Invalid Withdraw amount.',
          type: 'is-danger',
        })
      }
    },
  },
}
</script>
