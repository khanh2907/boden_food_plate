module ApplicationHelper
  def meal_label_color(name)
    case name
      when 'Breakfast'
        'success'
      when 'Snack'
        'info'
      when 'Lunch'
        'warning'
      when 'Dinner'
        'primary'
      else
        'default'
    end

  end
end
