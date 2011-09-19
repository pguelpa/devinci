require 'spec_helper'

describe Devinci::Bixi do
  describe "#parse" do
    before do
      @io = mock(IO, :close => nil)
      @document = mock(Nokogiri::XML::Document, :xpath => [])

      @parser = Devinci::Bixi.new(anything)
      @parser.stub!(:io).and_return(@io)
    end

    it "should use the inherited io method and pass the result to Nokogiri" do
      Nokogiri.should_receive(:XML).with(@io).and_return(@document)
      @parser.parse
    end

    it "should search for all the stations" do
      Nokogiri.stub!(:XML).and_return(@document)
      @document.should_receive(:xpath).with('/stations/station').and_return([])

      @parser.parse
    end

    it "should close the io object after successful parsing" do
      Nokogiri.stub!(:XML).and_return(@document)

      @io.should_receive(:close)
      @parser.parse
    end

    it "should close the io object after failed parsing" do
      Nokogiri.stub!(:XML).and_raise

      @io.should_receive(:close)
      lambda { @parser.parse }.should raise_error
    end

    it "should raise a ParseError if the file fails to be parsed" do
      Nokogiri.stub!(:XML).and_raise ArgumentError.new("Foo Error")

      lambda {
        @parser.parse
      }.should raise_error Devinci::ParseError, /Foo Error/
    end
  end

  describe "#parse (station details)" do
    before :all do
      @station = Devinci::Bixi.new('spec/fixtures/devinci/bixi_station.xml').parse.first
    end

    {
      :id => '1',
      :name => 'Notre Dame / Place Jacques Cartier',
      :terminal_name => '6001',
      :latitude => 45.508183,
      :longitude => -73.554094,
      :installed => true,
      :locked => false,
      :installed_on => Time.utc(2010, 6, 8, 16, 02, 00),
      :removed_on => Time.utc(2010, 7, 9, 16, 02, 00),
      :temporary => false,
      :bikes => 13,
      :empty_docks => 17,
    }.each do |attribute, value|
      it "should parse #{attribute} from the node" do
        @station[attribute].should == value
      end
    end
  end

  describe "#parse (missing dates)" do
    before :all do
      @station = Devinci::Bixi.new('spec/fixtures/devinci/bixi_station_no_dates.xml').parse.first
    end

    it "should return nil for install_date if it has no value" do
      @station[:installed_on].should be_nil
    end

    it "should return nil for removed_on if it has no value" do
      @station[:removed_on].should be_nil
    end
  end
end
