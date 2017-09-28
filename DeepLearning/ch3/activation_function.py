import numpy as np

class activation_function():
	#活性化関数を実装する
	def __init__(self, arg):
		pass

	#シグモイド関数
	def sigmoid(x):
		return 1 / (1 + np.exp(-x))

	def softmax(a):
		c = np.max(a)
		exp_a = np.exp(a - c)
		sum_exp_a = np.sum(exp_a)
		y = exp_a / sum_exp_a

		return y