gpfm
====

This is the documentation of the code for the Gaussian process factorization machines (GPFMs) used in our SIGIR'2014 paper entitled "Gaussian Process Factorization Machines  for Context-aware Recommendations". It can be run with MATLAB or Octave (tested on version 3.6.0 on Ubuntu). 12.04)

For questions, please contact trung(dot)ngvan(at)gmail(dot)com.

Last update: 10/05/2014.

INPUT FORMAT

GPFM can deal with two types of feedback: explicit and implicit. The code requires that you provide the training and testing data in the format required by GPFM (for explicit feedback) and GPPW (for implicit feedback). This should be given in the form of observation matrices.

1.1 Explicit feedback
It is most convenient to introduce the observation matrix with an example:

1 2 1 1 4

1 1 2 1 3

1 1 1 2 1

2 1 2 2 5

2 1 3 1 1

Here we have 5 observations each represented in one row of the matrix. When storing in a file, the equivalent is one line of the file.

Each row/observation contains the following attributes:

user_id, item_id, context_variable_1, context_variable_2, ..., context_variable_K, rating.

Consider the 3rd observation, the user_id is 1, item_id is 1, and it has two contextual variables. The first contextual variable has value 1 and the second has value 2. The rating given to this combination of item and context (1,1,2) is 1 by the user.

Some important issues to remember:
- Currently only categorical attributes are supported. Thus, all elements of the matrix must be integer (except the ratings which can be real-valued).
- In MATLAB, subscript/index starts from 1 so if your data has 0, you must convert that to 1 e.g. increase the value of all of your categorical features.

See data/demo_train.csv and data/demo_test.csv. Of course, the format is the same for both of the training and testing data.

1.2 Implicit feedback

For the case of implicit feedback, an additional pairwise comparison matrix is required for pairwise preference training.
If we were to convert the above dataset into implicit feedback with rating higher than 3 as relevant items, the following 2 matrices are needed for GPPW.

Item-based matrix:

1 2 1 1 +1

1 1 2 1 -1

1 1 1 2 -1

2 1 2 2 +1

2 1 3 1 -1

Note that this matrix is in exactly the same format as in the explicit feedback case, except that now the ratings are +1 (relevant) and -1 (irrelevant) only. Likewise, the test matrix can be of the same format as well.

Pairwise matrix:

1 2 1 1 1 2 1 +1

1 2 1 1 1 1 2 +1

1 1 2 1 2 1 1 -1

1 1 1 2 2 1 1 -1

2 1 2 2 1 3 1 +1

2 1 3 1 1 2 2 -1

Each row in the pairwise matrix has the form:

user_id, (item_id1, contexts1), (item_id2, contexts2), preference

where preference = +1 if user prefers the first combination (item_id1, contexts1) over the second combination (item_id2, contexts2).

Let us consider user 1 as an example. He likes the (item,context) combination of (2,1,1) and dislikes the combination of (1,2,1) so we create the pairwise preference in the first row: 1 2 1 1 1 2 1 +1

See data/demo_pw_train.csv for an example of pairwise matrix; data/demo_pw_item.csv and data/demo_pw_test.csv are similar to that in the explicit case.

TRAINING AND MAKING PREDICTION

Once the data is in the right format, it is straightforward to run GPFM or GPPW on them. 

There are a few parameters to configure for each specific dataset, but the recommended / default values can be found in the demo script. 
The most important ones are:
- kernel : which kernel to use (one of 'rbf', 'linearOne', or 'linear'), but 'rbf' is most powerful and often outperforms the other two kernels
- useBias : whether to use the bias term in the model
- learnRate : learning rate of the stochastic gradient descent algorithm (this should be set according to the datasets)
- dimItem : the latent dimension of items
- dimContext : the latent dimensions of contexts 

See scripts/demo_gpfm.m and scripts/demo_gppw.m for an example of how to set-up and run a GPFM model on an explicit feedback problem and a GPPW model on an implicit feedback problem. 


