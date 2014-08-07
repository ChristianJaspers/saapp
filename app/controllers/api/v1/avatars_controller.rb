class Api::V1::AvatarsController < Api::RestrictedApplicationController
  def update
    if (uploader = Api::UploadAvatarForUser.call(self)).success?
      render_json(uploader.result, 200, serializer: Api::UserSerializer)
    else
      render_fail_json(uploader.result)
    end
  end
end
