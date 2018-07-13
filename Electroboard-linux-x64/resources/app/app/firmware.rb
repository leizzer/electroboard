class Firmware
  attr_reader :name, :dictionary, :loader, :generator

  FIRMWARES = %w{tmk qmk}

  def self.instance
    @instance ||= Firmware.new
  end

  def initialize
    @dictionary = Dictionary.instance
    set_qmk
  end

  def load text
    @loader.process text
  end

  def generate_empty_keymap l, r, c
    @loader.generate_empty_keymap l, r, c
  end

  def export_keymap l, r, c, keymap
    @generator.export_keymap l, r, c, keymap
  end

  def empty_keymap
    KeymapLoader.new
  end

  def set_tmk
    @name = 'tmk'
    @dictionary.set_tmk
    @generator = TMKGenerator.new
    @loader = TMKLoader.new
  end

  def set_qmk
    @name = 'qmk'
    @dictionary.set_qmk
    @generator = QMKGenerator.new
    @loader = QMKLoader.new
  end

  def set_to str
    self.send "set_#{str}"
  end

end
