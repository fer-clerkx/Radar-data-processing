function tests = getClosestObjectTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = getClosestObject();
end

function test0Objects(testCase)
	tracked = struct('tracking', false, 'px', 0, 'py', 0);
	detect = struct('px', 0, 'py', 0);
	actOutput = testCase.TestData.dut(tracked, detect);
	expOutput = uint8(0);
	verifyEqual(testCase, actOutput, expOutput);
end

function testMaxObjects(testCase)
	inputSize = testCase.TestData.dut.MAX_INPUT_OBSTACLES;
	tracked = struct('tracking', false, 'px', 0, 'py', 0);
	tracked = repmat(tracked, 1, inputSize);
	detect = struct('px', 0, 'py', 0);
	actOutput = testCase.TestData.dut(tracked, detect);
	expOutput = uint8(0);
	verifyEqual(testCase, actOutput, expOutput);
end

function testClosestObject(testCase)
	% Make sure input data is constant between test runnings.
	rng("default")
	inputSize = testCase.TestData.dut.MAX_INPUT_OBSTACLES;
	detect = struct('px', 0, 'py', 0);
	for i=1:10
		% Generate pseudorandom input data
		inputDistances = randperm(inputSize);
		distanceSquares = num2cell(sqrt(inputDistances));
		tracked = struct('tracking', true, 'px', distanceSquares, 'py', distanceSquares);

		% Run function
		actOutput = testCase.TestData.dut(tracked, detect);

		% Calculate expected output
		[~, minDistIdx] = min(inputDistances);
		expOutput = bitshift(uint8(1), minDistIdx-1);

		verifyEqual(testCase, actOutput, expOutput);
	end
end