function b = multiply(A, x)
%MULTIPLY Compute b = A*x using element-wise access.

[m, n] = size(A);

b = zeros(m, 1);

for i = 1:m
	total = 0;
	for j = 1:n
		total = total + A(i, j) * x(j);
	end
	b(i) = total;
end

end
