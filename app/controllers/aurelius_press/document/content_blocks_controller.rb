class AureliusPress::Document::ContentBlocksController < AureliusPress::ApplicationController
  before_action :authenticate_user!
  before_action :set_content_block

  def destroy
    authorize @content_block, :destroy?, policy_class: AureliusPress::Document::ContentBlockPolicy
    @document = @content_block.document
    @content_block.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to edit_path_for(@document), notice: "Content block removed." }
    end
  end

  private

  def set_content_block
    @content_block = AureliusPress::ContentBlock::ContentBlock.find(params[:id])
  end

  def edit_path_for(document)
    case document
    when AureliusPress::Document::BlogPost
      edit_aurelius_press_blog_post_path(document)
    when AureliusPress::Document::Page
      edit_aurelius_press_page_path(document)
    else
      root_path
    end
  end
end
