#!/usr/bin/bash

let es=0

catch() {
    if [[ $es == 0 ]]; then
        {
            echo "did not expect an error but got one"
            return
        }
    fi
    echo "astro_init.sh: error: $es"
    exit 1
}

try() {
    set -e
    "$@"
}

main() {
    echo "thank you for using astro_init.sh"

    es=$es+1
    bun create astro@latest -- --template minimal . --install --no-git &&
        echo "done installing astro"

    es=$es+1
    bun install --save-dev \
        eslint eslint-plugin-astro \
        @typescript-eslint/parser \
        prettier \
        prettier-plugin-astro \
        eslint-plugin-jsx-a11y \
        jiti &&
        echo "done installing basic packages"

    es=$es+1
    printf '\n' | bunx astro add astro-compressor --yes &&
        echo "added integration package"

    es=$es+1
    rm -r ./src ./public &&
        cp -r \
            $ASTRO_INIT__SOURCE_ROOT_PATH/src \
            $ASTRO_INIT__SOURCE_ROOT_PATH/public \
            $ASTRO_INIT__SOURCE_ROOT_PATH/eslint.config.ts \
            $ASTRO_INIT__SOURCE_ROOT_PATH/prettier.config.mjs \
            . &&
        echo "moved some stuff"

    es=$es+1
    cat tsconfig.json |
        jq --indent 4 \
            '.extends = "astro/tsconfigs/strictest" | 
            . += {
                "compilerOptions": {
                    "baseUrl": ".",
                    "paths": {
                        "@/*": ["src/*"]
                    }
                }
            }' >new_tsconfig.json &&
        mv new_tsconfig.json tsconfig.json &&
        bunx prettier --write tsconfig.json &&
        echo "changed tsconfig"

    es=$es+1
    rm README.md &&
        echo "deleted readme"
}

try main || catch &&
    if ! tmux ls | grep -q "astro_dev"; then
        {
            tmux new-session -d -s astro_dev "bun run dev"
            exit 0
        }
    fi
tmux kill-session -t astro_dev &&
    tmux new-session -d -s astro_dev "bun run dev"
