class AccountService
    def initialize(smart_meter_to_price_plan_accounts)
        @smart_meter_to_price_plan_accounts = smart_meter_to_price_plan_accounts
    end

    def price_plan_for_meter(meter_id)
        @smart_meter_to_price_plan_accounts[meter_id]
    end
end