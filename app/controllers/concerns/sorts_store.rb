module SortsStore
  extend ActiveSupport::Concern
  
  private
  def sorts_store(q)
    action_key = "#{controller_path}::#{params[:action]}"
    sorts = JSON.parse(cookies[:sorts_store]) rescue {}
    checksum = sorts.hash
    
    if params[:button] == "reset"
      sorts.delete(action_key)

    else
      if q[:s].present?
        sorts[action_key] = q[:s]
      elsif sorts[action_key].present?
        q[:s] = sorts[action_key]
      end
    end
    
    cookies.permanent[:sorts_store] = sorts.to_json unless checksum == sorts.hash
    q
  end
end