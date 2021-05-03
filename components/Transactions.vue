<template>
  <section class="has-background-white-ter">
    <div class="container">
      <div class="columns">
        <div
          id="cross"
          class="column is-align-content-center has-background-white is-three-fifth"
        >
          <h1
            class="is-size-1 has-text-left has-text-black has-text-weight-light"
          >
            Transactions
          </h1>
          <br />
          <b-table
            :data="data"
            default-sort="transaction.date"
            aria-next-label="Next page"
            aria-previous-label="Previous page"
            aria-page-label="Page"
            aria-current-label="Current page"
          >
            <b-table-column
              field="id"
              label="ID"
              sortable
              numeric
              v-slot="props"
            >
              {{ props.row.id }}
            </b-table-column>

            <b-table-column
              field="transaction.name"
              label="Name"
              sortable
              v-slot="props"
            >
              {{ props.row.name }}
            </b-table-column>

            <b-table-column
              field="transaction.type"
              label="Type"
              sortable
              v-slot="props"
            >
              {{ props.row.type }}
            </b-table-column>

            <b-table-column
              field="date"
              label="Date"
              sortable
              centered
              v-slot="props"
            >
              <span class="tag is-success">
                {{ new Date(props.row.date).toLocaleDateString() }}
              </span>
            </b-table-column>

            <b-table-column label="Amount" v-slot="props">
              <span>
                ${{
                  props.row.amount
                    .toFixed(2)
                    .replace(/\d(?=(\d{3})+\.)/g, '$&,') || 'undefined'
                }}
              </span>
            </b-table-column>
          </b-table>
        </div>
      </div>
    </div>
  </section>
</template>
<script>
import daiABI from '~/helpers/ERC20Abi.json'

export default {
  created() {
    ;(this.$nuxt || EventBus || this.$EventBus).$on(
      'updateTransactions',
      this.updateTable
    )
  },
  async mounted() {
    this.getDataFromContract()
  },
  data() {
    return {
      data: [],
    }
  },
  methods: {
    updateTable() {
      this.getDataFromContract()
    },
    async getDataFromContract() {
      const accounts = await ethereum.request({ method: 'eth_accounts' })
      //We take the first address in the array of addresses and display it
      this.isLoggedIn = accounts[0]

      this.fDaiInstance = new this.$web3.eth.Contract(
        daiABI,
        '0xa8D9d33501Df73D5B534f70a2239EF8F526AB147'
      )

      let transactions = await this.fDaiInstance
        .getPastEvents(
          'Transfer',
          {
            filter: {
              to: accounts[0],
            }, // Using an array means OR: e.g. 20 or 23
            fromBlock: 167910,
            toBlock: 'latest',
          },
          function (error, events) {
            return events
          }
        )
        .then(function (events) {
          return events
        })
      let organizedTxs = []
      transactions.map(function (tx) {
        organizedTxs.push({
          id: tx.id,
          name: tx.returnValues.to,
          type: tx.event,
          date: tx.blockNumber,
          amount: tx.returnValues.value / Math.pow(10, 18),
        })
      })
      this.data = organizedTxs
    },
  },
}
</script>

<style scoped>
#cross {
  margin-top: -5rem;
  -webkit-box-shadow: 1px 1px 18px 0px rgba(0, 41, 89, 0.39);
  box-shadow: 1px 1px 18px 0px rgba(0, 41, 89, 0.39);
}
</style>
