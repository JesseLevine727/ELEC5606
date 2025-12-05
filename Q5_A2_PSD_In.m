% Define the function
f = @(x) (5.75e-9) ./ (x.^2 + 1);

% Create a range for x
x = linspace(-10, 10, 1000);
y = f(x);

% Plot the function
figure;
plot(x, y, 'b-', 'LineWidth', 1.5); % Plot the function
hold on; % Hold the current plot

% Add a point at x = 1
x_point = 1;
y_point = f(x_point);
plot(x_point, y_point, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Add red point

% Add a point at x = 0
x_point = 0;
y_point = f(x_point);
plot(x_point, y_point, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Add red point


% Add labels and title
xlabel('Hz');
ylabel('PSD of Freq. Mod.');
grid on; % Add grid for better visualization
hold off; % Release the plot hold
