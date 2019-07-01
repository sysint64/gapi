module gapi.text;

import std.conv;
import std.string;
import std.container.array;

import derelict.sdl2.ttf;
import derelict.sdl2.sdl;

import gapi.opengl;
import gapi.geometry;
import gapi.geometry_quad;
import gapi.font;
import gapi.vec;
import gapi.shader;
import gapi.shader_uniform;
import gapi.transform;
import gapi.texture;

struct TextParams {
    uint textSize;
    Font font;
    dstring text;
}

struct Text {
    Texture2D texture;
}

Text createText() {
    Text text;
    return text;
}

void deleteText(in Text text) {
    deleteTexture2D(text.texture);
}

struct UpdateTextInput {
    uint textSize = 12;
    Font* font;
    dstring text;
    vec2 position;
    mat4 cameraMvpMatrix;
}

struct UpdateTextureTextResult {
    Texture2D texture;
    vec2 surfaceSize;
}

UpdateTextureTextResult updateTextureText(Text* text, UpdateTextInput input) {
    if (input.text.length == 0) {
        return UpdateTextureTextResult(
            text.texture,
            vec2(0, 0)
        );
    }

    const white = SDL_Color(0, 0, 0);

    auto copy = new ushort[input.text.length + 1];

    for (size_t i = 0; i < input.text.length; ++i) {
        copy[i] = cast(ushort) input.text[i];
    }

    copy[input.text.length] = 0;

    auto font = getTTF_Font(input.font, input.textSize);

    SDL_Surface* surface = TTF_RenderUNICODE_Blended(font, copy.ptr, white);

    if (!surface)
        throw new Error("Unable create text texture: " ~ to!string(TTF_GetError()));

    scope(exit) SDL_FreeSurface(surface);

    const Texture2DParameters params = {
        minFilter: false,
        magFilter: false
    };

    if (text.texture.id == 0) {
        text.texture = createTexture2DFromSurface(surface, params);
    } else {
        updateTexture2DFromSurface(text.texture, surface);
    }

    return UpdateTextureTextResult(
        text.texture,
        vec2(surface.w, surface.h)
    );
}

vec2 getTextBounds(Text* text, UpdateTextInput input) {
    int width;
    int height;

    auto copy = new ushort[input.text.length + 1];

    for (size_t i = 0; i < input.text.length; ++i) {
        copy[i] = cast(ushort) input.text[i];
    }

    copy[input.text.length] = 0;

    auto font = getTTF_Font(input.font, input.textSize);

    const white = SDL_Color(0, 0, 0);
    SDL_Surface* surface = TTF_RenderUNICODE_Blended(font, copy.ptr, white);

    // if (!TTF_SizeUNICODE(font, copy.ptr, &width, &height)) {
    if (!surface)
        throw new Error("Unable to get text size: " ~ to!string(TTF_GetError()));
    // }

    return vec2(surface.w, surface.h);
}
