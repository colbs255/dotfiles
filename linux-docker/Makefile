# Variable
image_name := colby-linux

# First target is the default command
all: build run
build:
	docker build -t $(image_name) -f $(image_name).Dockerfile ..
run:
	docker run -it $(image_name)
clean:
	docker rmi $(image_name):latest -f
edit:
	nvim $(image_name).Dockerfile

.PHONY: all build run clean edit
