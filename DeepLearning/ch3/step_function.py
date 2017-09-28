import numpy as np
import matplotlib.pylab as plt

def step_function(x):
	#ステップ関数を実装する
	#ステップ関数:活性化関数の一種。階段関数とも呼ばれる。
	#　　　　　　　閾値を境に出力を変更する。
	#            ex) x <= 0 0
	#                x >  0 1
	y = x > 0
	return y.astype(np.int)

x = np.arange(-5.0, 5.0, 0.1)
y = step_function(x)

plt.plot(x, y)
plt.ylim(-0.1, 1.1)
plt.show()