plot(output.bodies(1).time,output.bodies(1).position(:,5),output.bodies(1).time,output.bodies(2).position(:,5))
B = hydro.ex_K([5 11], 1, :);
b2 = permute(B, [3 1 2]);
b2 = reshape(b2, [], 2);
plot(b2,'DisplayName','b2')
