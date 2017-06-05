#!/usr/bin/env bash

MNIST_DIR=mnist
MNIST_TRAIN_IMAGES_URL=http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz
MNIST_TRAIN_LABELS_URL=http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz
MNIST_TEST_IMAGES_URL=http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz
MNIST_TEST_LABELS_URL=http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz

[ ! -d $MNIST_DIR ] && mkdir $MNIST_DIR

download_mnist () {
	for u in $@; do
		curl -O $u
		FILE=`echo $u | cut -d'/' -f6`
		mv $FILE $MNIST_DIR/$FILE
		gzip -fd $MNIST_DIR/$FILE
	done
}

download_mnist \
	$MNIST_TRAIN_IMAGES_URL\
	$MNIST_TRAIN_LABELS_URL \
	$MNIST_TEST_IMAGES_URL \
	$MNIST_TEST_LABELS_URL
