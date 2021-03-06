require 'spec_helper'

module Topcgen
  module JAVA
    describe JAVA do
      def initialize_values
        @info = {:name=>"KiloManX", 
                 :statement_link=>"/stat?c=problem_statement&pm=2288&rd=4725", 
                 :editorial_link_full=>"http://www.topcoder.com/tc?module=Static&d1=match_editorials&d2=srm181", 
                 :used_in=>"SRM 181", :used_as=>"Division I Level Three", 
                 :categories=>"Dynamic Programming, Search", :point_value=>"1000", 
                 :solution_java=>"/stat?c=problem_solution&cr=277659&rd=4725&pm=2288", 
                 :solution_cpp=>"/stat?c=problem_solution&cr=262936&rd=4725&pm=2288"}
        @info[:statement_link_full] = 'http://community.topcoder.com' + @info[:statement_link]
        @package = Package.new(@info[:name], 'topc', @info[:categories])

        @stmt = {:class=>"KiloManX", :method=>"leastShots", :parameters=>"String[], int[]", :returns=>"int[]", :signature=>"int[] leastShots(String[] damageChart, int[] bossHealth)"}
        @tests = [
          {:arguments=>"{\"070\",\"500\",\"140\"},{150,150,150}", :expected=>"{ 218 }"},
          {:arguments=>"{\"1542\",\"7935\",\"1139\",\"8882\"},{150,150,150,150}", :expected=>"{ 205 }"},
          {:arguments=>"{\"07\",\"40\"},{150,10}", :expected=>"{ 48 }"}
        ]
      end

      it "should generate the problem class" do
        initialize_values
        prepare_values

        @info[:main_imports] = [ 
          { :path => 'java.util' }, 
          { :path => 'java.io' }
        ]

        stream = StringIO.new
        file = read_file 'spec/files/KiloManX.java'

        JAVA.main_class(stream, @package, @method, @info)
        stream.string.should eq file

        stream.close
      end

      it "should generate unit tests for problem that returns a single value" do
        initialize_values
        @stmt[:returns] = 'double'
        @stmt[:signature] = @stmt[:signature].gsub(/^int\[\]/, 'double')
        @tests.each do |t|
          t[:expected] = t[:expected].gsub(/\{|\}|\s+/, '')
        end

        prepare_values

        @info[:test_imports] = [ 
          { :path => 'junit.framework' },
          { :path => 'org.junit', :object => 'Test' },
          { :path => 'org.junit.Assert', :static => true } 
        ]

        stream = StringIO.new
        file = read_file 'spec/files/KiloManXTestSV.java'

        JAVA.test_class(stream, @package, @method, @info, @values)
        stream.string.should eq file

        stream.close
      end

      it "should generate the unit tests for problem that returns an array" do
        initialize_values
        prepare_values

        @info[:test_imports] = [ 
          { :path => 'junit.framework' },
          { :path => 'org.junit', :object => 'Test' },
          { :path => 'org.junit.Assert', :static => true } 
        ]

        stream = StringIO.new 
        file = read_file 'spec/files/KiloManXTestAR.java'

        JAVA.test_class(stream, @package, @method, @info, @values)
        stream.string.should eq file

        stream.close
      end

      it "should generate the test runner class" do
        initialize_values
        prepare_values

        @info[:test_runner_imports] = [ 
          { :path => 'junit.framework', :object => 'Test' },
          { :path => 'junit.framework', :object => 'TestSuite' },
          { :path => 'org.junit.runner', :object => 'RunWith' },
          { :path => 'org.junit.runners', :object => 'Suite' }
        ]

        stream = StringIO.new
        file = read_file 'spec/files/Runner.java'

        JAVA.test_runner_class(stream, @package, @method, @info)
        stream.string.should eq file

        stream.close
      end

      def prepare_values
        @method = MethodParser.new @stmt[:method], @stmt[:parameters], @stmt[:returns], @stmt[:signature]
        @values = @tests.map do |t|
          a_types = @method.parameters.map { |p| p[:type] }
          r_types = [ @stmt[:returns] ]
          arguments = ValueParser.parse a_types, t[:arguments]
          expected = ValueParser.parse r_types, t[:expected]
          { :arguments => arguments, :expected => expected[0] }
        end
      end

      def read_file file
        File.open(file, 'r') do |f|
          f.rewind
          f.read
        end
      end
    end

  end
end

