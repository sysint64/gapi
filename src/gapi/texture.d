
module gapi.texture;

import std.string;
import derelict.sfml2.graphics;
import gapi.opengl;

struct Texture2D {
    uint width;
    uint height;
    Texture2DParameters params;
    private const(sfTexture)* sf_texture;
}

struct Texture2DParameters {
    bool wrapS = false;
    bool wrapT = false;
    bool minFilter = false;
    bool magFilter = false;
}

Texture2D createTexture2DFromFile(in string fileName,
                                  in Texture2DParameters params = Texture2DParameters())
{
    const char* fileNamez = toStringz(fileName);
    const sf_texture = sfTexture_createFromFile(fileNamez, null);

    if (!sf_texture) {
        throw new Error("Can't load image '" ~ fileName ~ "'");
    }

    const texture = createFromSfmlTexture(sf_texture);
    return updateTexture2D(texture, params);
}

package Texture2D createFromSfmlTexture(const(sfTexture)* sf_texture, in Texture2DParameters params) {
    const texture = createFromSfmlTexture(sf_texture);
    return updateTexture2D(texture, params);
}

package Texture2D createFromSfmlTexture(const(sfTexture)* sf_texture) {
    Texture2D texture;

    const size = sfTexture_getSize(sf_texture);

    texture.width = size.x;
    texture.height = size.y;
    texture.sf_texture = sf_texture;

    return texture;
}

package void updateSfmlTexture(Texture2D* texture, const(sfTexture)* sf_texture) {
    texture.sf_texture = sf_texture;
}

void bindTexture2D(in Texture2D texture) {
    sfTexture_bind(texture.sf_texture);
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

    sfTexture_bind(texture.sf_texture);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrapS);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrapT);

    return texture;
}

void deleteTexture2D(in Texture2D texture) {
    sfTexture_destroy(cast(sfTexture*) texture.sf_texture);
}
