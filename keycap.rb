class Keycap < Hyperloop::Component
  before_mount do
    mutate.key 'A'
    mutate.edit false

    mutate.selected false
  end

  def show_value val
    mutate.key val
  end

  def show_popup val
    mutate.edit val
  end

  def toggle_select
    mutate.selected !state.selected
  end

  def selected
    state.selected ? 'selected' : ''
  end

  def render
    span do

      div.keycap(class: self.selected) do
        state.key

      end.on(:click) do
        self.toggle_select
        show_popup true
      end

      KeyValue(keycap: self, show: state.edit)
    end
  end

end
