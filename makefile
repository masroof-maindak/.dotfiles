REMOTE_DIR  := remote
REMOTE_PKGS := tmux fish nvim vim lf

.PHONY: stow-all stow-remote install-stow clean-remote

install-stow:
	@if ! command -v stow >/dev/null 2>&1; then \
	    echo "Installing stow..."; \
	    if command -v pacman >/dev/null 2>&1; then \
	        sudo pacman -S --noconfirm stow; \
	    elif command -v apt-get >/dev/null 2>&1; then \
	        sudo apt-get install -y stow; \
	    elif command -v dnf >/dev/null 2>&1; then \
	        sudo dnf install -y stow; \
	    else \
	        echo "Unsupported distro. Install stow manually."; \
	        exit 1; \
	    fi \
	fi

$(REMOTE_DIR):
	@mkdir -p $(REMOTE_DIR)/.config
	@for pkg in $(REMOTE_PKGS); do \
	    if [ -d ".config/$$pkg" ]; then \
	        ln -sf ../.config/$$pkg $(REMOTE_DIR)/.config/$$pkg; \
	    fi; \
	done

stow-remote: install-stow $(REMOTE_DIR)
	stow --dir=$(REMOTE_DIR) --target=$(HOME) .

stow-all: install-stow
	stow --dir=. --target=$(HOME) .

clean-remote:
	rm -rf $(REMOTE_DIR)
