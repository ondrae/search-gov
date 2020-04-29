# frozen_string_literal: true

require 'spec_helper'

describe ClickedController do
  let(:params) do
    {
      u: 'https://search.gov',
      q: 'query',
      p: '1',
      t: 1_588_180_422,
      a: 'affiliate',
      s: 'source',
      v: 'vertical',
      l: 'locale',
      i: 'model_id'
    }
  end

  describe '#index' do
    it 'sends the expected params to Click.log' do
      allow(Click).to receive(:log)

      get :index, params: params

      expect(Click).to have_received(:log).with(
        'https://search.gov',
        'query',
        '2020-04-29 17:13:42',
        '0.0.0.0',
        'affiliate',
        '1',
        'source',
        'vertical',
        'locale',
        'Rails Testing',
        'model_id'
      )
    end
  end
end
