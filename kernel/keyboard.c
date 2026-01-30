#include "keyboard.h"
#include <stdint.h>

static const char scancode_map[] = {
    0, 27, '1','2','3','4','5','6','7','8','9','0','-','=', '\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',
    0,'a','s','d','f','g','h','j','k','l',';','\'','`',
    0,'\\','z','x','c','v','b','n','m',',','.','/',0,'*',0,' '
};

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

void keyboard_init() {}

//char keyboard_getchar() {
//    while (!(inb(0x64) & 1));
//    uint8_t sc = inb(0x60);
//    if (sc > 57) return 0;
//    return scancode_map[sc];
//}

char keyboard_getchar() {
    uint8_t sc;
    do {
        while (!(inb(0x64) & 1)); // Waiting for data
        sc = inb(0x60);
    } while (sc & 0x80); // If the most significant bit is 1, then this is a "key release" event, skip it.

    if (sc > 57) return 0;
    return scancode_map[sc];
}