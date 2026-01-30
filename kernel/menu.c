#include "menu.h"
#include "video.h"
#include "keyboard.h"
#include "input.h"

const char* items[] = {
    "Information",
    "Test screen",
    "Restart"
};

int selected = 0;
int count = 3;

// menu functions
void show_info() {
    clear_screen();
    print("--- Information ---\n\n");
    print("This is an x86 bare-metal project.\n");
    print("Version: 1.0\n\n");
    print("Press any key to return...");
    
    keyboard_getchar(); // Waiting for a button press
}

void show_test_screen() {
    clear_screen();
    print("Test screen activated.\n");
    for(int i = 0; i < 5; i++) print("************************\n");
    print("\nPress any key to return...");
    
    keyboard_getchar();
}

void reboot() {
    asm volatile(
        "outb %b0, %1" 
        : 
        : "a"(0xFE), "Nd"(0x64)
    );
}


void draw_menu() {
    clear_screen();
    for (int i = 0; i < count; i++) {
        if (i == selected) print("> ");
        else print("  ");
        print(items[i]);
        print("\n");
    }
}

void menu_loop()
{
    while(1)
    {
        draw_menu();
        char c = keyboard_getchar();

        if( c == 'w' && selected > 0 ) selected--;
        if( c == 's' && selected < count - 1 ) selected++;

        if (c == '\n')
        {
            if( selected == 0 )
            {
                show_info();
            }
            else if( selected == 1 )
            {
                show_test_screen();
            }
            else if( selected == 2 )
            {
                reboot();
            }
        }
    }
}
