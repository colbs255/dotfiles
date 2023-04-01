# Variable
image_name := colby-linux

# First target is the default command
all: clean build run
build:
	docker build -t $(image_name) -f $(image_name).Dockerfile ..
run:
	docker run -it $(image_name)
clean:
	docker rmi $(image_name) -f
edit:
	nvim $(image_name).Dockerfile

.PHONY: clean all
