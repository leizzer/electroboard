class Keyboard < Hyperloop::Component
  state({ loading: true })

  after_mount do
    mutate.loading false
    mutate.keymap ''

    mutate.layers 2

    mutate.rows 5
    mutate.cols 12

    @active_layer = 0
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

    mutate.keymap wrap_matrix(matrix)
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

  def activate_layer num
    Element.find("#tab#{@active_layer}").remove_class('selected')
    Element.find("#tab#{num}").add_class('selected')

    Element.find("#tab_body#{@active_layer}").add_class('hidden')
    Element.find("#tab_body#{num}").remove_class('hidden')

    @active_layer = num
  end


  def render
    return p{'loading...'} if state.loading

    div.keyboard do
      form(action: '#') do
        label{'Matrix'}

        input.matrix(type: 'text', value: state.rows, placeholder: 'R').on(:change) do |e|
          mutate.rows e.target.value.to_i
        end

        span{'x'}

        input.matrix(type: 'text', value: state.cols, placeholder: 'C').on(:change) do |e|
          mutate.cols e.target.value.to_i
        end

      end

      br

      div.layer_tabs do
        state.layers.times do |x|
          span.tab(id: "tab#{x}", class: preselected_tab(x)) {"Layer #{x}"}.on(:click) { activate_layer x }
        end
      end

      state.layers.times do |x|
        div.tab_body(id: "tab_body#{x}", class: display_current_tab(x)) do
          Layer(key: x, label: x, ref: "layer#{x}", rows: state.rows, cols: state.cols)
        end
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

      KeyValuePopup()
    end
  end

  private

  def preselected_tab num
    'selected' if @active_layer == num
  end

  def display_current_tab num
    'hidden' unless @active_layer == num
  end
end
