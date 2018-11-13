module gapi.texture;

import std.string;
import gapi.opengl;
import gapi.vec;

struct Texture2D {
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
    return Texture2D();
}

void bindTexture2D(in Texture2D texture) {
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

void deleteTexture2D(in Texture2D texture) {
}
