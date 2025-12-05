Delta_w = 200;                    % rad/s (frequency step)
phi_ss  = 0.10;                   % from plot
K       = Delta_w / phi_ss;       % -> 1000 s^-1

tp = 8e-3;                        % 8 ms peak time from plot

% Solve tp = 1/wn + 1/(K*(1 - wn/K))  for wn
f = @(wn) 1./wn + 1./(K*(1 - wn./K)) - tp;
wn = fzero(f, 150);               % good initial guess ~150

% Closed-form phi(t) for zeta = 1:
phi = @(t) Delta_w/K + Delta_w*exp(-wn*t).*( t.*(1 - wn/K) - 1/K );

% Check sample points
t_ms = [8 20 30 40];
t    = t_ms/1000;
fprintf('K = %.3f s^-1,  wn = %.3f rad/s\n', K, wn);
fprintf('phi(8ms)=%.3f, phi(20ms)=%.3f, phi(30ms)=%.3f, phi(40ms)=%.3f\n', phi(t));

% Plot
tt = linspace(0, 0.05, 2000);
plot(tt*1e3, phi(tt), 'LineWidth', 1.6); grid on;
xlabel('t (ms)'); ylabel('\phi(t) [rad]');
title(sprintf('\\zeta=1, K=%.0f s^{-1}, \\omega_n=%.2f rad/s', K, wn));
yline(phi_ss,'--','\phi_{ss}');
