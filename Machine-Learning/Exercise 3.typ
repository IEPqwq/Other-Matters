#import "@preview/ori:0.2.3": *
#import "@preview/physica:0.9.8": *
#set heading(numbering: numbly("{1:1}、", default: "1.1  "))
#set math.equation(numbering: "(1)")


#show: ori.with(
  title: "PB23000094",
  author: "潘晨骏 PB23000094",
  subject: "机器学习HW3",
  semester: "潘晨骏",
  date: datetime.today(),
  // maketitle: true,
  // makeoutline: true,
  // theme: "dark",
  // media: "screen",
)



// #set page(
//   paper: "a4",
//   margin: (x: 2cm, y: 2.5cm)
// )

// 设置字体，如果你的系统没有 SimSun（宋体），可以替换为其他中文字体如 "Microsoft YaHei"
// #set text(font: ("New Computer Modern", "SimSun"), size: 11pt)
// #set par(justify: true, leading: 0.75em, first-line-indent: 2em)
// #set heading(numbering: "1.1")

// 标题部分
// #align(center)[
//   #text(size: 16pt, weight: "bold")[《机器学习》习题 6.2 解答]
//   #v(0.5em)
//   #text(size: 14pt)[基于 LIBSVM 的线性核与高斯核 SVM 比较]
// ]
// #v(1.5em)

#heading(level: 1, numbering: none)[Answer 1]
线性核和高斯核分别由以下公式给出

*线性核*：
  $ kappa(x_i, x_j) = x_i^T x_j $

*高斯核*：
  $ kappa(x_i, x_j) = exp(-gamma ||x_i - x_j||^2) $


我使用底层封装了 LIBSVM 库的 `scikit-learn` 工具包进行模型训练，最后得到如下结果：

#figure(
  image("assets/output1.png")
)

线性核 SVM 的支持向量编号 (共 15 个): [ 9 10 12 13 14 15 16 17  2  3  4  5  6  7  8]

高斯核 SVM 的支持向量编号 (共 8 个): [12 13 14 15  2  3  6  7]

可以发现，高斯核比线性核更好地完成了分类任务。对于线性核SVM的结果，正例（好瓜）和反例（坏瓜）并不是完美的线性可分的。存在少量的“反例”样本（如编号 13、14、15等点）在物理距离上非常靠近“正例”群体，甚至侵入到了正例的分布区域内。而高斯核SVM比较好的完成了分类任务。

*支持向量的数量与分布差异*

  - 线性核
    SVM：通常选出的支持向量数量相对较少。由于线性核仅能提供全局线性的直线划分，它无法绕过那些互相交叠的点。因此，线性核的支持向量主要由距离该直线最近的边缘点，以及落在软间隔内部、甚至被错误分类的“顽固边界点”构成。
  - 高斯核
    SVM：通常选出的支持向量数量较多。高斯核为了拟合复杂的非线性轮廓，其决策边界会变得弯曲，试图把正例“圈”起来。为了支撑起这种复杂的、曲折的边界，算法需要依赖大量分布在各类拐角和边缘上的点作为“支柱”。


*决策边界的几何形态*

  - 线性模型的决策边界是一条平直的超平面，模型相对简单，泛化能力稳定，但对于当前这种非线性交叠的数据，必然会产生一定的训练误差。
  - 高斯模型的决策边界则呈现出丰富的曲线形态。它具有极强的表达能力，能巧妙地绕过异常的负例样本，在训练集上通常能达到极高的准确率（甚至 0 误差）。

*参数（C 与 $gamma$）选取的影响补充*

在高斯核的实际训练中，支持向量的具体数量高度依赖于惩罚参数 C 和高斯核宽度 $gamma$：

*C*:
- 若 C 设置极大（对错误零容忍），模型为了分类正确每一个点，边界会极度扭曲，导致几乎所有靠近边界的样本都变成支持向量，产生过拟合现象。
- 若 C 设置偏小，则分类边界更趋于平滑，容易产生欠拟合

*$gamma$*:

- 若 $gamma$设置极大，每个样本仅在自身周围极小范围内产生影响，模型会退化成在每个训练点周围画小圈，此时几乎所有训练集样本都会被选定为支持向量。
- 若 $gamma$设置小决策边界会变得非常平滑，甚至趋近于线性，高斯核 SVM 的表现会退化为接近线性SVM


```
# ---------------------------------------------------------
# 使用的源代码
import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm

# 解决 Matplotlib 中文显示问题（Windows/Linux 常用 SimHei，Mac 可改为 'Arial Unicode MS'）
# Mac 常用中文字体
plt.rcParams['font.sans-serif'] = ['Arial Unicode MS'] 
# 或者尝试：plt.rcParams['font.sans-serif'] = ['Heiti TC']
plt.rcParams['axes.unicode_minus'] = False

# 1. 准备西瓜数据集 3.0alpha
X = np.array([
    [0.697, 0.460],[0.774, 0.376], [0.634, 0.264],[0.608, 0.318],[0.556, 0.215], [0.403, 0.237],[0.481, 0.149], [0.437, 0.211], # 1-8 是好瓜
    [0.666, 0.091], [0.243, 0.267],[0.245, 0.057], [0.343, 0.099],[0.639, 0.161],[0.657, 0.198], [0.360, 0.370],[0.593, 0.042], [0.719, 0.103]  # 9-17 是坏瓜
])
y = np.array([1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1])

# 2. 训练模型 (使用 C=10, 高斯核 gamma=10)
C_value = 100.0
svm_linear = svm.SVC(kernel='linear', C=C_value)
svm_rbf = svm.SVC(kernel='rbf', gamma=10, C=C_value)

svm_linear.fit(X, y)
svm_rbf.fit(X, y)

# 获取支持向量的索引 (注意：Python 索引从 0 开始，题目编号从 1 开始，需 +1)
sv_idx_linear = svm_linear.support_ + 1
sv_idx_rbf = svm_rbf.support_ + 1

# 3. 创建画板 (1行2列)
fig, axes = plt.subplots(1, 2, figsize=(14, 6))
titles =[f'线性核 SVM (C={C_value})', f'高斯核 SVM (C={C_value}, $\gamma$=10)']
models =[svm_linear, svm_rbf]

for ax, model, title in zip(axes, models, titles):
    # 3.1 绘制原始数据点
    ax.scatter(X[y == 1, 0], X[y == 1, 1], c='green', marker='o', s=60, label='好瓜 (+1)')
    ax.scatter(X[y == -1, 0], X[y == -1, 1], c='red', marker='x', s=60, label='坏瓜 (-1)')

    # 3.2 圈出支持向量
    # edgecolors='k' 黑色边框，facecolors='none' 内部透明
    ax.scatter(model.support_vectors_[:, 0], model.support_vectors_[:, 1], 
               s=150, facecolors='none', edgecolors='k', linewidths=1.5, 
               label='支持向量 (Support Vectors)')

    # 3.3 绘制决策边界和间隔边界
    xlim = ax.get_xlim()
    ylim = ax.get_ylim()
    
    # 创建网格点以评估模型
    xx = np.linspace(xlim[0], xlim[1], 100)
    yy = np.linspace(ylim[0], ylim[1], 100)
    YY, XX = np.meshgrid(yy, xx)
    xy = np.vstack([XX.ravel(), YY.ravel()]).T
    
    # 获取网格上每个点的决策函数值
    Z = model.decision_function(xy).reshape(XX.shape)

    # 绘制等高线：
    # Z=0 是决策边界 (实线)
    # Z=-1, Z=1 是间隔边界 (虚线)
    ax.contour(XX, YY, Z, colors='blue', levels=[-1, 0, 1], alpha=0.5, 
               linestyles=['--', '-', '--'])

    # 3.4 图形设置
    ax.set_title(title, fontsize=14)
    ax.set_xlabel('密度 (Density)', fontsize=12)
    ax.set_ylabel('含糖率 (Sugar Content)', fontsize=12)
    ax.legend(loc='upper left')
    ax.grid(True, linestyle=':', alpha=0.6)

plt.tight_layout()
plt.show()
print("--- 实验结果 ---")
print(f"线性核 SVM 的支持向量编号 (共 {len(sv_idx_linear)} 个): {sv_idx_linear}")
print(f"高斯核 SVM 的支持向量编号 (共 {len(sv_idx_rbf)} 个): {sv_idx_rbf}")
# ---------------------------------------------------------
```
#pagebreak()

#heading(level: 1, numbering: none)[Answer 2]

*1. 判断是否线性可分，并通过硬间隔最大化求线性支持向量模型：*

观察给定的 8 个样本：
- 类别为 $y = -1$ 的样本（$x_1$ 到 $x_4$），其第一个属性 $x^{(1)}$ 的值分别为：2, 3, 4, 4。均满足 $x^{(1)} <= 4$。
- 类别为 $y = 1$ 的样本（$x_5$ 到 $x_8$），其第一个属性 $x^{(1)}$ 的值分别为：6, 6, 7, 8。均满足 $x^{(1)} >= 6$。

显然，我们可以在 $x^{(1)} = 4$ 和 $x^{(1)} = 6$ 之间（例如 $x^{(1)} = 5$）画一条垂直于横轴的直线，将两类样本完美分开。因此，这 8 个训练样本 *是线性可分的*。

设划分超平面的方程为 $w^T x + b = 0$，其中 $w = vec(w_1, w_2)$。硬间隔最大化的原问题为：
$ min_(w,b) 1/2 ||w||^2 $
$ "s.t." quad y_i (w^T x_i + b) >= 1, quad i=1,2,...,8 $

构建拉格朗日对偶问题，引入拉格朗日乘子 $alpha_i >= 0$：
$ max_alpha sum_(i=1)^8 alpha_i - 1/2 sum_(i=1)^8 sum_(j=1)^8 alpha_i alpha_j y_i y_j (x_i^T x_j) $
$ "s.t." quad sum_(i=1)^8 alpha_i y_i = 0, quad alpha_i >= 0 $

根据 SMO 算法的计算逻辑，参与构建最大间隔边界（即 $alpha_i > 0$）的样本必然是离决策边界最近的样本。观察数据可知，两类的边界分别在 $x^{(1)}=4$ 和 $x^{(1)}=6$ 处。通过计算可得，非零的拉格朗日乘子为：
$ alpha_3 = 0.5 quad ("对应"  x_3(4,4), y_3=-1) $
$ alpha_5 = 0.5 quad ("对应"  x_5(6,4), y_5=1) $
*(注：其余 $alpha_i$ 均为 0，且满足 $sum alpha_i y_i = 0.5(-1) + 0.5(1) = 0$ 的约束条件。)*

根据求得的 $alpha$ 计算权重向量 $w$：
$ w &= sum_(i=1)^8 alpha_i y_i x_i = alpha_3 y_3 x_3 + alpha_5 y_5 x_5 \
    &= 0.5 dot (-1) dot vec(4, 4) + 0.5 dot 1 dot vec(6, 4) \
    &= vec(-2, -2) + vec(3, 2) \
    &= vec(1, 0) $
即 $w_1 = 1, w_2 = 0$。

选择一个支持向量（例如 $x_5$）来求解偏置 $b$：
$ y_5 (w^T x_5 + b) = 1 \
  1 dot (1 dot 6 + 0 dot 4 + b) = 1 \
  6 + b = 1 -> b = -5 $

由此得到最终的线性支持向量分类模型为：
$ f(x) = text("sign")(w^T x + b) = text("sign")(x^{(1)} - 5) $


*2.确定支持向量*

支持向量是使得约束条件等号成立的训练样本，即满足 $y_i (w^T x_i + b) = 1$ 的样本。将模型参数 $w=vec(1,0), b=-5$ 代入检验：

- 对于 $x_3 = vec(4, 4), y_3 = -1$: $quad -1 dot (4 - 5) = 1$ （是支持向量）
- 对于 $x_4 = vec(4, 2), y_4 = -1$: $quad -1 dot (4 - 5) = 1$ （是支持向量）
- 对于 $x_5 = vec(6, 4), y_5 = 1$: $quad 1 dot (6 - 5) = 1$ （是支持向量）
- 对于 $x_6 = vec(6, 3), y_6 = 1$: $quad 1 dot (6 - 5) = 1$ （是支持向量）

*结论：* 训练样本中的 *$x_3, x_4, x_5, x_6$* 这四个样本正好处于间隔边界上，它们是该模型的支持向量。



*3.决定额外样本的预测类别*

利用学出的模型 $f(x) = text("sign")(x^{(1)} - 5)$，对给定的 3 个新样本进行预测：

- *对于 $x_9 = vec(3, 4)$：*
  $ w^T x_9 + b = 3 - 5 = -2 < 0 $
  *预测类别为：-1*

- *对于 $x_{10} = vec(7, 4)$：*
  $ w^T x_{10} + b = 7 - 5 = 2 > 0 $
  *预测类别为：1*

- *对于 $x_{11} = vec(5, 5)$：*
  $ w^T x_{11} + b = 5 - 5 = 0 $

#pagebreak()

#heading(level: 1, numbering: none)[Answer 3]

给定新样本 $x = ("颜色" = "黑色", "毛发" = "粗糙", "体型" = "小型")$。
根据朴素贝叶斯分类器，我们需要比较该样本属于“温顺”和“暴躁”的后验概率。根据贝叶斯定理和属性条件独立性假设，公式如下（忽略相同的分母）：
$ P(c | x) prop P(c) dot P("黑色" | c) dot P("粗糙" | c) dot P("小型" | c) $
其中类别 $c in \{ "温顺", "暴躁" \}$。

总训练样本数 $N = 7$。
- **温顺** 的样本有 4 个（样本 1, 4, 5, 7）。
- **暴躁** 的样本有 3 个（样本 2, 3, 6）。

先验概率为：
$ P("温顺") &= 4/7 \
  P("暴躁") &= 3/7 $

对于类别 $c = "温顺"$（共 4 个样本）：
- 颜色为“黑色”的有 1 个（样本4），故 $P("黑色" | "温顺") = 1/4$
- 毛发为“粗糙”的有 2 个（样本1, 7），故 $P("粗糙" | "温顺") = 2/4 = 1/2$
- 体型为“小型”的有 3 个（样本1, 4, 5），故 $P("小型" | "温顺") = 3/4$

对于类别 $c = "暴躁"$（共 3 个样本）：
- 颜色为“黑色”的有 2 个（样本2, 3），故 $P("黑色" | "暴躁") = 2/3$
- 毛发为“粗糙”的有 1 个（样本2），故 $P("粗糙" | "暴躁") = 1/3$
- 体型为“小型”的有 1 个（样本6），故 $P("小型" | "暴躁") = 1/3$

若新猫的性格为“温顺”，其概率正比于：
$ P("温顺" | x) &prop P("温顺") times P("黑色" | "温顺") times P("粗糙" | "温顺") times P("小型" | "温顺") \
  &= 4/7 times 1/4 times 1/2 times 3/4 \
  &= 3/56 approx 0.0536 $

新猫的性格为“暴躁”，其概率正比于：
$ P("暴躁" | x) &prop P("暴躁") times P("黑色" | "暴躁") times P("粗糙" | "暴躁") times P("小型" | "暴躁") \
  &= 3/7 times 2/3 times 1/3 times 1/3 \
  &= 2/63 approx 0.0317 $

将两者化为同分母比较大小（公分母为 $504$）：
- $P("温顺" | x) prop 3/56 = 27/504$
- $P("暴躁" | x) prop 2/63 = 16/504$

因为 $3/56 > 2/63$ ，即 $P("温顺" | x) > P("暴躁" | x)$。
根据最大后验概率（MAP）准则，朴素贝叶斯分类器预测这只新猫的性格为 **温顺**。