#define NOB_IMPLEMENTATION
#pragma GCC diagnostic ignored "-Wmissing-field-initializers"

#include "nob.h"
#include <stdlib.h>
#include <string.h>

#define BINARY_NAME "main"
#define BUILD_FOLDER "./build/"
#define SRC_FOLDER "./src"

typedef struct {
    char **items;
    size_t count;
    size_t capacity;
} Path_List;

static bool has_c_extension(const char *path) {
    size_t len = strlen(path);
    return len >= 2 && strcmp(path + len - 2, ".c") == 0;
}

static void path_list_append(Path_List *arr, const char *str) {
    if (arr->count >= arr->capacity) {
        size_t new_cap = arr->capacity == 0 ? 8 : arr->capacity * 2;
        char **new_items = realloc(arr->items, new_cap * sizeof(char *));
        NOB_ASSERT(new_items != NULL);
        arr->items = new_items;
        arr->capacity = new_cap;
    }
    arr->items[arr->count++] = strdup(str);
    NOB_ASSERT(arr->items[arr->count - 1] != NULL);
}

static bool collect_files(Nob_Walk_Entry entry) {
    Path_List *arr = (Path_List *)entry.data;
    if (entry.type == FILE_REGULAR && has_c_extension(entry.path)) {
        path_list_append(arr, entry.path);
    }
    return true;
}

int main(int argc, char **argv) {
    NOB_GO_REBUILD_URSELF(argc, argv);

    Nob_Cmd cmd = {0};

    nob_cc(&cmd);
    nob_cc_flags(&cmd);
    nob_cmd_append(&cmd, "-o", BUILD_FOLDER BINARY_NAME);

    Path_List files = {0};
    nob_walk_dir(SRC_FOLDER, collect_files, &files);

    for (size_t i = 0; i < files.count; i++) {
        nob_cmd_append(&cmd, files.items[i]);
    }

    if (!nob_cmd_run(&cmd))
        return 1;

    for (size_t i = 0; i < files.count; i++) {
        free(files.items[i]);
    }
    free(files.items);

    return 0;
}
