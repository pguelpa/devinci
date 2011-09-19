module Devinci
  class Bixi < Base
    attr_reader :document

    def parse
      @document = Nokogiri::XML(io)

      @document.xpath('/stations/station').map do |node|
        parse_station(node)
      end
    rescue Exception => e
      raise Devinci::ParseError, "Error parsing the input from XML: #{e.message}", e.backtrace
    ensure
      io.close
    end

    private
      def parse_station(node)
        station = {}
        node.children.each do |c|
          case c.name
          when 'id'
            station[:id] = c.content
          when 'name'
            station[:name] = c.content
          when 'terminalName'
            station[:terminal_name] = c.content
          when 'lat'
            station[:latitude] = c.content.to_f
          when 'long'
            station[:longitude] = c.content.to_f
          when 'installed'
            station[:installed] = (c.content == 'true')
          when 'locked'
            station[:locked] = (c.content == 'true')
          when 'installDate'
            station[:installed_on] = c.content.empty? ? nil : Time.at(c.content.to_i / 1000)
          when 'removalDate'
            station[:removed_on] = c.content.empty? ? nil : Time.at(c.content.to_i / 1000)
          when 'temporary'
            station[:temporary] = (c.content == 'true')
          when 'nbBikes'
            station[:bikes] = c.content.to_i
          when 'nbEmptyDocks'
            station[:empty_docks] = c.content.to_i
          end
        end

        station
      end
  end
end