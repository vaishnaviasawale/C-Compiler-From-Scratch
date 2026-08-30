| Package       | Why                                                         |
| ------------- | ----------------------------------------------------------- |
| `gcc`         | C compiler                                                  | 
| `make`        | Build automation                                            |
| `binutils`    | `objdump`, `as`, `ld`, etc.                                 |
| `glibc-devel` | C development headers/libraries                             |
| `git`         | Useful inside the environment                               |
| `gdb`         | Debugging later                                             |
| `vim`         | Basic editor inside container if needed                     |
| `less`        | Convenient for examining large `objdump` output             |
| `file`        | Identify executable formats                                 |
| `which`       | Check where commands live                                   |
| `diffutils`   | `diff`, useful for tests                                    |

To create the Podman image:
From this folder, run: podman build -t compiler-dev .
Podman will read the containerfile and create an image called compiler-dev
It can be seen by: podman images

To enter the development environment:
podman run --rm -it \
  -v "$PWD:/src:Z" \
  -w /src \
  compiler-dev

We get a shell inside the container where we can check things like:
gcc --version
objdump --version
make --version


