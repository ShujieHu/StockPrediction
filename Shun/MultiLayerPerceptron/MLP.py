#!/usr/bin/env python

import os.path
import tensorflow as tf
import numpy as np

# Parameters
learning_rate = 0.001
training_epochs = 200
batch_size = 100
display_step = 1

# Model saver
model_path = './CVmodel.ckpt'

# Network Parameters
n_hidden_1 = 128 # 1st layer num features
n_hidden_2 = 32 # 2nd layer num features
n_input = 99 # MNIST data input (img shape: 28*28)
n_classes = 99 # MNIST total classes (0-9 digits)

# tf Graph input
x = tf.placeholder(tf.float32, shape=[None, n_input])
y = tf.placeholder(tf.float32, shape=[None, n_classes])

# Create model
def multilayer_perceptron(_X, _weights, _biases):
    layer_1 = tf.nn.relu(tf.add(tf.matmul(_X, _weights['h1']), _biases['b1'])) #Hidden layer with RELU activation
    layer_2 = tf.nn.relu(tf.add(tf.matmul(layer_1, _weights['h2']), _biases['b2'])) #Hidden layer with RELU activation
    return tf.sigmoid(tf.matmul(layer_2, _weights['out']) + _biases['out'])

# Store layers weight & bias
weights = {
    'h1': tf.Variable(tf.random_normal([n_input, n_hidden_1])),
    'h2': tf.Variable(tf.random_normal([n_hidden_1, n_hidden_2])),
    'out': tf.Variable(tf.random_normal([n_hidden_2, n_classes]))
}
biases = {
    'b1': tf.Variable(tf.random_normal([n_hidden_1])),
    'b2': tf.Variable(tf.random_normal([n_hidden_2])),
    'out': tf.Variable(tf.random_normal([n_classes]))
}

# Construct model.
pred = multilayer_perceptron(x, weights, biases)

# Loss and optimizer.
#cost = -tf.reduce_sum(y * tf.log(pred)) # Cross Entropy loss 
cost = tf.reduce_sum(tf.pow(pred - y, 2)) # L2 loss
optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost)

# Load the time-series data.
training = np.loadtxt("Training")
testing = np.loadtxt("Testing")

# Initializing the variables
init = tf.initialize_all_variables()
saver = tf.train.Saver()

# Launch the graph
with tf.Session() as sess:
    sess.run(init)
    if os.path.exists(model_path):
        saver.restore(sess, model_path)
        print "Model Restored!"

    # Training cycle
    for epoch in range(training_epochs):
        np.random.shuffle(training)
        avg_cost = 0.
        total_batch = int(training.shape[0]/batch_size)
        # Loop over all batches
        for i in range(total_batch):
            batch_xs = training[(0 + i * batch_size):(batch_size + i * batch_size),0:99]
            batch_ys = training[(0 + i * batch_size):(batch_size + i * batch_size),99:]
            # Fit training using batch data
            sess.run(optimizer, feed_dict={x: batch_xs, y: batch_ys})
            # Compute average loss
            avg_cost += sess.run(cost, feed_dict={x: batch_xs, y: batch_ys})/total_batch
        # Display logs per epoch step
        if epoch % display_step == 0:
            print "Epoch:", '%04d' % (epoch+1), "cost=", "{:.9f}".format(avg_cost)

    save_path = saver.save(sess, model_path)
    print("Model saved in file: %s" % save_path)

    print "Optimization Finished!"

    # Test model
    correct_prediction = tf.equal(tf.cast(tf.round(pred), "int64"), tf.cast(y, "int64")) 
    # Calculate accuracy
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float"))
    print "Accuracy:", accuracy.eval({x: testing[:,0:99], y: testing[:,99:]})

