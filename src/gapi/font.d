module gapi.font;

import std.stdio;
import std.string;
import std.container.array;

import gapi.texture;

struct Font {
}

Font createFontFromFile(in string fileName) {
    Font font;

    const char* fileNamez = toStringz(fileName);

    return font;
}

void deleteFont(in Font font) {
}

Texture2D getFontGlyphsTexture(in Font font, in uint textSize, in Texture2DParameters params) {
    return Texture2D();
}

Texture2D getFontGlyphsTexture(in Font font, in uint textSize) {
    return Texture2D();
}
