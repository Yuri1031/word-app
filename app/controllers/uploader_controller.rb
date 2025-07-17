class UploaderController < ApplicationController
  skip_forgery_protection

  before_action do
    ActiveStorage::Current.url_options = { host: request.base_url }
  end

  def image
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params[:file],
      filename: params[:file].original_filename,
      content_type: params[:file].content_type
    )
    render json: { location: url_for(blob) }, content_type: "application/json"

  end
end
