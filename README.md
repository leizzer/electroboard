# Electroboard

A keymap generator for custom/homemade keyboards using [tmk_firmware](https://github.com/tmk/tmk_keyboard) or [qmk_firmware](https://github.com/qmk/qmk_firmware) keycodes.

## Builds
(already packaged, ready to use)

* Windows [download](https://drive.google.com/open?id=0B5iM8TQ7sHptcUhiZGJsM1AxLVE)
* Linux [download x64](https://drive.google.com/open?id=0B5iM8TQ7sHptYy1RNEZWMER3ek0) | [download ia32](https://drive.google.com/open?id=0B5iM8TQ7sHptY3c3dlVOTG4yaFE)
* OS X [download x64](https://drive.google.com/open?id=0B5iM8TQ7sHptaUFSZXBra2wxUkU) 

## How to use

1. Generate a matrix with the amount of layers that you want.
2. Click the keycaps that you want to change and select the new value from the popup.
3. Generate the keymap.
4. Save it.

### Importing an existing keymap

For an existing keymap you would probably have to do some modifications to the file before importing it. Refer to [File Formats](https://github.com/leizzer/electroboard#fileformat)

If your keymap has function definitions, imports and more. Move them to a separated file in the same directory and name it `keymap_common.h`. That file will be imported by the new generated code.

Remove spaces and add new lines when needed, as the [File Formats](https://github.com/leizzer/electroboard#fileformat) section says for the firmware of your choice.

If you are using variables to define the layers, please change it back to numbers. (e.g.: [0]={...} instead of [\_LW]={...})

#### Firmware selection

1. Select the firmware that you want to work with at the top. (TMK or QMK)
2. Click the "Change" button, *even* if the amount of layers, rows and columns are the same.

### Known issue:

- Does't generate a good keymap for non-rectangular grids.
- This version doesn't handle function definitions and extra code like imports and definitions. So if you are importing an existing keymap to modify it, you should move all your custom code and functions to `keymap_common.h` that is imported by the new generated file.
- Any unrecognized code will be loaded as it is, for example `MO(0)`. See the screenshots.

## Technology in use

* [Electron](https://github.com/electron/electron)
* [Ruby-Hyperloop](https://github.com/ruby-hyperloop/hyper-react)
* [Opal](https://github.com/opal/opal)

## Fileformat

The output file will be something similar to this.

```c
#include "keymap_common.h"
const uint8_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

[0] = KEYMAP(
ESC, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, BSPC, \
TAB, Q, W, E, R, T, Y, U, I, O, P, ENT, \
CAPS, A, S, D, F, G, H, J, K, L, SCLN, QUOT, \
LSFT, Z, X, C, V, B, N, M, COMM, DOT, SLSH, RSFT, \
LCTL, LGUI, LALT, NO, FN0, SPC, SPC, FN1, NO, RALT, BSPC, RCTL, \
),

[1] = KEYMAP(
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
GRV, NO, NO, NO, NO, NO, NO, NO, NO, FN2, FN3, FN4, \
NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, \
LSFT, NO, FN12, FN11, FN10, NO, NO, NO, NO, NO, FN6, RSFT, \
LCTL, NO, NO, NO, FN0, SPC, SPC, FN1, NO, NO, NO, RCTL, \
),

[2] = KEYMAP(
F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, \
FN5, NO, UP, NO, NO, NO, NO, NO, NO, LBRC, RBRC, BSLS, \
NO, LEFT, DOWN, , NO, NO, NO, NO, NO, NO, MINS, EQL, \
LSFT, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, RSFT, \
LCTL, NO, NO, NO, FN0, SPC, SPC, FN1, NO, NO, NO, RCTL, \
),

};
```

## Import a file

The file to import should respect this format:

#### TMK

 - Each layer starts with `KEYMAP`.
 - New line after `KEYMAP(`.
 - Each line is a row.
 - Each row starts at the start of the line. (No space at the beginning)
 - Each row ends with `\`.
 - Empty line between layers.

```c
[0] = KEYMAP(
ESC, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, BSPC, \
TAB, Q, W, E, R, T, Y, U, I, O, P, ENT, \
CAPS, A, S, D, F, G, H, J, K, L, SCLN, QUOT, \
LSFT, Z, X, C, V, B, N, M, COMM, DOT, SLSH, RSFT, \
LCTL, LGUI, LALT, NO, FN0, SPC, SPC, FN1, NO, RALT, BSPC, RCTL, \
),

[1] = KEYMAP(
...
),
```

#### QMK

 - Use numbers for layers instead of variables. (eg [0] instead of [QWERTY]).
 - New line after `[0] = {`.
 - Each line is a row.
 - Each row starts at the start of the line. (No space at the beginning)
 - Each row ends with a new line.
 - Empty line between layers.

```c
[0] = {
{KC_TAB,  KC_Q,    KC_W,    KC_E,   KC_R,    KC_T,   KC_Y,   KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC},
{KC_ESC,  KC_A,    KC_S,    KC_D,   KC_F,    KC_G,   KC_H,   KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT},
{KC_LSFT, KC_Z,    KC_X,    KC_C,   KC_V,    KC_B,   KC_N,   KC_M,    KC_COMM, KC_DOT,  KC_SLSH, MT(MOD_RSFT, KC_ENT)},
{KC_LCTL, KC_LGUI, KC_LALT, M(0),   MO(0), KC_SPC, KC_SPC, MO(1), KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT}
},

[1] = {
...
}
```

#### Note

If you ain't sure about the format, my advice is to generate and save a dummy file to see what you have to change in your current keymap to respect the expected file format.


## Screenshot
![screenshot](/images/screenshot.png)

![in action1](/images/peek_1.gif)

![in action2](/images/peek_2.gif)

![in action3](/images/peek_3.gif)




## ToDo

* Add shortcuts to QMK dictionary from https://github.com/qmk/qmk_firmware/blob/master/quantum/keymap_common.c
* Custom CSS from user
* Support irregular layouts, like a normal keyboard with a long spacebar
* Manage Functions

