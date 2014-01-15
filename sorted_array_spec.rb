require 'rspec'
require './sorted_array.rb'

shared_examples "yield to all elements in sorted array" do |method|
    specify do 
      expect do |b| 
        sorted_array.send(method, &b) 
      end.to yield_successive_args(2,3,4,7,9) 
    end
end

describe SortedArray do
  let(:source) { [2,3,4,7,9] }
  let(:sorted_array) { SortedArray.new source }

  describe "iterators" do
    describe "that don't update the original array" do 
      describe :each do
        context 'when passed a block' do
          it_should_behave_like "yield to all elements in sorted array", :each
        end

        it 'should return the array' do
          sorted_array.each {|el| el }.should eq source
        end
      end

      describe :map do
        it 'the original array should not be changed' do
          original_array = sorted_array.internal_arr
          expect { sorted_array.map {|el| el } }.to_not change { original_array }
        end

        it_should_behave_like "yield to all elements in sorted array", :map

        it 'creates a new array containing the values returned by the block' do
          new_array = sorted_array.map {|ele| ele*2}
          new_array.should == [4,6,8,14,18]
        end
      end
    end

    describe "that update the original array" do
      describe :map! do
        it 'the original array should be updated' do
          sorted_array.map! {|ele| ele - 1}.should == [1,2,3,6,8]
        end

        it_should_behave_like "yield to all elements in sorted array", :map!

        it 'should replace value of each element with the value returned by block' do
          sorted_array.map! {|ele| ele *2}.should == [4,6,8,14,18]
        end
      end
    end
  end

  describe :find do

    it "the find method should not find anything" do
      sorted_array.find{|ele| ele == 24 }.should == nil
    end
  

    it "the find method should find the first element equal to 2" do
      sorted_array.find{|ele| ele == 2 }.should == 2
    end
  end

  describe :inject do
    it "this example should multiply up all the values in sorted_array" do
      sorted_array.inject(1){|sum, ele| sum * ele}.should == 1512
    end

    it "this example should sum up all the values in sorted_array" do
      sorted_array.inject{|sum, ele| sum + ele}.should == 25
    end
  end
  
end
