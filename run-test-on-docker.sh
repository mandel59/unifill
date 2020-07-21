dir="$(dirname "$(readlink -f "$0")")"

docker build -t mandel59/unifill-test-runner -f unifill-test-runner.dockerfile .
mkdir -p "$dir/test"
docker run --volume "$dir/test:/opt/unifill/test" mandel59/unifill-test-runner lix compile-test.hxml
