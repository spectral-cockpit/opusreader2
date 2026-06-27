# R Project Justfile

# install prek git hooks
prek-get:
	curl --proto '=https' --tlsv1.2 -LsSf https://github.com/j178/prek/releases/latest/download/prek-installer.sh | sh

# Install the prek git pre-commit hook.
install-hooks:
    prek install

# Run all prek hooks on all files.
check:
    prek run -a

# Format R files with air
format:
    air format .

fix:
    jarl check --fix --allow-dirty . 

# Lint Markdown files with rumdl.
lint-md:
    rumdl check .

# Auto-fix Markdown issues with rumdl.
fix-md:
    rumdl fmt .

test-r:
	@nix-shell ./nix_envs/r-pages/default.nix --run 'Rscript -e "print('\''R works'\'')"'

render-docs:
	@echo "Starting documentation rendering..."
	@nix-shell ./nix_envs/r-pages/default.nix --run 'Rscript render_docs.R' || {
		echo "Error: Documentation rendering failed.";
		echo "This might be due to R package compatibility issues in the nix environment.";
		echo "Try running the command manually to see detailed error messages.";
		false;
	}

debug-r-packages:
	@echo "Testing R package loading..."
	@nix-shell ./nix_envs/r-pages/default.nix --run 'Rscript -e "print('\''Testing package loading...'\'')"'
