import { support_parent } from "./support_parent.js"

export const support_child = {
  mixins: [support_parent],
  props: {
    base: { type: Object, required: false },
  },
}
