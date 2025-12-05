Delta_f = 5e6;                     % Hz
Delta_w = 2*pi*Delta_f;            % rad/s
u1_dc   = 2.0;                     % V (settled)
K3 = Delta_w / u1_dc               % rad/s/V

samples = [ 0,        1.00;        % t (us), u1 (V)
            0.035,   -2.67;
            0.070,    0.00 ];
K1_est = max(abs(samples(:,2)))    % V/rad (sinusoidal PD peak)
%% First-order PLL (cosine model): u1(t) simulation for acquisition transient
clear; clc;

% ---- Given/observed values ----
Delta_f = 5e6;                    % Hz (input is +5 MHz from VCO free-run)
Delta_w = 2*pi*Delta_f;           % rad/s
u1_dc   = 2.0;                    % V (observed steady-state PD output)
u1_0    = 1.0;                    % V at t = 0
K1      = 2.67;                   % V/rad (from your peak excursion)

% ---- VCO sensitivity from steady-state: K3*u1_dc = Delta_w ----
K3 = Delta_w / u1_dc;             % rad/s/V
K  = K1*K3;                       % rad/s (composite pull gain)

fprintf('Using K1 = %.3f V/rad,  K3 = %.4g rad/s/V,  K = %.4g rad/s\n', K1, K3, K);

% ---- Initial phase(s) from cos(phi0) = u1(0)/K1 ----
c = max(-1, min(1, u1_0 / K1));   % clamp numerical noise
phi0_1 = acos(c);                  % in [0,pi]
phi0_2 = -acos(c);                 % the other branch (cos same, sin flips)

% ---- ODE (cosine model) ----
odefun = @(t,phi) Delta_w - K*cos(phi);

% ---- Integrate over a short acquisition window ----
t_end_us = 0.2;                   % adjust if you need a longer view
tspan = [0, t_end_us*1e-6];
opts = odeset('RelTol',1e-10,'AbsTol',1e-12);

[ts1, phi1] = ode45(odefun, tspan, phi0_1, opts);
[ts2, phi2] = ode45(odefun, tspan, phi0_2, opts);

u1_1 = K1*cos(phi1);
u1_2 = K1*cos(phi2);

% ---- Plot ----
figure; hold on; grid on;
plot(ts1*1e6, u1_1, 'LineWidth', 1.7);
yline(u1_dc, '--', 'u_{1,DC}=2 V', 'HandleVisibility','off');



xlabel('time (\mus)'); ylabel('u_1 (V)');
legend('Location','best');

% ---- Quick diagnostics: initial slopes for both branches ----
du1dt = @(phi0) (-K1*sin(phi0)) * (Delta_w - K*cos(phi0));
s1 = du1dt(phi0_1);  s2 = du1dt(phi0_2);
fprintf('Initial slopes: branch1 du1/dt(0) = %+0.3g V/s,  branch2 = %+0.3g V/s\n', s1, s2);

% ---- Check steady-state consistency ----
phi_ss = acos(Delta_w / K);       % exists if |Delta_w| <= K
u1_ss  = K1*cos(phi_ss);
fprintf('Predicted steady u1 = %.3f V (target 2.000 V)\n', u1_ss);

