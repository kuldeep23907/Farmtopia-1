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
            label="Deposit"
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
        <div v-if="stepLocation === 1" class="columns">
          <div class="column" v-for="coin in stablecoins" :key="coin.name">
            <img :src="coin.path" alt="" />
          </div>
        </div>

        <div class="columns">
          <div class="column">
            <div v-if="stepLocation === 2" class="column is-full">
              <h1 class="has-text-weight-bold is-size-3 has-text-success">
                Deposit of ${{ depositAmount }} Successful.
              </h1>
              <a :href="'https://explorer.offchainlabs.com/#/tx/' + depositId">
                <p>
                  {{
                    (
                      'https://explorer.offchainlabs.com/#/tx/' + depositId
                    ).substring(0, 45) + '............'
                  }}
                </p>
              </a>
            </div>
            <div class="column input-group is-four-fifth">
              <div class="columns">
                <div class="column text-wrap is-four-fifth">
                  <b-input
                    v-if="(stepLocation === 0)"
                    v-model="depositAmount"
                    type="number"
                    controls="false"
                    min="5"
                    :max="balance"
                    :placeholder="
                      'Max deposit: $' +
                      balance
                        .toFixed(10)
                        .replace(/\d(?=(\d{3})+\.)/g, '$&,')
                        .split('.')[0]
                    "
                  ></b-input>
                </div>
                <div class="column is-one-fifth">
                  <b-button v-if="(stepLocation === 0)" @click="deposit"
                    >Deposit</b-button
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
import farmtopiaInterface from '~/helpers/FarmtopiaInterface.json'

export default {
  async mounted() {
    const accounts = await ethereum.request({ method: 'eth_accounts' })
    //We take the first address in the array of addresses and display it
    this.isLoggedIn = accounts[0]

    this.daiInstance = new this.$web3.eth.Contract(
      daiABI,
      '0x59d141841328f89bf38672419655175f53740010'
    )
    this.fDaiInstance = new this.$web3.eth.Contract(
      daiABI,
      '0xa8D9d33501Df73D5B534f70a2239EF8F526AB147'
    )
    // var this.daiInstance = web3.eth
    //
    this.balance = Number(
      (await this.daiInstance.methods.balanceOf(this.isLoggedIn).call()) /
        Math.pow(10, 18)
    )
  },
  data() {
    return {
      isOpen: false,
      stepLocation: 0,
      depositAmount: null,
      balance: 0,
      depositId: null,
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
      modalMessage: 'Select Your Deposit Amount',
    }
  },
  methods: {
    open() {
      this.isOpen = true
      this.depositAmount = null
      this.stepLocation = 0
      this.modalMessage = 'Select Your Deposit Amount'
    },
    close() {
      this.isOpen = false
    },
    emitAddToBalance(amount) {
      ;(this.$nuxt || EventBus || this.$EventBus).$emit('addToBalance', {
        amount,
      })
    },
    async deposit() {
      if (this.depositAmount > 0 && this.depositAmount <= this.balance) {
        let loading = this.$buefy.loading.open()
        this.stepLocation = 1
        this.modalMessage = 'Confirming your deposit......'
        let approvalProcess = await this.daiInstance.methods
          .approve(
            '0x0876F852e337fc11ae0715F6ABd6b7Ed499a8F46',
            String(this.depositAmount * Math.pow(10, 18))
          )
          .send({ from: this.isLoggedIn })

        let allowedBalance = await this.daiInstance.methods
          .allowance(
            this.isLoggedIn,
            '0x0876F852e337fc11ae0715F6ABd6b7Ed499a8F46'
          )
          .call()
        let farmtopiainterface = new this.$web3.eth.Contract(
          farmtopiaInterface.abi,
          '0x0876F852e337fc11ae0715F6ABd6b7Ed499a8F46'
        )
        farmtopiainterface.methods
          .deposit(String(this.depositAmount * Math.pow(10, 18)))
          .send({ from: this.isLoggedIn })
          .then((result) => {
            loading.close()
            this.stepLocation = 2
            this.modalMessage = 'Deposit Successful'

            this.$buefy.toast.open({
              message: 'Successful deposit of $' + this.depositAmount,
              type: 'is-success',
            })
            console.log('Results:', result)
            this.emitAddToBalance(this.depositAmount)
            this.depositId = result.transactionHash
          })
          .catch((error) => {
            loading.close()
            console.log(error)
            this.stepLocation = 0
            this.modalMessage = 'Select Your Deposit Amount'

            this.$buefy.toast.open({
              message: error.message,
              type: 'is-danger',
            })
          })
      }
    },
  },
}
</script>
