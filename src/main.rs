use raylib::prelude::*;

const SCREEN_WIDTH: i32 = 650;
const SCREEN_HEIGHT: i32 = 650;

fn main() {
    let protractor_png_data = include_bytes!("../resources/protractor.png");

    let mut opacity: f32 = 0.5;

    let (mut rl, thread) = raylib::init()
        .size(SCREEN_WIDTH, SCREEN_HEIGHT)
        // .undecorated()
        .title("Screen Protractor")
        .build();

    // make window always on top
    let topmost = rl.get_window_state().set_window_topmost(true);
    rl.set_window_state(topmost);

    // make window non resizeable
    rl.clear_window_state(rl.get_window_state().set_window_resizable(false));

    // make window 50% transparent
    rl.set_window_opacity(opacity);

    let image = match Image::load_image_from_mem(".png", protractor_png_data) {
        Ok(image) => image,
        Err(error) => panic!("Problem loading PNG from memory {error:?}"),
    };
    let texture = match rl.load_texture_from_image(&thread, &image) {
        Ok(texture) => texture,
        Err(error) => panic!("Problem loading texture from Image {error:?}"),
    };

    rl.set_target_fps(60);

    // for mouse dragging the window
    // let mut mouse_delta: prelude::Vector2;
    // let mut window_position: prelude::Vector2;

    let mut exit_window = false;

    while !exit_window {
        if rl.window_should_close() || rl.is_key_pressed(KeyboardKey::KEY_Q) {
            exit_window = true
        }

        // handle keypresses
        if rl.is_key_pressed(KeyboardKey::KEY_MINUS) {
            opacity -= 0.1
        }
        if rl.is_key_pressed(KeyboardKey::KEY_EQUAL) {
            opacity += 0.1
        }
        if rl.is_key_pressed(KeyboardKey::KEY_ZERO) {
            opacity = 0.5
        }

        if rl.is_key_pressed(KeyboardKey::KEY_D) {
            if rl.get_window_state().window_undecorated() {
                rl.set_window_state(rl.get_window_state().set_window_undecorated(false));
            } else {
                rl.set_window_state(rl.get_window_state().set_window_undecorated(true));
            }
        }

        // handle mouse drag
        // window_position = rl.get_window_position();
        // mouse_delta = rl.get_mouse_delta();
        // if rl.is_mouse_button_pressed(MouseButton::MOUSE_BUTTON_LEFT) {
        //     rl.set_window_position(
        //         (mouse_delta.x + window_position.x) as i32,
        //         (mouse_delta.y + window_position.y) as i32,
        //     );
        // }

        // update window opacity
        if opacity < 0.01 {
            opacity = 0.1;
        } else if opacity > 1.0 {
            opacity = 1.0;
        }
        rl.set_window_opacity(opacity);

        // draw our protractor
        let mut d = rl.begin_drawing(&thread);

        d.clear_background(Color::BLANK);
        d.draw_texture(&texture, 0, 0, Color::WHITE);
    }
}
