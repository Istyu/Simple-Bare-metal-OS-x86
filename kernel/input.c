// input.c
#include "keyboard.h"
#include "input.h"

key_t input_getkey() {
    char c = keyboard_getchar();
    if (c == 'w') return KEY_UP;
    if (c == 's') return KEY_DOWN;
    if (c == '\n') return KEY_ENTER;
    return KEY_UNKNOWN;
}
