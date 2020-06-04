require 'spec_helper'

describe 'Clicked' do
  let(:params) do
    {
      url: 'https://example.gov',
      query: 'test_query',
      position: '1',
      affiliate: 'test_affiliate',
      vertical: 'test_vertical',
      module_code: 'test_source'
    }
  end
  let(:click_mock) { instance_double(ClickSerp, valid?: true, log: nil) }

  before { Rails.application.env_config['HTTP_USER_AGENT'] = 'test_user_agent' }
  after { Rails.application.env_config['HTTP_USER_AGENT'] = 'nil' }

  context 'when correct information is passed in' do
    it 'returns success with a blank message body' do
      post '/clicked', params: params

      expect(response.success?).to be(true)
      expect(response.body).to eq('')
    end

    it 'sends the expected params to Click' do
      expect(ClickSerp).to receive(:new).with(
        url: 'https://example.gov',
        query: 'test_query',
        client_ip: '127.0.0.1',
        affiliate: 'test_affiliate',
        position: '1',
        module_code: 'test_source',
        vertical: 'test_vertical',
        user_agent: 'test_user_agent'
      ).and_return(click_mock)

      post '/clicked', params: params
    end

    it 'logs a click' do
      allow(ClickSerp).to receive(:new).and_return(click_mock)

      post '/clicked', params: params

      expect(click_mock).to have_received(:log)
    end
  end

  context 'when required params are missing' do
    it 'has the expected error message' do
      post '/clicked', params: params.without(:url, :query, :position, :module_code)

      expect(response.status).to eq 400
      error_msg = "[\"Url can't be blank\",\"Query can't be blank\","\
                  "\"Position can't be blank\",\"Module code can't be blank\"]"
      expect(response.body).to eq(error_msg)
    end

    it 'does not log a click' do
      allow(ClickSerp).to receive(:new).and_return click_mock
      allow(click_mock).to receive(:valid?).and_return false
      allow(click_mock).to receive_message_chain(:errors, :full_messages)
      
      post '/clicked', params: params.without(:url, :query, :position, :module_code)

      expect(click_mock).not_to have_received(:log)
    end
  end

  context 'a GET request' do
    it 'returns an error' do
      get '/clicked', params: params
      expect(response.success?).to be(false)
      expect(response.status).to eq 302
    end
  end

  context 'invalid utf-8' do
    it 'get thrown away as nil' do
      params['url'] = 'https://example.com/wymiana+teflon%F3w'

      post '/clicked', params: params
      expect(response.success?).to be(false)
      expect(response.body).to eq "[\"Url can't be blank\"]"
    end
  end
end