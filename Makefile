export GOPATH := ${PWD}
export PATH := ${PATH}:${GOPATH}/bin
export GOBIN := ${GOPATH}/bin
main:
	go run main.go
build:
	go install main.go
images:
	docker build -t clown .
run:
	docker run -it -v /Users/suifengluo/Documents/gitlab_work/clown:/gopath --rm clown
docker: images run



example:
	go run src/slob/example/run/example.go

example_gen_run:
	go run src/slob/example/gen/prefix_person_suffix.go