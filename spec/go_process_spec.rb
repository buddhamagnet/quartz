require 'spec_helper'

describe Quartz::GoProcess do

  let(:process) { Quartz::GoProcess.new(file_path: 'spec/test.go') }

  describe '#get_metadata' do

    context 'with a go file' do

      it 'pulls metadata' do
        process.get_metadata.should eq({"adder"=>{"NameToMethodMetadata"=>{"Add"=>{"ArgumentToType"=>{"A"=>"int", "B"=>"int"}}}}})
      end

    end

  end

  describe '#call' do

    it 'is able to call a method on a struct' do
      result = process.call('adder', 'Add', { 'A' => 5, 'B' => 6 })
      result.should eq({"X"=>11})
    end

  end

  it 'works with an existing binary file' do
    temp_file = "/tmp/quartz_test_#{rand(10000)}"
    system('go', 'build', '-o', temp_file, 'spec/test.go')
    process = Quartz::GoProcess.new(bin_path: temp_file)
    result = process.call('adder', 'Add', { 'A' => 5, 'B' => 6 })
    result.should eq({"X"=>11})
    File.delete(temp_file)
  end

end
