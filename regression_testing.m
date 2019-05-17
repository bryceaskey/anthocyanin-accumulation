%use after exporting all trained regressions in a color space to the workspace
%all exported regressions must be named to match code below
%the "test" variable is a table containing mean color index values for test images in a single color space
%the "predicted" variable stores output NAI predictions for all regressions
[height, width] = size(Test);
predicted = cell(height + 1, 19);

regression_names = ["Linear", "Interactions Linear", "Robust Linear", "Stepwise Linear", "Fine Tree", "Medium Tree", "Coarse Tree", "Linear SVM", "Quadratic SVM", "Cubic SVM", "Fine Gaussian SVM", "Medium Gaussian SVM", "Coarse Gaussian SVM", "Boosted Trees", "Bagged Trees", "Squared Exponential GPR", "Matern 5/2 GPR", "Exponential GPR", "Rational Quadratic GPR"];
for regression_count = 1:1:length(regression_names)
    predicted{1, regression_count} = regression_names(regression_count);
end

for image_count = 1:1:height
    predicted{image_count + 1, 1} = Linear.predictFcn(test(image_count, :));
    predicted{image_count + 1, 2} = InteractionsLinear.predictFcn(test(image_count, :));
    predicted{image_count + 1, 3} = RobustLinear.predictFcn(test(image_count, :));
    predicted{image_count + 1, 4} = StepwiseLinear.predictFcn(test(image_count, :));
    predicted{image_count + 1, 5} = FineTree.predictFcn(test(image_count, :));
    predicted{image_count + 1, 6} = MediumTree.predictFcn(test(image_count, :));
    predicted{image_count + 1, 7} = CoarseTree.predictFcn(test(image_count, :));
    predicted{image_count + 1, 8} = LinearSVM.predictFcn(test(image_count, :));
    predicted{image_count + 1, 9} = QuadraticSVM.predictFcn(test(image_count, :));
    predicted{image_count + 1, 10} = CubicSVM.predictFcn(test(image_count, :));
    predicted{image_count + 1, 11} = FineGaussianSVM.predictFcn(test(image_count, :));
    predicted{image_count + 1, 12} = MediumGaussianSVM.predictFcn(test(image_count, :));
    predicted{image_count + 1, 13} = CoarseGaussianSVM.predictFcn(test(image_count, :));
    predicted{image_count + 1, 14} = BoostedTrees.predictFcn(test(image_count, :));
    predicted{image_count + 1, 15} = BaggedTrees.predictFcn(test(image_count, :));
    predicted{image_count + 1, 16} = SquaredExponentialGPR.predictFcn(test(image_count, :));
    predicted{image_count + 1, 17} = Matern52GPR.predictFcn(test(image_count, :));
    predicted{image_count + 1, 18} = ExponentialGPR.predictFcn(test(image_count, :));
    predicted{image_count + 1, 19} = RationalQuadraticGPR.predictFcn(test(image_count, :));
end
