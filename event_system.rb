class EventSystem
  attr_reader :keyvalue_popupa, :keyboard

  def initialize
    @listeners = Hash.new []
  end

  def set_keyvalue_popup popup
    @keyvalue_popup = popup
  end

  def open_popup keycap
    @keyvalue_popup.open_for keycap
  end

  def keymap_loaded keymap
    @listeners[:on_keymap_loaded].each do |obj|
      obj.on_keymap_loaded keymap
    end
  end

  def listen_keymap_loaded obj
    @listeners[:on_keymap_loaded] << obj
  end

  def self.instance
    @instance ||= EventSystem.new
  end
end
