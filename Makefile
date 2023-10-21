IMAGE_REPO?=joestldr
IMAGE_NAME?=ssh-client
IMAGE_TAG?=latest

IMAGE=$(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

build:
	@docker build --tag $(IMAGE) .
	@if [ ${IMAGE_TAG} != "latest" ]; then \
		docker tag $(IMAGE) $(IMAGE_REPO)/$(IMAGE_NAME):latest; \
	fi

push: build
	@docker push $(IMAGE)
	@if [ ${IMAGE_TAG} != "latest" ]; then \
		docker push $(IMAGE_REPO)/$(IMAGE_NAME):latest; \
	fi

save: build
	@rm -rf images
	@mkdir images
	@docker save $(IMAGE) | pigz -9 > ./images/$(IMAGE_REPO)-$(IMAGE_NAME)-$(IMAGE_TAG).tar.gz

jenkins: build push save

test-run-password: build
	@docker run --name joestldr-ssh -it --rm \
			$(IMAGE) \
		-vvv $$(whoami)@$$(hostname -I | cut -d ' ' -f 1)

test-run-keys: build
	@docker run --name joestldr-ssh -it --rm \
			--volume ~/.ssh:/ssh \
			$(IMAGE) \
		-vvv $$(whoami)@$$(hostname -I | cut -d ' ' -f 1)
