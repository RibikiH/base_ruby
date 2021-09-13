require "csv"
module Crud
  extend ActiveSupport::Concern
  include DetectModel
  include SortsStore
  
  included do
    class_attribute :sorts
    append_view_path("app/views/crud")
  end
  
  def index
    q = params[:q] || {}
    q.keys.each do |key|
      if key.to_s =~ /_(in|any|all)$/ && q[key].kind_of?(String)
        begin
          q[key] = CSV.parse_line q[key], col_sep: " "
        rescue CSV::MalformedCSVError
          q[key] = ""
        end
      end
    end
    q = sorts_store(q)
    @q = model.search(q)
    @q.sorts = sorts
    
    before_result
    @rel = @q.result(distinct: true)
    after_result
    
    if params[:format] == "csv"
      raise ActiveRecord::RecordNotFound if @rel.count > 1000
      return 
    end
    
    @list = @rel.page(params[:page])
    before_render
  end
  
  def new
    @item = model.new
  end

  def create
    @item = model.new(permitted_params)
    before_create
    respond_to do |format|
      if @item.save
        format.html { redirect_to url_after_create, notice: model.model_name.human+I18n.t('actions.saved') }
        format.json { render :show, status: :created, location: url_after_create }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @item.attributes = permitted_params
    before_update
    respond_to do |format|
      if @item.save
        format.html { redirect_to url_after_update, notice: model.model_name.human+I18n.t('actions.updated') }
        format.json { render :show, status: :ok, location: url_after_update }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to url_after_destroy, notice: model.model_name.human+I18n.t('actions.deleted') }
      format.json { head :no_content }
      format.js
    end
  end

  private
  def permitted_params
    raise NotImplementedError, "you must override permitted_params"
  end
  def url_after_destroy
    [namespace, @parent_item, @item.class].compact
  end
  def url_after_create
    [:edit, namespace, @parent_item, @item].compact
  end
  def url_after_update
    [:edit, namespace, @parent_item, @item].compact
  end
  
  def before_result
  end
  def after_result
  end
  def before_render
  end
  def before_create
  end
  def before_update
  end
end