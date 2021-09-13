module HasPaperTrailWithDevise
  extend ActiveSupport::Concern

  included do
    has_paper_trail skip: %w(created_at updated_at reset_password_token reset_password_sent_at remember_created_at sign_in_count current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip failed_attempts unlock_token locked_at)
  end
end