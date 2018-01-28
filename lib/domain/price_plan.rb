class PricePlan
  attr_reader :plan_name, :base_cost

  def initialize(plan_name, base_cost)
    @plan_name = plan_name
    @base_cost = base_cost
  end
end  