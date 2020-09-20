class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.where('deadline LIKE (?)', params[:date] + '%').where(user_id: logged_in_user.id)

    @completion_percentage = nil
    if @tasks.count > 0
      @completion_percentage = @tasks.where('is_completed', true).count * 100.00 / @tasks.count
      @completion_percentage = @completion_percentage.round(0)
    end

    render json: { tasks: @tasks.as_json(include: :tags), completion_percentage: @completion_percentage }
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  def group_by_criteria
    deadline.to_date.to_s(:db)
  end

  def task_completion_data
    @data = []
    tasks = Task.where('deadline >= ?', params[:number_of_days].to_i.days.ago.to_datetime.beginning_of_day)
                .where('deadline <= ?', 0.days.ago.to_datetime.end_of_day)
    grouped_tasks_by_day = tasks.group_by(&:deadline).map { |k, v| [k, v] }.sort
    grouped_tasks_by_day.each do |tasks_data|
      completion_percentage = tasks_data[1].select { |task| task[:is_completed] == true }.count * 100.00 / tasks_data[1].count
      @data.push({ date: tasks_data[0], completion_percentage: completion_percentage.round(0) })
    end
    render json: @data
  end

  # POST /tasks
  def create
    task_data = task_params
    task_data[:user_id] = logged_in_user.id
    task_data[:deadline] = Date.parse(params[:deadline]).end_of_day
    @task = Task.new(task_data)

    if @task.save
      tags = params.require(:tags)

      tags.each do |tag|
        if tag[:id].present?
          TasksTag.create({ task_id: @task.id, tag_id: tag[:id] })
        else
          new_tag = Tag.create!({ name: tag[:name].upcase, code: tag[:name].downcase })
          TasksTag.create({ task_id: @task.id, tag_id: new_tag.id })
        end
      end

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
    @task.tags.delete_all
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
