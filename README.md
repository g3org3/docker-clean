# docker-clean

## Install
```
$ npm i -g dockerclean
```

## Usage
```bash
USAGE:
 docker-clean [options]

Options
  -v       	      Display version
  --con, -c	      Remove exited containers
  --vol, -x       Clean up volumes
  --images, -i	  Remove all images tagged with <none>
  --all, -a	      Remove all of the above
```

### Debug
```bash
# append a 'v' to toggle verbose info

# verbose info for all
docker-clean -av

# verbose info for remove exited containers
docker-clean -cv
```

## Credits
[chadoe - docker-cleanup-volumes](https://github.com/chadoe/docker-cleanup-volumes)
