## Epitech Coding Style

#### Requirements
____

You need to install `docker` and `git`, to build correctly epitech coding style
image

If you have not setup an SSH private/public key on your GitHub profile, you may
want to change the URL inside `build.sh` which points to the banana vera
repository URL as it's a private EPITECH repository. Switch the following
line :

```bash
BANANA_VERA_REPOSITORY="git@github.com:Epitech/banana-coding-style-checker"
```

to this one :

```bash
BANANA_VERA_REPOSITORY="https://github.com/Epitech/banana-coding-style-checker"
```

#### Epitech Coding Style
____

Just specify the tag you want to apply to the image on the build.sh :

``` bash
build.sh --tag latest
```

You can add an option to clean the cache before building the image :

``` bash
build.sh --tag latest -n
```

#### Deployment
____


##### Login into dockerhub

``` bash
docker login -u username
```

You'll be prompted for your password

##### Push docker image

**`epitech-coding-style`**
``` bash
docker push epitechcontent/epitech-coding-style:latest
```

Where `latest` is the tag of image you want to push, e.g. : latest, devel, coverage
