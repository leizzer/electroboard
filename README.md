# Electroboard

A keymap generator for custom/homemade keyboards using [tmk_firmware](https://github.com/tmk/tmk_keyboard) keycodes.

## Builds
(already packaged, ready to use)

* Linux [download x64](https://drive.google.com/open?id=0B5iM8TQ7sHptZHQtYUUwdnJSQjQ) | [download ia32](https://drive.google.com/open?id=0B5iM8TQ7sHptVVF3MjZSWmdBMFE)
* OS X [download x64](https://drive.google.com/open?id=0B5iM8TQ7sHptUWpHVjB6Y1ppa28) 

## How to use

1. Generate a matrix with the amount of layers that you want. Or import a TMK keymap that you already have (functions won't be loaded.
2. Click the keycaps that you want to change and select the new value from the popup.
3. Generate the keymap.
4. Save it.

### Known issue

This version doesn't handle function definitions for now, so if you are importing an existing keymap to modify it, you are going to copy the functions from the old file to the new one. Another way is to define the functions in other file and then just import that file.

## Technology in use

* [Electron](https://github.com/electron/electron)
* [Hyper-react (Reactrb)](https://github.com/ruby-hyperloop/hyper-react)
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

To import a file, the keymap should respect this format:

 - Each layer starts with `KEYMAP`.
 - New line after `KEYMAP(`.
 - Each line is a row.
 - Each row starts at the start of the line.
 - Each row ends with `\`.

```c
[0] = KEYMAP(
ESC, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, BSPC, \
TAB, Q, W, E, R, T, Y, U, I, O, P, ENT, \
CAPS, A, S, D, F, G, H, J, K, L, SCLN, QUOT, \
LSFT, Z, X, C, V, B, N, M, COMM, DOT, SLSH, RSFT, \
LCTL, LGUI, LALT, NO, FN0, SPC, SPC, FN1, NO, RALT, BSPC, RCTL, \
),
```

## Screenshot
![in action](/images/screenshot.png)

## ToDo

* Package for Windows
* Import and Export qmk_firmware
* Manage Functions
* Custom CSS from user
