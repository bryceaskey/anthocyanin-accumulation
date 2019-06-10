%use after exporting all trained regressions in a color space to the workspace
%all exported regressions must be named to match code below
%the "Test" variable must be manually created, and is a table containing mean color index values for Test images in a single color space
%the "Predictions" variable is created by the code, and stores output NAI predictions for all regressions
[height, width] = size(Test);
Predictions = cell(height + 1, 19);

regression_names = ["Linear", "Interactions Linear", "Robust Linear", "Stepwise Linear", "Fine Tree", "Medium Tree", "Coarse Tree", "Linear SVM", "Quadratic SVM", "Cubic SVM", "Fine Gaussian SVM", "Medium Gaussian SVM", "Coarse Gaussian SVM", "Boosted Trees", "Bagged Trees", "Squared Exponential GPR", "Matern 5/2 GPR", "Exponential GPR", "Rational Quadratic GPR"];
for regression_count = 1:1:length(regression_names)
    Predictions{1, regression_count} = regression_names(regression_count);
end

for image_count = 1:1:height
    Predictions{image_count + 1, 1} = Linear.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 2} = InteractionsLinear.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 3} = RobustLinear.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 4} = StepwiseLinear.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 5} = FineTree.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 6} = MediumTree.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 7} = CoarseTree.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 8} = LinearSVM.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 9} = QuadraticSVM.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 10} = CubicSVM.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 11} = FineGaussianSVM.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 12} = MediumGaussianSVM.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 13} = CoarseGaussianSVM.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 14} = BoostedTrees.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 15} = BaggedTrees.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 16} = SquaredExponentialGPR.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 17} = Matern52GPR.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 18} = ExponentialGPR.predictFcn(Test(image_count, :));
    Predictions{image_count + 1, 19} = RationalQuadraticGPR.predictFcn(Test(image_count, :));
end
