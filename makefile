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
	@# Each manifest entry is a path, or 'src:dst' to stage the file under a
	@#   different name (e.g. anon-config as config for the git dir).
	@for entry in $(REMOTE_PATHS); do \
	    src=$${entry%%:*}; dst=$${entry#*:}; \
	    if [ -e "$$src" ]; then \
	        mkdir -p $(REMOTE_DIR)/$$(dirname "$$dst"); \
	        ln -sfr "$$src" "$(REMOTE_DIR)/$$dst"; \
	    fi; \
	done

	@for entry in $(REMOTE_PATHS); do \
	    dst=$${entry#*:}; \
	    mkdir -p "$(HOME)/$$(dirname "$$dst")"; \
	done
	@# ^ Ensure target dirs exist (e.g. .local/bin, .config) so stow
	@#   can create symlinks inside them, WITHOUT symlinking the dir
	stow --dir=$(REMOTE_DIR) --target=$(HOME) .

stow-all: install-stow
	stow --dir=. --target=$(HOME) .

clean-remote:
	-stow -D --dir=$(REMOTE_DIR) --target=$(HOME) . 2>/dev/null
	rm -rf $(REMOTE_DIR)
