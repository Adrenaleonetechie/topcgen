require 'spec_helper'
require 'net/https'

module Topcgen
  describe MethodParser do
    it "should parse method parameters" do
      data = {
        :method=>"leastShots", 
        :parameters=>"String[], int[], long, float", 
        :returns=>"int", 
        :signature=>"int leastShots(String[] damageChart, int[] bossHealth, long a, float b)"
      }

      parser = MethodParser.new data[:method], data[:parameters], data[:returns], data[:signature]
      parser.parameters.length.should eq 4
      parser.parameters[0].should eq ({ :type => 'String[]', :name => 'damageChart' })
      parser.parameters[1].should eq ({ :type => 'int[]', :name => 'bossHealth' })
      parser.parameters[2].should eq ({ :type => 'long', :name => 'a' })
      parser.parameters[3].should eq ({ :type => 'float', :name => 'b' })
      parser.name.should eq 'leastShots'
      parser.return_type.should eq 'int'
    end
  end
end
