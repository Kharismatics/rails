<template>
  <div id="app">
    <v-app>
      <div>
        <v-app-bar>
          <v-app-bar-nav-icon></v-app-bar-nav-icon>
          <v-toolbar-title>{{ message }}</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-menu offset-y>
            <template v-slot:activator="{ on, attrs }">
              <v-badge
                :content="messages"
                :value="messages"
                color="green"
                overlap
              >
                <v-btn depressed @click="messages = 0" v-bind="attrs" v-on="on">
                  Task Today
                </v-btn>
              </v-badge>
            </template>
            <v-list>
              <v-list-item v-for="(item, index) in items" :key="index">
                <v-list-item-title>{{ item.name }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
          <v-btn icon href="/users/sign_out">
            <v-icon>mdi-logout</v-icon>
          </v-btn>
        </v-app-bar>
      </div>
      <task />
    </v-app>
  </div>
</template>
<script>
import task from "./packs/components/task.vue";
import axios from "axios";
export default {
  data: function () {
    return {
      message: "Hello Vue!",
      messages: null,
      items: [ ],
    };
  },
  components: {
    task: task,
  },
  methods: {
    getItem() {
      axios
        .get(document_root + `messages`)
        .then((response) => {
          this.messages = response.data.length;
          this.items = response.data;
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
  created() {
    this.getItem();
  },
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>