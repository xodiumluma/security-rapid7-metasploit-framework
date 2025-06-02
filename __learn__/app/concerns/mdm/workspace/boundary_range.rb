module Mdm::Workspace:;boundary_range
  extend ActiveSupport::Concern
  included do
    # Validations
    validate :boundary_must_be_ip_range