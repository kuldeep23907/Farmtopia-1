<template>
  <b-modal v-model="isOpen" :width="640" scroll="keep">
    <div class="modal-background"></div>

    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ modalMessage }}</p>
        <button @click="close" class="delete" aria-label="close"></button>
      </header>
      <section class="modal-card-body">
        <b-steps :has-navigation="false">
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
            label="Result"
            icon="account-plus"
          ></b-step-item>
        </b-steps>
        <div class="columns">
          <div class="column" v-for="coin in stablecoins" :key="coin.name">
            <img :src="coin.path" alt="" />
            <!-- <div class="column is-four-fifth">
              <b-input :placeholder="'Max Withdraw: ' + coin.balance"></b-input>
            </div> -->
          </div>
        </div>
      </section>
      <!-- <footer class="modal-card-foot">
        <button class="button is-success">Deposit</button>
        <button @click="close" class="button">Cancel</button>
      </footer> -->
    </div>
  </b-modal>
</template>
<script>
export default {
  data() {
    return {
      isOpen: false,
      step: 1,
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
      modalMessage: 'Select Your Withdraw Stablecoin',
    }
  },
  methods: {
    open() {
      this.isOpen = true
    },
    close() {
      this.isOpen = false
    },
  },
}
</script>
