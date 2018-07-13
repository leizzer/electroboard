class KeyValuePopup < Hyperloop::Component
  attr_accessor :dictionary

  state({ display: 'hidden', state: 'Empty' })

  after_mount do
    @keycap = nil

    EventSystem.instance.set_keyvalue_popup self
  end

  def dictionary
    Firmware.instance.dictionary
  end

  def open_for keycap
    @keycap = keycap

    mutate.val dictionary.get_keycode(@keycap.current_value)
    mutate.display ''
  end

  def set_key_value
    @keycap.selected_value dictionary.get_key(state.val)

    mutate.display 'hidden'
  end

  def render
    return if @keycap.nil?

    div(class: "keyvaluepopup #{state.display}") do
      form(action: '#') do
        select(value: state.val) do
          dictionary.key_map.each_pair do |k, v|
            option(value: v){k}
          end
        end.on :change do |e|
          mutate.val e.target.value
        end

        input(type: 'text', value: state.val).on :change do |e|
          mutate.val e.target.value
          rerender
        end

        input(type: 'submit', value: 'Acept')
      end.on(:submit) do |e|
        e.prevent_default
        self.set_key_value
      end
    end
  end
end
