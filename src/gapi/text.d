module gapi.text;

import std.conv;
import std.string;
import std.container.array;

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
}

Text createText() {
    Text text;
    return text;
}

void deleteText(in Text text) {
}

struct UpdateTextInput {
    uint textSize;
    Font font;
    dstring text;
    vec2 position;
    mat4 cameraMvpMatrix;
}

struct UpdateTextResult {
    Array!Glyph glyphs;
    Texture2D texture;
}

struct Glyph {
    Texture2DCoords texCoords;
    mat4 mvpMatrix;
}

UpdateTextResult updateText(in Text text, in UpdateTextInput input) {
    // auto sf_text = cast(sfText*) text.sf_text;
    // auto sf_font = cast(sfFont*) input.font.sf_font;

    // sfText_setFont(sf_text, input.font.sf_font);
    // sfText_setCharacterSize(sf_text, input.textSize);

    // string text_s = to!string(input.text);
    // const char* text_z = toStringz(text_s);

    // sfText_setString(sf_text, text_z);

    // vec2 glyphPosition = input.position;
    // uint prevChar = 0;

    // Array!Glyph glyphs;
    // const texture = getFontGlyphsTexture(input.font, input.textSize);

    // for (size_t i = 0; i < input.text.length; ++i) {
    //     const curChar = input.text[i];
    //     const sf_glyph = sfFont_getGlyph(sf_font, curChar, input.textSize, 0, 0);
    //     const offset = getCharOffset(sf_font, input.textSize, prevChar, curChar, sf_glyph);

    //     glyphPosition.x += offset.x;
    //     glyphPosition.y = input.position.y + offset.y;

    //     prevChar = curChar;

    //     const Transform2D glyphTransform = {
    //         position: glyphPosition,
    //         scaling: vec2(sf_glyph.bounds.width, sf_glyph.bounds.height)
    //     };
    //     const mvpMatrix = input.cameraMvpMatrix * create2DModelMatrix(glyphTransform);
    //     glyphPosition.x += sf_glyph.advance;

    //     Texture2DCoords glyphTexCoords;

    //     glyphTexCoords.offset = vec2(sf_glyph.textureRect.left, sf_glyph.textureRect.top);
    //     glyphTexCoords.size = vec2(sf_glyph.textureRect.width, sf_glyph.textureRect.height);

    //     const Glyph glyph = {
    //         mvpMatrix: mvpMatrix,
    //         texCoords: normilizeTexture2DCoords(glyphTexCoords, texture)
    //     };

    //     glyphs.insert(glyph);
    // }

    // return UpdateTextResult(
    //     glyphs,
    //     texture
    // );
    return UpdateTextResult();
}

struct RenderTextInput {
    ShaderProgram shader;
    GlyphGeometry glyphGeometry;
    UpdateTextResult updateResult;
}

void renderText(in RenderTextInput input) {
    bindVAO(input.glyphGeometry.vao);
    bindIndices(input.glyphGeometry.indicesBuffer);

    setShaderProgramUniformTexture(input.shader, "texture", input.updateResult.texture, 0);

    for (size_t i = 0; i < input.updateResult.glyphs.length; ++i) {
        const glyph = input.updateResult.glyphs[i];

        setShaderProgramUniformMatrix(input.shader, "MVP", glyph.mvpMatrix);
        setShaderProgramUniformVec2f(input.shader, "texOffset", glyph.texCoords.offset);
        setShaderProgramUniformVec2f(input.shader, "texSize", glyph.texCoords.size);

        renderIndexedGeometry(cast(uint) quadIndices.length, GL_TRIANGLE_STRIP);
    }
}

// private vec2 getCharOffset(sfFont* sf_font, in uint textSize, in dchar prevChar,
//                            in dchar curChar, in sfGlyph glyph)
// {
//     const kerning = sfFont_getKerning(sf_font, prevChar, curChar, textSize);

//     vec2 glyphOffset;

//     glyphOffset.x = kerning;
//     glyphOffset.x += glyph.bounds.left;
//     glyphOffset.y = -glyph.bounds.top - glyph.bounds.height;

//     return glyphOffset;
// }
