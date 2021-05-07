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
                ${{ depositAmount }} in Transit. View Transaction
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
import fTokenABI from '~/helpers/fToken.json'

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
      fTokenABI.abi,
      '0xF80cFBbed73261E3802603aEDF76bDb25530d328'
    )

    this.farmtopiainterface = new this.$web3.eth.Contract(
      farmtopiaInterface.abi,
      '0xfE6a16D577854b6502d9b32B9683d0f56f3fA863'
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
      var dai = this.daiInstance
      // var fToken = this.fDaiInstance
      var farmtopia = this.farmtopiainterface
      // var account = this.isLoggedIn

      if (this.depositAmount > 0 && this.depositAmount <= this.balance) {
        let loading = this.$buefy.loading.open()
        this.stepLocation = 1
        this.modalMessage = 'Waiting for Approval to Transfer Funds...'
        console.log(dai, '1')
        await dai.methods
          .approve(
            farmtopia.options.address,
            String(this.depositAmount * Math.pow(10, 18))
          )
          .send({ from: this.isLoggedIn }, (error, result) => {
            if (error) {
              console.log('Approval Failed', error)
            } else {
              console.log('Approval Passed', result)
              this.$buefy.toast.open({
                message: 'Transaction Approved',
                type: 'is-success',
              })
              this.modalMessage = 'Confirming Transaction...'

              // dai.methods
              //   .allowance(account, farmtopia.options.address)
              //   .call({}, function (error, result) {
              //     if (error) {
              //       console.log('Approval Failed', error)
              //     } else {
              //       console.log('Approval Passed', result)
              //     }
              //   })
              farmtopia.methods
                .deposit(String(this.depositAmount * Math.pow(10, 18)))
                .send({ from: this.isLoggedIn }, (error, result) => {
                  if (error) {
                    // loading.close()
                    // console.log(error.message)
                    // this.stepLocation = 0
                    // this.modalMessage = 'Select Your Deposit Amount'
                    // this.$buefy.toast.open({
                    //   message: error.message,
                    //   type: 'is-danger',
                    // })
                  }
                  if (result) {
                    loading.close()
                    this.stepLocation = 2
                    this.modalMessage = 'Deposit Pending.....'
                    this.depositId = result
                  }
                })
                .then((result) => {
                  this.$buefy.toast.open({
                    message: 'Successful deposit of $' + this.depositAmount,
                    type: 'is-success',
                  })
                  console.log('Results:', result)
                  this.emitAddToBalance(this.depositAmount)
                  this.modalMessage = 'Deposit Successful'
                })
                .catch((e) => {
                  loading.close()
                  console.log(e.message)
                  this.stepLocation = 0
                  this.modalMessage = 'Select Your Deposit Amount'

                  this.$buefy.toast.open({
                    message: e.message,
                    type: 'is-danger',
                  })
                })
            }
          })
          .catch((e) => {
            loading.close()
            console.log(e.message)
            this.stepLocation = 0
            this.modalMessage = 'Select Your Deposit Amount'

            this.$buefy.toast.open({
              message: e.message,
              type: 'is-danger',
            })
          })
      }
    },
  },
}
</script>
