%% Check omega_n and zeta for a 2nd-order PLL (integrator + phase lead)

% ----- Given data from the problem -----
Delta_omega_i = 2*pi*5e3;      % rad/s (not used for zeta solve, but useful to check linearity)
Omega_peak     = 2*pi*1e3;     % rad/s where phase-error is maximum  -> equals omega_n
gain_dB        = 2;            % m0/mi at that same Omega

% ----- Step 1: Natural frequency from error-peak -----
omega_n = Omega_peak;

% ----- Step 2: Damping from Eq. (6.5) at Omega = omega_n -----
A = 10^(gain_dB/20);                 % linear magnitude m0/mi
% From Eq. (6.5) at x=1:  A = sqrt(1+4*zeta^2) / (2*zeta)
zeta = 1/(2*sqrt(A^2 - 1));

fprintf('Computed results:\nomega_n = %.6g rad/s (%.3f kHz)\nzeta    = %.4f\n\n', ...
        omega_n, omega_n/(2*pi*1e3), zeta);

% ----- Verification 1: Evaluate |H(jOmega)| exactly at Omega = omega_n -----
Omega = omega_n;
num = sqrt( omega_n^4 + 4*zeta^2*omega_n^2*Omega^2 );
den = sqrt( (omega_n^2 - Omega^2)^2 + 4*zeta^2*omega_n^2*Omega^2 );
Hmag_at_res = num/den;
fprintf('|H(j*omega_n)| = %.6f  (%.3f dB)  [should match %.3f dB]\n\n', ...
        Hmag_at_res, 20*log10(Hmag_at_res), gain_dB);

% ----- Verification 2: Confirm error peaks at x = 1 -----
% Eq. (6.6) in normalized form: m/mi = x^2 / sqrt((1 - x^2)^2 + 4*zeta^2*x^2)
x = logspace(-2, 2, 2000);
err_mag = x.^2 ./ sqrt( (1 - x.^2).^2 + 4*zeta^2.*x.^2 );
[~, idxMax] = max(err_mag);
x_at_peak = x(idxMax);
fprintf('Error magnitude peaks at x = Omega/omega_n = %.4f  [should be ~ 1]\n\n', x_at_peak);

% ----- Optional sanity: peak phase-error amplitude at x=1 (linear regime check) -----
Delta_phi_max = Delta_omega_i / (2*zeta*omega_n);   % notes' formula at x=1
fprintf('Implied peak phase-error (x=1): Delta_phi_max = %.3f rad\n', Delta_phi_max);

