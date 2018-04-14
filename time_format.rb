class TimeFormat
  TIME_FORMAT = { "year" => "%Y", "month" => "%m", "day" => "%d",
                  "hour" => "%H h", "minute" => "%M m", "second" => "%S s" }.freeze

  attr_accessor :status, :body

  def initialize(query_string)
    @query_string = query_string
    @true_format = []
    @unknown_format = []
    query_to_time_format
    response
  end

  def query_to_time_format
    time_query = Rack::Utils.parse_nested_query(@query_string)['format'].split(',')

    time_query.each do |time|
      if TIME_FORMAT.has_key?(time)
        @true_format << TIME_FORMAT[time]
      else
        @unknown_format << time
      end
    end
  end

  def response
    if @unknown_format.empty?
      self.status = 200
      self.body = Time.now.strftime(@true_format.join("-"))
    else
      self.status = 400
      self.body = "Unknown time format #{@unknown_format}"
    end
  end
end
