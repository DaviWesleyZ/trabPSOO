<template>
    <v-btn 
        fab 
        :depressed="value" 
        color="primary-het"
        @click="$emit('input', !value)">
        <v-icon color="white">filter_list</v-icon>
    </v-btn>
</template>

<script>
export default {
    props: {
        value: {
            type: Boolean,        
            required: true,
        }
    },
}
</script>

