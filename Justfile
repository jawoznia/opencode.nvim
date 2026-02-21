test:
	nvim --headless -u lua/tests/minimal_init.lua \
		-c "PlenaryBustedDirectory lua/tests" \
		-c "qa"

podman-opencode:
    podman run --rm -it \
        --name opencode \
        --read-only \
        --cap-drop=ALL \
        --security-opt no-new-privileges \
        --pids-limit=256 \
        --memory=2g \
        --cpus=2 \
        --tmpfs /root/.local:rw,size=512m \
        --tmpfs /root/.cache:rw,size=1g \
        --tmpfs /root/.config:rw,size=64m \
        -v "$PWD:/workspace:rw,z" \
        -w /workspace \
        --network=slirp4netns:allow_host_loopback=true \
        opencode-lua-dev \
        opencode
