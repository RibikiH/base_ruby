module DbZenginBank
  extend ActiveSupport::Concern

  included do
    scope :search_with, ->(params) {
      return where(id: nil) unless [:code, :branch_code, :sort_code, :char].any?{|x|params[x].present?}

      rel = self
      rel = rel.where(code: params[:code]) if params[:code].present?
      rel = rel.where(branch_code: params[:branch_code]) if params[:branch_code].present?
      rel = rel.where(sort_code: params[:sort_code]) if params[:sort_code].present?
      
      if (regex_value = Settings.bank_initial[params[:char]]).present?
        if params[:code].present?
          rel = rel.where("branch_kana ~* ?", "^#{regex_value}").order(:branch_kana)
        else
          attrs = "name, kana, code"
          rel = rel.where("kana ~* ?", "^#{regex_value}").group(attrs).select(attrs).order(:kana)
        end
      end
      
      rel
    }
  end
end