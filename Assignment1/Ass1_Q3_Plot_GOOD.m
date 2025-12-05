% Choose tau1, tau2 (lead: tau1 > tau2 > 0)
tau1 = 1.0;
tau2 = 0.02;

% Domain for sigma: start left of -1/(2*tau1) to satisfy K >= 0
sig_left  = -1/tau2 - 5/tau2;   % just "far left" for plotting
sig_right = -1/(2*tau1);        % K>=0 boundary
sigma = linspace(sig_left, sig_right, 2000);

% Compute omega(sigma) from the REAL=0 equation after enforcing IMAG=0
radicand = (-2*tau1.*sigma - 1)./(tau1*tau2) - sigma.^2;
omega = sqrt(max(radicand, 0));   % clamp negative to 0 for safety
Ksig  = (-2*tau1.*sigma - 1)/tau2;

% Keep only valid points (both conditions)
valid = (radicand >= 0) & (Ksig >= 0);
sigma = sigma(valid);
omega = omega(valid);
Ksig  = Ksig(valid);

% Plot the analytic root-locus (complex branch)
figure; plot(sigma,  omega, 'LineWidth',1.6); hold on;
plot(sigma, -omega, 'LineWidth',1.6);
grid on; axis equal; xlabel('\sigma'); ylabel('\omega');
title('Analytic root-locus (REAL=0 with IMAG=0 enforced)');

% Optional: overlay the circle form to confirm
c = -1/tau2; r = sqrt(1/tau2^2 - 1/(tau1*tau2));
th = linspace(0, 2*pi, 400);
plot(c + r*cos(th), r*sin(th), '--');


