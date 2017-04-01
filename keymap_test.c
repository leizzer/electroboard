#include "keymap_common.h"
const uint8_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

[0] = KEYMAP(
A, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
NO, NO, NO, NO, NO, NOC, NO, NO, NO, NO, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NOD, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
),

[1] = KEYMAP(
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
NO, NO, NOGRV, NO, NO, NO, NO, NO, NO, NOCOMM, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NOLBRC, NO, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
),

};

const action_t fn_actions[] PROGMEM = { };
