module ApplicationHelper
  def humanize_runtime(time)
    hours = time / 60
    minutes = time % 60
    "#{hours} #{'Hour'.pluralize(hours)}, #{minutes} #{'minutes'.pluralize(minutes)}"
  end
end
