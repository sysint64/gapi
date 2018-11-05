module gapi.text;

import std.conv;
import std.string;

import derelict.sfml2.graphics;

import gapi.opengl;
import gapi.geometry;
import gapi.geometry_quad;
import gapi.font;
import gapi.vec;
import gapi.shader;
import gapi.shader_uniform;
import gapi.transform;

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

void renderText(in Text text, in TextParams textParams, in ShaderProgram shader,
                in GlyphGeometry glyphGeometry, in Transform2D textTransform,
                in mat4 cameraMvpMatrix)
{
    bindVAO(glyphGeometry.vao);
    bindIndices(glyphGeometry.indicesBuffer);

    const glyphsTexture = getFontGlyphsTexture(textParams.font, textParams.textSize);
    // setShaderProgramUniformTexture(shader, "texture", glyphsTexture, 0);

    auto sf_text = cast(sfText*) text.sf_text;
    auto sf_font = cast(sfFont*) textParams.font.sf_font;

    sfText_setFont(sf_text, textParams.font.sf_font);
    sfText_setCharacterSize(sf_text, textParams.textSize);

    string text_s = to!string(textParams.text);
    const char* text_z = toStringz(text_s);

    sfText_setString(sf_text, text_z);

    vec2 glyphPosition = textTransform.position;
    uint prevChar = 0;

    for (size_t i = 0; i < textParams.text.length; ++i) {
        const curChar = textParams.text[i];
        const glyph = sfFont_getGlyph(sf_font, curChar, textParams.textSize, 0, 0);
        const offset = getCharOffset(sf_font, textParams.textSize, prevChar, curChar, glyph);

        glyphPosition.x += offset.x;
        glyphPosition.y = textTransform.position.y + offset.y;

        prevChar = curChar;

        // Rendering
        const Transform2D glyphTransform = {
            position: glyphPosition,
            scaling: vec2(glyph.bounds.width, glyph.bounds.height)
        };
        const mvpMatrix = cameraMvpMatrix * create2DModelMatrix(glyphTransform);
        setShaderProgramUniformMatrix(shader, "MVP", mvpMatrix);

        renderIndexedGeometry(cast(uint) quadIndices.length, GL_TRIANGLE_STRIP);

        glyphPosition.x += glyph.advance;
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
