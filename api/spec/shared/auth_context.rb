# frozen_string_literal: true

require 'json_web_token'

RSpec.shared_context 'with user authentication', shared_context: :metadata do
  let(:user_id) { user_id }
  let(:id_token) do
    {
      'user' => {
        'id' => user_id
      }
    }
  end
  let(:Authorization) { 'Bearer token' }
  before do
    allow(JsonWebToken).to receive(:decode).and_return(id_token)
  end
end

RSpec.shared_context 'with missing jwt authentication', shared_context: :metadata do
  let(:Authorization) { nil }
  before do
    allow(JsonWebToken).to receive(:decode).and_raise(JWT::VerificationError)
  end
end
