test:
	nvim --headless -u opencode/tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests" \
		-c "qa"

