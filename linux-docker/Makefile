# Variable
image_name := dockertest

# First target is the default command
all: clean build run
build:
	docker build -t $(image_name) -f dockerfile ..
run:
	docker run -it $(image_name)
clean:
	docker rmi $(image_name) -f
edit:
	nvim dockerfile

.PHONY: clean all
