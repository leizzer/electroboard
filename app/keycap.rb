class Keycap < Hyperloop::Component
  state({ edit: false, selected: false, key: nil})
  param :val
  param :ilayer
  param :irow
  param :icol

  after_mount do
    mutate.key params.val
  end

  before_receive_props do
    mutate.key params.val
  end

  def selected_value val
    set_value val

    toggle_select
    show_popup false
  end

  def show_popup val
    mutate.edit val
  end

  def toggle_select
    mutate.selected !state.selected

    EventSystem.instance.open_popup self
  end

  def selected
    state.selected ? 'selected' : ''
  end

  def selected?
    state.selected
  end

  def current_value
    state.key
  end

  def set_value val
    mutate.key val
    EventSystem.instance.value_changed val, params.ilayer, params.irow, params.icol
  end

  def render
    return unless state.key
    span do

      div.keycap(class: self.selected) do
        state.key

      end.on(:click) do
        self.toggle_select
        show_popup true
      end
    end
  end

end
