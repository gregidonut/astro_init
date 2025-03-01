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
    bun create astro@latest -- --template minimal . &&
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
    bunx astro add astro-compressor &&
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
    sed -i -E 's|("extends": ".*)strict(".*)|\1strictest\2|' ./tsconfig.json &&
        sed -i 's/favicon\.svg/sword\.svg/g' ./src/layouts/Layout.astro &&
        echo "changed some other things"

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
