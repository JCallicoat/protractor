Simple screen protractor / compass using [raylib](https://github.com/raysan5/raylib) meant for viewing above map images oriented North to determine headings from lines of sight.

![Screenshot](screenshot.png)

| Key         | Action                               |
| ----------- | ------------------------------------ |
| Escape or q | Exit the program                     |
| Minus (-)   | Decrease window opacity              |
| Equal (=)   | Increase window opacity              |
| Zero (0)    | Reset opacity to 0.5                 |
| d           | Toggle window decorations / titlebar |

Note: Mouse dragging via raylib was a little buggy (probably due to my lack of experience with raylib), so it is disabled, use the titlebar to drag the window for now.

This branch requires the raylib libraries and headers to be installed on the system and discoverable in standard search paths.

To build just clone the `c` branch of the repo and run `make`.

```shell
git clone -b c https://github.com/JCallicoat/protractor
cd protractor
make
```

The output will be named `protractor` in the current directory.
