class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.where('deadline LIKE (?)', params[:date] + '%').where(user_id: logged_in_user.id).order(:id)

    @completion_percentage = nil
    if @tasks.count > 0
      @completion_percentage = @tasks.where('is_completed', true).count * 100.00 / @tasks.count
      @completion_percentage = @completion_percentage.round(0)
    end 
    
    render json: { tasks: @tasks, completion_percentage: @completion_percentage }
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    task_data = task_params
    task_data[:user_id] = logged_in_user.id
    @task = Task.new(task_data)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    params.require(:task).permit(:name, :deadline, :description, :is_completed)
  end
end
