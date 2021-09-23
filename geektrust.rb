require 'pry'
require './portfolio_item'
require 'date'

def main
  portfolio = []
  sip = {}
  percent_dis = {}
    input_file = ARGV[0]
    file = File.open(input_file)
    commands =  file.readlines.map(&:chomp)
    commands.each do |comm|
      split_command = comm.split
      case split_command[0]
      when "ALLOCATE"
        percent_dis = find_percent(split_command,percent_dis)
        portfolio = allocate(split_command,portfolio)
      when "SIP"
        sip = sip(split_command, sip)
      when "CHANGE"
        portfolio = change(split_command,portfolio,sip)
      when "BALANCE"
        balance(split_command,portfolio)
      when "REBALANCE"
        show_rebalanced_amount(portfolio)
      else
        "wrong input"
      end
      # Automating rebalancing condition
      len = portfolio.length()
      if len == 6 || len == 12
        rebalance(portfolio,percent_dis)
      end
    end
end

def allocate(funds, portfolio)
  portfolio.push(PortfolioItem.new('january',funds[1],funds[2],funds[3]))
end

def sip(split_command, sip)
  sip["equity"] = split_command[1]
  sip["debt"] = split_command[2]
  sip["gold"] = split_command[3]
  sip
end

def change(split_command,portfolio,sip)
  name = split_command[4]
  month_index = Date::MONTHNAMES.index(name.capitalize)
  len = portfolio.length()
  if portfolio[month_index - 1].nil?
    portfolio.push(PortfolioItem.new(name.downcase,portfolio[len-1].equity,portfolio[len-1].debt,portfolio[len-1].gold) )
  end
  portfolio.each do |port|
    if port.name == name.downcase && port.name != "january"
      port.equity = port.equity + Integer(sip["equity"])
      port.debt = port.debt + Integer(sip["debt"])
      port.gold = port.gold + Integer(sip["gold"])
    end
    if port.name == name.downcase
      g_l_percent = []
      g_l_percent.push(split_command[1].to_f)
      g_l_percent.push(split_command[2].to_f)
      g_l_percent.push(split_command[3].to_f)
      port = gain_loss(port,g_l_percent)
    end
  end
  portfolio
end

def gain_loss(port,g_l_percent)
  port.equity = Integer(port.equity).round + ((g_l_percent[0] * Integer(port.equity).round) / 100)
  port.debt = Integer(port.debt).round + ((g_l_percent[1] * Integer(port.debt).round) / 100)
  port.gold = Integer(port.gold).round + ((g_l_percent[2] * Integer(port.gold).round) / 100)
  port
end

def rebalance(portfolio,percent_dis)
  len = portfolio.length()
  final_total = Integer(portfolio[len -1].equity) + Integer(portfolio[len - 1].debt) + Integer(portfolio[len - 1].gold)
  portfolio[len -1].equity = (percent_dis["equity"] * final_total)/100
  portfolio[len -1].debt = (percent_dis["debt"] * final_total)/100
  portfolio[len -1].gold = (percent_dis["gold"] * final_total)/100
  portfolio
end

def balance(split_command,portfolio)
  name = split_command[1]
  month_index = Date::MONTHNAMES.index(name.capitalize)
  print("\n#{Integer(portfolio[month_index - 1].equity)} #{Integer(portfolio[month_index - 1].debt)} #{Integer(portfolio[month_index - 1].gold)}\n")
end

def find_percent(split_command,percent_dis)
  initial_equity_fund = split_command[1]
  initial_debt_fund = split_command[2]
  initial_gold_fund = split_command[3]
  initial_total = Integer(initial_equity_fund) + Integer(initial_debt_fund) + Integer(initial_gold_fund)
  percent_dis["equity"] = (Float(initial_equity_fund) * 100)/initial_total
  percent_dis["debt"] = (Float(initial_debt_fund) * 100)/initial_total
  percent_dis["gold"] =  (Float(initial_gold_fund) * 100)/initial_total
  percent_dis
end

def show_rebalanced_amount(portfolio)
  len = portfolio.length()
  if len.remainder(6) == 0
    print("\n#{Integer(portfolio[len - 1].equity)} #{Integer(portfolio[len - 1].debt)} #{Integer(portfolio[len - 1].gold)}\n")
  else
    print("\nCANNOT_REBALANCE\n")
  end
end

main