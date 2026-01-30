// input.h
typedef enum {
    KEY_UP,
    KEY_DOWN,
    KEY_ENTER,
    KEY_UNKNOWN
} key_t;

key_t input_getkey();
