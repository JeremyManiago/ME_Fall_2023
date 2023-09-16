Jeremy Maniago
ME 51500/I5800
P. Ganatos
Due 09/07/23

(1) Curtis (1.6): An 80 kg man and a 50 kg woman stand 0.5 m from each other. What is the force of gravitational attraction between the couple?

$$ \Large
\begin{align}
F&=\frac{Gm_{1}m_{2}}{r_{12}^{2}} & 
\begin{cases}
 \text{G = } 6.67259 \times 10^{-11} \ \frac{\text{ m}^{3}}{\text{ kg - sec}^{2}} \\
 m_{1}=80 \text{ kg} \\
 m_{2}=50 \text{ kg} \\
 r_{12}=0.5 \text{ m}
\end{cases} \\
&=\frac{6.67259 \times 10^{-11})(80)(50)}{(0.5)} \\
&=\boxed{1.068 \ \mu N}
\end{align}

$$

---
(2) Curtis (1.8): If a person’s weight is 𝑊 on the surface of the earth, calculate what it would be, in terms of 𝑊, at the surface of a) The moon; b) Mars; c) Jupiter.

On surface of Earth:
$$\Large
\begin{align}
F = W &= \frac{Gm_{1}m_{E}}{r_{E}^{2}} = m_{1} \left(\frac{Gm_{E}}{r_{E}^{2}}\right)
\end{align}
$$

Knowing that $\large G=6.67259\times 10^{-11} \ \frac{\text{ m}^{3}}{\text{ kg - sec}^{2}}$, $\large m_{E}=5.9722\times 10^{24} \text{ kg}$, and $\large r_{E}=6.3781\times 10^{6} \text{ m}$ :
$$\Large
\begin{align}
W &= m_{1} \left(\frac{(6.67259\times 10^{-11})(5.9722\times 10^{24})}{(6.3781\times 10^{6})^{2}}\right) = m_{1} ( \ \underbrace{9.796 \ \frac{\text{m}}{\text{s}^{2}}}_{g} \ ) \\
&\Rightarrow  \underline{m_{1}=\frac{W}{9.796 \ \frac{\text{m}}{\text{s}^{2}}}}
\end{align}
$$

a) On the moon;
$$\Large
\begin{align}
&g_{moon}=1.62 \ \frac{\text{m}}{\text{s}^{2}} \\
\\
&\Rightarrow W_{moon} = m_{1} g_{moon}=\left( \frac{W}{9.796 \ \frac{\text{m}}{\text{s}^{2}}} \right)\left(1.62 \ \frac{\text{m}}{\text{s}^{2}}\right) \\
&=\boxed{0.165W}
\end{align}
$$

b) On Mars;
$$\Large
\begin{align}
&g_{Mars}=3.71 \ \frac{\text{m}}{\text{s}^{2}} \\
\\
&\Rightarrow W_{Mars} = m_{1} g_{Mars}=\left( \frac{W}{9.796 \ \frac{\text{m}}{\text{s}^{2}}} \right)\left(3.71 \ \frac{\text{m}}{\text{s}^{2}}\right) \\
&=\boxed{0.379W}
\end{align}
$$

c) On Jupiter;
$$\Large
\begin{align}
&g_{Jupiter}=24.79 \ \frac{\text{m}}{\text{s}^{2}} \\
\\
&\Rightarrow W_{Jupiter} = m_{1} g_{Jupiter}=\left( \frac{W}{9.796 \ \frac{\text{m}}{\text{s}^{2}}} \right)\left(24.79 \ \frac{\text{m}}{\text{s}^{2}}\right) \\
&=\boxed{2.53W}
\end{align}
$$

---

<br>
<br>

---

(3) Prove that equations (3.3) and (3.4) given in the class notes are equivalent to (3.2).
$$\Large
\begin{align}
& m_{i} \frac{d\bar{r}_{i}}{dt^{2}}=Gm_{i} \sum_{j = 1}^{N}' \frac{m_{j}}{r_{ij}}(\bar{r}_{j} - \bar{r}_{i}) & (3.2) \\
& m_{i} \frac{d\bar{r}_{i}}{dt^{2}}=\nabla_{i}U & (3.3) \\
& U = \frac{G}{2} \sum_{i=1}^{N}\sum_{j=1}^{N}' \frac{m_{i} m_{j}}{r_{ij}} & (3.4)
\end{align}
$$

From (3.4), we can get rid of the i summation because we only want the force of attraction on mass $\large m_{i}$ , and not on every possible pair. To prove this - at some point in expanding the double summation, we will get similar terms that add up. e.g. 
$$\Large
\frac{m_{1}m_{2}}{r_{12}} = \frac{m_{2}m_{1}}{r_{21}} = 2\left[\frac{m_{1}m_{2}}{r_{12}}\right]
$$

Since this will be true for each pair, and by keeping i = 1, we get
$$\Large
\begin{align}
U &= \frac{G}{2}\sum_{j=1}^{N}' 2\left[\frac{m_{i} m_{j}}{r_{ij}}\right]  \\
&= Gm_{i}\sum_{j=1}^{N}'\frac{m_{j}}{r_{ij}}
\end{align}
$$

Now we can plug the force function U into (3.3)
$$\Large
m_{i} \frac{d\bar{r}_{i}}{dt^{2}}=\nabla_{i} \left(Gm_{i}\sum_{j=1}^{N}'\frac{m_{j}}{r_{ij}}\right)
$$

To evaluate the gradient, we must take the partial of U with each direction
$$\Large
\nabla_{i}U = \frac{\partial U}{\partial x_{i}}\hat{i} \ +\frac{\partial U}{\partial y_{i}}\hat{i} \ +\frac{\partial U}{\partial z_{i}}\hat{i}
$$

Let us evaluate partial x first. Since $\large G, \large m_{i},$ and $\large m_{j}$ are independent of direction, we can group them outside of the gradient
$$\Large
\begin{align}
\frac{\partial U}{\partial x_{i}} \hat{i} &= \frac{\partial}{\partial x_{i}}\left(Gm_{i}\sum_{j=1}^{N}'\frac{m_{j}}{r_{ij}}\right) \hat{i} \\
&=Gm_{i}\sum_{j=1}^{N}'m_{j} \frac{\partial}{\partial x_{i}}\left(\frac{1}{r_{ij}}\right) \hat{i}
\end{align}
$$

We know that 
$$
\Large
\begin{align}
r_{ij} &= \mid \bar{r}_{j}-\bar{r}_{i} \mid  \\
	 & = ((\bar{r}_{j}-\bar{r}_{i})^{2})^{1/2} \\
	 & = ((x_{j}-x_{i})^{2}+(y_{j}-y_{i})^{2}+(z_{j}-z_{i})^{2})^{1/2}
\end{align}
$$
So that partial x is equal to
$$
\Large
\begin{align}
 &= \frac{\partial}{\partial x_{i}} \left(((x_{j}-x_{i})^{2}+(y_{j}-y_{i})^{2}+(z_{j}-z_{i})^{2})^{-1/2}\right) \hat{i}  \\
	 & = \left[-\frac{1}{2} ((x_{j}-x_{i})^{2}+(y_{j}-y_{i})^{2}+(z_{j}-z_{i})^{2})^{-3/2}\right]\left[2(x_{j}-x_{i})\right]\left[-1\right] \hat{i} \\
	 & =\frac{(x_{j}-x_{i})}{((x_{j}-x_{i})^{2}+(y_{j}-y_{i})^{2}+(z_{j}-z_{i})^{2})^{3/2}} \\
	 & =\frac{(x_{j}-x_{i})}{r_{ij}^{3}} \hat{i}
\end{align}
$$

Similarly, for partial y and partial z
$$
\Large
\begin{align}
\frac{\partial}{\partial y_{i}} \left(\frac{1}{r_{ij}}\right) \hat{j} &=\frac{(y_{j}-y_{i})}{r_{ij}^{3}} \hat{j} \\
\frac{\partial}{\partial z_{i}} \left(\frac{1}{r_{ij}}\right) \hat{k} &=\frac{(z_{j}-z_{i})}{r_{ij}^{3}} \hat{k}
\end{align}
$$

We can take out the $\large r_{ij}^{3}$ term since it is the same in all 3 components of the gradient. We are left with
$$
\Large
\begin{align}
&Gm_{i}\sum_{j=1}^{N}' \frac{m_{j}}{r_{ij}^{3}} \underbrace{\left((x_{j}-x_{i}) \hat{i} \ + (y_{j}-y_{i}) \hat{j} \ + (z_{j}-z_{i}) \hat{k}\right)}_{(\bar{r}_{j}-\bar{r}_{i})} \\
	 &= \boxed{Gm_{i}\sum_{j=1}^{N}' \frac{m_{j}}{r_{ij}^{3}} (\bar{r}_{j}-\bar{r}_{i})}
\end{align}
$$
which is identical to the right hand side of equation (3.2)

---

(4) Prove that the force function 𝑈 given by equation (3.4) in the class notes is equal to the total work done by the gravitational forces in assembling a system of 𝑁 point masses from a state of infinite dispersion to a given configuration.
$$
\Large
\begin{align}
U = \frac{G}{2} \sum_{i=1}^{N}\sum_{j=1}^{N}' \frac{m_{i} m_{j}}{r_{ij}} &  & (3.4)
\end{align}
$$

Total work is given by
$$
\Large
-\int F * \, dr 
$$
Force due to gravitational attraction on mass $\large m_{i}$
$$
\Large
F_{i}=\frac{Gm_{i}m_{j}}{r_{ij}^{2}}
$$

Since we want to bring point masses from infinity to a given config, we do
$$
\Large
\begin{align}
-\int_{\infty}^{r_{ij}} F \, dr &= -\int_{\infty}^{r_{ij}} \frac{Gm_{i}m_{j}}{r^{2}} \, dr \\
	 & = - Gm_{i}m_{j} \int_{\infty}^{r_{ij}} r^{-2} \, dr \\
	 & = -Gm_{i}m_{j} \left[ -\frac{1}{r} \right]_{\infty}^{r_{ij}} \\
	 & = -Gm_{i}m_{j} \left[ \left(-\frac{1}{r_{ij}}\right) + \underbrace{\left(-\frac{1}{\infty}\right)}_{\to \ 0} \right] \\
	 & =\frac{Gm_{i}m_{j}}{r_{ij}}
\end{align}
$$

This is only for 2 masses. If we want N masses, we include summations. Similar to problem (3), we will have a summation iterating the $\large i^{th}$ mass and another iterating the $\large j^{th}$ mass (where $\large j \neq i$). As previously stated, this type of notation will lead to accounting each pair of masses twice, hence dividing the entire equation by 2 
$$
\Large
\Rightarrow \boxed{\frac{G}{2} \sum_{i=1}^{N}\sum_{j=1}^{N}' \frac{m_{i} m_{j}}{r_{ij}}}
$$
which is identical to equation (3.4)

---

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

---
(5) Prove equation (4.7) given in the class notes.
$$
\Large
\begin{align}
\frac{\bar{d}_{j}}{d_{j}^{3}} + \frac{\bar{\rho}_{j}}{\rho_{j}^{3}} = -\nabla\left( \frac{1}{d_{j}} - \frac{1}{\rho_{j}^{3}}\bar{r} \cdot \bar{\rho}_{j} \right) &  & (4.7)
\end{align}
$$
We know that 
$$
\Large
\begin{align}
\bar{r}=\bar{r}_{2}-\bar{r}_{1}
\end{align}
$$
If we set $\large m_{1}$ to 0 in all directions (origin), then $\large \bar{r} = 0$
$$
\Large
\begin{align}
\bar{r}&=\bar{r}_{2}-(0)=\bar{r}_{2} \\
\bar{\rho}_{j}&=\bar{r}_{j}-(0)=\bar{r}_{j} \\
\bar{d}_{j}&=\bar{r}_{2}-\bar{r}_{j}
\end{align}
$$

We can separate this gradient into
$$
\Large
-\nabla\left( \frac{1}{d_{j}} \right)-\nabla\left(- \frac{1}{\rho_{j}^{3}}\bar{r} \cdot \bar{\rho}_{j} \right)
$$
The left part will be
$$
\Large
\begin{align}
&= -\nabla\left(((x_{2}-x_{j})^{2}+(y_{2}-y_{j})^{2}+(z_{2}-z_{j})^{2})^{-1/2}\right) \\
	 & =\frac{1}{d_{j}^{3}} ((x_{2}-x_{j})\hat{i}+(y_{2}-y_{j})\hat{j}+(z_{2}-z_{j})\hat{k})  \\
	 & \boxed{\frac{\bar{d_{j}}}{d_{j}^{3}}}
\end{align}
$$

For the right side, we have
$$
\Large
\begin{align}
\bar{r} \cdot \bar{\rho}_{j} = (x\cdot x_{j} \ \hat{i}) + (y\cdot y_{j} \ \hat{j}) + (z\cdot z_{j} \ \hat{k})
\end{align}
$$
So that
$$
\Large
\begin{align}
&=-\nabla\left( -\frac{(x\cdot x_{j} \ \hat{i}) + (y\cdot y_{j} \ \hat{j}) + (z\cdot z_{j} \ \hat{k})}{\left((x_{j}^{2}+y_{j}^{2}+z_{j}^{2})^{1/2}\right)} \right) \\
	 & =\frac{1}{\rho_{j}^{3}}(x_{j}\hat{i}+y_{j}\hat{j}+z_{j}\hat{k}) \\
	 & = \boxed{\frac{\bar{\rho}_{j}}{\rho_{j}^{3}}}
\end{align}
$$
The steps in taking the derivative were skipped due to similarity of the derivate taken in question (3). Combining the left and right part we get
$$
\Large
\boxed{\frac{\bar{d_{j}}}{d_{j}^{3}} + \frac{\bar{\rho}_{j}}{\rho_{j}^{3}}}
$$

---
