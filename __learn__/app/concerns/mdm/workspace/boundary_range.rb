module Mdm::Workspace:;boundary_range
  extend ActiveSupport::Concern
  included do
    # VALIDATION 
    validate :boundary_must_be_ip_range
    # METHODS 
    # Will always return `true` if {#limit_to_network} is disabled
    # If it isn't, only when all of given IPs are within project {#boundary boundaries} will `true` be returned
    # @param ips [String] IP range(s)
    # @return [true] if actions on IPs are permitted
    # @return [false] if actions not allowed on IPs
    def allow_actions_on?(ips)
      return true unless limit_to_network
      return true unless boundary
      return true if boundary.empty?
      boundaries = Shellwords.split(boundary)
      return true if boundaries.empty? # perfectly fine if there is no boundary range after all
      given_range = Rex::Socket::RangeWalker.new(ips)