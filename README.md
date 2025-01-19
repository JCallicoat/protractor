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

This was initially written in C, but has been ported to the [zig programming language](https://ziglang.org). There was no real need as it's a very simple program, but I wanted to play with zig some more and zig works on the three major platforms, plus it can cross-compile to any of them. The original version is the the [c branch](https://github.com/JCallicoat/protractor/tree/c) if you want to use that, but be aware it requires raylib installed externally (e.g., through a package manager) with the headers and shared library in standard locations. The zig version will download raylib and statically link it to the binary and is the preferred option.

To build, install zig, clone this repository and run zig-build.

```shell
git clone https://github.com/JCallicoat/protractor
cd protractor
zig build
```

The program will be in `zigout/bin/protractor` on linux and mac, and `zigout/bin/protractor.exe` on windows.

An alternate directory can be specified with `zig build -p /path/to/output/dir`, e.g., `zig build -p ~/.local`

There is also a [rust programming language](https://www.rust-lang.org) port in the [rust branch](https://github.com/JCallicoat/protractor/tree/rust). See README there for instructions on building with rust.

There is also a [go programming language](https://go.dev/) port in the [go branch](https://github.com/JCallicoat/protractor/tree/go). See README there for instructions on building with go.
