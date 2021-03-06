class PointHistoryDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def explanation
    return if point_history.entry_card_explanation.blank?

    content_tag(:div, point_history.entry_card_explanation,
                class: 'uk-width-1-1 uk-text-justify uk-margin-top')
  end

  def group_link(options = {})
    link_to point_history.group_name, group_path(point_history.group_id), options
  end

  def user_link(options = {})
    link_to point_history.user_name, profile_path(point_history.user_screen_name), options
  end

  def nice_entry_card_type
    Rails.configuration.x.entry_types[entry_card_type]
  end
end
