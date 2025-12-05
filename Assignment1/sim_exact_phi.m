function phi_at = sim_exact_phi(K, wn, zeta, Delta_w, t_query)
    % Build the two terms of Φ(s) for LPF+lead frequency-step
    D  = [1, 2*zeta*wn, wn^2];                         % s^2 + 2ζωn s + ωn^2
    GA = tf(1, D);                                     % Δω / D(s)
    GB = (wn^2/K) * tf(1, conv([1 0], D));            % (ωn^2/K)·Δω / [s·D(s)]
    Gtot = GA + GB;                                    % total Φ(s)/Δω

    % Simulate on a UNIFORM grid and interpolate to requested times
    t_end = max(t_query);
    t_sim = linspace(0, t_end, 2000);                  % uniform, monotone
    u     = Delta_w * ones(size(t_sim));               % constant Δω input
    phi   = lsim(Gtot, u, t_sim);                      % simulate
    phi_at = interp1(t_sim, phi, t_query, 'linear');   % sample at t_query
end
