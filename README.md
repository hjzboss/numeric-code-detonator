# numeric-code-detonator

#### 介绍
EDA实验，数字密码引爆器

#### 功能介绍
数字密码引爆器具体设计要求：
1. 数字密码引爆器采用4个十进制数，输入密码时通过数码管显示当前输入的数字
2. 当4位密码输入正确后系统可以正确启动引爆装置；当密码输入错误（多一位、少一位或错误）时，系统给出警报
3. 系统复位后处于系统复位后处于等待状态，按下等待状态，按下Ready键后，准备就绪，可以输入密码。
4. 密码输入正确后，可以起爆密码输入正确后，可以起爆
5. 密码输入错误时，系统给出警报密码输入错误时，系统给出警报，红灯闪烁，此时，此时Ready和Wait_t无效，必须由安保人员重新设置到等待状态。
6. 引爆事件发生后，系统应重新回到等待状态引爆事件发生后，系统应重新回到等待状态
7. 十个数字键作为密码输入


#### FPGA
* 所用板卡：PYNQ Z2, 依元素数字io扩展卡
* sw1-sw4作为密码输入，sw5作为confirm，sw6作为复位
* btn3作为ready，btn2作为sure，btn1作为fire，btn0作为wait_t，sw0作为setup