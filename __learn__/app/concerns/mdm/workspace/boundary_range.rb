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
      return false unless given_range # non-existent IPs aren't helpful
      allowed = false
      boundaries.each do |boundary_range|
        fine = Rex::Socket::RangeWalker.new(boundary)
        allowed = true if fine.include_range? given_range
      end
      return allowed
    end

    # Check if {#boundary} is {#valid_ip_or_range? a proper IP address or address range}
    # As this was not tested before it was ported here from Mdm, the default workspace doesn't validate
    # Always validate boundaries - a workspace may have a blank default boundary
    # @return [void]
    def boundary_must_be_ip_range
      unless boundary_blank?
        begin
          boundaries = Shellwords.split(boundary)
        rescue ArgumentError
          boundaries = []
        end
        boundaries.each do |range|
          unless valid_ip_or_range?(range)
            errors.add(
              :boundary,
              "Needs to be a valid IP range"
            )
          end
        end
      end
    end

    # Returns array of address ranges
    # @return [Array<String>]
    def addresses
      (boundary || "").split("\n")
    end

    private

    # Inform whether string is valid IP add/IP add range
    #
    # @return [true] yes - valid IP add/IP add range
    # @return [false] nope - not valid
    def valid_ip_or_range?(string)
      validRange = Rex::Socket::RangeWalker.new(string)
      validRange && validRange.ranges && validRange.ranges.any?
    end
  end
end
