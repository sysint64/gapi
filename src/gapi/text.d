module gapi.text;

import std.conv;
import std.string;
import std.container.array;

import derelict.sfml2.graphics;

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
    private const(sfText)* sf_text;
}

Text createText() {
    Text text;
    text.sf_text = sfText_create();
    return text;
}

void deleteText(in Text text) {
    sfText_destroy(cast(sfText*) text.sf_text);
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
    vec4 texCoord;
    mat4 mvpMatrix;
}

UpdateTextResult updateText(in Text text, in UpdateTextInput input) {

    auto sf_text = cast(sfText*) text.sf_text;
    auto sf_font = cast(sfFont*) input.font.sf_font;

    sfText_setFont(sf_text, input.font.sf_font);
    sfText_setCharacterSize(sf_text, input.textSize);

    string text_s = to!string(input.text);
    const char* text_z = toStringz(text_s);

    sfText_setString(sf_text, text_z);

    vec2 glyphPosition = input.position;
    uint prevChar = 0;

    Array!Glyph glyphs;

    for (size_t i = 0; i < input.text.length; ++i) {
        const curChar = input.text[i];
        const sf_glyph = sfFont_getGlyph(sf_font, curChar, input.textSize, 0, 0);
        const offset = getCharOffset(sf_font, input.textSize, prevChar, curChar, sf_glyph);

        glyphPosition.x += offset.x;
        glyphPosition.y = input.position.y + offset.y;

        prevChar = curChar;

        const Transform2D glyphTransform = {
            position: glyphPosition,
            scaling: vec2(sf_glyph.bounds.width, sf_glyph.bounds.height)
        };
        const mvpMatrix = input.cameraMvpMatrix * create2DModelMatrix(glyphTransform);
        glyphPosition.x += sf_glyph.advance;

        const Glyph glyph = {
            mvpMatrix: mvpMatrix
        };

        glyphs.insert(glyph);
    }

    return UpdateTextResult(
        glyphs,
        getFontGlyphsTexture(input.font, input.textSize)
    );
}

struct RenderTextInput {
    ShaderProgram shader;
    GlyphGeometry glyphGeometry;
    UpdateTextResult updateResult;
}

void renderText(in Text text, in RenderTextInput input) {
    bindVAO(input.glyphGeometry.vao);
    bindIndices(input.glyphGeometry.indicesBuffer);

    // setShaderProgramUniformTexture(input.shader, "texture", input.updateResult.texture, 0);

    for (size_t i = 0; i < input.updateResult.glyphs.length; ++i) {
        setShaderProgramUniformMatrix(input.shader, "MVP", input.updateResult.glyphs[i].mvpMatrix);
        renderIndexedGeometry(cast(uint) quadIndices.length, GL_TRIANGLE_STRIP);
    }
}

private vec2 getCharOffset(sfFont* sf_font, in uint textSize, in dchar prevChar,
                           in dchar curChar, in sfGlyph glyph)
{
    const kerning = sfFont_getKerning(sf_font, prevChar, curChar, textSize);

    vec2 glyphOffset;

    glyphOffset.x = kerning;
    glyphOffset.x += glyph.bounds.left;
    glyphOffset.y = -glyph.bounds.top - glyph.bounds.height;

    return glyphOffset;
}
