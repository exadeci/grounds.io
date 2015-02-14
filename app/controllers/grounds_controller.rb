class GroundsController < ApplicationController
  def show
    ground = Ground.new_or_default(session[:language])
    @ground = GroundDecorator.new(ground, view_context)
  end

  def shared
    ground = Ground.find(params[:id])
    @ground = GroundDecorator.new(ground, view_context)
    render 'show'
  end

  def share
    @ground = Ground.new(ground_params)
    @gist = Gist.new
    @gist.create(@ground.code)
    Rails.logger.debug(@gist)
    if @ground.save
      render json: { shared_url: ground_shared_url(@ground) }
    else
      render json: {}, status: :bad_request
    end
  end

  def switch_option
    option, code = params[:option], params[:code]
    if Editor.has_option?(option, code)
      session[option] = code
      render json: {}
    else
      render json: {}, status: :bad_request
    end
  end

  private

  def ground_params
    params.require(:ground).permit(:language, :code)
  end
end
