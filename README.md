# astro_init

Is just an initialization script for Astro.
It will scaffold a base project

## dependencies

use the `ASTRO_INIT__SOURCE_ROOT_PATH` to specify the
where it's going to copy the files from

i just symlink the sh file to my `~/bin`, and then do:

```sh
env ASTRO_INIT__SOURCE_ROOT_PATH=path/to/dir astro_init.sh
```

it does not have a default, it should just error if
it can't find the path dir

- `jq` & `sed` for some parsing
- `tmux` to run the dev server in
- `bun` for the js runtime

## road map

i need to figure out how to get it so the actual astro
create script from npm to stop asking questions and just
do the thing,
