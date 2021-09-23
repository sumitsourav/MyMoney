class Portfolio
  attr_accessor :operation, :equity, :debt, :gold

  def initialize(equity, debt, gold)
    @operation
    @equity = equity
    @debt = debt
    @gold = gold
  end
end