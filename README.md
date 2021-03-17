# -本项目基于物候相机监测植被的季节变化，根据拍摄的RGB图像实现植被生长特征时间点的自动提取。
我们计算了绝对绿度指数（ExG）、相对绿度指数（Gcc）、绿红植被指数（GRVI）和色相指数（Hue），利用平均值法和最大亮度法比较了上述４个颜色指数提取植被生长过程时间节点的效果，与实际观测结果相比较，遴选最佳指数。利用Logistic曲线、高斯函数、傅里叶函数等，对各颜色指数时间序列进行拟合，得到植被生长的关键时间节点。
