class EventSystem
  attr_reader :keyvalue_popup, :keyboard

  def initialize
    @listeners = Hash.new { |h, k| h[k]=[] }
  end

  def set_keyvalue_popup popup
    @keyvalue_popup = popup
  end

  def open_popup keycap
    @keyvalue_popup.open_for keycap
  end

  def set_keymap keymap
    @keymap = keymap
  end

  def value_changed val, layer, row, col
    @keymap.set_keyvalue val, layer, row, col
  end

  def listen event, obj
    @listeners[event].push obj
    create_method event
  end

  def self.instance
    @instance ||= EventSystem.new
  end

  private

  def create_method event
    name = "on_#{event}"
    return if respond_to? name

    define_singleton_method name do |*args|
      @listeners[event].each do |obj|
        if obj.respond_to? name
          obj.send name, *args
        end
      end
    end
  end
end
