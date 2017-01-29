module HasJsonResult
  extend ActiveSupport::Concern

  included do
    let(:result) do
      body = JSON.parse(req.body)
      body.is_a?(Array) ? body.map(&:deep_symbolize_keys) : body.deep_symbolize_keys
    end
  end
end
