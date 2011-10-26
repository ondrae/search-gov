require 'spec/spec_helper'

describe IndexedDocumentFetcher, "#perform(indexed_document_id)" do
  fixtures :affiliates
  before do
    @aff = affiliates(:power_affiliate)
    IndexedDocument.destroy_all
    @indexed_document = IndexedDocument.create(:url => 'http://search.usa.gov/', :affiliate => @aff)
  end
  
  context "when it can't locate the IndexedDocument for a given id" do
    before do
      IndexedDocument.stub!(:find).and_return nil
    end
    
    it "should ignore the entry" do
      @indexed_document.should_not_receive(:fetch)
      IndexedDocumentFetcher.perform(1)
    end
  end

  context "when it can locate the Superfresh URL entry for a given url & affiliate_id" do
    before do
      IndexedDocument.stub!(:find).and_return @indexed_document
    end
    
    it "should attempt to fetch and index the document" do
      @indexed_document.should_receive(:fetch)
      IndexedDocumentFetcher.perform(@indexed_document.id)
    end
  end
end