class NightReport
  attr_reader :business_date, :records

  def initialize(business_date)
    @business_date = business_date
    @records = []
  end

  def read_input(path)
    File.foreach(path) do |line|
      account, amount, status = line.strip.split(",")
      @records << { account: account, amount: amount.to_i, status: status }
    end
  end

  def summary
    successful = @records.select { |record| record[:status] == "OK" }
    { count: @records.length, total: successful.sum { |record| record[:amount] } }
  end

  def write_report(path)
    File.write(path, "#{@business_date},#{summary}\n")
  end
end
