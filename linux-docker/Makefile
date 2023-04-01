# Variable
image_name := colbs-linux

# First target is the default command
all: clean build run
build:
	docker build -t $(image_name) -f colby-linux.Dockerfile ..
run:
	docker run -it $(image_name)
clean:
	docker rmi $(image_name) -f
edit:
	nvim colby-linux.Dockerfile

.PHONY: clean all
