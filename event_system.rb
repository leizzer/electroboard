class EventSystem
  attr_reader :keyvalue_popup

  def set_keyvalue_popup popup
    @keyvalue_popup = popup
  end

  def open_popup keycap
    @keyvalue_popup.open_for keycap
  end

  def self.instance
    @instance ||= EventSystem.new
  end
end
