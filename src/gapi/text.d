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

struct GlyphGeometry {
    Buffer indicesBuffer;
    Buffer verticesBuffer;
    Buffer texCoordsBuffer;

    VAO vao;
}

struct Text {
    private Texture2D texture;
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
    mat4 mvpMatrix;
    Texture2D texture;
}

UpdateTextureTextResult updateTextureText(Text* text, UpdateTextInput input) {
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

    const Transform2D textTransform = {
        position: input.position,
        scaling: vec2(surface.w, surface.h)
    };

    const mvpMatrix = input.cameraMvpMatrix * create2DModelMatrix(textTransform);

    return UpdateTextureTextResult(
        mvpMatrix,
        text.texture
    );
}

struct RenderTextureTextInput {
    ShaderProgram shader;
    GlyphGeometry geometry;
    UpdateTextureTextResult updateResult;
}

void renderTextureText(in RenderTextureTextInput input) {
    bindVAO(input.geometry.vao);
    bindIndices(input.geometry.indicesBuffer);

    setShaderProgramUniformTexture(input.shader, "texture", input.updateResult.texture, 0);
    setShaderProgramUniformMatrix(input.shader, "MVP", input.updateResult.mvpMatrix);

    renderIndexedGeometry(cast(uint) quadIndices.length, GL_TRIANGLE_STRIP);
}
