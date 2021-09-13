module ApplicationHelper
  def active_nav?(re)
    if Regexp.compile(re) =~ request.fullpath
      'active'
    else
      ''
    end
  end
end
