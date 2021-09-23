class PortfolioItem
  attr_accessor :name, :equity, :debt, :gold

  def initialize(name, equity, debt, gold)
    @name = name
    @equity = equity
    @debt = debt
    @gold = gold
  end
end