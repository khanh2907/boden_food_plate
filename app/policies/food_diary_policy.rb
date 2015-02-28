class FoodDiaryPolicy
  attr_reader :user, :model

  def initialize(current_resource, model)
    if current_resource.instance_of? Participant
      @current_participant = current_resource
      @current_user = nil
    else
      @current_user = current_resource
      @current_participant = nil
    end

    @food_diary = model
  end

  def index?
    return false if @current_participant
    @current_user.admin?
  end

  def update?
    @current_user.admin? || @food_diary.participant == @current_participant
  end

  def destroy?
    return false if @current_participant
    @current_user.admin?
  end

  def new?
    return false if @current_participant
    @current_user.admin?
  end

  def create?
    return false if @current_participant
    @current_user.admin?
  end

  def edit?
    return false if @current_participant
    @current_user.admin?
  end

  def show?
    return true if @current_user
    @food_diary.participant == @current_participant
  end

  def day?
    return true if @current_user
    @food_diary.participant == @current_participant
  end

  def next_day?
    return true if @current_user
    @food_diary.participant == @current_participant
  end

  def breakdown?
    return true if @current_user
    @food_diary.participant == @current_participant
  end
end
