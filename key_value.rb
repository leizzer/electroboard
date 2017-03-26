class KeyValue < Hyperloop::Component
  attr_accessor :dictionary

  param :keycap
  param :show

  before_mount do
    mutate.value 'A'

    @dictionary = Dictionary.instance
  end

  def set_value value
    params.keycap.show_value state.value
    params.keycap.toggle_select
    params.keycap.show_popup false
  end

  def is_open
    unless params.show
      'hidden'
    end
  end

  def render
    div(class: "keyvaluepopup #{is_open}") do
      form(action: '#') do
        select do
          @dictionary.key_map.each_pair do |k, v|
            option(value: v){k}
          end
        end.on :change do |e|
          mutate.value @dictionary.kc_map[e.target.value]
        end

        input(type: 'submit', value: 'Acept')
      end.on(:submit) do |e|
        e.prevent_default
        self.set_value e.target.value
      end
    end
  end
end
