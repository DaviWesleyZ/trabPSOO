import Vue from "vue";

Vue.filter('descCurta', (desc, cap = 60) => {
    if (desc.length > cap) {
        return desc.substring(0, cap) + "..."
    } else {
        return desc
    }
})
