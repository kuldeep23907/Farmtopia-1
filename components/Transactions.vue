<template>
  <section class="has-background-white-ter">
    <div class="container animate__animated animate__fadeInUp">
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
            :default-sort="['date', 'desc']"
            aria-next-label="Next page"
            aria-previous-label="Previous page"
            aria-page-label="Page"
            :loading="loading"
            aria-current-label="Current page"
            default-sort-direction="desc"
          >
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
import fTokenABI from '~/helpers/fToken.json'

export default {
  created() {
    ;(this.$nuxt || EventBus || this.$EventBus).$on(
      'updateTransactions',
      this.updateTable
    )
  },
  async mounted() {
    this.getDataFromContract()
    console.log(this.$axios)
  },
  data() {
    return {
      data: [],
      loading: true,
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
        fTokenABI.abi,
        '0xF80cFBbed73261E3802603aEDF76bDb25530d328'
      )

      let transactions = await this.fDaiInstance
        .getPastEvents(
          'mintOnDepositEvent',
          {
            filter: {
              to: accounts[0],
            }, // Using an array means OR: e.g. 20 or 23
            fromBlock: 0,
            toBlock: 'latest',
          },
          function (error, events) {
            return events
          }
        )
        .then(function (events) {
          return events
        })
      let transactionsFrom = await this.fDaiInstance
        .getPastEvents(
          'burnOnWithdrawEvent',
          {
            filter: {
              to: accounts[0],
            }, // Using an array means OR: e.g. 20 or 23
            fromBlock: 0,
            toBlock: 'latest',
          },
          function (error, events) {
            return events
          }
        )
        .then(function (events) {
          return events
        })

      transactions = transactions.concat(transactionsFrom)
      console.log(transactions, 'All')

      let organizedTxs = []
      let amount
      console.log(transactions.length, 'Total txs detected')
      transactions.map(async (tx) => {
        var date = await this.$web3.eth
          .getBlock(tx.blockNumber)
          .then((result) => {
            return result.timestamp
          })

        if (tx.event === 'burnOnWithdrawEvent') {
          tx.event = 'Withdraw'
          amount = tx.returnValues.fTokensAmount
        }
        if (tx.event === 'mintOnDepositEvent') {
          tx.event = 'Deposit'
          amount = tx.returnValues.amount
        }

        organizedTxs.push({
          id: tx.id,
          name: tx.returnValues.to,
          type: tx.event,
          amount: amount / Math.pow(10, 18),
          date: new Date(date * 1000).toLocaleDateString('en-US'),
        })
      })
      this.data = organizedTxs
      this.loading = false
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
