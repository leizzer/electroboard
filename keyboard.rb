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
    @keymap = nil

    EventSystem.instance.listen_keymap_loaded self
  end

  after_update do
    puts 'UPDATE'
    reasign_keyvalues @keymap if @keymap
  end

  def on_keymap_loaded keymap
    @keymap = keymap
    mutate.layers keymap.layers_count
    mutate.rows keymap.rows_count
    mutate.cols keymap.cols_count
  end

  def generate_keymap
    matrix = ''

    state.layers.times do |l|
      layer = []

      state.rows.times do |r|
        row = []

        state.cols.times do |c|
          value = get_keyvalue_on l, r, c
          row << @dictionary.key_map[value]
        end

        row << "\\" #if r < state.rows - 1

        layer << row.join(', ')
      end

      matrix += "\n[#{l}] = KEYMAP(\n#{layer.join("\n")}\n),\n"
    end

    mutate.keymap wrap_matrix(matrix)
  end

  def wrap_matrix matrix
   "#include \"keymap_common.h\"\nconst uint8_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {\n#{matrix}\n};\n\nconst action_t fn_actions[] PROGMEM = { };"
  end

  def activate_layer num
    Element.find("#tab#{@active_layer}").remove_class('selected')
    Element.find("#tab#{num}").add_class('selected')

    Element.find("#tab_body#{@active_layer}").add_class('hidden')
    Element.find("#tab_body#{num}").remove_class('hidden')

    @active_layer = num
  end

  def setup_new_layout setup
    mutate.cols setup.state.cols
    mutate.rows setup.state.rows
    mutate.layers setup.state.layers
  end

  def render
    return if state.loading
    puts 'rerendering'

    div do

      SetupForm(layers: state.layers, rows: state.rows, cols: state.cols, handler: self)

      div(id: 'keyboard-wrap') do
        div.layer_tabs do
          state.layers.times do |x|
            span.tab(id: "tab#{x}", class: preselected_tab(x)) {"Layer #{x}"}.on(:click) { activate_layer x }
          end
        end

        state.layers.times do |x|
          div.tab_body(id: "tab_body#{x}", class: display_current_tab(x)) do
            Layer(label: x, ref: "layer#{x}", rows: state.rows, cols: state.cols)
          end
        end
      end

      div(id: 'actions') do
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

        button do
          'Open'
        end.on :click do
          @file_manager.loadFile()
        end
      end

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

  def get_keyvalue_on layer, row, column
    self.refs["layer#{layer}"].refs["row#{row}"].refs["key#{column}"].state.key
  end

  def set_keyvalue_on layer, row, column, value
    self.refs["layer#{layer}"].refs["row#{row}"].refs["key#{column}"].set_value value
  end

  def reasign_keyvalues keymap
    state.layers.times do |l|
      state.rows.times do |r|
        state.cols.times do |c|
          puts keymap.layers[l][r][c]
          set_keyvalue_on l, r, c, keymap.layers[l][r][c]
          puts ">>#{get_keyvalue_on l, r, c}"
        end
      end
    end
  end
end
