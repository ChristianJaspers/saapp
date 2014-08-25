shared_examples 'api: forbidden' do
  it { expect(response.status).to eq 403 }

  it do
    expect(response.body).to be_json_eql <<-EOS
      {
        "error": {
          "code": 1010,
          "message": "#{ I18n.t('api.errors.no_access') }"
        }
      }
    EOS
  end
end
