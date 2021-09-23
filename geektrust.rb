require 'pry'
require './fund'
require './sip'

$monthly_sip = Hash.new({
  "equity" => 0,
  "debt" => 0,
  "gold" => 0
})

$change_rate = Hash.new

$portfolio = Hash.new({
})
def main
    input_file = ARGV[0]
    file = File.open(input_file)
    commands =  file.readlines.map(&:chomp)
    commands.each do |comm|
      command_parser(comm)
    end
    print $total_funds
    print $monthly_sip
end

def command_parser(command)
  split_command = command.split
  case split_command[0]
  when "ALLOCATE"
    allocate(split_command)
  when "SIP"
    sip(split_command)
  when "CHANGE"
    change(split_command)
  when "BALANCE"
  when "REBALANCE"
  else
    "wrong input"
  end
end

def allocate(funds)
  $portfolio["january"] = {
    "equity" => funds[1],
    "debt" => funds[2],
    "gold" => funds[3]
  }
end

def sip(sip)
  $monthly_sip["equity"] = sip[1]
  $monthly_sip["debt"] = sip[2]
  $monthly_sip["gold"] = sip[3]
end

def change(rate)
  
end


main