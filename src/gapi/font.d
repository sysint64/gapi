module gapi.font;

import std.stdio;
import std.string;
import std.container.array;

import derelict.sfml2.graphics;
import gapi.texture;

struct Font {
    package const(sfFont)* sf_font;
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

Texture2D getFontGlyphsTexture(in Font font, in uint textSize, in Texture2DParameters params) {
    const sf_glyphsTexture = sfFont_getTexture(cast(sfFont*) font.sf_font, textSize);
    return createFromSfmlTexture(sf_glyphsTexture, params);
}

Texture2D getFontGlyphsTexture(in Font font, in uint textSize) {
    const sf_glyphsTexture = sfFont_getTexture(cast(sfFont*) font.sf_font, textSize);
    return createFromSfmlTexture(sf_glyphsTexture);
}
