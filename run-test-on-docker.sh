dir="$(dirname "$(readlink -f "$0")")"

docker build -t mandel59/unifill-test-runner -f unifill-test-runner.dockerfile .
mkdir -p "$dir/test/build"
docker run --volume "$dir/test/build:/opt/unifill/test/build" mandel59/unifill-test-runner lix compile-test.hxml
