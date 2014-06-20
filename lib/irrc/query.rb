require 'irrc/irr'
require 'irrc/query_status'

module Irrc

  # Public: IRR/whois query and result container
  class Query
    include Irrc::Irr
    include Irrc::QueryStatus

    attr_reader :sources, :protocols

    # Public: Create a new Query object
    #
    # object  - IRR object to extract. (eg: as-set, route-set, aut-num object)
    # options - The Hash options to pass to IRR (default: {procotol: [:ipv4, :ipv6]})
    #           :source   - Specify authoritative IRR source names.
    #                       If not given, any source will be accepted. (optional)
    #           :protocol - :ipv4, :ipv6 or [:ipv4, :ipv6]
    #                       A String or Symbol of protcol name is accepted. (optional)
    #
    # Examples
    #
    #   Irrc::Query.new('AS-JPNIC', source: :jpirr, protocol: :ipv4)
    #   Irrc::Query.new('AS-JPNIC', source: [:jpirr, :radb])
    def initialize(object, options={})
      options = {protocol: [:ipv4, :ipv6]}.merge(options)
      @sources = Array(options[:source]).compact.map(&:to_s).flatten.uniq
      @protocols = Array(options[:protocol]).compact.map(&:to_s).flatten.uniq
      self.object = object.to_s
    end

    def result
      @result ||= Struct.new(:ipv4, :ipv6).new
    end

    # Public: Register aut-num object(s) as a result.
    #
    # autnums - aut-num object(s) in String. Array form is also acceptable for multiple objects.
    def add_aut_num_result(autnums)
      @protocols.each do |protocol|
        result[protocol] ||= {}

        Array(autnums).each do |autnum|
          result[protocol][autnum] ||= []
        end
      end
    end

    # Public: Register route object(s) as a result.
    #
    # prefixes - route object(s) in String. Array form is also acceptable for multiple objects.
    # autnum   - Which aut-num has the route object(s).
    # protocol - Which protocol the route object(s) is for. :ipv4 or :ipv6.
    #            A String or Symbol of protcol name is accepted.
    def add_prefix_result(prefixes, autnum, protocol)
      result[protocol] ||= {}
      result[protocol][autnum] ||= []
      result[protocol][autnum] |= Array(prefixes)
    end
  end
end
