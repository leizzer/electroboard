require 'native'
class KeyValuePopup < Hyperloop::Component
  attr_accessor :dictionary

  state({ display: 'hidden' })

  after_mount do
    @keycap = nil
    @dictionary = Dictionary.instance

    EventSystem.instance.set_keyvalue_popup self
  end

  def open_for keycap
    @keycap = keycap
    @key_value = @keycap.current_value

    mutate.display ''
  end

  def set_value value
    @keycap.selected_value value

    mutate.display 'hidden'
  end

  def render
    return if @keycap.nil?

    div(class: "keyvaluepopup #{state.display}") do
      form(action: '#') do
        select do
          @dictionary.key_map.each_pair do |k, v|
            option(value: v){k}
          end
        end.on :change do |e|
          @key_value =  @dictionary.kc_map[e.target.value]
        end

        input(type: 'submit', value: 'Acept')
      end.on(:submit) do |e|
        e.prevent_default
        self.set_value @key_value
      end
    end
  end
end
