<template lang="pug">
BlindfoldApp(:config="config")
</template>

<script>
import _ from "lodash"

export default {
  name: "blindfold",
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/blindfold
    const config = await $axios.$get("/api/blindfold", {params: query})
    return { config }
  },
  mounted() {
    if (_.isEmpty(this.$route.query)) {
      this.ga_click("目隠し詰将棋")
    } else {
      this.ga_click("目隠し詰将棋●")
    }
  },
  computed: {
    meta() {
      return {
        title: "目隠し詰将棋",
        description: "",
        og_image_key: "blindfold",
        twitter_card_is_small: true,
      }
    }
  },
}
</script>

<style lang="sass">
</style>
