# MNIST Parser

This is a simple program written in [Vala][vala] to generate the ground truth file for the [MNIST Database][mnist].

To download the database into a newly created `mnist` folder, run:

``` bash
./download-mnist.sh
```

Then build the program:

``` bash
meson build
ninja -C build
```

To generate the ground truth in a folder named `train` and prefix each file with `train-img`, run:

``` bash
./build/mnist-parser --images mnist/train-images-idx3-ubyte --labels mnist/train-labels-idx1-ubyte --output train --prefix train-img
```

This will generate all the images named `train-img_%05d.pgm` inside the folder `train`, together with a `ground_truth.txt` file.

Do the same for the test set:

``` bash
./build/mnist-parser --images mnist/t10k-images-idx3-ubyte --labels mnist/t10k-labels-idx1-ubyte --output test --prefix test-img
```

[vala]:https://wiki.gnome.org/Projects/Vala
[mnist]:http://yann.lecun.com/exdb/mnist/
