# Erstellt am 2026-01-01 mit rix + manuelle Integration von Python/uv
let
 pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f86d45c4be4a79b899abc53e48c977ffd9581701.tar.gz") {};
 
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      altdoc
      devtools;
  };
      
  system_packages = builtins.attrValues {
    inherit (pkgs) 
      glibcLocales
      nix
      R
      python312     # Python 3.12 für altdoc
      uv;           # uv als moderner Package Manager
  };
  
  shell = pkgs.mkShell {
    LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    
    buildInputs = [ rpkgs system_packages ];

    shellHook = ''
      echo "--- R + Python 3.12 Environment (2026) ---"
      
      VENV_PATH=".venv_altdoc"

      if [ ! -d "$VENV_PATH" ]; then
        echo "Initializing uv venv in $VENV_PATH mit Python 3.12..."
        uv venv "$VENV_PATH" --python ${pkgs.python312}/bin/python3
      fi

      source "$VENV_PATH/bin/activate"

      UV_PROJECT_ENVIRONMENT=.venv_altdoc uv sync
      
      echo "Status: R $(R --version | head -n1), Python $(python3 --version), uv $(uv --version)"
    '';
  }; 
in
  {
    inherit pkgs shell;
  }
