class Keyboard < Hyperloop::Component
  state({ loading: true })

  after_mount do
    mutate.loading false

    mutate.layers 2

    mutate.rows 5
    mutate.cols 12

    mutate.keymap Firmware.instance.generate_empty_keymap state.layers, state.rows, state.cols

    @active_layer = 0
    @dictionary = Dictionary.instance
    @file_manager = Native(`new FileManager`)
    @keymap_file = ''

    EventSystem.instance.set_keymap state.keymap
    EventSystem.instance.listen 'keymap_loaded', self
    EventSystem.instance.listen 'setup_new_layout', self
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
    @keymap_file = Firmware.instance.export_keymap state.layers, state.rows, state.cols, state.keymap
    Element.find('pre').html(@keymap_file)
  end

  def activate_layer num
    Element.find("#tab#{@active_layer}").remove_class('selected')
    Element.find("#tab#{num}").add_class('selected')

    Element.find("#tab_body#{@active_layer}").add_class('hidden')
    Element.find("#tab_body#{num}").remove_class('hidden')

    @active_layer = num
  end

  def on_setup_new_layout setup
    reset_values
    force_update!

    mutate.cols setup.state.cols
    mutate.rows setup.state.rows
    mutate.layers setup.state.layers

    mutate.keymap Firmware.instance.generate_empty_keymap(state.layers, state.rows, state.cols)
    EventSystem.instance.set_keymap state.keymap
  end

  def render
    return if state.loading
    div do
      SetupForm(layers: state.layers, rows: state.rows, cols: state.cols)

      div(id: 'keyboard-wrap') do
        div.layer_tabs do
          span.tab { b{"#{Firmware.instance.name.upcase}"} }
          state.keymap.layers_count.times do |x|
            span.tab(id: "tab#{x}", class: preselected_tab(x)) {"Layer #{x}"}.on(:click) { activate_layer x }
          end
        end

        state.keymap.layers_count.times do |x|
          div.tab_body(id: "tab_body#{x}", class: display_current_tab(x)) do
            Layer(label: x, layer: state.keymap.layers[x], ilayer: x)
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

    mutate.keymap Firmware.instance.empty_keymap
  end

end
