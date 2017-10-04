class AggregationsCollection < Hash
  def self.build_from_results(results)
    new.tap do |aggregations|
      results.aggregations.each do |key, aggregation|
        buckets = aggregation.buckets.map do |bucket|
          Aggregation.build_from_bucket(bucket, key)
        end
        aggregations.store(key, buckets)
      end
    end
  end

  class Aggregation < Struct.new(:id, :name, :group, :count)
    def self.build_from_bucket(bucket, name)
      config = Product::AGGREGATIONS[name]
      records = config[:model].all.to_a
      id = bucket[:key]
      record = records.find { |r| r.id == id }
      new id, record.send(config[:title]), name, bucket[:doc_count]
    end
  end
end
