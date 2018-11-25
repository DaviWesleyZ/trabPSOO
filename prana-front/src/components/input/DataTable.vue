<template>
    <v-data-table
        :items="items"
        :headers="headers"
        :search="search">
        <template slot="items" slot-scope="props">
            <slot name="hmm" v-bind="{ item: props.item }"></slot>
        </template>
    </v-data-table>
</template>

<script>
export default {
    props: {
        headers: Array,
        items: Array,
        search: String
    }
}
</script>

<style scoped>

</style>


