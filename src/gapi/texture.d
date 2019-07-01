module gapi.texture;

import std.stdio;
import std.string;
import std.conv;

import gapi.opengl;
import gapi.vec;
import derelict.sdl2.image;
import derelict.sdl2.sdl;

struct Texture2D {
    GLuint id = 0;
    uint width;
    uint height;
    Texture2DParameters params;
}

struct Texture2DParameters {
    bool wrapS = false;
    bool wrapT = false;
    bool minFilter = false;
    bool magFilter = false;
}

struct Texture2DCoords {
    vec2 offset;
    vec2 size;
}

Texture2DCoords normilizeTexture2DCoords(in Texture2DCoords coords, in Texture2D texture) {
    const Texture2DCoords normilizedCoords = {
        offset: vec2(coords.offset.x / texture.width, coords.offset.y / texture.height),
        size: vec2(coords.size.x / texture.width, coords.size.y / texture.height)
    };
    return normilizedCoords;
}

Texture2D createTexture2DFromFile(in string fileName,
                                  in Texture2DParameters params = Texture2DParameters())
{
    const char* fileNamez = toStringz(fileName);
    auto surface = IMG_Load(fileNamez);
    scope(exit) SDL_FreeSurface(surface);

    if (!surface) {
        throw new Error("Unable create image from file: " ~ to!string(IMG_GetError()));
    }

    return createTexture2DFromSurface(surface, params);
}

package Texture2D createTexture2DFromSurface(SDL_Surface* surface,
                                             in Texture2DParameters params = Texture2DParameters())
{
    Texture2D texture;
    glGenTextures(1, &texture.id);
    glBindTexture(GL_TEXTURE_2D, texture.id);

    texture.width = surface.w;
    texture.height = surface.h;

    const format = surface.format.BytesPerPixel == 4 ? GL_RGBA : GL_RGB;
    glTexImage2D(
        /* target */ GL_TEXTURE_2D,
        /* level */ 0,
        /* internalformat */ format,
        /* width */ texture.width,
        /* height */ texture.height,
        /* border */ 0,
        /* format */ format,
        /* type */ GL_UNSIGNED_BYTE,
        /* data */ surface.pixels
    );

    return updateTexture2D(texture, params);
}

package Texture2D updateTexture2DFromSurface(Texture2D texture, SDL_Surface* surface) {
    glBindTexture(GL_TEXTURE_2D, texture.id);

    texture.width = surface.w;
    texture.height = surface.h;

    const format = surface.format.BytesPerPixel == 4 ? GL_RGBA : GL_RGB;
    glTexImage2D(
        /* target */ GL_TEXTURE_2D,
        /* level */ 0,
        /* internalformat */ format,
        /* width */ texture.width,
        /* height */ texture.height,
        /* border */ 0,
        /* format */ format,
        /* type */ GL_UNSIGNED_BYTE,
        /* data */ surface.pixels
    );

    return texture;
}

void deleteTexture2D(in Texture2D texture) {
    if (texture.id != 0) {
        glDeleteTextures(1, &texture.id);
    }
}

void bindTexture2D(in Texture2D texture) {
    glBindTexture(GL_TEXTURE_2D, texture.id);
}

void unbindTexture2D() {
    glBindTexture(GL_TEXTURE_2D, 0);
}

Texture2D updateTexture2D(Texture2D texture, in Texture2DParameters params) {
    texture.params = params;

    const wrapS = params.wrapS ? GL_REPEAT : GL_CLAMP_TO_EDGE;
    const wrapT = params.wrapT ? GL_REPEAT : GL_CLAMP_TO_EDGE;
    const minFilter = params.minFilter ? GL_LINEAR : GL_NEAREST;
    const magFilter = params.magFilter ? GL_LINEAR : GL_NEAREST;

    bindTexture2D(texture);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrapS);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrapT);

    return texture;
}
