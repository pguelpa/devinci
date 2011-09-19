module Devinci
  class ParseError < RuntimeError; end

  class Base
    attr_reader :filename, :options

    def initialize(filename, options = {})
      @filename = filename
      @options = options
    end

    def io
      @io ||= case @options[:compression]
      when :gzip
        Zlib::GzipReader.open(@filename)
      else
        File.open(@filename)
      end
    end

    def downloaded_on
      match = filename.match(/(\d{4})-(\d{2})-(\d{2})..(\d{2}):(\d{2}):(\d{2})/)
      if match
        numbers = (1..6).map { |n| match[n].to_i }
        Time.utc(*numbers)
      end
    end

    def parse
      raise NotImplementedError, "Each parser must define their own parse method"
    end
  end
end