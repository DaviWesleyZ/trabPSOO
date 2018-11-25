<template>
    <v-card md12 >
        <v-card-title>
            <h1>Listagem de produtos</h1>
            <v-spacer></v-spacer>
           
                <v-text-field
                    v-model="search"
                    append-icon="search"
                    label="Pesquisar"
                    single-line
                    hide-details
                ></v-text-field>

                <botao-filtro
                    v-model="showFiltro"
                    class="ml-4"
                ></botao-filtro>
            

            <filtro
                v-model="filtros"
                :itens="produtos"
                @itensFiltrados="produtosFiltrados = $event"
                :forceUpdate="updateFiltro"
                :showFiltro="showFiltro">
            </filtro>
        </v-card-title>

        <v-data-table
            :headers="headers"
            :items="produtosFiltrados"
            :search="search"
            class="compact">
            <template slot="items" slot-scope="props">
                    <td>{{ props.item.codigo }}</td>
                    <td>{{ props.item.descricao }}</td>
                    <td>{{ props.item.quantidade }}</td>
                    <td>{{ props.item.valor }}</td><td>
                </td>
            </template>
        
        </v-data-table>
    </v-card>
</template>

<script>
export default {
    data() {
        return {
            search: "",

            filtros: [
                { text: 'Código',  campo: 'codigo', type: 'autocomplete'},
                { text: 'Descrição',  campo: 'descricao', type: 'autocomplete'},
                { text: 'Quantidade',  campo:"quantidade", type:'autocomplete'},
                { text: 'Valor',  campo: 'valor', type:'autocomplete'},
            ],

            headers: [
                { text: 'Código',       value: 'codigo'},
                { text: 'Descrição',       value: 'descricao' },
                { text: 'Quantidade',  value: 'quantidade'},
                { text: 'Valor',     value: 'valor'}
            ],

            produtos: [],
            produtosFiltrados: [],
            updateFiltro: 0,
            showFiltro: false,
        }
    },

    mounted() {
        
         this.getTodosProdutos((produtos) => {
            this.produtos = produtos;
        });
    },

}
</script>


