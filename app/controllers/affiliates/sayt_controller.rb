class Affiliates::SaytController < Affiliates::AffiliatesController
  before_filter :require_affiliate_or_admin, :except => 'demo'
  before_filter :setup_affiliate, :except => 'demo'

  def index
    @title = "Type-ahead Search - "
    @sayt_suggestion = SaytSuggestion.new
    @filter = params[:filter]
    conditions = @filter.present? ? ["affiliate_id = ? AND phrase LIKE ? AND ISNULL(deleted_at)", @affiliate.id, "#{@filter}%"] : ["affiliate_id = ? AND ISNULL(deleted_at)", @affiliate.id]
    @sayt_suggestions = SaytSuggestion.paginate(:conditions => conditions, :page => params[:page] || 1, :order => 'phrase ASC')
  end

  def create
    @sayt_suggestion = SaytSuggestion.find_or_initialize_by_affiliate_id_and_phrase(@affiliate.id, params[:sayt_suggestion][:phrase])
    if @sayt_suggestion.id.present? and @sayt_suggestion.deleted_at.nil?
      flash[:error] = "Unable to add: <b>#{@sayt_suggestion.phrase}</b>; Please check the phrase and try again.  Note: <ul><li>Duplicate phrases are rejected.</li><li>Phrases must be at least 3 characters.</li></ul>".html_safe
    else
      @sayt_suggestion.is_protected = true
      @sayt_suggestion.popularity = SaytSuggestion::MAX_POPULARITY
      @sayt_suggestion.affiliate = @affiliate
      @sayt_suggestion.deleted_at = nil
      @sayt_suggestion.save
      flash[:success] = "Successfully added: #{@sayt_suggestion.phrase}"
    end
    redirect_to affiliate_type_ahead_search_index_path(@affiliate)
  end

  def destroy
    @sayt_suggestion = SaytSuggestion.find(params[:id])
    if @sayt_suggestion
      @sayt_suggestion.update_attributes(:deleted_at => Time.now, :is_protected => true)
      flash[:success] = "Deleted phrase: #{@sayt_suggestion.phrase}"
    end
    redirect_to affiliate_type_ahead_search_index_path(@affiliate)
  end

  def upload
    result = SaytSuggestion.process_sayt_suggestion_txt_upload(params[:txtfile], @affiliate)
    if result
      flashy = "#{result[:created]} Type-ahead Search suggestions uploaded successfully."
      flashy += " #{result[:ignored]} Type-ahead Search suggestions ignored." if result[:ignored] > 0
      flash[:success] = flashy
    else
      flash[:error] = "Your file could not be processed. Please check the format and try again."
    end
    redirect_to affiliate_type_ahead_search_index_path(@affiliate)
  end

  def preferences
    @affiliate.update_attribute(:is_sayt_enabled, params[:is_sayt_enabled] == '1')
    redirect_to affiliate_type_ahead_search_index_path(@affiliate), :flash => { :success => 'Preferences updated.' }
  end

  def demo
    @affiliate = Affiliate.find_by_id(params[:affiliate_id])
    render :layout => 'affiliate_sayt'
  end

  def destroy_all
    @affiliate.sayt_suggestions.destroy_all
    redirect_to affiliate_type_ahead_search_index_path(@affiliate), :flash => { :success => 'All type-ahead search suggestions successfully deleted.' }
  end
end