require "yaml"

class SignupsQuestion < ActiveRecord::Base
  def question_options
    SignupsQuestion::Options.new(options)
  end

  class Options
    attr_reader :value

    def initialize(options)
      if options
        @value = YAML.parse(options)
      else
        @value = {}
      end
    end

    def checked?
      value.fetch(:checked, false)
    end

    def placeholder
      value[:placeholder]
    end

    def dropdown_options
      value.fetch(:dropdown_options, ["", "", "", ""])
    end
  end

  class Style
    attr_reader :value, :label

    def initialize(value, label)
      @value = value
      @label = label
    end

    CHECKBOX = new("checkbox", "Checkbox")
    DROPDOWN = new("dropdown", "Dropdown")
    TEXT = new("text", "Text")

    class << self
      def all
        [CHECKBOX, DROPDOWN, TEXT]
      end

      def each(&block)
        all.each(&block)
      end
    end
  end
end
