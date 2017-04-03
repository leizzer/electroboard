#include "keymap_common.h"
const uint8_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

[0] = KEYMAP(
A, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
NO, NO, NO, NO, NO, C, NO, A, NO, NO, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, D, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
),

[1] = KEYMAP(
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
NO, NO, GRV, NO, NO, NO, NO, NO, NO, COMM, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, LBRC, NO, NO, NO, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
),

};

const action_t fn_actions[] PROGMEM = { };
