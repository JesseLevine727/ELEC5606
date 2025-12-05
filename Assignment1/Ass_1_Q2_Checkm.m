%% Given from the Bode sketch
% Breaks: pole at 1 rad/s, zero at 50 rad/s, 0 dB at 1000 rad/s
tau1 = 1/1;          % pole at 1 rad/s  => tau1 = 1
tau2 = 1/50;         % zero at 50 rad/s => tau2 = 0.02
wc   = 1000;         % unity-gain (0 dB) crossover shown on the plot

%% Solve K so that |L(j*wc)| = 1
% L(s) = K*(1 + s*tau2) / ( s*(1 + s*tau1) )
K = wc * sqrt(1 + (wc*tau1)^2) / sqrt(1 + (wc*tau2)^2);

%% Build open-loop and check crossover & phase margin
s = tf('s');
L = K * (1 + tau2*s) / ( s*(1 + tau1*s) );

% 1) Read off margins (phase margin should be computed at gain crossover)
[GM, PM, Wcg, Wcp] = margin(L);
fprintf('Computed K         = %.6g\n', K);
fprintf('Gain crossover wcp = %.6g rad/s (target 1000)\n', Wcp);
fprintf('Phase margin PM    = %.3f deg\n', PM);

% 2) Directly evaluate angle at wc to see the same PM
Ljwc = freqresp(L, wc);            % complex value L(j*wc)
phi_deg = rad2deg(angle(Ljwc));    % open-loop phase at wc
PM2 = 180 + phi_deg;               % definition of phase margin
fprintf('Angle L(j*wc)      = %.3f deg\n', phi_deg);
fprintf('PM from angle      = %.3f deg\n', PM2);

% 3) Plot to visually confirm slopes & crossover
figure; margin(L); grid on;

%% Closed-loop and natural frequency / damping
T = feedback(L, 1);    % closed-loop phase lock (type-I, 2nd-order)

% (a) From the standard formulas for this loop:
wn_th   = sqrt(K / tau1);
zeta_th = (1 + K*tau2) / (2*wn_th*tau1);

fprintf('\nFrom formulas:\n');
fprintf('omega_n (theory)   = %.6g rad/s\n', wn_th);
fprintf('zeta (theory)      = %.6g\n', zeta_th);

% (b) From the actual closed-loop poles:
d = damp(T);  % columns: wn, zeta, poles....
disp('Closed-loop modal data [wn  zeta]:');
disp(d);

% Optional: show poles explicitly
disp('Closed-loop poles:');
disp(pole(T));
