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

  def to_s
    str = "*********************************************************\n" +
          "Queue:   #{@name} (G/G/#{@servers}/#{@clients})          \n" +
          "Arrival: #{@min_arrival} ... #{@max_arrival}             \n" +
          "Service: #{@min_service} ... #{@max_service}             \n" +
          "*********************************************************\n" +
          "   State               Time               Probability    \n"
    @states.each do |k, v|
      str = str +
            "#{k}".rjust(7) +
            "#{v[:time]}".rjust(21) +
            "#{v[:probability]}%".rjust(22) + "\n"
    end

    str = str +
          "                                                         \n" +
          "      Population: #{self.population}                     \n" +
          "      Throughput: #{self.throughput}                     \n" +
          "           Usage: #{self.usage}                          \n" +
          "   Response Time: #{self.response_time}                  \n" +
          "Number of losses: #{@losses}                             \n\n"
  end
end

simulation_file = ARGV[0]
queues = []

File.open(simulation_file) do |f|
  queue = nil
  f.each_line do |line|
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
    end
  end
end

queues.each do |q|
  puts q
end