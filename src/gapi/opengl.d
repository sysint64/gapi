module gapi.opengl;
public import derelict.opengl;

mixin glFreeFuncs!(GLVersion.highestSupported, true);
