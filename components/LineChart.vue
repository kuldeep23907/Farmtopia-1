<script>
import { Line } from 'vue-chartjs'

export default {
  extends: Line,
  mounted() {
    this.renderChart(
      {
        labels: [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
        ],
        datasets: [
          {
            label: 'Account Balance',
            backgroundColor: '#C3D4FF',
            borderColor: '#5081FF',
            data: [10000, 20000, 40000, 70000, 90000, 100000, 120000],
          },
        ],
      },
      {
        responsive: false,
        maintainAspectRatio: false,
        scales: {
          xAxes: [
            {
              gridLines: {
                display: false,
              },
              ticks: {
                fontColor: '#FFF', // this here
              },
            },
          ],
          yAxes: [
            {
              ticks: {
                fontColor: '#FFF', // this here
                callback: function (value, index, values) {
                  return '$' + value
                },
              },
              gridLines: {
                display: false,
              },
            },
          ],
        },
      }
    )
  },
}
</script>
