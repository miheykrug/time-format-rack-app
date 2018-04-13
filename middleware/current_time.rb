class CurrentTime
  TIME_FORMAT = { "year" => "%Y", "month" => "%m", "day" => "%d",
                  "hour" => "%H h", "minute" => "%M m", "second" => "%S s" }.freeze

  attr_accessor :request, :time_format, :unknown_time_format

  def initialize(app)
    @app = app
  end

  def call(env)
    self.request = Rack::Request.new(env)
    self.time_format = []
    self.unknown_time_format = []

    status, headers, body = @app.call(env)

    return [404, headers, ["Not found\n"]] if !true_path?

    try_query_to_time_format

    return [400, headers, ["Unknown time format #{unknown_time_format}"]] if unknown_time_format.any?

    body << Time.now.strftime(time_format.join("-"))

    [status, headers, body]

  end

  private

  def true_path?
    request.env['REQUEST_PATH'] == '/time'
  end

  def try_query_to_time_format
    time_query = Rack::Utils.parse_nested_query(request.query_string)['format'].split(',')

    time_query.each do |time|
      if TIME_FORMAT.has_key?(time)
        time_format << TIME_FORMAT[time]
      else
        unknown_time_format << time
      end
    end
  end

end
