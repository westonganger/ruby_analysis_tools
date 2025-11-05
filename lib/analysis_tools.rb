require "bigdecimal"

class AnalysisTools

  @@allow_classes = [
    # /SomeExampleClass/,
  ].freeze

  @@ignore_classes = [
    /RSpec/,
    /AnalysisTools/,
  ].freeze

  def self.count_method_calls(methods_with_args: false)
    _init

    trace = TracePoint.new(:call, :c_call, :return, :c_return) do |trace|
      key = [trace.defined_class, trace.callee_id].join(".")

      if _method_has_args?(trace)
        if methods_with_args
          hash = @@calls_with_args
        else
          next
        end
      else
        if methods_with_args
          next
        else
          hash = @@calls_no_args
        end
      end

      if trace.event == :call || trace.event == :c_call
        if @@allow_classes.any?
          if !@@allow_classes.any? { |x| trace.defined_class.to_s.match?(x) }
            next
          end
        elsif @@ignore_classes.any? { |x| trace.defined_class.to_s.match?(x) }
          next
        end

        hash[key] ||= {count: 0, seconds: 0}
        hash[key][:count] += 1

        @@start_times[trace.method_id] = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      elsif trace.event == :return || trace.event == :c_return
        start_time = @@start_times.delete(trace.method_id)

        if start_time
          end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          runtime = end_time - start_time
          hash[key][:seconds] += runtime
        end
      end
    end

    trace.enable
  end

  def self.report
    puts "\n\n"
    puts "==========================================="
    puts "ANALYSIS TOOLS"
    puts "==========================================="
    puts

    puts "Method Calls (with no args)"
    pp @@calls_no_args
      .select{|k,v| v[:seconds] >= BigDecimal("0.001") }
      .sort_by {|k,v| v[:seconds] }

    puts

    puts "Method Calls (with args)"
    pp @@calls_with_args
      .select{|k,v| v[:seconds] >= BigDecimal("0.001") }
      .sort_by {|k,v| v[:seconds] }
  ensure
    _reset
  end

  private

  def self._method_has_args?(trace)
    return !trace.parameters.empty?
  end

  def self._init
    @@calls_no_args ||= {}
    @@calls_with_args ||= {}
    @@start_times ||= {}
  end

  def self._reset
    @@calls_no_args = {}
    @@calls_with_args = {}
    @@start_times = {}
  end
end
