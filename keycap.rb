class Keycap < React::Component::Base
  before_mount do
    state.key 'A'
    state.edit! false

    state.selected false
  end

  def show_value val
    state.key val
  end

  def show_popup val
    state.edit! val
  end

  def toggle_select
    state.selected !state.selected
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
