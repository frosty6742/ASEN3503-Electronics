% Read each matrix/vector pair, compute b = A*x, and write b to CSV.
for k = 1:3
	A = readmatrix(sprintf('A%d.csv', k));
	x = readmatrix(sprintf('x%d.csv', k));

	b = multiply(A, x);

	writematrix(b, sprintf('b%d.csv', k));
end
