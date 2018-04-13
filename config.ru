require_relative 'middleware/current_time'
require_relative 'app'

use CurrentTime
run App.new
