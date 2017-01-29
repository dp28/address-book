module ErrorSpecs
  extend ActiveSupport::Concern
  include HasJsonResult

  included do
    shared_examples_for 'an API error' do |options|
      it { should have_http_status options.fetch(:status, :bad_request) }

      it 'should have an error message aimed at developers to help with debugging' do
        expect(result[:message]).to match options.fetch(:message)
      end

      it 'should have a machine-parseable key that could be used in transalations' do
        expect(result[:key]).to eq options.fetch(:key)
      end
    end

    shared_examples_for 'requiring a parameter' do |param|
      it_should_behave_like 'an API error', message: /#{param}.*required/, key: 'missing_parameter'
    end

    shared_examples_for 'a not found response' do |entity|
      it_should_behave_like(
        'an API error', message: /#{entity}.+found/i, key: 'not_found', status: :not_found
      )
    end
  end
end
