class QueueData
  attr_reader :name, :type
  attr_accessor :min_arrival, :max_arrival, :min_service, :max_service,
                :losses, :states

  def initialize name, type
    @name = name
    @type = type
    @states = Hash.new
  end
end

simulation_file = ARGV[0]
queues = []

File.open(simulation_file) do |f|
  queue = nil
  f.each_line do |line|
    if data = line.match(/Queue:\s*(\w+)\s*\((.+)\)/)
      queue = QueueData.new data[1], data[2]
      queues << queue
    elsif data = line.match(/Arrival:\s*(\d+\.\d+)\s*\.{3}\s*(\d+\.\d+)/)
      queue.min_arrival = data[1]
      queue.max_arrival = data[2]
    elsif data = line.match(/Service:\s*(\d+\.\d+)\s*\.{3}\s*(\d+\.\d+)/)
      queue.min_service = data[1]
      queue.max_service = data[2]
    elsif data = line.match(/\s*(\d+)\s*(\d+\.\d+)\s*(\d+\.\d+)\%/)
      queue.states[data[1].to_s] = { time: data[2], probability: data[3] }
    elsif data = line.match(/Number of losses:\s*(\d+)/)
      queue.losses = data[1]
    end
  end
end

queues.each do |q|
  puts "#{q.name} #{q.type} #{q.min_arrival} #{q.max_arrival} #{q.min_service} #{q.max_service} #{q.states.size} #{q.losses}"
end