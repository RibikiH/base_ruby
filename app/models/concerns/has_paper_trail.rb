module HasPaperTrail
  extend ActiveSupport::Concern

  included do
    has_paper_trail skip: %w(created_at updated_at)
  end
end