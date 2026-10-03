{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    love
    lua5_1
    luarocks
    lua-language-server
  ];

  shellHook = ''
    echo "Entorno listo. Ejecuta love . para iniciar"
  '';
}
