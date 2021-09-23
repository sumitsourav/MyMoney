class Funds
  attr_accessor :equity, :debt, :gold

  def initialize(equity, debt, gold)
    @equity = equity
    @debt = debt
    @gold = gold
  end
end