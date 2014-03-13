class NewsItemsDestroyer
  extend Resque::Plugins::Priority
  @queue = :primary

  def self.perform(rss_feed_url_id)
    NewsItem.where(rss_feed_url_id: rss_feed_url_id).select(:id).
        find_in_batches(batch_size: 10000) do |group|
      ids = group.map(&:id).freeze
      ElasticNewsItem.delete(ids)
      NewsItem.delete_all(['id IN (?)', ids])
    end
  end
end