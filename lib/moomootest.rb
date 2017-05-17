# TODO: Create more assertions based on testing needs
#       Use 'test "some test description here" do/assert/end' format 

module Assertions
  def test name="untitled"
    yield
  end

  def assert test, msg = "Failed test"
    unless test then
      bt = caller.drop_while { |s| s =~ /#{__FILE__}/ }
      raise RuntimeError, msg, bt
    end
  end

  def assert_equal a, b
    assert a == b, "Failed assert_equal #{a} vs #{b}"
  end

  def assert_in_delta a, b
    assert (a-b).abs <= 0.001, "Failed assert_in_delta #{a} vs #{b}"
  end
end

class Reporter
  attr_accessor :failures

  def initialize
    self.failures = []
  end

  def << result
    unless result.failure? then  
      print '.'
    else
      print 'F'
      failures << result
    end
  end

  def summary
    puts

    failures.each do |result|
      failure = result.failure
      puts
      puts "Failure: #{result.class}##{result.name}: #{failure.message}"
      puts "  #{failure.backtrace.first}"
    end
  end
end

class MooMooTest
  include Assertions

  attr_accessor :failure, :name
  alias failure? failure

  TESTS = []

  def initialize name
    self.name = name
    self.failure = false
  end

  def self.inherited x
    TESTS << x
  end

  def self.run_all_tests
    reporter = Reporter.new

    TESTS.each do |klass|
      klass.run reporter
    end
    
    reporter.summary
  end

  def self.test_names
    public_instance_methods.grep(/^test_/)
  end

  def self.run reporter
    test_names.shuffle.each do |name|
      reporter << self.new(name).run
    end
  end

  def run
    send name
  rescue => e
    self.failure = e
  ensure
    return self
  end
end