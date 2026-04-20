#import "template.typ": *

// 主题颜色
#let theme-color = rgb("#26267d")
#let icon = icon.with(fill: theme-color)

// 设置图标, 来源: https://fontawesome.com/icons/
#let fa-award = icon("icons/fa-award.svg")
#let fa-building-columns = icon("icons/fa-building-columns.svg")
#let fa-code = icon("icons/fa-code.svg")
#let fa-envelope = icon("icons/fa-envelope.svg")
#let fa-github = icon("icons/fa-github.svg")
#let fa-graduation-cap = icon("icons/fa-graduation-cap.svg")
#let fa-linux = icon("icons/fa-linux.svg")
#let fa-phone = icon("icons/fa-phone.svg")
#let fa-windows = icon("icons/fa-windows.svg")
#let fa-wrench = icon("icons/fa-wrench.svg")
#let fa-work = icon("icons/fa-work.svg")

// 设置简历选项与头部
#show: resume.with(
  // 字体和基准大小
  size: 10pt,
  // 标题颜色
  theme-color: theme-color,
  // 控制纸张的边距
  margin: (
    top: 1.5cm,
    bottom: 2cm,
    left: 2cm,
    right: 2cm,
  ),

  // 如果需要姓名及联系信息居中，请删除下面关于头像的三行参数，并取消header-center的注释
  //header-center: true,

  // 如果不需要头像，则将下面三行的参数注释或删除
  photograph: "证件照.jpeg",
  photograph-width: 8em,
  gutter-width: 2em,
)[
  = 潘晨骏

  #info(
    color: theme-color,
    (
      icon: fa-phone,
      content: [(+86) 177-0792-7322],
    ),
    (
      icon: fa-building-columns,
      content: "中国科学技术大学",
    ),
    (
      icon: fa-graduation-cap,
      content: "量子信息科技英才班",
    ),
    (
      icon: fa-envelope,
      content: "cjpan@mail.ustc.edu.cn",
      link: "mailto:cjpan@mail.ustc.edu.cn",
    ),
    // (
    //   icon: fa-github,
    //   content: "github.com/liming-dev",
    //   link: "https://github.com/liming-dev",
    // ),
  )
][
  #h(2em)

  本人是中科大少年班学院大三学生，目前就读于量子信息科技英才班，综合成绩良好。在大二大三期间参与了多个冷原子相关实验项目，积累了相关理论基础并具备精密光路调节和电子学仪器使用经验。希望在研究生阶段继续深造中性原子量子计算方向，就该平台的未来潜力开展进一步探索。
]


== #fa-graduation-cap 个人经历

#sidebar(with-line: true, side-width: 15%)[
  2023.09-至今

  2024.09-至今

  2025.07-至今

  学习成绩
][
  *中国科学技术大学* · 少年班学院

  *中国科学技术大学* · 量子信息科技英才班

  *合肥国家实验室* 光镊冷原子量子计算实验室 实习

  *GPA*: 3.58/4.3, *rank*: 14 / 22
]


// == #fa-wrench 专业技能

// #sidebar(with-line: false, side-width: 12%)[
//   *操作系统*
  
//   *掌握*
  
//   *熟悉*

//   *了解*
// ][
//   #fa-linux Linux, #h(0.5em) #fa-windows Windows
  
//   React, JavaScript, Python
  
//   Vue, TypeScript, Node.js

//   Webpack, Java
// ]


== #fa-award 获奖情况

#item(
  [ *23、24、25年优秀学生奖学金* ],
  [ *校级铜奖* ],
  date[  ],
)

#item(
  [ *24、25年太湖科技奖学金* ],
  [ *二等奖* ],
  date[],
)

#item(
  [ *25年原子物理学术研讨* ],
  [ *优秀奖* ],
  date[],
)

#item(
  [ *少年班学院语言类标化考试奖学金* ],
  [ ],
  date[],
)

== #fa-wrench 科研经历

#item(
  [ *原子冷却与原子捕获实验课* ],
  [ *“百年诺奖技术重现与超越“实验课程* ],
  date[ 2024 年 10 月 – 2025 年 10 月 ],
)

// #tech[ Golang, Docker, Kubernetes ]
实验主要搭建了一套超高真空系统与相应的原子冷却准备光路

- 掌握了精密光路调整与真空系统相关基本实验技术
- 了解了原子冷却、捕获技术的系统构成

#item(
  [ *光镊冷原子量子计算实验室* ],
  [ *实习经历* ],
  date[ 2025 年 7 月 – 至今 ],
)
- 参与了铷原子量子计算平台准备光路与真空系统的搭建
- 期间通过阅读文献理解了原子能级精细调控与量子门实现的基本物理机制


== #fa-building-columns 校园经历

#item(
  [ *USTC校学生合唱团副团长* ],
  [],
  date[ 2025 年 06 月 – 至今 ],
)

#item(
  [ *班级团支书* ],
  [],
  date[ 2025 年 09 月 – 至今 ],
)
