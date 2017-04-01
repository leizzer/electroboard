class KeymapLoader
  attr_reader :layers_count, :rows_count, :cols_count, :layers

  attr :layers_regex

  def initialize
    @layers_count = 0
    @rows_count = 0
    @cols_count = 0

    @layers = []
  end

  def generate_empty_keymap
    @layers << [] << []
  end

end

class TMK < KeymapLoader
  def initialize
    super
    @layers_regex = /KEYMAP\(\s([\w,\s\\]*)/
  end

  def process text
    #Thinking about using js instead, because I can't use #captures from ruby
    text.split(/^\n/).each do |batch|
      result = batch.match(@layers_regex).to_a

      result.each do |l|
        next if l.include? 'KEYMAP'

        @layers_count += 1

        row = l.split("\\\n")

        keys = []
        row.each do |r|
          keys << r.gsub(/\s/, '').split(',')
        end

        @layers << keys
      end
    end

    if @layers[0]
      @rows_count = @layers[0].size
      if @layers[0][0]
        @cols_count = @layers[0][0].size
      end
    end

    EventSystem.instance.keymap_loaded self
  end
end
