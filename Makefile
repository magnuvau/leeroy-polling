.PHONY: start stop

run:
	./daemon.sh >> /dev/null 2>&1 &

stop:
	kill $(shell cat killme.pid)
