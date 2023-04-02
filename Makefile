IMG_NAME := ckatsak/opencv-slim
IMG_TAG := 4.7.0-python3.11.2-slim-bullseye

.PHONY: opencv-slim
opencv-slim:
	docker build --no-cache --progress=plain --pull \
		-t $(IMG_NAME):$(IMG_TAG) .

.PHONY: push
push:
	docker push $(IMG_NAME):$(IMG_TAG)

.PHONY: clean
clean:
	-docker rmi $(IMG_NAME):$(IMG_TAG)
	-docker rmi $(IMG_NAME):latest
