前言和致谢函。
这是一篇针对操作系统课程的草稿文本。它通过研究一个名为xv6的示例内核来解释操作系统的主要概念。xv6是Dennis Ritchie和Ken Thompson的Unix version6(V6)[10]的重新实现。xv6松散地遵循v6的结构和风格，但在ANSIC[5]中针对多核RISC-V[9]实现。
本文应该与xv6的源代码一起阅读，这种方法的灵感来自John Lions对UNIX第6版的评论[7]。见https://pdos.csail.mit.edu/6.828。
指向v6和xv6的在线资源的指针，包括几个实际操作的家庭作业。
使用xv6。
我们已经在麻省理工学院的操作系统课程6.828中使用过这篇课文。我们感谢教职员工，
助教和6.828名学生，他们都对xv6有过直接或间接的贡献。
我们要特别感谢奥斯汀·克莱门茨和尼克莱·泽尔多维奇。最后，我们会。
我想感谢那些通过电子邮件给我们发送文本中的错误或改进建议的人：Abutalib。
阿加耶夫，Sebastian Boehm，Anton Burtsev，Raphael Carvalho，Tej Chajed，Rasit Eskicioglu，Color。
模糊，朱塞佩，郭涛，罗伯特·希尔德曼，沃尔夫冈·凯勒，奥斯汀·刘，帕万·马达塞蒂，
Jacek Masiulaniec，Michael McConville，Micuelgvieira，Mark Morrissey，Harry Pan，Askar Safin，
Salman Shah，Ruslan Savchenko，Pawel Szczurko，Warren Toomey，tyfkda，Tzerbib，Xi Wang，和。
邹昌伟。
如果您发现错误或有改进建议，请发送电子邮件给Frans Kaashoek。
和罗伯特·莫里斯(kaashoek，rtm@csail.mit.edu)。