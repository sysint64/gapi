module gapi.vec;

import gl3n.linalg;

alias vec = Vector;
alias vec2 = Vector!(float, 2);
alias vec3 = Vector!(float, 3);
alias vec4 = Vector!(float, 4);

alias vec2i = Vector!(int, 2);
alias vec3i = Vector!(int, 3);
alias vec4i = Vector!(int, 4);

alias vec2ui = Vector!(uint, 2);
alias vec3ui = Vector!(uint, 3);
alias vec4ui = Vector!(uint, 4);

alias mat2 = Matrix!(float, 2, 2);
alias mat3 = Matrix!(float, 3, 3);
alias mat4 = Matrix!(float, 4, 4);

alias mat23 = Matrix!(float, 2, 3);
alias mat32 = Matrix!(float, 3, 2);
alias mat24 = Matrix!(float, 2, 4);
alias mat42 = Matrix!(float, 4, 2);
alias mat34 = Matrix!(float, 3, 4);
alias mat43 = Matrix!(float, 4, 3);
