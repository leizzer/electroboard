class KeymapLoader
  attr_reader :layers_count, :rows_count, :cols_count, :layers

  attr :layers_regex

  def initialize
    @layers_count = 0
    @rows_count = 0
    @cols_count = 0

    @layers = []
  end

  def generate_empty_keymap l, r, c
    @layers_count = l
    @rows_count = r
    @cols_count = c

    create_matrix

    self
  end

  def set_keyvalue val, l, r, c
    @layers[l][r][c] = val
  end

  private

  def create_matrix
    @layers = []

    @layers_count.times do |l|
      @layers << []
      @rows_count.times do |r|
        @layers[l] << []
        @cols_count.times do |c|
          @layers[l][r] << 'Empty'
        end
      end
    end
  end

end

class TMKLoader < KeymapLoader
  def initialize
    super
    @layers_regex = /KEYMAP\(\s([\w,\s\\]*)/
  end

  def process text
    @layers_count = 0
    dictionary = Dictionary.instance

    #Thinking about using js instead, because I can't use #captures from ruby
    text.split(/^\n/).each do |batch|
      result = batch.match(@layers_regex).to_a

      result.each do |l|
        next if l.include? 'KEYMAP'


        row = l.split("\\\n")

        keys = []
        row.each do |r|
          values = r.gsub(/\s/, '').split(',')
          values.map! {|k| dictionary.get_key(k.to_sym)}
          keys << values
        end

        unless keys.empty?
          @layers[@layers_count] = keys
          @layers_count += 1
        end
      end
    end

    if @layers[0]
      @rows_count = @layers[0].size
      if @layers[0][0]
        @cols_count = @layers[0][0].size
      end
    end

    EventSystem.instance.on_keymap_loaded self
  end
end

class QMKLoader < KeymapLoader
  def initialize
    super
    @layers_regex = /\=\s*.*([\{\s\w\/,\\\(\)}]*)/
  end

  def process text
    @layers_count = 0
    dictionary = Dictionary.instance

    #Thinking about using js instead, because I can't use #captures from ruby
    text.split(/^\n/).each do |batch|
      result = batch.match(@layers_regex).to_a

      result.each do |l|
        next if l.include? '='

        row = l.split("\n")
        row.select! {|r| r.match /[A-Z]/}

        row = row.map{|r| r.match(/\{([A-Z_, a-z0-9\(\)]+)/)[1]}

        keys = []
        row.each do |r|
          values = r.gsub(/\s/, '').split(/(?![^\(]*\))\,/)
          values.map! {|k| dictionary.get_key(k.to_sym)}
          keys << values
        end

        unless keys.empty?
          @layers[@layers_count] = keys
          @layers_count += 1
        end
      end
    end

    if @layers[0]
      @rows_count = @layers[0].size
      if @layers[0][0]
        @cols_count = @layers[0][0].size
      end
    end

    EventSystem.instance.on_keymap_loaded self
  end
end
