module gapi.font;

import std.stdio;
import std.string;
import std.container.array;

import derelict.sfml2.graphics;
import gapi.texture;

struct Font {
    Array!GlyphsTexture glyphsTextures;
    private const(sfFont)* sf_font;
}

struct GlyphsTexture {
    Texture2D texture;
    uint size;
}

Font createFontFromFile(in string fileName) {
    Font font;

    const char* fileNamez = toStringz(fileName);
    font.sf_font = sfFont_createFromFile(fileNamez);

    return font;
}

void deleteFont(in Font font) {
    sfFont_destroy(cast(sfFont*) font.sf_font);
}

Texture2D getFontGlyphsTexture(ref Font font, in uint textSize,
                               in Texture2DParameters params = Texture2DParameters())
{
    Texture2D* glyphsTexture2D = null;

    for (size_t i = 0; i < font.glyphsTextures.length; ++i) {
        if (font.glyphsTextures[i].size == textSize) {
            glyphsTexture2D = &font.glyphsTextures[i].texture;
            break;
        }
    }

    if (glyphsTexture2D is null) {
        const sf_glyphsTexture = sfFont_getTexture(cast(sfFont*) font.sf_font, textSize);
        const texture = createFromSfmlTexture(sf_glyphsTexture, params);
        GlyphsTexture glyphsTexture = {
            texture: texture,
            size: textSize
        };
        font.glyphsTextures.insert(glyphsTexture);
        return texture;
    } else {
        const sf_glyphsTexture = sfFont_getTexture(cast(sfFont*) font.sf_font, textSize);
        updateSfmlTexture(glyphsTexture2D, sf_glyphsTexture);
        return *glyphsTexture2D;
    }
}
