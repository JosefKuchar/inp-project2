#include <stdio.h>

void main() {
    char string[] = "xkucha28";
    int a = 'k' - 'a' + 1;
    int b = 'u' - 'a' + 1;
    for (int i = 0; string[i] >= 'a'; i++) {
        int c = string[i];
        if (i % 2 == 0) {
            c += a;
            if (c > 'z') {
                c -= 26;
            }
        } else {
            c -= b;
            if (c < 'a') {
                c += 26;
            }
        }
        putc(c, stdout);
    }
}
