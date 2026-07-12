REMOTE_DIR   := remote
REMOTE_PATHS := $(shell grep -v '^\s*#' system/package-lists/remote-manifest | grep -v '^\s*$$')

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

stow-remote: install-stow
	@if [ -d $(REMOTE_DIR) ]; then \
	    stow -D --dir=$(REMOTE_DIR) --target=$(HOME) . 2>/dev/null; \
	    rm -rf $(REMOTE_DIR); \
	fi
	@for p in $(REMOTE_PATHS); do \
	    if [ -e "$$p" ]; then \
	        mkdir -p $(REMOTE_DIR)/$$(dirname "$$p"); \
	        ln -sfr "$$p" "$(REMOTE_DIR)/$$p"; \
	    fi; \
	done
	stow --dir=$(REMOTE_DIR) --target=$(HOME) .

stow-all: install-stow
	stow --dir=. --target=$(HOME) .

clean-remote:
	-stow -D --dir=$(REMOTE_DIR) --target=$(HOME) . 2>/dev/null
	rm -rf $(REMOTE_DIR)
