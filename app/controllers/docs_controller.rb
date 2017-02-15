class DocsController < ApplicationController
  def index
    load_tutorials
  end

  class WindowText
    attr_reader :id, :name, :contents, :lines
    def initialize(name, contents)
      @name = name
      @id = name
      @contents = contents
      self.parse_lines
    end

    def parse_lines
      @lines = contents.split("\n").map do |line|
        line = " " if line.strip == ""
        prefix, content = line[0...2], line[2..-1]
        if prefix =~ /#/
          {command: true, text: content}
        else
          {command: false, text: line}
        end
      end
    end
  end

  def tutorial
    load_tutorials
  end

  def load_tutorials
    tutorial_windows_dir = File.join(Rails.root, "app/views/docs/windows/tutorial/*")
    @tutorials ||= Dir[tutorial_windows_dir].inject({}) do |tutorials, path|
      name = File.basename(path)
      contents = File.read(path)
      tutorials[name] = WindowText.new(name, contents)
      tutorials
    end
  end
end
