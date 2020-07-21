docker build -t mandel59/unifill-test-runner -f unifill-test-runner.dockerfile .
docker run mandel59/unifill-test-runner haxe compile-test.hxml
