class Dictionary
  DICTIONARIES = %w{tmk qmk}

  def self.instance
    @instance ||= Dictionary.new
  end

  def initialize
    @name = nil
  end

  def key_map
    @firmware.key_map
  end

  def kc_map
    @firmware.kc_map
  end

  def set_tmk
    unless @name == 'tmk'
      @firmware = TmkDictionary.new
      @name = 'tmk'
    end
  end

  def set_qmk
    unless @name == 'qmk'
      @firmware = QmkDictionary.new
      @name = 'qmk'
    end
  end

  def set_to str
    self.send "set_#{str}"
  end

  def get_keycode value
    key_map[value] || value
  end

  def get_key value
    kc_map[value] || value
  end

end
