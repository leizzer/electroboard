class Keyboard < Hyperloop::Component
  state({ loading: true })

  after_mount do
    mutate.loading false

    mutate.layers 2

    mutate.rows 5
    mutate.cols 12

    mutate.keymap KeymapLoader.new.generate_empty_keymap state.layers, state.rows, state.cols

    @active_layer = 0
    @dictionary = Dictionary.instance
    @file_manager = Native(`new FileManager`)
    @keymap_file = ''

    EventSystem.instance.listen 'keymap_loaded', self
  end

  def on_keymap_loaded keymap
    reset_values
    force_update!

    mutate.layers keymap.layers_count
    mutate.rows keymap.rows_count
    mutate.cols keymap.cols_count

    EventSystem.instance.set_keymap keymap
    mutate.keymap keymap
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

        row << "\\"

        layer << row.join(', ')
      end

      matrix += "\n[#{l}] = KEYMAP(\n#{layer.join("\n")}\n),\n"
    end

    @keymap_file = wrap_matrix(matrix)

    Element.find('pre').html(@keymap_file)
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

    mutate.keymap state.keymap.generate_empty_keymap(state.layers, state.rows, state.cols)
  end

  def render
    return if state.loading

    div do

      SetupForm(layers: state.layers, rows: state.rows, cols: state.cols, handler: self)

      div(id: 'keyboard-wrap') do
        div.layer_tabs do
          state.keymap.layers_count.times do |x|
            span.tab(id: "tab#{x}", class: preselected_tab(x)) {"Layer #{x}"}.on(:click) { activate_layer x }
          end
        end

        state.keymap.layers_count.times do |x|
          div.tab_body(id: "tab_body#{x}", class: display_current_tab(x)) do
            Layer(key: x, label: x, ref: "layer#{x}", layer: state.keymap.layers[x], ilayer: x)
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
          @file_manager.openSaveFile(@keymap_file)
        end

        button do
          'Open'
        end.on :click do
          @file_manager.loadFile()
        end
      end

      pre do
        ""
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
    state.keymap.layers[layer][row][column]
  end

  def reset_values keymap=nil
    mutate.layers 0
    mutate.rows 0
    mutate.cols 0

    mutate.keymap KeymapLoader.new
  end

end
