import Vue from 'vue'
import Router from 'vue-router'


import Painel       from '@/views/Painel'
import Login        from '@/views/Login'
import PainelAdmin from '@/views/PainelAdmin'
import Usuarios      from '@/views/Usuarios'
import Produtos		from '@/views/Produtos'

Vue.use(Router)

export default new Router({
  
	routes: [
		{ path: '/',                       name: 'Home',          component: Painel },
		{ path: '/painel',                 name: 'Painel',        component: Painel, props: true },
		{ path: '/paineladmin',           name: 'PainelAdmin',  component: PainelAdmin },
		{ path: '/login',         		   name: 'Login',         component: Login },
		{ path: '/usuarios',               name: 'Usuarios',      component: Usuarios },
		{ path: '/produtos',               name: 'Produtos',          component: Produtos },
	],

	base: process.env.ROUTER_BASE,
	mode: 'history'
})


