class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :update, :destroy]

  # GET /goals
  def index
    @goals = Goal.where(status: params[:status])

    render json: { goals: @goals }
  end

  # GET /goals/1
  def show
    render json: @goal
  end

  # POST /goals
  def create
    goal_data = goal_params
    goal_data[:user_id] = logged_in_user.id
    @goal = Goal.new(goal_data)

    if @goal.save
      render json: @goal, status: :created, location: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /goals/1
  def update
    update_data = goal_params

    if params[:add_progress].present?
      update_data[:current_progress] = @goal.current_progress + params[:add_progress]
    end

    if @goal.update(update_data)
      @goal.update({ status: 'completed' }) if @goal.current_progress >= @goal.target

      render json: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /goals/1
  def destroy
    @goal.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_goal
    @goal = Goal.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def goal_params
    params.require(:goal).permit(:name, :measured_in, :start_from, :current_progress,
                                 :target, :deadline, :is_completed, :status)
  end
end
