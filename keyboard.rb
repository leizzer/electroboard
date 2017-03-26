class Keyboard < React::Component::Base

  before_mount do
    state.keymap! ''

    state.layers! 2
    state.active_layer! 0

    state.rows! 5
    state.cols! 12

    @dictionary = Dictionary.instance
    @file_manager = Native(`new FileManager`)
  end

  def generate_keymap
    matrix = ''

    state.layers.times do |l|
      layer = []

      state.rows.times do |r|
        row = []

        state.cols.times do |c|
          value = self.refs["layer#{l}"].refs["row#{r}"].refs["key#{c}"].state.key
          row << @dictionary.key_map[value]
        end

        row << "\\" if r < state.rows - 1

        layer << row.join(', ')
      end

      matrix += "\n[#{l}] = KEYMAP(#{layer.join("\n")}),\n"
    end

    state.keymap! wrap_matrix(matrix)
  end

  def wrap_matrix matrix
    "
    #include \"keymap_common.h\"

    const uint8_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
      #{matrix}
    };

    const action_t fn_actions[] PROGMEM = { };
    "
  end

  def hide_or_show num
    if num == state.active_layer
      ''
    else
      'hidden'
    end
  end

  def selected_tab num
    num == state.active_layer ? 'selected' : ''
  end


  def render
    div.keyboard do
      form(action: '#') do
        label{'Matrix'}

        input.matrix(type: 'text', value: state.rows, placeholder: 'R').on(:change) do |e|
          state.rows! e.target.value.to_i
        end

        span{'x'}

        input.matrix(type: 'text', value: state.cols, placeholder: 'C').on(:change) do |e|
          state.cols! e.target.value.to_i
        end

      end

      br

      div.layer_tabs do
        state.layers.times do |x|
          span.tab(class: self.selected_tab(x)) {"Layer #{x}"}.on(:click) { state.active_layer! x }
        end
      end

      state.layers.times do |x|
        Layer(key: x, label: x, ref: "layer#{x}", rows: state.rows, cols: state.cols, hide: self.hide_or_show(x))
      end

      br
      button do
        'Generate keymap'
      end.on :click do
        generate_keymap
      end

      button do
        'Save'
      end.on :click do
        @file_manager.openSaveFile(state.keymap)
      end
      br

      pre do
        "#{state.keymap}"
      end
    end
  end
end
