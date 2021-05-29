import _ from "lodash"
import AutoMatchingModal from "./AutoMatchingModal.vue"

export const app_auto_matching = {
  methods: {
    auto_matching_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.modal.open({
        component: AutoMatchingModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => { this.sound_play("click") },
        props: { base: this.base },
      })
    },
  },
}
