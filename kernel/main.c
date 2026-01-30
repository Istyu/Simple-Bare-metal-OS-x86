#include "video.h"
#include "keyboard.h"
#include "menu.h"

void kmain() {
    clear_screen();
    print("Bare-metal menu system\n\n");

    keyboard_init();
    menu_loop();

    while (1);
}
