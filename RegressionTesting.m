%use after exporting all trained regressions in a color space to the workspace
%all exported regressions must be named to match the code below
%test -> table containing mean color index values for test images in a
%single color space
%predicted -> stores output NAI predictions for all regressions
predicted = zeros(27, 19);
predicted(:, 1) = Linear.predictFcn(test);
predicted(:, 2) = InteractionsLinear.predictFcn(test);
predicted(:, 3) = RobustLinear.predictFcn(test);
predicted(:, 4) = StepwiseLinear.predictFcn(test);
predicted(:, 5) = FineTree.predictFcn(test);
predicted(:, 6) = MediumTree.predictFcn(test);
predicted(:, 7) = CoarseTree.predictFcn(test);
predicted(:, 8) = LinearSVM.predictFcn(test);
predicted(:, 9) = QuadraticSVM.predictFcn(test);
predicted(:, 10) = CubicSVM.predictFcn(test);
predicted(:, 11) = FineGaussianSVM.predictFcn(test);
predicted(:, 12) = MediumGaussianSVM.predictFcn(test);
predicted(:, 13) = CoarseGaussianSVM.predictFcn(test);
predicted(:, 14) = BoostedTrees.predictFcn(test);
predicted(:, 15) = BaggedTrees.predictFcn(test);
predicted(:, 16) = SquaredExponentialGPR.predictFcn(test);
predicted(:, 17) = Matern52GPR.predictFcn(test);
predicted(:, 18) = ExponentialGPR.predictFcn(test);
predicted(:, 19) = RationalQuadraticGPR.predictFcn(test);