# frozen_string_literal: true

require 'spec_helper'

describe ClickedController do
  let!(:affiliate) { affiliates('basic_affiliate') }
  let(:params) do
    {
      u: 'https://search.gov',
      q: 'query',
      p: '1',
      t: 1_588_180_422,
      a: 'nps.gov',
      s: 'source',
      v: 'vertical',
      l: 'locale',
      i: 'model_id',
      access_key: 'basic_key'
    }
  end

  describe '#index' do
    it 'sends the expected params to Click.log' do
      allow(Click).to receive(:log)

      get :index, params: params

      expect(response.status).to eq 200
      expect(Click).to have_received(:log).with(
        'https://search.gov',
        'query',
        '2020-04-29 17:13:42',
        '0.0.0.0',
        'nps.gov',
        '1',
        'source',
        'vertical',
        'locale',
        'Rails Testing',
        'model_id'
      )
    end

    context 'without an access key' do
      it 'returns a 401' do
        get :index, params: params.without(:access_key)

        expect(response.status).to eq 401
      end
    end

    context 'without an affiliate name' do
      it 'returns a 401' do
        get :index, params: params.without(:a)

        expect(response.status).to eq 401
      end
    end

    context 'without an access key and and affiliate name' do
      it 'returns a 401' do
        get :index, params: params.without(:access_key).without(:a)

        expect(response.status).to eq 401
      end
    end
  end
end
