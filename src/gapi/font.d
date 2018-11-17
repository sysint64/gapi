module gapi.font;

import std.stdio;
import std.conv;
import std.string;
import std.container.array;

import derelict.sdl2.ttf;

import gapi.texture;

struct Font {
    private string fileName;
    private Array!FontSize sizes;
}

struct FontSize {
    uint size;
    TTF_Font* font = null;
}

Font createFontFromFile(in string fileName) {
    Font font;
    font.fileName = fileName;
    return font;
}

package TTF_Font* getTTF_Font(Font* font, in uint textSize) {
    for (size_t i = 0; i < font.sizes.length; ++i) {
        if (font.sizes[i].size == textSize) {
            return font.sizes[i].font;
        }
    }

    const char* fileNamez = toStringz(font.fileName);
    FontSize fontSize;

    fontSize.font = TTF_OpenFont(fileNamez, textSize);
    fontSize.size = textSize;

    font.sizes.insert(fontSize);

    if (!fontSize.font)
        throw new Error("Unable create font from file: " ~ to!string(TTF_GetError()));

    return fontSize.font;
}

void deleteFont(in Font font) {
    for (size_t i = 0; i < font.sizes.length; ++i) {
        TTF_CloseFont(cast(TTF_Font*) font.sizes[i].font);
    }
}

Texture2D getFontGlyphsTexture(in Font font, in uint textSize, in Texture2DParameters params) {
    return Texture2D();
}

Texture2D getFontGlyphsTexture(in Font font, in uint textSize) {
    return Texture2D();
}
