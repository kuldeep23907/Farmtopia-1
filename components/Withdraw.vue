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
                    min="100"
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
                    :href="
                      'https://explorer.offchainlabs.com/#/tx' + withdrawId
                    "
                  >
                    <p>
                      {{
                        (
                          'https://explorer.offchainlabs.com/#/tx' + withdrawId
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
import daiABI from '~/helpers/ERC20Abi.json'
import fTokenABI from '~/helpers/fToken.json'

import farmtopiaInterface from '~/helpers/FarmtopiaInterface.json'
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
  async mounted() {
    const accounts = await ethereum.request({ method: 'eth_accounts' })
    //We take the first address in the array of addresses and display it
    this.isLoggedIn = accounts[0]

    this.daiInstance = new this.$web3.eth.Contract(
      daiABI,
      '0x59d141841328f89bf38672419655175f53740010'
    )
    this.fDaiInstance = new this.$web3.eth.Contract(
      fTokenABI.abi,
      '0xF80cFBbed73261E3802603aEDF76bDb25530d328'
    )

    this.farmtopiainterface = new this.$web3.eth.Contract(
      farmtopiaInterface.abi,
      '0xfE6a16D577854b6502d9b32B9683d0f56f3fA863'
    )

    this.accountBalance = Number(
      (await this.fDaiInstance.methods.balanceOf(this.isLoggedIn).call()) /
        Math.pow(10, 18)
    )
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
        this.withdrawAmount <= this.accountBalance
      ) {
        let loading = this.$buefy.loading.open()
        this.stepLocation = 1

        var result = await this.farmtopiainterface.methods
          .withdraw(String(this.withdrawAmount * Math.pow(10, 18)))
          .send({ from: this.isLoggedIn })
          .then((result) => {
            loading.close()
            this.stepLocation = 2
            this.$buefy.toast.open({
              message: 'Successful Withdraw of $' + this.withdrawAmount,
              type: 'is-success',
            })
            console.log(result)
            this.emitRemoveFromBalance(this.withdrawAmount)
            this.withdrawId = result.transactionHash
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
        console.log(this.withdrawAmount, this.accountBalance)
      }
      console.log('this func tion ran', result)
    },
  },
}
</script>
