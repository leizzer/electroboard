class KeymapGenerator
  attr :dictionary

  def initialize
    @keymap = nil
    @keymap_file = ''
    @dictionary = Dictionary.instance
  end

  def export_keymap layers, rows, cols, keymap
    raise "define #export_keymap"
  end

end

class TMKGenerator < KeymapGenerator

  def export_keymap layers, rows, cols, keymap
    matrix = ''

    layers.times do |l|
      layer = []

      rows.times do |r|
        row = []

        cols.times do |c|
          value = keymap.layers[l][r][c]
          row << @dictionary.get_keycode(value)
        end

        row << "\\"

        layer << row.join(', ')
      end

      matrix += compose_layer l, layer
    end

    @keymap_file = wrap_matrix matrix
  end

  private

  def compose_layer num, layer
    "\n[#{num}] = KEYMAP(\n#{layer.join("\n")}\n),\n"
  end

  def wrap_matrix matrix
   "#include \"keymap_common.h\"\nconst uint8_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {\n#{matrix}\n};\n\nconst action_t fn_actions[] PROGMEM = { };"
  end

end

class QMKGenerator < KeymapGenerator

  def export_keymap layers, rows, cols, keymap
    matrix = ''

    layers.times do |l|
      layer = []

      rows.times do |r|
        row = []

        cols.times do |c|
          value = keymap.layers[l][r][c]
          row << @dictionary.get_keycode(value)
        end

        layer << '{ '+row.join(', ')+' }'
      end

      matrix += compose_layer l, layer
    end

    @keymap_file = wrap_matrix matrix
  end

  private

  def compose_layer num, layer
    "\n[#{num}] = {\n#{layer.join("\n")}\n},\n"
  end

  def wrap_matrix matrix
   "#include \"keymap_common.h\"\nconst uint8_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {\n#{matrix}\n};\n\nconst action_t fn_actions[] PROGMEM = { };"
  end

end
