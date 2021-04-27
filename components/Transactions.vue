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
              {{ props.row.transaction.name }}
            </b-table-column>

            <b-table-column
              field="transaction.type"
              label="Type"
              sortable
              v-slot="props"
            >
              {{ props.row.transaction.type }}
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
                  props.row.transaction.amount
                    .toFixed(2)
                    .replace(/\d(?=(\d{3})+\.)/g, '$&,')
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
export default {
  created() {
    ;(this.$nuxt || EventBus || this.$EventBus).$on(
      'updateTransactions',
      this.updateTable
    )
  },
  data() {
    return {
      data: [],
    }
  },
  methods: {
    updateTable(array) {
      this.data = this.data.concat(array.message)
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
