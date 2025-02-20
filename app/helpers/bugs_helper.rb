module BugsHelper
  def color_class(bug)
    return 'bg-warning-subtle text-dark' if bug.new_bug?
    return 'bg-primary-subtle text-dark' if bug.started?
    return 'bg-success-subtle text-dark' if bug.resolved?
  end
end
