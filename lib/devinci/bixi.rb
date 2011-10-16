module Devinci
  class Bixi < Base
    attr_reader :document

    FUNS = {
      :content => lambda { |c| c.content },
      :to_f => lambda { |c| c.content.to_f },
      :to_i => lambda { |c| c.content.to_i },
      :boolean => lambda { |c| c.content == 'true' },
      :time => lambda { |c| c.content.empty? ? nil : Time.at(c.content.to_i / 1000) }
    }

    KEY_TYPES = {
      'id' => [:id, :content],
      'name' => [:name, :content],
      'terminalName' => [:terminal_name, :content],
      'lat' => [:latitude, :to_f],
      'long' => [:longitude, :to_f],
      'installed' => [:installed, :boolean],
      'locked' => [:locked, :boolean],
      'installDate' => [:installed_on, :time],
      'removalDate' => [:removed_on, :time],
      'temporary' => [:temporary, :boolean],
      'nbBikes' => [:bikes, :to_i],
      'nbEmptyDocks' => [:empty_docks, :to_i]
    }

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
      node.children.inject({}) do |acc, child|
        key, type = KEY_TYPES[child.name]

        acc[key] = FUNS[type][child] if key
        acc
      end
    end
  end
end
