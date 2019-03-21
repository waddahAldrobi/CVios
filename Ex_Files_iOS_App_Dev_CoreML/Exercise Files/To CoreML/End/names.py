import pandas as pd
import numpy as np
from sklearn.utils import shuffle
from sklearn.feature_extraction import DictVectorizer
from sklearn.tree import DecisionTreeClassifier
from sklearn.pipeline import Pipeline
import coremltools

names = pd.read_csv('namesDataset.csv')
names = names.as_matrix()[:, 1:]

# 80% reserved for Training
TRAIN_SPLIT = 0.8

def features(name):
    name = name.lower()
    return {
        'firstLetter1': name[0],
        'firstLetter2': name[0:2],
        'firstLetter3': name[0:3],
        'lastLetter1': name[-1],
        'lastLetter2': name[-2:],
        'lastLetter3': name[-3:],
    }


features = np.vectorize(features)


X = features(names[:, 0]) # X contains the features

y = names[:, 1] # y contains the targets

# Shuffle sorted names list for better training
X, y = shuffle(X, y)
X_train, X_test = X[:int(TRAIN_SPLIT * len(X))], X[int(TRAIN_SPLIT * len(X)):]
y_train, y_test = y[:int(TRAIN_SPLIT * len(y))], y[int(TRAIN_SPLIT * len(y)):]

vectorizer = DictVectorizer()
dtc = DecisionTreeClassifier()


pipeline = Pipeline([('dict', vectorizer), ('dtc', dtc)])
pipeline.fit(X_train, y_train)

# Testing
print pipeline.predict(features(["Alex", "Emma"]))     # ['M' 'F']


print pipeline.score(X_train, y_train)

print pipeline.score(X_test, y_test)

# Convert to CoreML model
coreml_model = coremltools.converters.sklearn.convert(pipeline)
coreml_model.author = 'Brian Advent'
coreml_model.license = 'Unknown'
coreml_model.short_description = 'Classifies gender based on provided first name'
coreml_model.input_description['input'] = 'First name features seperated by first 3 and last 3 letters as Dictionary [String:Double]'
coreml_model.output_description['classLabel'] = 'The most likely gender, for the given input. (F|M)'
coreml_model.output_description['classProbability'] = 'The probabilities gender, based on input.'
coreml_model.save('GenderByName.mlmodel')
