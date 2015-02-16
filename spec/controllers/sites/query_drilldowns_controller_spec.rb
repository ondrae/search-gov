require 'spec_helper'

describe Sites::QueryDrilldownsController do
  render_views
  fixtures :users, :affiliates, :memberships
  before { activate_authlogic }

  describe '#show' do
    it_should_behave_like 'restricted to approved user', :get, :show

    context 'when affiliate is downloading query CSV data' do
      include_context 'approved user logged in to a site'
      let(:drilldown_queries_response) { JSON.parse(File.read("#{Rails.root}/spec/fixtures/json/rtu_dashboard/drilldown_queries.json")) }

      before do
        ES::client_reader.stub(:search).and_return(drilldown_queries_response)
      end

      it 'should generate a CSV of various query fields' do
        get :show, query:'foo', start_date: '2015-02-01', end_date: '2015-02-05', format: 'csv'
        response.content_type.should eq("text/csv; charset=utf-8; header=present")
        response.headers["Content-Disposition"].should eq("attachment;filename=nps.gov_foo_2015-02-01_2015-02-05.csv")
        response.body.should start_with(Sites::QueryDrilldownsController::HEADER_FIELDS.to_csv)
        response.body.should contain("2015-02-01,04:52:14,204.184.232.180,US,MO,Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko,Other,IE,Windows 7,http://search.usa.gov/search?utf8=%E2%9C%93&affiliate=usagov&query=fashion+psychology,http://search.usa.gov/search?affiliate=usagov&query=fashion,web,BWEB BOOS")
      end
    end
  end
end