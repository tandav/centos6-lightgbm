import lightgbm as lgb
from sklearn.datasets import make_regression
from sklearn.model_selection import train_test_split


RANDOM_SEED = 42

X, y = make_regression(n_samples=100, n_features=32, n_informative=32, random_state=RANDOM_SEED)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=RANDOM_SEED)

p = dict(
    learning_rate = 0.1,
    n_estimators = 1,
    seed=RANDOM_SEED,
)

model = lgb.LGBMRegressor(**p).fit(
    X_train, y_train, eval_set=[(X_test, y_test)], eval_metric=['l1', 'l2'],
)

print(model.predict(X_test))
