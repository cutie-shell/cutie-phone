#include <phone.h>

int main(int argc, char *argv[]) {
    Phone app(argc, argv);
    return app.isPrimary() ? app.exec() : 0;
}
