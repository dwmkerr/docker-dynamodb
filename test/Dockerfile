FROM docker:1.12

# Create a nice place to play
RUN mkdir -p /opt/test
WORKDIR /opt/test

# Copy over our test scripts.
COPY *.sh /opt/test/

CMD \ 
    docker load  && \
	./test/basics.test.sh && \
	./test/ephemeral.test.sh && \
	./test/persistent.test.sh
