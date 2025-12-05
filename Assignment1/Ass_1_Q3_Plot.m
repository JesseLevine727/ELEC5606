% --- set your loop times (lead: tau1 > tau2 > 0) ---
tau1 = 1.0;
tau2 = 0.02;

% --- 1) Plot f(sigma) vs sigma
sig = linspace(-200, 20, 2000);
f   = tau1*tau2*sig.^2 + 2*tau1*sig + 1;

figure; plot(sig, f, 'LineWidth',1.6); grid on
xlabel('\sigma'); ylabel('f(\sigma) = \tau_1\tau_2\sigma^2 + 2\tau_1\sigma + 1');
title('LHS of Re\{D(s)\} after enforcing Im\{D\}=0');
yline(0,'k--');

% Mark the zeros of f(sigma): real-axis intercepts of the complex branch
z = roots([tau1*tau2, 2*tau1, 1]);  % two sigma values
hold on; plot(z, [0 0], 'ro', 'MarkerSize', 7);
text(z(1),0,'  \leftarrow intercept'); text(z(2),0,'  \leftarrow intercept');