<template>
  <div id="app">
    <v-app>
      <p>{{ message }}</p>
      <task/>
    </v-app>
  </div>
</template>

<script>
import task from "./packs/components/task.vue";
export default {
  data: function() {
    return {
      message: "Hello Vue!"
    };
  },
  components: {
    task: task
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>