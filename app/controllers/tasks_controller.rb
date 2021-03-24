class TasksController < ApplicationController
    def index
        @tasks = Task.all
        render json: @tasks 
    end
    def show
        @task = Task.find(params[:id])
        render json: { data: @task, status: :ok, message: 'Success' }
    end
    def create
        @task = Task.new(task_params)
        if @task.save
        render json: { status: :ok, message: 'Success' }
        else
        render json: { json: @task.errors, status: :unprocessable_entity }
        end
    end
    def update
        @task = Task.find(params[:id])
        if @task.update(task_params)
        render json: { status: :ok, message: 'Success' }
        else
        render json: { json: @task.errors, status: :unprocessable_entity }
        end
    end
    def destroy
        @task = Task.find(params[:id])
        if @task.destroy
        render json: { json: 'Task was successfully deleted.'}
        else
        render json: { json: @task.errors, status: :unprocessable_entity }
        end
    end
    private
    def task_params
        params.require(:task).permit(:id, :name, :description, :due_date, :priority, :iscomplete)
    end
end