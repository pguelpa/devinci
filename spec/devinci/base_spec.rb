require 'spec_helper'

describe Devinci::Base do
  describe ".new" do
    it "should take a filename" do
      filename = "/root/fooname"
      Devinci::Base.new(filename).filename.should == filename
    end
  end

  describe "#io" do
    it "should return a regular file object when there is no compression" do
      File.should_receive(:open).with('/root/fooname').and_return(:file_io)
      Devinci::Base.new('/root/fooname').io.should == :file_io
    end

    it "should memoize the io object for later use" do
      file = mock(File)
      File.should_receive(:open).once.and_return(file)

      parser = Devinci::Base.new(anything)
      2.times { parser.io }
    end

    it "should build an Gzip IO object when :compression => :gzip" do
      Zlib::GzipReader.should_receive(:open).with('/root/fooname').and_return(:gzip_file_io)
      Devinci::Base.new('/root/fooname', :compression => :gzip).io.should == :gzip_file_io
    end
  end

  describe "#downloaded_on" do
    it "should parse the time that the data was downloaded on from the filename as UTC" do
      at = Devinci::Base.new('someStation-2011-05-14::14:00:01.xml.gz').downloaded_on
      at.should == Time.utc(2011, 5, 14, 14, 0, 1)
    end
  end

  describe "#parse" do
    it "should raise a NotImplementedError" do
      lambda {
        Devinci::Base.new(anything).parse
      }.should raise_error NotImplementedError
    end
  end
end
