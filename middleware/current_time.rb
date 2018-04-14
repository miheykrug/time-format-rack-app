require_relative '../time_format'

class CurrentTime

  def call(env)
    @request = Rack::Request.new(env)

    if true_path?
      time = TimeFormat.new(@request.query_string)
      response(time.status, time.body)
    else
      response(404, "Not found\n")
    end
  end

  private

  def response(status, body)
    [
      status,
      { 'Content-Type' => 'text/plain' },
      [body]
    ]
  end

  def true_path?
    @request.path_info == '/time'
  end


end
