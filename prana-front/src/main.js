// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import Vuetify from 'vuetify'
import VueResource from 'vue-resource'
import './scripts/save-csv.min.js';

import UploadButton from './components/input/UploadButton.vue';
import DatePicker from './components/input/DatePicker.vue';
import Filtro from './components/input/Filtro.vue';
import ButtonFiltro from './components/input/ButtonFiltro.vue';
import DataTable from './components/input/DataTable.vue';

import 'vuetify/dist/vuetify.min.css'

import './API/api.js'
import './helpers/filter.js'
import './helpers/date.js'

import br from './locales/pt-br.js'

Vue.use(Vuetify, {
	lang: {
		locales: {
			br: br
		},
		current: "br"
	}
})

Vue.use(require('vue-cookies'))
Vue.use(VueResource)


Vue.component('upload-button', UploadButton);
Vue.component('het-date-picker', DatePicker);
Vue.component('filtro', Filtro);
Vue.component('botao-filtro', ButtonFiltro);
Vue.component('het-data-table', DataTable);

Vue.config.productionTip = false
window.isEqual = require("lodash/isequal")
window.clone = require("lodash/clone")


import './styles/style.scss'
/* eslint-disable no-new */
const vue = new Vue({
	el: '#app',
	router,
	components: { App, UploadButton },
	template: '<App/>',
	

	data() {
		return {
			logado: true,
			drawer: false,
			checarNotificacaoAtrasaApontamento: true,
			items: [],
			perfil: "",
		}
	},

	created() {
		if (this.logado) {
			this.getMenu((menus) => {
				this.items = menus;
			});
		}
	},

})

router.beforeEach((to, from, next) => {

	if ((vue.$cookies.get("het_username") == null || vue.$cookies.get("het_token") == null) && to.path != "/login") {
		vue.$router.push("/login");

	} else {
		next();
	}
})
