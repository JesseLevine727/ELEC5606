% PLL Simulation Project
clear; clc; close all;

R1= 100e3;          % 100k ohm
R2 = 1.4e3;         % 1.4k ohm
C_loop = 1e-6;      % 1uF
wn = 1000;          % Loop Natural Frequency
zeta = 1/sqrt(2);   % Damping Factor       
Bi = 1e4;           % Branch Filter noise equivalent BW
BL = 500;           % Loop noise equivalent BW of 2B_L = 1000Hz
R_b = 3000;         % Bit rate
T = 1/R_b;          % Bit duration



