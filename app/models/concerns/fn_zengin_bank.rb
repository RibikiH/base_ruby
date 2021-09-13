module FnZenginBank
  extend ActiveSupport::Concern

  module ClassMethods
    # How to use
    # io = IO.read csv, encoding: 'cp932'
    # CSV.parse(io) do |row|
    #   ZenginBank.from_csv(row)
    # end
    def from_csv(row)
      x = new
      x.code = row[0]
      x.branch_code = row[1]
      x.kana = NKF.nkf("-Ww -X", row[2].to_s)
      x.name = row[3]
      x.branch_kana = NKF.nkf("-Ww -X", row[4].to_s)
      x.branch_name = row[5]
      x.zip = row[6]
      x.address = row[7]
      x.tel = row[8]
      x.clearing_house_number = row[9]
      x.sort_code = row[10]
      x.domestic_exchange = row[11]
      
      x.save
      x
    end
  end

end