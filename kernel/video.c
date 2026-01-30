#include "video.h"
#include <stdint.h>

#define VGA_MEMORY ((uint16_t*)0xB8000)
#define WIDTH 80
#define HEIGHT 25

static int row = 0, col = 0;
static uint8_t color = 0x0F;

void clear_screen() {
    for (int i = 0; i < WIDTH * HEIGHT; i++)
        VGA_MEMORY[i] = (color << 8) | ' ';
    row = col = 0;
}

void print_char(char c) {
    if (c == '\n') {
        col = 0;
        row++;
        return;
    }
    VGA_MEMORY[row * WIDTH + col] = (color << 8) | c;
    col++;
}

void print(const char* str) {
    while (*str)
        print_char(*str++);
}
