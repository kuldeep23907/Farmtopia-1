import Vue from 'vue'

export default function (ctx, inject) {
  // Yep, that's it.
  inject('bus', new Vue())
}
