<template lang="pug">
b-field.WkbkTopSearch
  b-input(
    type="search"
    icon="magnify"
    icon-clickable
    @icon-click="base.search_handle"
    v-model.trim="base.query"
    rounded
    @keydown.native.enter="base.search_handle"
    )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkTopSearch",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkTopSearch
</style>
