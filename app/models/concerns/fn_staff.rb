module FnStaff
  extend ActiveSupport::Concern

  module ClassMethods
    def send_entry_transfer(entry)
      return unless entry.self_service_transfer?

      entry.company.staffs.find_each do |recipient|
        FurikomiMailer.staff_entry_transfer(entry: entry, recipient: recipient).deliver_later
      end
    end

    def send_entry_cancel(entry)
      entry.company.staffs.find_each do |recipient|
        FurikomiMailer.staff_entry_cancel(entry: entry, recipient: recipient).deliver_later
      end
    end
  end
end
