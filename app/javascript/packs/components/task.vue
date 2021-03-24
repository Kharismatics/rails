<template>
  <v-data-table
    :headers="headers"
    :items="desserts"
    sort-by="due_date"
    class="elevation-1"
  >
    <template v-slot:item.iscomplete="{ item }">
      <v-chip
        :color="getColoriscomplete(item.iscomplete)"
        dark
        class="black--text"
      >
        {{ item.iscomplete > 0 ? "Completed" : "On Progress" }}
      </v-chip>
    </template>
    <template v-slot:item.priority="{ item }">
      <v-chip :color="getColorpriority(item.priority)" dark class="black--text">
        {{
          item.priority == 1 ? "Low" : item.priority == 2 ? "Medium" : "High"
        }}
      </v-chip>
    </template>
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>My Task</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="primary" dark class="mb-2" v-bind="attrs" v-on="on">
              New Item
            </v-btn>
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="12" md="12">
                    <v-text-field
                      v-model="editedItem.name"
                      label="Task name"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="6" sm="6" md="6">
                    <v-menu
                      ref="menu"
                      v-model="menu"
                      :close-on-content-click="false"
                      :return-value.sync="editedItem.due_date"
                      transition="scale-transition"
                      offset-y
                      min-width="auto"
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <v-text-field
                          v-model="editedItem.due_date"
                          label="Due Date"
                          prepend-icon="mdi-calendar"
                          readonly
                          v-bind="attrs"
                          v-on="on"
                        ></v-text-field>
                      </template>
                      <v-date-picker
                        v-model="editedItem.due_date"
                        no-title
                        scrollable
                      >
                        <v-spacer></v-spacer>
                        <v-btn text color="primary" @click="menu = false">
                          Cancel
                        </v-btn>
                        <v-btn
                          text
                          color="primary"
                          @click="$refs.menu.save(editedItem.due_date)"
                        >
                          OK
                        </v-btn>
                      </v-date-picker>
                    </v-menu>
                  </v-col>
                  <v-col cols="6" sm="6" md="6">
                    <v-select
                      v-model="editedItem.priority"
                      :items="items"
                      item-text="state"
                      item-value="abbr"
                      label="Priority"
                    ></v-select>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-text-field
                      v-model="editedItem.description"
                      label="Description"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-checkbox
                      false-value="0"
                      true-value="1"
                      v-model="editedItem.iscomplete"
                      :label="`Status (click to change) ${
                        editedItem.iscomplete.toString() == 1
                          ? 'Complete'
                          : 'On Progress'
                      }`"
                    ></v-checkbox>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close"> Cancel </v-btn>
              <v-btn color="blue darken-1" text @click="save"> Save </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
        <v-dialog v-model="dialogDelete" max-width="500px">
          <v-card>
            <v-card-title class="headline"
              >Are you sure you want to delete this item?</v-card-title
            >
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="closeDelete"
                >Cancel</v-btn
              >
              <v-btn color="blue darken-1" text @click="deleteItemConfirm"
                >OK</v-btn
              >
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>
    <template v-slot:item.actions="{ item }">
      <v-btn color="warning" small class="mr-2" @click="editItem(item)">
        edit
      </v-btn>
      <v-btn color="red" small @click="deleteItem(item)"> delete </v-btn>
    </template>
    <template v-slot:no-data>
      <v-btn color="primary" @click="initialize"> Reset </v-btn>
    </template>
  </v-data-table>
</template>
<script>
import axios from "axios";
export default {
  data: () => ({
    items: [
      { state: "Low", abbr: 1 },
      { state: "Medium", abbr: 2 },
      { state: "High", abbr: 3 },
    ],
    checkbox: 0,
    menu: false,
    dialog: false,
    dialogDelete: false,
    headers: [
      {
        text: "Task Name",
        align: "start",
        sortable: false,
        value: "name",
      },
      { text: "Description", value: "description" },
      { text: "Due Date", value: "due_date" },
      { text: "Priority", value: "priority" },
      { text: "Status", value: "iscomplete" },
      { text: "Actions", value: "actions", sortable: false },
    ],
    desserts: [],
    editedIndex: -1,
    editedItem: {
      name: "",
      description: "",
      due_date: new Date().toISOString().substr(0, 10),
      priority: 1,
      iscomplete: 0,
    },
    defaultItem: {
      name: "",
      description: "",
      due_date: new Date().toISOString().substr(0, 10),
      priority: 1,
      iscomplete: 0,
    },
  }),

  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "New Task" : "Edit Task";
    },
  },

  watch: {
    dialog(val) {
      val || this.close();
    },
    dialogDelete(val) {
      val || this.closeDelete();
    },
  },

  created() {
    this.initialize();
  },

  methods: {
    // initialize () {
    //   this.desserts = [
    //     {
    //       name: 'Task 1',
    //       description: 'just Task 1',
    //       due_date: new Date().toISOString().substr(0, 10),
    //       priority: 3,
    //       iscomplete: 0,
    //     },
    //   ]
    // },
    getColoriscomplete(param) {
      if (param > 0) return "green";
      else return "orange";
    },
    getColorpriority(param) {
      if (param == 3) return "red";
      else if (param == 2) return "yellow";
      else return "grey";
    },

    initialize() {
      return axios
        .get(document_root + "tasks")
        .then((response) => {
          console.log(response.data);
          this.desserts = response.data;
        })
        .catch((e) => {
          console.log(e);
        });
    },
    getItem(item) {
      axios
        .get(document_root + `tasks/${item.id}`)
        .then((response) => {
          this.dessert = response.data;
        })
        .catch((error) => {
          console.log(error);
        });
    },

    editItem(item) {
      this.editedIndex = item.id;
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },

    deleteItem(item) {
      const index = this.desserts.indexOf(item);
      confirm("Are you sure you want to delete this item?");
      axios
        .delete(document_root + `tasks/${item.id}`)
        .then((response) => {
          console.log(response);
          console.log(response.data.json);
          alert(response.data.json);
          this.initialize();
        })
        .catch((error) => {
          console.log(error);
        });
      this.desserts.splice(index, 1);
    },

    deleteItemConfirm() {
      this.desserts.splice(this.editedIndex, 1);
      this.closeDelete();
    },

    close() {
      this.dialog = false;
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      });
    },

    closeDelete() {
      this.dialogDelete = false;
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      });
    },

    save(item) {
      if (this.editedIndex > -1) {
        axios
          .put(document_root + `tasks/` + this.editedItem.id, {
            id: this.editedItem.id,
            name: this.editedItem.name,
            description: this.editedItem.description,
            due_date: this.editedItem.due_date,
            priority: this.editedItem.priority,
            iscomplete: this.editedItem.iscomplete,
          })
          .then((response) => {
            console.log(response);
            this.initialize();
          })
          .catch((error) => {
            console.log(error);
          });
      } else {
        axios
          .post(document_root + `tasks/`, {
            task: this.editedItem,
          })
          .then((response) => {
            console.log(response);
            console.log("Created!");
            this.initialize();
          })
          .catch((error) => {
            console.log(error);
          });
      }
      this.close();
    },
  },
};
</script>