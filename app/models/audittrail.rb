class Audittrail < ApplicationRecord

  scope :for_datatables, -> {
    select("id,module,event_description,host(ip_address) as ipaddress,created_at,modified_by_name")
  }

  scope :recent_changes, -> {
    select("a.event_description,host(a.ip_address) as ip_address,a.modified_by_email,a.modified_by_name,a.created_at,u.photo_file_name")
      .from("audittrails a join users u on a.modified_by_email = u.email")
      .order("a.id DESC")
      .limit(5)
  }
end