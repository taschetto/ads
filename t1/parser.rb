require 'tempfile'
require 'fileutils'

class QueueData
  PRECISION = 5

  attr_reader :name, :servers, :clients
  attr_accessor :min_arrival, :max_arrival, :min_service, :max_service,
                :losses, :states

  def initialize name, servers, clients
    @name = name
    @servers = servers
    @clients = clients
    @states = Hash.new
  end

  def population
    result = 0
    @states.each do |k, v|
      result += k.to_i * v[:probability] / 100
    end
    result.round(PRECISION)
  end

  def throughput
    result = 0
    @states.each do |k, v|
      result += v[:probability] / 100 * [k.to_i, @servers].min
    end
    result.round(PRECISION)
  end

  def usage
    result = 0
    @states.each do |k, v|
      result += v[:probability] / 100 * [k.to_i, @servers].min / @servers
    end
    result.round(PRECISION)
  end

  def response_time
    (self.population / self.throughput).round(PRECISION)
  end
end

temp_file = Tempfile.new('temp_file')

simulation_file = ARGV[0]
queues = []

begin
  File.open(simulation_file) do |f|
    queue = nil
    f.each_line do |line|
      temp_file.puts line
      if data = line.match(/Queue:\s*(\w+)\s*\(G\/G\/(\d+)\/(\d+)\)/)
        queue = QueueData.new data[1], data[2].to_i, data[3].to_i
        queues << queue
      elsif data = line.match(/Arrival:\s*(\d+\.\d+)\s*\.{3}\s*(\d+\.\d+)/)
        queue.min_arrival = data[1].to_i
        queue.max_arrival = data[2].to_i
      elsif data = line.match(/Service:\s*(\d+\.\d+)\s*\.{3}\s*(\d+\.\d+)/)
        queue.min_service = data[1].to_i
        queue.max_service = data[2].to_i
      elsif data = line.match(/\s*(\d+)\s*(\d+\.\d+)\s*(\d+\.\d+)\%/)
        queue.states[data[1].to_s] = { time: data[2].to_f, probability: data[3].to_f }
      elsif data = line.match(/Number of losses:\s*(\d+)/)
        queue.losses = data[1].to_i
        temp_file.puts "      Population: #{queue.population}\n" +
                       "      Throughput: #{queue.throughput}\n" +
                       "           Usage: #{queue.usage}\n" +
                       "   Response Time: #{queue.response_time}\n"
      end
    end
  end
  temp_file.close
  FileUtils.mv(temp_file.path, simulation_file)
ensure
  temp_file.close
  temp_file.unlink
end